from libcpp cimport bool
from libc.stdio cimport printf


cdef class APU_CHANNEL:
    cdef:
        int length_counter
        unsigned int period
        unsigned int volume
        float current_sample

        bool length_flag
        bool enabled

    cdef void on_tick(self) nogil
    cdef float get_sample(self) nogil

    cdef inline void tick_length_counter(self) nogil:
        if self.length_counter > 0:
            self.length_counter -= 1

    cdef inline void trigger(self) nogil:
        self.enabled = True
        if self.length_counter == 0:
            self.length_counter = 64

    cdef inline bool sound_on(self) nogil:
        if not self.enabled:
            return False

        if self.length_flag and (self.length_counter == 0):
            return False

        if self.volume == 0:
            return False
        return True


    cdef inline int tick(self) nogil:
        self.on_tick()
        if self.sound_on():
            self.current_sample = self.get_sample()
            return self.period
        return 128  # 32.768kHz