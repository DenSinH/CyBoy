from src.mem.mappers.mapper cimport MAPPER


cdef class MBC3(MAPPER):

    cdef void write8(MBC3 self, unsigned short address, unsigned char value) nogil