from libc.stdio cimport fopen, fclose, FILE, fread, fwrite, printf

include "./generic/macros.pxi"
include "./mem/IO.pxi"

DEF MODE_2_CYCLES = 80
DEF MODE_3_CYCLES = 200  # depends on sprite count
DEF MODE_0_CYCLES = 176  # depends on sprite count
DEF LINE_CYCLES = 456

cdef class GB:
    def __cinit__(self):
        self.mem = MEM()
        self.cpu = GBCPU(self.mem)
        self.ppu = GBPPU(self.mem)

    cpdef public void load_bootrom(GB self, str file_name):
        cdef FILE *bootrom 
        bootrom = fopen(file_name.encode("UTF-8"), "rb")
        if bootrom is NULL:
            raise FileNotFoundError(f"File {file_name} does not exist")
        fread(&self.mem.BOOT, 0x100, 1, bootrom)
        fclose(bootrom)

    cpdef public void skip_bootrom(GB self):
        # A: 01 F: E0 B: 00 C: 13 D: 00 E: D8 H: 01 L: 4D SP: FFFE PC: 00:0100
        # todo: other IO writes
        self.mem.write8(0xff50, 1)  # unmap boot rom
        self.cpu.registers[REG_A] = 1
        self.cpu.F = 0xb0
        self.cpu.registers[REG_B] = 0x00
        self.cpu.registers[REG_C] = 0x13
        self.cpu.registers[REG_D] = 0x00
        self.cpu.registers[REG_E] = 0xd8
        self.cpu.registers[REG_H] = 0x01
        self.cpu.registers[REG_L] = 0x4d
        self.cpu.SP = 0xfffe
        self.cpu.PC = 0x0100

    cpdef public void load_rom(GB self, str file_name):
        cdef FILE *rom 
        rom = fopen(file_name.encode("UTF-8"), "rb")
        if rom is NULL:
            raise FileNotFoundError(f"File {file_name} does not exist")
        fread(&self.mem.ROM0, 0x4000, 1, rom)
        fread(&self.mem.ROM1, 0x4000, 1, rom)
        fclose(rom)

    cpdef public void spawn_frontend(GB self):
        self.frontend = new Frontend(
            &self.cpu.shutdown,
            <unsigned char*>&self.ppu.display[0], 
            b"GB",
            &self.mem.IO.JOYPAD,
            &self.ppu.frame,
            160,
            144,
            2
        )

        self.frontend.bind_callback(ord('v'), <frontend_callback>&GB.dump_vram, <void*>self)
        self.frontend.bind_callback(ord('p'), <frontend_callback>&GB.print_status, <void*>self)
        self.bind_keyboard_input('w', JOYPAD_UP)
        self.bind_keyboard_input('a', JOYPAD_LEFT)
        self.bind_keyboard_input('s', JOYPAD_DOWN)
        self.bind_keyboard_input('d', JOYPAD_RIGHT)
        self.bind_keyboard_input(',', JOYPAD_A)
        self.bind_keyboard_input('.', JOYPAD_B)
        self.bind_keyboard_input('k', JOYPAD_START)
        self.bind_keyboard_input('l', JOYPAD_SELECT)

        self.bind_controller_input(11, JOYPAD_UP)
        self.bind_controller_input(13, JOYPAD_LEFT)
        self.bind_controller_input(12, JOYPAD_DOWN)
        self.bind_controller_input(14, JOYPAD_RIGHT)
        self.bind_controller_input(0, JOYPAD_A)
        self.bind_controller_input(1, JOYPAD_B)
        self.bind_controller_input(4, JOYPAD_START)
        self.bind_controller_input(6, JOYPAD_SELECT)
        self.frontend.run()

    cpdef public void close_frontend(GB self):
        self.frontend.join()
        del self.frontend

    cpdef public int run(GB self):
        if self.frontend is NULL:
            self.spawn_frontend()

        cdef unsigned int timer = 0
        cdef unsigned int cycles = 0
        with nogil:
            while not self.cpu.shutdown:
                if self.mem.IO.LY < 144:
                    self.mem.set_STAT_mode(2)
                    while timer < MODE_2_CYCLES * 4:
                        cycles = self.cpu.step()
                        self.mem.tick(cycles)
                        timer += cycles
                    timer -= MODE_2_CYCLES * 4

                    # change mode to 3
                    self.mem.set_STAT_mode(3)
                    while timer < MODE_3_CYCLES * 4:
                        cycles = self.cpu.step()
                        self.mem.tick(cycles)
                        timer += cycles
                    timer -= MODE_3_CYCLES * 4

                    # change mode to 0 and do HBlank stuff
                    self.mem.set_STAT_mode(0)
                    while timer < MODE_0_CYCLES * 4:
                        cycles = self.cpu.step()
                        self.mem.tick(cycles)
                        timer += cycles
                    timer -= MODE_0_CYCLES * 4
                else:
                    while timer < LINE_CYCLES * 4:
                        cycles = self.cpu.step()
                        self.mem.tick(cycles)
                        timer += cycles
                    timer -= LINE_CYCLES * 4

                self.mem.IO.LY = self.mem.IO.LY + 1
                if self.mem.IO.LY - 1 < 144:
                    self.ppu.draw_line(self.mem.IO.LY - 1)
                elif self.mem.IO.LY == 144:
                    self.mem.set_STAT_mode(1)
                    self.mem.IO.IF_ = self.mem.IO.IF_ | INTERRUPT_VBLANK
                    self.cpu.interrupt()
                elif self.mem.IO.LY == 154:
                    # send frame to screen
                    self.mem.IO.LY = 0
                
                if self.mem.IO.LYC == self.mem.IO.LY:
                    self.mem.IO.STAT = self.mem.IO.STAT | STAT_LY_COINCIDENCE
                    if self.mem.IO.STAT & STAT_LY_COINCIDENCE_INTR:
                        self.mem.IO.IF_ = self.mem.IO.IF_ | INTERRUPT_STAT
                        self.cpu.interrupt()

        self.close_frontend()

    cpdef public void bind_keyboard_input(GB self, str key, unsigned char mask):
        self.frontend.bind_keyboard_input(ord(key), mask)

    cpdef public void bind_controller_input(GB self, char button, unsigned char mask):
        self.frontend.bind_controller_input(button, mask)

    cdef void dump_vram(GB self) nogil:
        cdef FILE *dump 
        dump = fopen(b"VRAM.dump", "wb+")
        if dump is NULL:
            return
        fwrite(self.mem.VRAM, 0x2000, 1, dump)
        fclose(dump)

    cdef void print_status(GB self) nogil:
        printf(
            "A: %02X F: %02X B: %02X C: %02X D: %02X E: %02X H: %02X L: %02X SP: %04X PC: 00:%04X\n",
            self.cpu.registers[REG_A], self.cpu.F, 
            self.cpu.registers[REG_B], self.cpu.registers[REG_C], 
            self.cpu.registers[REG_D], self.cpu.registers[REG_E], 
            self.cpu.registers[REG_H], self.cpu.registers[REG_L], 
            self.cpu.SP, self.cpu.PC
        )
        printf("Halted: %d\n", self.cpu.halted)

    def __getitem__(self, address: int):
        return self.mem.read8(address)

    def step(self):
        return self.cpu.step()

    @property
    def shutdown(self):
        return self.cpu.shutdown