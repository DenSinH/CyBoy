from src.mem.mem cimport *
from libc.stdio cimport printf

include "./IO.pxi"

cdef unsigned char read_unimpIO(MEM mem, unsigned short address) nogil:
    # printf("Unimplemented read from address %04x\n", address)
    return 0xff

cdef void write_unimpIO(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("Unimplemented write %02x to address %04x\n", value, address)
    pass

cdef unsigned char read_JOYP(MEM mem, unsigned short address) nogil:
    cdef unsigned char value = mem.IO.JOYP & 0x30
    if value & 0x20:    # direction buttons
        return value | ~(mem.IO.JOYPAD & 0xf)
    elif value & 0x10:  # action buttons
        return value | ~(mem.IO.JOYPAD >> 4)
    return value | 0xf

cdef void write_DIV(MEM mem, unsigned short address, unsigned char value) nogil:
    mem.IO.DIV = 0

cdef unsigned int[4] TAC_SETTINGS = [
    1024, 16, 64, 256
]

cdef void write_TAC(MEM mem, unsigned short address, unsigned char value) nogil:
    cdef unsigned char old = mem.IO.TAC
    mem.IO.TAC = value & 7
    mem.IO.TIMA_limit = TAC_SETTINGS[value & 3]
    if (value & TIMA_ENABLED):
        if not (old & TIMA_ENABLED):
            # printf("Start timer %02x %02x\n", mem.IO.TMA, mem.IO.TIMA_limit)
            mem.IO.TIMA_timer = 0
            mem.IO.TIMA = mem.IO.TMA

cdef void write_SB(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("%c", value)
    pass

cdef void write_DMA(MEM mem, unsigned short address, unsigned char value) nogil:
    mem.IO.DMA = value
    cdef unsigned short src     = <unsigned short>value << 8
    cdef unsigned short offset  = 0
    if value < 0xe0:
        for offset in range(0x100):
            mem.write8(0xfe00 + offset, mem.read8(src + offset))

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