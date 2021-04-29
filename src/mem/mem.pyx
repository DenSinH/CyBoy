cdef class MEM:

    cdef public unsigned char read8(MEM self, unsigned short address):
        if address < 0x100:
            return self.BOOT[address]
        return 0

    cdef public void write8(MEM self, unsigned short address, unsigned char value):
        pass