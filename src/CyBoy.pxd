cimport cython
from src.cpu.gbcpu cimport GBCPU
from src.ppu.gbppu cimport GBPPU
from src.mem.mem cimport MEM


@cython.final
cdef class GB:
    cdef:
        GBCPU cpu
        GBPPU ppu
        MEM mem
    
    cpdef public void load_bootrom(GB self, str file_name)
    cpdef public void skip_bootrom(GB self)
    cpdef public void load_rom(GB self, str file_name)
    cpdef public int run(GB self)

    cdef void dump_vram(GB self) nogil