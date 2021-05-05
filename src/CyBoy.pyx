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
            &self.ppu.frame,
            160,
            144,
            2
        )

        self.frontend.bind_callback(ord('v'), <frontend_callback>&GB.dump_vram, <void*>self)
        self.frontend.run()

    cpdef public void close_frontend(GB self):
        self.frontend.join()
        del self.frontend

    cpdef public int run(GB self):
        self.spawn_frontend()

        cdef unsigned int timer = 0
        with nogil:
            while not self.cpu.shutdown:
                if self.mem.IO.LY < 144:
                    self.mem.set_STAT_mode(2)
                    while timer < MODE_2_CYCLES * 4:
                        timer += self.cpu.step()
                    timer -= MODE_2_CYCLES * 4

                    # change mode to 3
                    self.mem.set_STAT_mode(3)
                    while timer < MODE_3_CYCLES * 4:
                        timer += self.cpu.step()
                    timer -= MODE_3_CYCLES * 4

                    # change mode to 0 and do HBlank stuff
                    self.mem.set_STAT_mode(0)
                    while timer < MODE_0_CYCLES * 4:
                        timer += self.cpu.step()
                    timer -= MODE_0_CYCLES * 4
                else:
                    while timer < LINE_CYCLES * 4:
                        timer += self.cpu.step()
                    timer -= LINE_CYCLES * 4

                self.mem.IO.LY = self.mem.IO.LY + 1
                if self.mem.IO.LY < 144:
                    self.ppu.draw_line(self.mem.IO.LY)
                elif self.mem.IO.LY == 144:
                    self.mem.set_STAT_mode(1)
                    self.mem.IO.IF_ = self.mem.IO.IF_ | INTERRUPT_VBLANK
                    self.cpu.interrupt()
                elif self.mem.IO.LY == 154:
                    # send frame to screen
                    self.mem.IO.LY = 0

        self.close_frontend()

    cdef void dump_vram(GB self) nogil:
        cdef FILE *dump 
        dump = fopen(b"VRAM.dump", "wb+")
        if dump is NULL:
            return
        fwrite(self.mem.VRAM, 0x2000, 1, dump)
        fclose(dump)

    def __getitem__(self, address: int):
        return self.mem.read8(address)

    def step(self):
        return self.cpu.step()

    @property
    def shutdown(self):
        return self.cpu.shutdown