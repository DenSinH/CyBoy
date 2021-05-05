from src.mem.IO cimport *
from libc.stdio cimport printf
from libc.stdlib cimport exit

cdef MemoryEntry MakeRW(unsigned char* data) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.data = data
    entry.write = True
    return entry

cdef MemoryEntry MakeROM(unsigned char* data) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.callback = NULL
    entry.write = False
    return entry

cdef MemoryEntry MakeUnused() nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = NULL
    entry.read = False
    entry.write_ptr.callback = NULL
    entry.write = False
    return entry

cdef MemoryEntry MakeIO(read_callback read, write_callback write) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read
    entry.read = False
    entry.write_ptr.callback = write
    entry.write = False
    return entry

cdef unsigned char read_unimplemented(MEM mem, unsigned short address) nogil:
    printf("read from unimplemented address %04x\n", address)
    exit(-1)

cdef void write_unimplemented(MEM mem, unsigned short address, unsigned char value) nogil:
    printf("write %02x to unimplemented address %04x\n", value, address)
    exit(-2)

cdef inline MemoryEntry MakeUnimplemented() nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read_unimplemented
    entry.read = False
    entry.write_ptr.callback = write_unimplemented
    entry.write = False
    return entry

cdef inline MemoryEntry MakeUnimpIO() nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read_unimpIO
    entry.read = False
    entry.write_ptr.callback = write_unimpIO
    entry.write = False
    return entry

cdef inline MemoryEntry MakeComplexWrite(unsigned char* data, write_callback write):
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.callback = write
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
            self.MMAP[0xff00 + i] = MakeUnimpIO()

        self.MMAP[0xff01] = MakeIO(NULL, write_SB)
        self.MMAP[0xff02] = MakeIO(NULL, NULL)  # todo
        self.MMAP[0xff07] = MakeUnimpIO()
        self.MMAP[0xff0f] = MakeComplexWrite(&self.IO.IF_, write_IF)
        self.MMAP[0xff11] = MakeUnimpIO()
        self.MMAP[0xff12] = MakeUnimpIO()
        self.MMAP[0xff13] = MakeUnimpIO()
        self.MMAP[0xff14] = MakeUnimpIO()
        self.MMAP[0xff17] = MakeUnimpIO()
        self.MMAP[0xff19] = MakeUnimpIO()
        self.MMAP[0xff21] = MakeUnimpIO()
        self.MMAP[0xff23] = MakeUnimpIO()
        self.MMAP[0xff24] = MakeUnimpIO()
        self.MMAP[0xff25] = MakeUnimpIO()
        self.MMAP[0xff26] = MakeUnimpIO()
        self.MMAP[0xff40] = MakeRW(&self.IO.LCDC)
        self.MMAP[0xff41] = MakeComplexWrite(&self.IO.STAT, write_STAT)
        self.MMAP[0xff42] = MakeRW(&self.IO.SCY)
        self.MMAP[0xff43] = MakeRW(&self.IO.SCX)
        self.MMAP[0xff44] = MakeROM(&self.IO.LY)
        self.MMAP[0xff47] = MakeUnimpIO()
        self.MMAP[0xff48] = MakeUnimpIO()
        self.MMAP[0xff49] = MakeUnimpIO()
        self.MMAP[0xff50] = MakeIO(NULL, write_UnmapBoot)
        self.MMAP[0xff7f] = MakeUnimpIO()

        for i in range(0x7f):
            self.MMAP[0xff80 + i] = MakeRW(&self.HRAM[i])

        self.MMAP[0xffff] = MakeComplexWrite(&self.IO.IE, write_IE)  # IE
