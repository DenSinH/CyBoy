cdef inline MemoryEntry MakeRW(unsigned char* data):
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.data = data
    entry.write = True
    return entry

cdef inline MemoryEntry MakeROM(unsigned char* data):
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.callback = NULL
    entry.write = False
    return entry

cdef inline MemoryEntry MakeUnused():
    cdef MemoryEntry entry 
    entry.read_ptr.data = NULL
    entry.read = False
    entry.write_ptr.callback = NULL
    entry.write = False
    return entry

cdef unsigned char read_unimplemented(MEM mem):
    print("read from unimplemented address")
    quit(-1)

cdef void write_unimplemented(MEM mem, unsigned char value):
    print("write to unimplemented address")
    quit(-2)

cdef inline MemoryEntry MakeUnimplemented():
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read_unimplemented
    entry.read = False
    entry.write_ptr.callback = write_unimplemented
    entry.write = False
    return entry

cdef class MEM:
    
    def __cinit__(self):
        cdef unsigned int i
        for i in range(0x4000):
            self.MMAP[i] = MakeROM(&self.ROM0[i])
        
        # if we want to use the boot rom
        for i in range(0x100):
            self.MMAP[i] = MakeROM(&self.BOOT[i])

        for i in range(0x4000):
            self.MMAP[0x4000 + i] = MakeROM(&self.ROM1[i])

        for i in range(0x2000):
            self.MMAP[0x8000 + i] = MakeRW(&self.VRAM[i])

        for i in range(0x2000):
            self.MMAP[0xa000 + i] = MakeRW(&self.ERAM[i])

        for i in range(0x1000):
            self.MMAP[0xc000 + i] = MakeRW(&self.WRAMlo[i])
        for i in range(0x1000):
            self.MMAP[0xd000 + i] = MakeRW(&self.WRAMhi[i])

        for i in range(0x1000):  # ECHO RAM
            self.MMAP[0xe000 + i] = MakeRW(&self.WRAMlo[i])
        for i in range(0xe00):   # ECHO RAM
            self.MMAP[0xf000 + i] = MakeRW(&self.WRAMhi[i])

        for i in range(0xa0):
            self.MMAP[0xfe00 + i] = MakeRW(&self.OAM[i])

        for i in range(0x60):
            self.MMAP[0xfea0 + i] = MakeUnused()

        for i in range(0x80):   # IO
            self.MMAP[0xff00 + i] = MakeUnimplemented()

        for i in range(0x7f):
            self.MMAP[0xff80 + i] = MakeRW(&self.HRAM[i])
        self.MMAP[0xffff] = MakeUnimplemented()  # IE
            
