cimport cython 


cdef inline unsigned short read16(unsigned char* ptr):
    return (<unsigned short*>ptr)[0]

@cython.final
cdef class MEM:
    cdef public:
        unsigned char BOOT[0x100]
        unsigned char ROM0[0x4000]
        unsigned char ROM1[0x4000]
        unsigned char VRAM[0x1000]

    cdef inline unsigned char read8(MEM self, unsigned short address):
        if address < 0x100:
            return self.BOOT[address]
        return 0

    cdef inline unsigned short read16(MEM self, unsigned short address):
        cdef unsigned short value
        if address < 0x100:
            return read16(&self.BOOT[address])
        return 0

    cdef inline void write8(MEM self, unsigned short address, unsigned char value):
        pass