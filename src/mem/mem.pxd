cimport cython 


@cython.final
cdef class MEM:
    cdef public:
        unsigned char BOOT[0x100]
        unsigned char ROM0[0x4000]
        unsigned char ROM1[0x4000]
        unsigned char VRAM[0x1000]

    cdef public unsigned char read8(MEM self, unsigned short address)
    cdef public void write8(MEM self, unsigned short address, unsigned char value)