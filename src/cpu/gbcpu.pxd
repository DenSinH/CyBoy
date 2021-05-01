cimport cython
from src.mem.mem cimport MEM
from libcpp cimport bool

include "../generic/macros.pxi"
include "gbinterp.pxi"

cdef class GBCPU

ctypedef int (*instruction)(GBCPU)

cdef inline bool HALF_CARRY_8BIT_SUB(unsigned char op1, unsigned char op2):
    return ((op1 & 0xf) < (op2 & 0xf))
cdef inline bool HALF_CARRY_8BIT_SUB_C(unsigned char op1, unsigned char op2, unsigned char C):
    return ((op1 & 0xf) < ((op2 & 0xf) + (C)))
cdef inline bool HALF_CARRY_16BIT_SUB(unsigned short op1, unsigned short op2):
    return ((op1 & 0xfff) < (op2 & 0xfff))
cdef inline bool HALF_CARRY_8BIT_ADD(unsigned char op1, unsigned char op2):
    return ((op1 & 0xf) + (op2 & 0xf)) > 0xf
cdef inline bool HALF_CARRY_8BIT_ADD_C(unsigned char op1, unsigned char op2, unsigned char C):
    return ((op1 & 0xf) + ((op2 & 0xf) + (C))) > 0xf
cdef inline bool HALF_CARRY_16BIT_ADD(unsigned short op1, unsigned short op2):
    return ((op1 & 0xfff) + (op2 & 0xfff)) > 0xfff

@cython.final
cdef class GBCPU:
    cdef: 
        unsigned char registers[8]
        unsigned char F
        unsigned short SP
        unsigned short PC

        unsigned char IME

        MEM mem

    cdef instruction[0x100] instructions
    cdef instruction[0x100] extended_instructions

    cdef public object log

    cdef inline int step(self):
        # self.log.write(f"A: {self.registers[REG_A]:02X} F: {self.F:02X} B: {self.registers[REG_B]:02X} C: {self.registers[REG_C]:02X} D: {self.registers[REG_D]:02X} E: {self.registers[REG_E]:02X} H: {self.registers[REG_H]:02X} L: {self.registers[REG_L]:02X} SP: {self.SP:04X} PC: 00:{self.PC:04X}\n")
        # self.log.flush()

        cdef unsigned char opcode = self.mem.read8(self.PC)
        self.PC += 1
        
        # print(f"instruction {opcode:02x}")
        cdef instruction instr = self.instructions[opcode]
        
        if instr is NULL:
            print(f"Unimplemented opcode: {opcode:02x} at {self.PC:04x}")
            quit(opcode)
        return instr(self)

    cdef inline void PUSH_PC(self):
        self.SP -= 2
        self.mem.write16(self.SP, self.PC)

    cdef inline void POP_PC(self):
        self.PC = self.mem.read16(self.SP)
        self.SP += 2

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
