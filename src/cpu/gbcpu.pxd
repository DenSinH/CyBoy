cimport cython
from src.mem.mem cimport MEM

include "../generic/macros.pxi"
include "gbinterp.pxi"

cdef class GBCPU

ctypedef int (*instruction)(GBCPU)

DEF REG_B = 0
DEF REG_C = 1
DEF REG_D = 2
DEF REG_E = 3
DEF REG_H = 4
DEF REG_L = 5
DEF REG_A = 7

DEF FLAG_Z = 0x80
DEF FLAG_N = 0x40
DEF FLAG_H = 0x20
DEF FLAG_C = 0x10

@cython.final
cdef class GBCPU:
    cdef public: 
        unsigned char registers[8]
        unsigned char F
        unsigned short SP
        unsigned short PC

        MEM mem

    cdef instruction[0x100] instructions
    cdef instruction[0x100] extended_instructions

    cdef inline int step(self):
        cdef unsigned char opcode = self.mem.read8(self.PC)
        print(f"instruction {opcode:02x}")
        cdef instruction instr = self.instructions[opcode]
        
        if instr is NULL:
            print(f"Unimplemented opcode: {opcode:02x}")
            quit(opcode)
        return instr(self)

    cdef inline unsigned short get_BC(self):
        cdef unsigned short BC = self.registers[REG_C]
        BC |= (<unsigned short>self.registers[REG_B]) << 8
        return BC

    cdef inline void set_BC(self, unsigned short value):
        self.registers[REG_C] = <unsigned char>value 
        self.registers[REG_B] = <unsigned char>(value >> 8)

    cdef inline unsigned short get_DE(self):
        cdef unsigned short DE = self.registers[REG_E]
        DE |= (<unsigned short>self.registers[REG_D]) << 8
        return DE

    cdef inline void set_DE(self, unsigned short value):
        self.registers[REG_E] = <unsigned char>value 
        self.registers[REG_D] = <unsigned char>(value >> 8)

    cdef inline unsigned short get_HL(self):
        cdef unsigned short HL = self.registers[REG_L]
        HL |= (<unsigned short>self.registers[REG_H]) << 8
        return HL

    cdef inline void set_HL(self, unsigned short value):
        self.registers[REG_L] = <unsigned char>value 
        self.registers[REG_H] = <unsigned char>(value >> 8)

    cdef inline unsigned short get_AF(self):
        cdef unsigned short AF = self.F
        AF |= (<unsigned short>self.registers[REG_A]) << 8
        return AF

    cdef inline void set_AF(self, unsigned short value):
        self.F = <unsigned char>value 
        self.registers[REG_A] = <unsigned char>(value >> 8)
