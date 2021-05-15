from src.apu.channels.channel cimport APU_CHANNEL
from libcpp cimport bool


cdef class NOISE(APU_CHANNEL):
    cdef:
        bool counter_step_width
        unsigned int shift_register

        int envelope_time, envelope_period
        bool envelope_up

    cdef inline void reset_shift_register(self) nogil:
        if self.counter_step_width:
            self.shift_register = 0x4000
        else:
            self.shift_register = 0x40

    cdef inline void reset_envelope(self) nogil:
        self.envelope_time = self.envelope_period

    cdef void on_tick(self) nogil
    cdef float get_sample(self) nogil
    cdef void do_envelope(self) nogil