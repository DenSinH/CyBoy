from src.apu.gbapu cimport GBAPU


cdef class SQUARE:
    
    def __cinit__(self, GBAPU apu):
        self.set_duty(0)

    cdef void on_tick(self) nogil:
        self.index += 1
        self.index &= 7

    cdef float get_sample(self) nogil:
        if self.duty & (1 << self.index):
            return (1.0 * self.volume) / 16.0
        return -(1.0 * self.volume) / 16.0