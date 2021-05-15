from src.apu.gbapu cimport GBAPU, MakeEvent, APU_callback


cdef class APU_CHANNEL:

    def __cinit__(self, GBAPU apu):
        apu.schedule(MakeEvent(0, <APU_callback>APU_CHANNEL.tick, <void*>self))
        self.period = 2048

    cdef void on_tick(self) nogil:
        return
        
    cdef float get_sample(self) nogil:
        return 0