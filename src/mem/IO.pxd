from src.mem.mem cimport MEM

# ctypedef unsigned char (*read_callback)(MEM mem, unsigned short address)
# ctypedef void (*write_callback)(MEM mem, unsigned short address, unsigned char value)

cdef unsigned char read_unimpIO(MEM mem, unsigned short address) nogil
cdef void write_unimpIO(MEM mem, unsigned short address, unsigned char value) nogil

cdef unsigned char read_JOYP(MEM mem, unsigned short address) nogil
cdef void write_DIV(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_TAC(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_SB(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_DMA(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_IF(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_IE(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_STAT(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_NR10(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR11(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR12(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR13(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR14(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_NR21(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR22(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR23(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR24(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_NR30(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR31(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR32(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR33(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR34(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_NR41(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR42(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR43(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_NR44(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_UnmapBoot(MEM mem, unsigned short address, unsigned char value) nogil