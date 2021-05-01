from libc.stdio cimport fopen, fclose, FILE, fread

cdef class GB:
    def __cinit__(self):
        self.mem = MEM()
        self.cpu = GBCPU(self.mem)

    cpdef public void load_bootrom(GB self, str file_name):
        cdef FILE *bootrom 
        bootrom = fopen(file_name.encode("UTF-8"), "rb")
        if bootrom is NULL:
            raise FileNotFoundError(f"File {file_name} does not exist")
        fread(&self.mem.BOOT, 0x100, 1, bootrom)
        fclose(bootrom)

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
        while True:
            self.cpu.step()