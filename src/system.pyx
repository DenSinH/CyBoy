from libc.stdio cimport fopen, fclose, FILE, fread

include "./generic/macros.pxi"

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

    cpdef public int run(GB self):
        # cdef int i
        # cdef unsigned short value = 0x4209
        # for i in range(0xf000_0000):
        #     self.cpu.set_BC(value)
        #     if (i & 0x0fff_0000) == 0:
        #         print(hex(i))
        with nogil:
            while True:
                self.cpu.step()