cimport cython
from src.mem.mem cimport MEM
from libcpp cimport bool
from libc.stdio cimport fopen, fclose, FILE, fread, fwrite, snprintf, printf
from libc.stdlib cimport exit

include "../generic/macros.pxi"
include "gbinterp.pxi"

cdef class GBCPU

ctypedef int (*instruction)(GBCPU) nogil

cdef inline bool HALF_CARRY_8BIT_SUB(unsigned char op1, unsigned char op2) nogil:
    return ((op1 & 0xf) < (op2 & 0xf))
cdef inline bool HALF_CARRY_8BIT_SUB_C(unsigned char op1, unsigned char op2, unsigned char C) nogil:
    return ((op1 & 0xf) < ((op2 & 0xf) + (C)))
cdef inline bool HALF_CARRY_16BIT_SUB(unsigned short op1, unsigned short op2) nogil:
    return ((op1 & 0xfff) < (op2 & 0xfff))
cdef inline bool HALF_CARRY_8BIT_ADD(unsigned char op1, unsigned char op2) nogil:
    return ((op1 & 0xf) + (op2 & 0xf)) > 0xf
cdef inline bool HALF_CARRY_8BIT_ADD_C(unsigned char op1, unsigned char op2, unsigned char C) nogil:
    return ((op1 & 0xf) + ((op2 & 0xf) + (C))) > 0xf
cdef inline bool HALF_CARRY_16BIT_ADD(unsigned short op1, unsigned short op2) nogil:
    return ((op1 & 0xfff) + (op2 & 0xfff)) > 0xfff

@cython.final
cdef class GBCPU:
    cdef:
        unsigned char shutdown
        bool halted
        unsigned char registers[8]
        unsigned char F
        unsigned short SP
        unsigned short PC

        unsigned char IME

        MEM mem
        FILE* log

    cdef instruction[0x100] instructions
    cdef instruction[0x100] extended_instructions

    cdef inline void log_line(self) nogil:
        cdef char[100] line
        # cdef int length = snprintf(line, 100, 
        #     "A: %02X F: %02X B: %02X C: %02X D: %02X E: %02X H: %02X L: %02X SP: %04X PC: 00:%04X\n",
        #     self.registers[REG_A], self.F, 
        #     self.registers[REG_B], self.registers[REG_C], 
        #     self.registers[REG_D], self.registers[REG_E], 
        #     self.registers[REG_H], self.registers[REG_L], 
        #     self.SP, self.PC
        # )
        cdef int length = snprintf(line, 100, 
            "BC=%04X DE=%04X HL=%04X AF=%04X SP=%04X PC=%04X\n",
            self.get_BC(), self.get_DE(), self.get_HL(), self.get_AF(),
            self.SP, self.PC
        )
        fwrite(line, length, 1, self.log)

    cdef inline int step(self) nogil:
        # self.log_line()
        # if self.PC == 0xC067:
        #     exit(0)

        if self.halted:
            return 4

        cdef unsigned char opcode = self.mem.read8(self.PC)
        self.PC += 1
        
        # print(f"instruction {opcode:02x}")
        cdef instruction instr = self.instructions[opcode]
        
        if instr is NULL:
            printf("Unimplemented opcode: %02x at %04x\n", opcode, self.PC)
            exit(opcode)
        return instr(self)

    cdef void interrupt(GBCPU self) nogil

    cdef inline void PUSH_PC(self) nogil:
        self.SP -= 2
        self.mem.write16(self.SP, self.PC)

    cdef inline void POP_PC(self) nogil:
        self.PC = self.mem.read16(self.SP)
        self.SP += 2

    cdef inline unsigned short get_BC(self) nogil:
        cdef unsigned short BC = self.registers[REG_C]
        BC |= (<unsigned short>self.registers[REG_B]) << 8
        return BC

    cdef inline void set_BC(self, unsigned short value) nogil:
        self.registers[REG_C] = <unsigned char>value 
        self.registers[REG_B] = <unsigned char>(value >> 8)

    cdef inline unsigned short get_DE(self) nogil:
        cdef unsigned short DE = self.registers[REG_E]
        DE |= (<unsigned short>self.registers[REG_D]) << 8
        return DE

    cdef inline void set_DE(self, unsigned short value) nogil:
        self.registers[REG_E] = <unsigned char>value 
        self.registers[REG_D] = <unsigned char>(value >> 8)

    cdef inline unsigned short get_HL(self) nogil:
        cdef unsigned short HL = self.registers[REG_L]
        HL |= (<unsigned short>self.registers[REG_H]) << 8
        return HL

    cdef inline void set_HL(self, unsigned short value) nogil:
        self.registers[REG_L] = <unsigned char>value 
        self.registers[REG_H] = <unsigned char>(value >> 8)

    cdef inline unsigned short get_AF(self) nogil:
        cdef unsigned short AF = self.F
        AF |= (<unsigned short>self.registers[REG_A]) << 8
        return AF

    cdef inline void set_AF(self, unsigned short value) nogil:
        self.F = <unsigned char>value 
        self.registers[REG_A] = <unsigned char>(value >> 8)
