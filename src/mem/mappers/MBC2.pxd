from src.mem.mem cimport MAPPER


cdef class MBC2(MAPPER):

    cdef void write8(MBC2 self, unsigned short address, unsigned char value) nogil