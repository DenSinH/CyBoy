from src.mem.mem cimport MEM, IO_REGS

cdef class GBPPU:
    cdef:
        # RRGGBBXX
        unsigned int[144][160] display;      # data on screen
        unsigned int[144][160] framebuffer;  # data being edited by emulator (copied to display on VBlank)
        char[160] bg_pixels                  # palette index of pixel
        char[160] obj_pixels                 # -1: no pixel, otherwise: the pixel of the object
        unsigned short[160] obj_src_x        # x coordinate of the sprite that caused the pixel at the given x coordinate
        unsigned char[160] obj_attrs         # the object attributes of the top pixel
        MEM mem

        unsigned char window_ly

        unsigned int frame

    cdef void draw_line(GBPPU self, unsigned char y) nogil
    cdef void draw_bg(GBPPU self, unsigned char y) nogil
    cdef void draw_window(GBPPU self, unsigned char y) nogil
    cdef void draw_obj(GBPPU self, unsigned char y) nogil
    cdef void composite_layer(GBPPU self, unsigned char y) nogil
    cdef void copy_buffer(GBPPU self) nogil