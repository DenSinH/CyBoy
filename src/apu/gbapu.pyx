

cdef class GBAPU:
    
    def __cinit__(self):

        self.scheduler.push_front(MakeEvent(-1, NULL, NULL))  # will crash, just here so that the scheduler is not empty
        self.scheduler.push_front(MakeEvent(0, <APU_callback>&GBAPU.tick_frame_sequencer, <void*>self))
        self.scheduler.push_front(MakeEvent(0, <APU_callback>&GBAPU.provide_sample, <void*>self))

        # scheduler must be non-empty when we add the channel events
        self.square1 = SQUARE(self)
        self.square2 = SQUARE(self)
        self.wave    = WAVE(self)
        self.noise   = NOISE(self)

    cdef int tick_frame_sequencer(GBAPU self) nogil:
        self.frame_sequencer += 1
        self.frame_sequencer &= 7

        if self.frame_sequencer == 0 or self.frame_sequencer == 2 or self.frame_sequencer == 4 or self.frame_sequencer == 6:
            if self.frame_sequencer == 2 or self.frame_sequencer == 6:
                self.square1.do_sweep()
            self.square1.tick_length_counter()
            self.square2.tick_length_counter()
            self.wave.tick_length_counter()
            self.noise.tick_length_counter()
        elif self.frame_sequencer == 7:
            self.square1.do_envelope()
            self.square2.do_envelope()
            self.noise.do_envelope()

        return 8192  # period of ticking the frame sequencer

    cdef int provide_sample(GBAPU self) nogil:
        cdef float left, right
        left  = 0
        right = 0
        if (self.NR52 & 0x80):
            if self.NR51 & 0x01:
                right += self.square1.current_sample
            if self.NR51 & 0x10:
                left += self.square1.current_sample
        
            if self.NR51 & 0x02:
                right += self.square2.current_sample
            if self.NR51 & 0x20:
                left += self.square2.current_sample

            if self.NR51 & 0x04:
                right += self.wave.current_sample
            if self.NR51 & 0x40:
                left += self.wave.current_sample

            if self.NR51 & 0x08:
                right += self.noise.current_sample
            if self.NR51 & 0x80:
                left += self.noise.current_sample
            
            right *= (self.NR50 & 7) / 7.0
            left  *= ((self.NR50 >> 4) & 7) / 7.0

            right *= 0.05
            left  *= 0.05

        self.frontend.provide_sample(left, right)
        return 128

        