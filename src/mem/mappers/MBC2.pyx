from src.mem.mem cimport MAPPER, MEM, MakeUnused, MakeRW
from libc.stdio cimport printf

include "../../generic/macros.pxi"

cdef class MBC2(MAPPER):

    cdef void write8(MBC2 self, unsigned short address, unsigned char value) nogil:
        if address >= 0x4000:
            return
        
        cdef unsigned short i, j
        if address & 0x0100:
            # control selected ROM bank
            self.ROM_bank = value & 0xf
            if not self.ROM_bank:
                self.ROM_bank = 1
            self.ROM_bank &= (self.ROM_amount - 1)
            for i in range(4):
                self.mem.fast_read_MMAP[4 + i] = &self.ROM[self.ROM_bank][i << 12]
        else:
            # control RAM enable
            if (value & 0xf) == 0xa:
                # enable
                for i in range(0x200):
                    # RAM is mirrored
                    for j in range(0x10):
                        self.mem.MMAP[ERAM_START + j * 0x200 + i] = MakeRW(&self.RAM[0][i])
            else:
                for i in range(0x2000):
                    self.mem.MMAP[ERAM_START + i] = MakeUnused()

