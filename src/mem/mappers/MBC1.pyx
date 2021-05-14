from src.mem.mem cimport MAPPER, MEM, MakeUnused, MakeRW
from libc.stdio cimport printf

include "../../generic/macros.pxi"

cdef class MBC1(MAPPER):

    cdef void write8(MBC1 self, unsigned short address, unsigned char value) nogil:
        cdef unsigned char region = address >> 12
        cdef unsigned short i
        cdef unsigned char bank, old_mode
        if region == 0 or region == 1:
            if not self.RAM_amount:
                # no ram in cart
                return

            if value & 0xf == 0xa:
                # enable RAM. In banking mode 0, only RAM bank 0 is accessible
                if self.banking_mode == 0:
                    bank = self.RAM_bank
                    self.RAM_bank = 0
                self.enable_RAM()
                if self.banking_mode == 0:
                    self.RAM_bank = bank
            else:
                # disable RAM
                self.disable_RAM()
        elif region == 2 or region == 3:
            # mask to maximum of ROM_amount banks
            bank = value & 0x1f

            if not bank:   
                # MBC translates 0 to 1
                bank = 1
            self.ROM_bank = ((self.ROM_bank & 0xe0) | bank) & (self.ROM_amount - 1)
            for i in range(4):
                self.mem.fast_read_MMAP[4 + i] = &self.ROM[self.ROM_bank][i << 12]
            # this does not affect the upper 2 bits selecting the ROM0 bank
        elif region == 4 or region == 5:
            if self.banking_mode and self.RAM_amount >= 4:  # at least 4 ram banks
                self.RAM_bank = value & 3

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

                if self.banking_mode:
                    # if we are in banking mode 1, also switch 0000-3fff
                    for i in range(4):
                        self.mem.fast_read_MMAP[i] = &self.ROM[self.ROM_bank & 0x60][i << 12]  # lower bank always 0x00, 0x20, 0x40, ...
        elif region == 6 or region == 7:
            old_mode = self.banking_mode
            self.banking_mode = value & 1

            # immediately enable RAM selected by 2 bit register at region 4/5 (if enabled)
            if self.mem.fast_read_MMAP[0xa] and self.RAM_amount >= 4:  # 4 ram banks
                # RAM is enabled, switch immediately
                if self.banking_mode == 0:
                    bank = self.RAM_bank
                    self.RAM_bank = 0
                self.enable_RAM()
                if self.banking_mode == 0:
                    self.RAM_bank = bank

            if old_mode and not self.banking_mode and self.ROM_bank > 0x20:
                # banking mode disabled, switch back 0x0000 - 0x3fff area
                for i in range(4):
                    self.mem.fast_read_MMAP[i] = &self.ROM[0][i << 12]
            elif self.banking_mode and not old_mode and self.ROM_bank > 0x20:
                # switch 0x0000 - 0x3fff area if banking mode is enabled
                for i in range(4):
                    self.mem.fast_read_MMAP[i] = &self.ROM[self.ROM_bank & 0x60][i << 12]  # lower bank always 0x00, 0x20, 0x40, ...
