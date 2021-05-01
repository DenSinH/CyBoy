include "../generic/macros.pxi"

cdef int pref(GBCPU cpu):
    cdef unsigned char opcode = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cdef instruction instr = cpu.extended_instructions[opcode]
    
    if instr is NULL:
        print(f"Unimplemented extended opcode: {opcode:02x} at {cpu.PC - 1:04x}")
        quit(opcode)
    return instr(cpu)

# cdef int LD_BC_u16(GBCPU cpu):
#     cpu.set_BC(cpu.mem.read16(cpu.PC))
#     cpu.PC += 2
#     return 12
# 
# cdef int LD_DE_u16(GBCPU cpu):
#     cpu.set_DE(cpu.mem.read16(cpu.PC))
#     cpu.PC += 2
#     return 12
# 
# cdef int LD_HL_u16(GBCPU cpu):
#     cpu.set_HL(cpu.mem.read16(cpu.PC))
#     cpu.PC += 2
#     return 12
#
# cdef int LD_SP_u16(GBCPU cpu):
#     cpu.SP = cpu.mem.read16(cpu.PC)
#     cpu.PC += 2
#     return 12


cdef int LD_atBC_A(GBCPU cpu):
    cdef unsigned short addr = cpu.get_BC()
    cpu.mem.write8(addr, cpu.registers[REG_A])

cdef int LD_atDE_A(GBCPU cpu):
    cdef unsigned short addr = cpu.get_DE()
    cpu.mem.write8(addr, cpu.registers[REG_A])

cdef int LD_atHL_Apl(GBCPU cpu):
    cdef unsigned short addr = cpu.get_HL()
    cpu.mem.write8(addr, cpu.registers[REG_A])
    cpu.set_HL(addr + 1)

cdef int LD_atHL_Amn(GBCPU cpu):
    cdef unsigned short addr = cpu.get_HL()
    cpu.mem.write8(addr, cpu.registers[REG_A])
    cpu.set_HL(addr - 1)


cdef int LD_A_atBC(GBCPU cpu):
    cdef unsigned short addr = cpu.get_BC()
    cpu.registers[REG_A] = cpu.mem.read8(addr)

cdef int LD_A_atDE(GBCPU cpu):
    cdef unsigned short addr = cpu.get_DE()
    cpu.registers[REG_A] = cpu.mem.read8(addr)

cdef int LD_A_atHLpl(GBCPU cpu):
    cdef unsigned short addr = cpu.get_HL()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    cpu.set_HL(addr + 1)

cdef int LD_A_atHLmn(GBCPU cpu):
    cdef unsigned short addr = cpu.get_HL()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    cpu.set_HL(addr - 1)


cdef int LD_ff00_A(GBCPU cpu):
    cdef unsigned short address = 0xff00 + cpu.registers[REG_C]
    cpu.mem.write8(address, cpu.registers[REG_A])

cdef int LD_A_ff00(GBCPU cpu):
    cdef unsigned short address = 0xff00 + cpu.registers[REG_C]
    cpu.registers[REG_A] = cpu.mem.read8(address)

    
cdef int LD_ffu8_A(GBCPU cpu):
    cdef unsigned char offs = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.mem.write8(0xff00 + offs, cpu.registers[REG_A])


cdef int LD_A_ffu8(GBCPU cpu):
    cdef unsigned char offs = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] = cpu.mem.read8(0xff00 + offs)

cdef int NOP(GBCPU cpu):
    return 4

cdef int DI(GBCPU cpu):
    cpu.IME = 0

cdef int EI(GBCPU cpu):
    cpu.IME = 1

cdef int RLA(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_A] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C

    cpu.registers[REG_A] <<= 1
    cpu.registers[REG_A] |= old_carry
    return 8

cdef int RRA(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] & 1:
        cpu.F |= FLAG_C
        cpu.registers[REG_A] >>= 1
        cpu.registers[REG_A] |= 0x80
    else:
        cpu.registers[REG_A] >>= 1

    return 8

cdef int CP_A_u8(GBCPU cpu):
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
    
cdef int AND_A_u8(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] &= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int XOR_A_u8(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char value = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] ^= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int ADD_A_u8(GBCPU cpu):
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

cdef int ADC_A_u8(GBCPU cpu):
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

cdef int SUB_A_u8(GBCPU cpu):
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


cdef int LD_u16_A(GBCPU cpu):
    cdef unsigned short address = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    cpu.mem.write8(address, cpu.registers[REG_A])
    return 16

cdef int LD_A_u16(GBCPU cpu):
    cdef unsigned short address = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    cpu.registers[REG_A] = cpu.mem.read8(address)
    return 16

cdef int JP_HL(GBCPU cpu):
    cpu.PC = cpu.get_HL()
    return 4


include "arithmeticimpl.pxi"
include "bitopimpl.pxi"
include "branchimpl.pxi"
include "loadimpl.pxi"