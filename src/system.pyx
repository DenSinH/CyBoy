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

    cdef public int run(GB self):
        while True:
            self.cpu.step()