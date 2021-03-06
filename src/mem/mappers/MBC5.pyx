from src.mem.mem cimport MAPPER, MEM, MakeUnused, MakeRW
from libc.stdio cimport printf

include "../../generic/macros.pxi"

cdef class MBC5(MAPPER):

    cdef void write8(MBC5 self, unsigned short address, unsigned char value) nogil:
        cdef unsigned char region = address >> 12
        cdef unsigned short i
        cdef unsigned char bank
        if region == 0 or region == 1:
            if not self.RAM_amount:
                # no ram in cart
                return

            if value & 0xf == 0xa:
                # enable RAM
                self.enable_RAM()
            else:
                # disable RAM
                self.disable_RAM()
        elif region == 2:
            # mask to maximum of ROM_amount banks
            bank = value

            self.ROM_bank = bank & (self.ROM_amount - 1)
            for i in range(4):
                self.mem.fast_read_MMAP[4 + i] = &self.ROM[self.ROM_bank][i << 12]
            # this does not affect the upper 2 bits selecting the ROM0 bank
        elif region == 3:
            # ninth bit of the ROM bank
            # we do not support this much ROM anyway
            pass
        elif region == 4 or region == 5:
            if self.RAM_amount >= 4:  # at least 4 ram banks
                self.RAM_bank = value & 0xf & (self.RAM_amount - 1)

                # check if RAM is enabled at all
                if self.mem.fast_read_MMAP[0xa]:
                    self.enable_RAM()
            elif self.ROM_amount > 0x20:
                # upper 2 bits of ROM bank
                self.ROM_bank &= 0x1f                   # clear upper two bits
                self.ROM_bank |= (value & 3) << 5
                self.ROM_bank &= (self.ROM_amount - 1)  # mask to maximum ROM banks

                for i in range(4):
                    self.mem.fast_read_MMAP[4 + i] = &self.ROM[self.ROM_bank][i << 12]