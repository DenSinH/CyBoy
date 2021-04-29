cimport cython
from src.mem.mem cimport MEM

include "../generic/macros.pxi"

cdef class GBCPU

cdef enum REG:
    REG_B = 0
    REG_C = 1
    REG_D = 2
    REG_E = 3
    REG_H = 4
    REG_L = 5
    REG_A = 7

cdef enum FLAG:
    FLAG_Z = 0x80
    FLAG_N = 0x40
    FLAG_H = 0x20
    FLAG_C = 0x10

ctypedef int (*instruction)(GBCPU)
cdef const instruction instructions[0x100]
cdef const instruction extended_instructions[0x100]

@cython.final
cdef class GBCPU:
    cdef public: 
        unsigned char registers[8]
        unsigned char F
        unsigned short SP
        unsigned short PC

        MEM mem

    cdef inline int step(self):
        cdef unsigned char opcode = self.mem.read8(self.PC)
        cdef instruction instr = instructions[opcode]
        
        if instr is NULL:
            print(f"Unimplemented opcode: {opcode:02x}")
            quit(opcode)
        return instr(self)

