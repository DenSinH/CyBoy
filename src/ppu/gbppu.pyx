from libc.stdio cimport printf
from libc.string cimport memcpy, memset

DEF SCREEN_HEIGHT         = 154
DEF VISIBLE_SCREEN_HEIGHT = 144

DEF OBJ_PRIORITY = 0x80
DEF OBJ_VFLIP    = 0x40
DEF OBJ_HFLIP    = 0x20

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

    cdef void draw_bg(GBPPU self, unsigned char y) nogil:
        cdef unsigned char LCDC = self.mem.IO.LCDC
        cdef unsigned short tile_map_address = 0x1800
        if LCDC & LCDC_BG_TILE_MAP:
            tile_map_address = 0x1c00

        cdef unsigned short tile_data = 0x1000
        if LCDC & LCDC_TILE_DATA:
            tile_data = 0x0000

        cdef unsigned char y_eff    = y + self.mem.IO.SCY           # add offset from scrolling, type size enables wrapping immediately
        cdef unsigned char x        = self.mem.IO.SCX               # scrolling
        cdef unsigned char screen_x = 0
        tile_data                  += (y_eff & 7) * 2               # vertical offset in bytes
        cdef unsigned short tile_id_base_address, tile_id_offset
        tile_id_base_address        = tile_map_address
        tile_id_base_address       += 32 * (y_eff >> 3)             # offset for leftmost tile
        tile_id_offset              = (x >> 3) - 1                  # correct for first loop iteration
        cdef unsigned char tile_id  = self.mem.VRAM[tile_id_base_address + tile_id_offset]
        cdef unsigned short current_data_ptr
        cdef unsigned short data_lo
        cdef unsigned short data_hi

        #if y >= 128:
        #    printf("%d/%d  + %d %02x\n", y, y_eff, self.mem.IO.SCY, tile_id_address)

        cdef unsigned char x_shift, pixel
        for screen_x in range(160):
            x_shift = x & 7
            if x_shift == 0:
                # advance to next tile
                tile_id_offset += 1
                tile_id_offset &= 31
                tile_id = self.mem.VRAM[tile_id_base_address + tile_id_offset]
                if LCDC & LCDC_TILE_DATA:
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

            self.bg_pixels[x] = pixel

            x += 1

    cdef void draw_window(GBPPU self, unsigned char y) nogil:
        cdef unsigned char LCDC = self.mem.IO.LCDC

        if not (LCDC & LCDC_WINDOW_ENABLE):
            return

        if y < self.mem.IO.WY:
            return

        if self.mem.IO.WX >= 167:
            return

        cdef unsigned char y_eff    = self.window_ly
        if self.mem.IO.WY < 144 and self.mem.IO.WX < 167:
            # still tick window if it's visible
            self.window_ly += 1
            
        # window visible
        cdef unsigned short tile_map_address = 0x1800
        if LCDC & LCDC_WINDOW_TILE_MAP:
            tile_map_address = 0x1c00

        cdef unsigned short tile_data = 0x1000
        if LCDC & LCDC_TILE_DATA:
            tile_data = 0x0000

        cdef unsigned char x        = 0                             # scrolling
        cdef unsigned char screen_x = self.mem.IO.WX - 7
        tile_data                  += (y_eff & 7) * 2               # vertical offset in bytes
        cdef unsigned short tile_id_base_address, tile_id_offset
        tile_id_base_address        = tile_map_address
        tile_id_base_address       += 32 * (y_eff >> 3)             # offset for leftmost tile
        tile_id_offset              = (x >> 3) - 1                  # correct for first loop iteration
        cdef unsigned char tile_id  = self.mem.VRAM[tile_id_base_address + tile_id_offset]
        cdef unsigned short current_data_ptr
        cdef unsigned short data_lo
        cdef unsigned short data_hi

        cdef unsigned char x_shift, pixel
        while screen_x < 160:
            x_shift = x & 7
            if x_shift == 0:
                # advance to next tile
                tile_id_offset += 1
                tile_id_offset &= 31
                tile_id = self.mem.VRAM[tile_id_base_address + tile_id_offset]
                if LCDC & LCDC_TILE_DATA:
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

            if pixel != 0:
                self.bg_pixels[screen_x] = pixel

            x += 1
            screen_x += 1

    cdef void draw_obj(GBPPU self, unsigned char y) nogil:
        cdef unsigned int i
        memset(self.obj_pixels, -1, 160)
            
        cdef unsigned char LCDC = self.mem.IO.LCDC
        if not (LCDC & LCDC_OBJ_ENABLE):
            return

        cdef unsigned char height = 8
        if LCDC & LCDC_OBJ_SIZE:
            height = 16

        # scan oam
        cdef unsigned char[10] sprites
        cdef char sprites_amount = 0
        cdef unsigned char obj_y
        for i in range(0, 0x80, 4):
            obj_y = self.mem.OAM[i] - 16
            if obj_y > y or obj_y + height <= y:
                continue
            
            sprites[sprites_amount] = i
            sprites_amount += 1
            if sprites_amount == 10:
                # 10 sprite limit per line
                break

        # loop backwards over sprites for proper priority
        sprites_amount -= 1
        cdef unsigned char obj_x, obj_id, obj_attr

        cdef unsigned short data_address
        cdef unsigned char dy, dx
        cdef unsigned char data_hi, data_lo
        cdef unsigned char pixel
        memset(self.obj_src_x, -1, 2 * 160)
        while sprites_amount >= 0:
            i = sprites[sprites_amount]
            obj_y    = self.mem.OAM[i] - 16
            obj_x    = self.mem.OAM[i + 1] - 8
            obj_id   = self.mem.OAM[i + 2] & ~(height >> 4)  # clear bottom bit for height 16 sprites
            obj_attr = self.mem.OAM[i + 3]

            dy = y - obj_y
            if obj_attr & OBJ_VFLIP:
                dy ^= height - 1
            
            data_address = (obj_id * 16) + dy * 2
            data_lo = self.mem.VRAM[data_address]
            data_hi = self.mem.VRAM[data_address + 1]

            for dx in range(8):
                if obj_x + dx < 160:
                    if self.obj_src_x[obj_x + dx] < obj_x:
                        continue
                    if obj_attr & OBJ_HFLIP:
                        pixel  = ((data_lo >> dx) & 1)       # lower bit
                        pixel |= ((data_hi >> dx) & 1) << 1  # upper bit
                    else:
                        pixel  = ((data_lo << dx) & 0x80) >> 7  # lower bit
                        pixel |= ((data_hi << dx) & 0x80) >> 6  # upper bit

                    if pixel != 0:
                        self.obj_pixels[obj_x + dx] = pixel
                        self.obj_attrs[obj_x + dx]  = obj_attr
                        self.obj_src_x[obj_x + dx] = obj_x

            sprites_amount -= 1

    cdef void composite_layer(GBPPU self, unsigned char y) nogil:
        cdef unsigned int x
        cdef unsigned int color
        for x in range(160):
            self.framebuffer[y][x] = palette[(self.mem.IO.BGP >> (self.bg_pixels[x] << 1)) & 3]
            if self.obj_pixels[x] != -1 and (self.bg_pixels[x] == 0 or not (self.obj_attrs[x] & OBJ_PRIORITY)):
                self.framebuffer[y][x] = palette[
                    (self.mem.IO.OBP[(self.obj_attrs[x] & 0x10) >> 4] >> (self.obj_pixels[x] << 1)) & 3
                ]
            else:
                self.framebuffer[y][x] = palette[
                    (self.mem.IO.BGP >> (self.bg_pixels[x] << 1)) & 3
                ]

    cdef void draw_line(GBPPU self, unsigned char y) nogil:
        cdef unsigned char x
        memset(self.bg_pixels, 0, 160)

        cdef unsigned char LCDC = self.mem.IO.LCDC
        if LCDC & LCDC_PPU_ENABLE:

            if LCDC & LCDC_BG_WINDOW_ENABLE:
                # on DMG this bit is a master enable for window and bg
                self.draw_bg(y)
            self.draw_obj(y)
            if LCDC & LCDC_BG_WINDOW_ENABLE:
                self.draw_window(y)
            self.composite_layer(y)

        
        if y == VISIBLE_SCREEN_HEIGHT - 1:
            self.frame += 1
            self.window_ly = 0
            self.copy_buffer()

    cdef void copy_buffer(GBPPU self) nogil:
        cdef unsigned int x, y
        memcpy(self.display, self.framebuffer, 4 * 144 * 160)