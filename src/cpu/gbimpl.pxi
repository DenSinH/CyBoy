from libc.stdio cimport printf
from libc.stdlib cimport exit

include "../generic/macros.pxi"

cdef int pref(GBCPU cpu) nogil:
    cdef unsigned char opcode = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cdef instruction instr = cpu.extended_instructions[opcode]
    
    if instr is NULL:
        printf("Unimplemented extended opcode: %02x at %04x\n", opcode, cpu.PC - 1)
        exit(opcode)
    return instr(cpu)

cdef int LD_atBC_A(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_BC()
    cpu.mem.write8(addr, cpu.registers[REG_A])
    return 8

cdef int LD_atDE_A(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_DE()
    cpu.mem.write8(addr, cpu.registers[REG_A])
    return 8

cdef int LD_atHL_Apl(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_HL()
    cpu.mem.write8(addr, cpu.registers[REG_A])
    cpu.set_HL(addr + 1)
    return 8

cdef int LD_atHL_Amn(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_HL()
    cpu.mem.write8(addr, cpu.registers[REG_A])
    cpu.set_HL(addr - 1)
    return 8

cdef int LD_A_atBC(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_BC()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    return 8

cdef int LD_A_atDE(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_DE()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    return 8

cdef int LD_A_atHLpl(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_HL()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    cpu.set_HL(addr + 1)
    return 8

cdef int LD_A_atHLmn(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.get_HL()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    cpu.set_HL(addr - 1)
    return 8

cdef int LD_ff00_A(GBCPU cpu) nogil:
    cdef unsigned short address = 0xff00 + cpu.registers[REG_C]
    cpu.mem.write8(address, cpu.registers[REG_A])
    return 8

cdef int LD_A_ff00(GBCPU cpu) nogil:
    cdef unsigned short address = 0xff00 + cpu.registers[REG_C]
    cpu.registers[REG_A] = cpu.mem.read8(address)
    return 8

cdef int LD_ffu8_A(GBCPU cpu) nogil:
    cdef unsigned char offs = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.mem.write8(0xff00 + offs, cpu.registers[REG_A])
    return 12

cdef int LD_A_ffu8(GBCPU cpu) nogil:
    cdef unsigned char offs = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] = cpu.mem.read8(0xff00 + offs)
    return 12

cdef int NOP(GBCPU cpu) nogil:
    return 4

cdef int DI(GBCPU cpu) nogil:
    cpu.IME = 0
    return 4

cdef int EI(GBCPU cpu) nogil:
    cpu.IME = 1
    cpu.interrupt()  # check if interrupts are requested
    return 4

cdef int RETI(GBCPU cpu) nogil:
    cpu.IME = 1
    cpu.POP_PC()
    cpu.interrupt()  # check if interrupts are requested
    return 16

cdef int DAA(GBCPU cpu) nogil:
    # https://ehaskins.com/2018-01-30%20Z80%20DAA
    cdef unsigned char correction = 0
    cdef unsigned char carry = 0
    if ((cpu.F & FLAG_H) or ((not (cpu.F & FLAG_N)) and ((cpu.registers[REG_A] & 0xf) > 9))):
        correction = 6
    
    if ((cpu.F & FLAG_C) or ((not (cpu.F & FLAG_N)) and (cpu.registers[REG_A] > 0x99))):
        correction |= 0x60
        carry = FLAG_C 

    if cpu.F & FLAG_N:
        cpu.registers[REG_A] -= correction
    else:
        cpu.registers[REG_A] += correction
    
    cpu.F &= ~(FLAG_Z | FLAG_H | FLAG_C)
    cpu.F |= carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SCF(GBCPU cpu) nogil:
    cpu.F |= FLAG_C 
    cpu.F &= ~(FLAG_N | FLAG_H)
    return 4

cdef int CCF(GBCPU cpu) nogil:
    cpu.F ^= FLAG_C
    cpu.F &= ~(FLAG_N | FLAG_H)
    return 4

cdef int CPL(GBCPU cpu) nogil:
    cpu.registers[REG_A] = ~cpu.registers[REG_A]
    cpu.F |= FLAG_N | FLAG_H
    return 4

cdef int HALT(GBCPU cpu) nogil:
    cpu.halted = 1
    return 4

cdef int POP_AF(GBCPU cpu) nogil:
    cpu.set_AF(cpu.mem.read16(cpu.SP) & 0xfff0)
    cpu.SP += 2
    return 12

cdef int LD_u16_SP(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    cpu.mem.write16(addr, cpu.SP)
    return 20

cdef int LD_SP_HL(GBCPU cpu) nogil:
    cpu.SP = cpu.get_HL()
    return 8

cdef int ADD_SP_i8(GBCPU cpu) nogil:
    cdef char offs = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(<unsigned char>cpu.SP, offs):
        cpu.F |= FLAG_H

    if (cpu.SP & 0xff) + <unsigned char>offs > 0xff:
        cpu.F |= FLAG_C

    cpu.SP += offs
    return 16

cdef int LD_HL_SP_i8(GBCPU cpu) nogil:
    cdef char offs = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(<unsigned char>cpu.SP, offs):
        cpu.F |= FLAG_H

    if (cpu.SP & 0xff) + <unsigned char>offs > 0xff:
        cpu.F |= FLAG_C

    cpu.set_HL(cpu.SP + offs)
    return 12

cdef int RLA(GBCPU cpu) nogil:
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_A] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C

    cpu.registers[REG_A] <<= 1
    cpu.registers[REG_A] |= old_carry
    return 4

cdef int RLCA(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_A] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C

    cpu.registers[REG_A] <<= 1
    cpu.registers[REG_A] |= carry
    return 4

cdef int RRA(GBCPU cpu) nogil:
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] >>= 1
    cpu.registers[REG_A] |= carry

    return 4

cdef int RRCA(GBCPU cpu) nogil:
    cdef unsigned char carry = cpu.registers[REG_A] & 1
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if carry:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] >>= 1
    cpu.registers[REG_A] |= carry << 7

    return 4

cdef int CP_A_u8(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if cpu.registers[REG_A] == value:
        cpu.F |= FLAG_Z 
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], value):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>value) < 0:
        cpu.F |= FLAG_C
    return 8
    
cdef int AND_A_u8(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] &= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int XOR_A_u8(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] ^= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int OR_A_u8(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] |= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int ADD_A_u8(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], value):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>value) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int ADC_A_u8(GBCPU cpu) nogil:
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], value, old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>value) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += value + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SBC_A_u8(GBCPU cpu) nogil:
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], value, old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>value) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= value + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8


cdef int SUB_A_u8(GBCPU cpu) nogil:
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], value):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>value) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8


cdef int LD_u16_A(GBCPU cpu) nogil:
    cdef unsigned short address = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    cpu.mem.write8(address, cpu.registers[REG_A])
    return 16

cdef int LD_A_u16(GBCPU cpu) nogil:
    cdef unsigned short address = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    cpu.registers[REG_A] = cpu.mem.read8(address)
    return 16

cdef int JP_HL(GBCPU cpu) nogil:
    cpu.PC = cpu.get_HL()
    return 4


include "arithmeticimpl.pxi"
include "bitopimpl.pxi"
include "branchimpl.pxi"
include "loadimpl.pxi"