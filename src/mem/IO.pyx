from src.mem.mem cimport *
from libc.stdio cimport printf


cdef unsigned char read_unimpIO(MEM mem, unsigned short address):
    print(f"Unimplemented read from address {address:04x}")
    return 0xff

cdef void write_unimpIO(MEM mem, unsigned short address, unsigned char value):
    print(f"Unimplemented write {value:02x} to address {address:04x}")

cdef void write_SB(MEM mem, unsigned short address, unsigned char value):
    printf("%c", value)

cdef unsigned char read_LY(MEM mem, unsigned short address):
    return 0x90

cdef void write_UnmapBoot(MEM mem, unsigned short address, unsigned char value):
    if value == 0:
        return
    cdef unsigned int i
    for i in range(0x100):
        mem.MMAP[i] = MakeROM(&mem.ROM0[i])