from src.mem.mappers.mapper cimport MAPPER


cdef class MBC1(MAPPER):

    cdef void write8(MBC1 self, unsigned short address, unsigned char value) nogil