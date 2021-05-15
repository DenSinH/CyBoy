from libc.stdio cimport printf


cdef class WAVE:

    cdef void on_tick(self) nogil:
        if not self.DAC_power:
            return
        self.index += 1
        self.index &= 0xf

    cdef float get_sample(self) nogil:
        if not self.DAC_power:
            return self.current_sample
        
        cdef unsigned char sample = self.wave_ram[self.index >> 1]
        if not (self.index & 1):
            # first MSB, then LSB
            sample >>= 4
        else:
            sample &= 0xf

        return 2.0 * sample / 16.0 * self.volume / 16.0