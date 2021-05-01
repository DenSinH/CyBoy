from src.mem.mem cimport MEM

# ctypedef unsigned char (*read_callback)(MEM mem, unsigned short address)
# ctypedef void (*write_callback)(MEM mem, unsigned short address, unsigned char value)

cdef unsigned char read_LY(MEM mem, unsigned short address)