from src.apu.channels.square cimport SQUARE
from src.apu.channels.noise cimport NOISE
from src.frontend.frontend cimport Frontend
from libcpp.list cimport list as cpplist
from cython.operator import dereference, preincrement
from libc.stdio cimport printf


ctypedef int (*APU_callback)(void* data) nogil

cdef struct APU_event:
    unsigned long long time
    APU_callback callback
    void* data

cdef inline APU_event MakeEvent(unsigned long long time, APU_callback callback, void* data):
    cdef APU_event event
    event.time     = time
    event.callback = callback
    event.data     = data
    return event    


cdef class GBAPU:

    cdef:
        unsigned long long timer
        cpplist[APU_event] scheduler

        unsigned char frame_sequencer

        unsigned char NR50, NR51, NR52

        SQUARE square1
        SQUARE square2
        NOISE noise

        Frontend* frontend

    cdef int tick_frame_sequencer(GBAPU self) nogil
    cdef int provide_sample(GBAPU self) nogil

    cdef inline void schedule(GBAPU self, APU_event event) nogil:
        cdef cpplist[APU_event].iterator it
        cdef int i

        it = self.scheduler.begin()
        for i in range(self.scheduler.size()):
            if dereference(it).time > event.time:
                self.scheduler.insert(it, event)
                return

            preincrement(it)

    cdef inline void tick(GBAPU self, unsigned int cycles) nogil:
        cdef int reschedule_after

        cdef APU_event event = self.scheduler.front()
        self.timer += cycles

        while self.timer > event.time:
            reschedule_after = event.callback(event.data)
            self.scheduler.pop_front()
            if reschedule_after >= 0:
                event.time += reschedule_after
                self.schedule(event)
            event = self.scheduler.front()
