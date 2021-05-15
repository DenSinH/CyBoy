from src.apu.gbapu cimport GBAPU


cdef class SQUARE:
    
    def __cinit__(self, GBAPU apu):
        self.set_duty(0)

    cdef void on_tick(self) nogil:
        self.index += 1
        self.index &= 7

    cdef void do_sweep(self) nogil:
        if self.sweep_period == 0:
            return

        self.sweep_timer -= 1
        cdef int d_period
        if self.sweep_timer == 0:
            d_period = self.period_shadow >> self.sweep_number
            if not self.sweep_up:
                d_period = -d_period
            
            self.period += d_period
            if self.period <= 0:
                self.period = 1
            elif self.period >= 1 << 22:
                self.period = 1 << 22

            self.sweep_reload()

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

    cdef float get_sample(self) nogil:
        if self.duty & (1 << self.index):
            return (1.0 * self.volume) / 16.0
        return -(1.0 * self.volume) / 16.0