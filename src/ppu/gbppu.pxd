from src.mem.mem cimport MEM, IO_REGS

cdef class GBPPU:
    cdef:
        # RRGGBBXX
        unsigned int[144][160] display;      # data on screen
        unsigned int[144][160] framebuffer;  # data being edited by emulator (copied to display on VBlank)
        MEM mem

        unsigned int frame

    cdef void draw_line(GBPPU self, unsigned char y) nogil
    cdef void copy_buffer(GBPPU self) nogil