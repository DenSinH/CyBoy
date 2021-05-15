cimport cython
from libcpp cimport bool
from src.cpu.gbcpu cimport GBCPU
from src.ppu.gbppu cimport GBPPU
from src.apu.gbapu cimport GBAPU
from src.mem.mem cimport MEM
from src.frontend.frontend cimport Frontend, frontend_callback


@cython.final
cdef class GB:
    cdef:
        GBCPU cpu
        GBPPU ppu
        GBAPU apu
        MEM mem

        Frontend* frontend
    
    cpdef public void load_bootrom(GB self, str file_name)
    cpdef public void skip_bootrom(GB self)
    cpdef public void load_rom(GB self, str file_name)
    cpdef public int run(GB self)
    cpdef public void spawn_frontend(GB self, bool video_sync, bool audio_sync)
    cpdef public void close_frontend(GB self)
    cpdef public void bind_keyboard_input(GB self, str key, unsigned char mask)
    cpdef public void bind_controller_input(GB self, char key, unsigned char mask)

    cdef void dump_vram(GB self) nogil
    cdef void dump_oam(GB self) nogil
    cdef void print_status(GB self) nogil
