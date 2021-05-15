from src.apu.channels.channel cimport APU_CHANNEL
from libc.stdio cimport printf


cdef class SQUARE(APU_CHANNEL):
    cdef:
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

    cdef void on_tick(self) nogil
    cdef float get_sample(self) nogil
