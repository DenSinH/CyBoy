from src.mem.mem cimport *
from libc.stdio cimport printf


cdef unsigned char read_unimpIO(MEM mem, unsigned short address) nogil:
    # printf("Unimplemented read from address %04x\n", address)
    return 0xff

cdef void write_unimpIO(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("Unimplemented write %02x to address %04x\n", value, address)
    pass

cdef void write_SB(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("%c", value)
    pass

cdef void write_IF(MEM mem, unsigned short address, unsigned char value) nogil:
    mem.IO.IF_ = value & 0x1f
    mem.interrupt_cpu(mem.cpu)

cdef void write_IE(MEM mem, unsigned short address, unsigned char value) nogil:
    mem.IO.IE = value & 0x1f
    mem.interrupt_cpu(mem.cpu)

cdef void write_STAT(MEM mem, unsigned short address, unsigned char value) nogil:
    mem.IO.STAT = (mem.IO.STAT & 0x3) | (value & 0xfc)

cdef void write_UnmapBoot(MEM mem, unsigned short address, unsigned char value) nogil:
    if value == 0:
        return
    cdef unsigned int i
    for i in range(0x100):
        mem.MMAP[i] = MakeROM(&mem.ROM0[i])