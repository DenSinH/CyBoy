from src.apu.gbapu cimport GBAPU
from libc.stdio cimport printf
from libc.stdlib cimport rand, RAND_MAX


cdef class NOISE:

    def __cinit__(self, GBAPU apu):
        self.reset_shift_register()

    cdef void on_tick(self) nogil:
        # Noise randomly switches between HIGH and LOW levels, the output levels are calculated by a shift register (X),
        # at the selected frequency, as such:
        # 7bit:  X=X SHR 1, IF carry THEN Out=HIGH, X=X XOR 40h ELSE Out=LOW
        # 15bit: X=X SHR 1, IF carry THEN Out=HIGH, X=X XOR 4000h ELSE Out=LOW
        # The initial value when (re-)starting the sound is X=40h (7bit) or X=4000h (15bit).
        # The data stream repeats after 7Fh (7bit) or 7FFFh (15bit) steps.
        cdef unsigned int carry = (self.shift_register ^ (self.shift_register >> 1)) & 1
        self.shift_register >>= 1
        self.shift_register |= carry << 15

        if carry:
           if self.counter_step_width:
               self.shift_register ^= 0x6000
           else:
               self.shift_register ^= 0x60

    cdef float get_sample(self) nogil:
        if not (self.shift_register & 1):
            return 1.0 * self.volume / 16.0
        return -1.0 * self.volume / 16.0

    cdef void do_envelope(self) nogil:
        if not self.envelope_period:
            return

        self.envelope_time -= 1
        if self.envelope_time == 0:
            self.reset_envelope()
            if self.envelope_up:
                self.volume += 1
            else:
                self.volume -= 1
            
            if <int>self.volume >= 16:
                self.volume = 15
            if <int>self.volume < 0:
                self.volume = 0