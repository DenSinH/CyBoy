from src.mem.mem cimport MAPPER, MEM, MakeUnused, MakeRW
from libc.stdio cimport printf


cdef class MBC1(MAPPER):

    cdef void write8(MBC1 self, unsigned short address, unsigned char value) nogil:
        cdef unsigned char region = address >> 12
        cdef unsigned short i
        cdef unsigned char bank
        if region == 0 or region == 1:
            if not self.RAM_amount:
                # no ram in cart
                return

            if value & 0xf == 0:
                # disable RAM
                for i in range(0x2000):
                    self.mem.MMAP[0xa000 + i] = MakeUnused()
            elif value & 0xf == 0xa:
                # enable RAM
                for i in range(0x2000):
                    self.mem.MMAP[0xa000 + i] = MakeRW(&self.RAM[self.RAM_bank][i])
        elif region == 2 or region == 3:
            # mask to maximum of ROM_amount banks
            bank = value & ((self.ROM_amount << 1) - 1) & 0x1f

            if not bank:  
                # MBC translates 0 to 1
                bank = 1
            self.ROM_bank = (self.ROM_bank & 0xe0) | bank
            for i in range(0x4000):
                self.mem.MMAP[0x4000 + i].read_ptr.data = &self.ROM[self.ROM_bank][i]
        elif region == 4 or region == 5:
            if self.banking_mode and self.RAM_amount >= 4:  # at least 4 ram banks
                self.RAM_bank = value & 3

                # check if RAM is enabled at all
                if self.mem.MMAP[0xa000].read:
                    for i in range(0x2000):
                        self.mem.MMAP[0xa000 + i] = MakeRW(&self.RAM[self.RAM_bank][i])
            elif self.ROM_amount >= 0x20:
                # upper 2 bits of ROM bank
                self.ROM_bank |= (value & 3) << 5
                self.ROM_bank &= ((self.ROM_amount << 1) - 1)  # mask to maximum ROM banks

                for i in range(0x4000):
                    self.mem.MMAP[0x4000 + i] = MakeRW(&self.ROM[self.ROM_bank][i])

                if self.banking_mode:
                    # if we are in banking mode 1, also switch 0000-3fff
                    for i in range(0x4000):
                        self.mem.MMAP[i] = MakeRW(&self.ROM[self.ROM_bank & 0x60][i])  # lower bank always 0x00, 0x20, 0x40, ...
        elif region == 6 or region == 7:
            bank = self.banking_mode
            self.banking_mode = value & 1

            # immediately enable RAM selected by 2 bit register at region 4/5 (if enabled)
            if self.mem.MMAP[0xa000].read and self.RAM_amount >= 4:  # 4 ram banks
                self.RAM_bank = value & 3

                # check if RAM is enabled at all
                if self.mem.MMAP[0xa000].read:
                    for i in range(0x2000):
                        self.mem.MMAP[0xa000 + i] = MakeRW(&self.RAM[self.RAM_bank][i])

            if bank and not self.banking_mode and self.ROM_bank >= 0x20:
                # banking mode disabled, switch back 0x0000 - 0x3fff area
                for i in range(0x4000):
                    self.mem.MMAP[i] = MakeRW(&self.ROM[0][i])
            elif self.banking_mode and not bank and self.ROM_bank >= 0x20:
                # switch 0x0000 - 0x3fff area if banking mode is enabled
                for i in range(0x4000):
                    self.mem.MMAP[i] = MakeRW(&self.ROM[self.ROM_bank & 0x60][i])  # lower bank always 0x00, 0x20, 0x40, ...
