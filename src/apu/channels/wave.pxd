from src.apu.channels.channel cimport APU_CHANNEL
from libcpp cimport bool


cdef class WAVE(APU_CHANNEL):
    cdef:
        unsigned char[16] wave_ram
        bool DAC_power
        unsigned char index
        unsigned short frequency

    cdef void on_tick(self) nogil
    cdef float get_sample(self) nogil