from libc.stdio cimport printf
from libc.string cimport memcpy

DEF SCREEN_HEIGHT         = 154
DEF VISIBLE_SCREEN_HEIGHT = 144

include "../mem/IO.pxi"

cdef unsigned int[4] palette = [
    0xcadc9f00, 0x8bac0f00, 0x30623000, 0x0f380f00
]

cdef class GBPPU:

    def __cinit__(self, MEM mem):
        self.mem = mem

        cdef int i, j
        for i in range(160):
            for j in range(144):
                self.display[j][i] = 0xffff_ffff

    cdef void draw_line(GBPPU self, unsigned char y) nogil:
        cdef unsigned char LCDC = self.mem.IO.LCDC
        if not (LCDC & LCDC_PPU_ENABLE):
            return

        cdef unsigned short tile_id_address = 0x1800
        if LCDC & LCDC_BG_TILE_MAP:
            tile_id_address = 0x1c00

        cdef unsigned short tile_data = 0x1000
        if LCDC & LCDC_BG_TILE_DATA:
            tile_data = 0x0000

        # todo: scrolling
        cdef unsigned char x        = 0
        cdef unsigned char screen_x = 0
        tile_data += (y & 7) * 2  # vertical offset in bytes
        tile_id_address            += (x >> 3) + 32 * (y >> 3)  # offset for leftmost tile
        tile_id_address            -= 1  # correct for first loop iteration
        cdef unsigned char tile_id  = self.mem.VRAM[tile_id_address]
        cdef unsigned short current_data_ptr
        cdef unsigned short data_lo
        cdef unsigned short data_hi

        cdef unsigned char x_shift, pixel
        for screen_x in range(160):
            x_shift = x & 7
            if x_shift == 0:
                # advance to next tile
                tile_id_address += 1
                # printf("id %x\n", tile_id_address)
                tile_id = self.mem.VRAM[tile_id_address]
                if LCDC & LCDC_BG_TILE_DATA:
                    # unsigned addressing
                    current_data_ptr = tile_data + tile_id * 16
                else:
                    # signed addressing
                    current_data_ptr = tile_data + <char>tile_id * 16

                # first byte holds lower bit, second byte holds upper bit
                data_lo = self.mem.VRAM[current_data_ptr]
                data_hi = self.mem.VRAM[current_data_ptr + 1]
            
            pixel  = ((data_lo << x_shift) & 0x80) >> 7  # lower bit
            pixel |= ((data_hi << x_shift) & 0x80) >> 6  # upper bit

            self.framebuffer[y][screen_x] = palette[pixel]

            x += 1
        
        if y == VISIBLE_SCREEN_HEIGHT - 1:
            self.frame += 1
            self.copy_buffer()

    cdef void copy_buffer(GBPPU self) nogil:
        cdef unsigned int x, y
        memcpy(self.display, self.framebuffer, 4 * 144 * 160)