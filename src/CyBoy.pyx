from libc.stdio cimport fopen, fclose, FILE, fread, fwrite, printf
from src.mem.mem cimport MakeROM

include "./generic/macros.pxi"
include "./mem/IO.pxi"

DEF MODE_2_CYCLES = 80
DEF MODE_3_CYCLES = 200  # depends on sprite count
DEF MODE_0_CYCLES = 176  # depends on sprite count
DEF LINE_CYCLES = 456

cdef class GB:
    def __cinit__(self):
        self.apu = GBAPU()
        self.mem = MEM(self.apu)
        self.cpu = GBCPU(self.mem)
        self.ppu = GBPPU(self.mem)

    cpdef public void load_bootrom(GB self, str file_name):
        cdef FILE *bootrom 
        bootrom = fopen(file_name.encode("UTF-8"), "rb")
        if bootrom is NULL:
            raise FileNotFoundError(f"File {file_name} does not exist")
        fread(&self.mem.BOOT, 0x100, 1, bootrom)
        fclose(bootrom)

        for i in range(0x100):
            self.mem.MMAP[i] = MakeROM(&self.mem.BOOT[i])
        self.mem.fast_read_MMAP[0] = NULL

    cpdef public void skip_bootrom(GB self):
        # A: 01 F: E0 B: 00 C: 13 D: 00 E: D8 H: 01 L: 4D SP: FFFE PC: 00:0100
        # todo: other IO writes
        # self.mem.write8(0xff05, 0x00)
        self.mem.write8(0xff05, 0x00)  # TIMA
        self.mem.write8(0xff06, 0x00)  # TMA
        self.mem.write8(0xff07, 0x00)  # TAC
        self.mem.write8(0xff10, 0x80)  # NR10
        self.mem.write8(0xff11, 0xbf)  # NR11
        self.mem.write8(0xff12, 0xF3)  # NR12
        self.mem.write8(0xff14, 0xbf)  # NR14
        self.mem.write8(0xff16, 0x3f)  # NR21
        self.mem.write8(0xff17, 0x00)  # NR22
        self.mem.write8(0xff19, 0xbf)  # NR24
        self.mem.write8(0xff1A, 0x7f)  # NR30
        self.mem.write8(0xff1B, 0xff)  # NR31
        self.mem.write8(0xff1C, 0x9f)  # NR32
        self.mem.write8(0xff1E, 0xbf)  # NR34
        self.mem.write8(0xff20, 0xff)  # NR41
        self.mem.write8(0xff21, 0x00)  # NR42
        self.mem.write8(0xff22, 0x00)  # NR43
        self.mem.write8(0xff23, 0xbf)  # NR44
        self.mem.write8(0xff24, 0x77)  # NR50
        self.mem.write8(0xff25, 0xf3)  # NR51
        self.mem.write8(0xff26, 0xf1)  # NR52
        self.mem.write8(0xff40, 0x91)  # LCDC
        self.mem.write8(0xff42, 0x00)  # SCY
        self.mem.write8(0xff43, 0x00)  # SCX
        self.mem.write8(0xff45, 0x00)  # LYC
        self.mem.write8(0xff47, 0xfc)  # BGP
        self.mem.write8(0xff48, 0xff)  # OBP0
        self.mem.write8(0xff49, 0xff)  # OBP1
        self.mem.write8(0xff4a, 0x00)  # WY
        self.mem.write8(0xff4b, 0x00)  # WX
        self.mem.write8(0xffff, 0x00)  # IE
        self.mem.write8(0xff50, 0x01)  # unmap boot rom
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
        self.mem.load_rom(file_name)

    cpdef public void spawn_frontend(GB self, bool video_sync, bool audio_sync):
        self.frontend = new Frontend(
            &self.cpu.shutdown,
            <unsigned char*>&self.ppu.display[0], 
            b"CyBoy",
            &self.mem.IO.JOYPAD,
            &self.ppu.frame,
            160,
            144,
            2
        )
        self.apu.frontend = self.frontend

        self.frontend.bind_callback(ord('v'), <frontend_callback>&GB.dump_vram, <void*>self)
        self.frontend.bind_callback(ord('o'), <frontend_callback>&GB.dump_oam, <void*>self)
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

        self.frontend.set_video_sync(video_sync)
        self.frontend.set_audio_sync(audio_sync)
        self.frontend.run()

    cpdef public void close_frontend(GB self):
        self.frontend.join()
        del self.frontend

    cpdef public int run(GB self):
        if self.frontend is NULL:
            self.spawn_frontend(True, True)  # video/audio sync is on by default

        cdef unsigned int i
        cdef unsigned int timer = 0
        cdef unsigned int cycles = 0
        cdef unsigned char line = 0
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

                self.apu.tick(LINE_CYCLES)

                if self.mem.IO.LY < 144:
                    self.ppu.draw_line(self.mem.IO.LY)
                elif self.mem.IO.LY == 144:
                    self.mem.set_STAT_mode(1)
                    self.mem.IO.IF_ = self.mem.IO.IF_ | INTERRUPT_VBLANK
                    self.cpu.interrupt()

                self.mem.IO.LY = self.mem.IO.LY + 1
                if self.mem.IO.LY == 154:
                    self.frontend.wait_for_frame()
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

    cdef void dump_oam(GB self) nogil:
        cdef FILE *dump 
        dump = fopen(b"OAM.dump", "wb+")
        if dump is NULL:
            return
        fwrite(self.mem.OAM, 0xa0, 1, dump)
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