cimport cython
from src.cpu.gbcpu cimport GBCPU
from src.mem.mem cimport MEM 


@cython.final
cdef class GB:
    cdef public:
        GBCPU cpu
        MEM mem

    cpdef public void load_bootrom(GB self, str file_name)
    cpdef public int run(GB self)