from src.mem.mem cimport MEM

# ctypedef unsigned char (*read_callback)(MEM mem, unsigned short address)
# ctypedef void (*write_callback)(MEM mem, unsigned short address, unsigned char value)

cdef unsigned char read_unimpIO(MEM mem, unsigned short address) nogil
cdef void write_unimpIO(MEM mem, unsigned short address, unsigned char value) nogil

cdef unsigned char read_JOYP(MEM mem, unsigned short address) nogil
cdef void write_DIV(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_TAC(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_SB(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_IF(MEM mem, unsigned short address, unsigned char value) nogil
cdef void write_IE(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_STAT(MEM mem, unsigned short address, unsigned char value) nogil

cdef void write_UnmapBoot(MEM mem, unsigned short address, unsigned char value) nogil