from src.mem.mem cimport MAPPER, MEM, MakeUnused, MakeRW
from libc.stdio cimport printf

include "../../generic/macros.pxi"

cdef class MBC3(MAPPER):

    cdef void write8(MBC3 self, unsigned short address, unsigned char value) nogil:
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
        elif region == 2 or region == 3:
            # mask to maximum of ROM_amount banks
            bank = value & 0x7f

            self.ROM_bank = bank & (self.ROM_amount - 1)
            if not self.ROM_bank:
                # only adjust bank 0 if actual bank 0 is selected
                for i in range(4):
                    self.mem.fast_read_MMAP[4 + i] = &self.ROM[1][i << 12]
            else:
                for i in range(4):
                    self.mem.fast_read_MMAP[4 + i] = &self.ROM[self.ROM_bank][i << 12]
            # this does not affect the upper 2 bits selecting the ROM0 bank
        elif region == 4 or region == 5:
            if value < 4:
                self.RAM_bank = value & (self.RAM_amount - 1)

                # check if RAM is enabled at all
                if self.mem.fast_read_MMAP[0xa]:
                    self.enable_RAM()
            elif 0x8 <= value < 0xc:
                    self.disable_RAM()
                # enable RTC registers
        elif region == 6 or region == 7:
            # latch clock
            pass
