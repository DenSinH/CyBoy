

cdef class GBAPU:
    
    def __cinit__(self):

        self.scheduler.push_front(MakeEvent(-1, NULL, NULL))  # will crash, just here so that the scheduler is not empty
        self.scheduler.push_front(MakeEvent(0, <APU_callback>&GBAPU.tick_frame_sequencer, <void*>self))
        self.scheduler.push_front(MakeEvent(0, <APU_callback>&GBAPU.provide_sample, <void*>self))

        # scheduler must be non-empty when we add the channel events
        self.square1 = SQUARE(self)
        self.square2 = SQUARE(self)


    cdef int tick_frame_sequencer(GBAPU self) nogil:
        self.frame_sequencer += 1
        self.frame_sequencer &= 7

        if self.frame_sequencer == 0 or self.frame_sequencer == 2 or self.frame_sequencer == 4 or self.frame_sequencer == 6:
            self.square1.tick_length_counter()
            self.square2.tick_length_counter()

        return 8192  # period of ticking the frame sequencer

    cdef int provide_sample(GBAPU self) nogil:
        cdef float sample = 0.01 * self.square1.current_sample

        self.frontend.provide_sample(sample, sample)
        return 128

        