from src.apu.channels.channel cimport APU_CHANNEL
from libcpp cimport bool
from libc.stdio cimport printf


cdef class SQUARE(APU_CHANNEL):
    cdef:
        unsigned char sweep_period
        unsigned char sweep_timer
        bool sweep_up
        unsigned char sweep_number
        unsigned short period_shadow

        int envelope_period
        int envelope_time
        bool envelope_up

        unsigned short frequency
        unsigned char duty
        unsigned char index

    cdef inline void set_duty(self, unsigned char duty) nogil:
        if duty == 0:
            self.duty = 0x01
        elif duty == 1:
            self.duty = 0x03
        elif duty == 2:
            self.duty = 0x0f
        elif duty == 3:
            self.duty = 0x3f

    cdef inline void sweep_reload(self) nogil:
        self.period_shadow = self.period
        self.sweep_timer = self.sweep_period

    cdef inline void reset_envelope(self) nogil:
        self.envelope_time = self.envelope_period

    cdef void do_envelope(self) nogil
    cdef void do_sweep(self) nogil
    cdef void on_tick(self) nogil
    cdef float get_sample(self) nogil
