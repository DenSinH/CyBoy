cimport cython
from src.cpu.gbcpu cimport GBCPU
from src.ppu.gbppu cimport GBPPU
from src.mem.mem cimport MEM
from src.frontend.frontend cimport Frontend, frontend_callback


@cython.final
cdef class GB:
    cdef:
        GBCPU cpu
        GBPPU ppu
        MEM mem

        Frontend* frontend
    
    cpdef public void load_bootrom(GB self, str file_name)
    cpdef public void skip_bootrom(GB self)
    cpdef public void load_rom(GB self, str file_name)
    cpdef public int run(GB self)
    cpdef public void spawn_frontend(GB self)
    cpdef public void close_frontend(GB self)

    cdef void dump_vram(GB self) nogil
