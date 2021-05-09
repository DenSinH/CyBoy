from src.mem.mem cimport MAPPER


cdef class MBC5(MAPPER):

    cdef void write8(MBC5 self, unsigned short address, unsigned char value) nogil