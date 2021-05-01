cdef int XOR_A_B(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_B]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_C(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_C]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_D(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_D]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_E(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_E]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_H(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_H]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_L(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_L]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_A(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_A]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_HL(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.mem.read8(cpu.get_HL())
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int INC_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_B], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_B] += 1
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_C], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_C] += 1
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_D], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_D] += 1
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_E], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_E] += 1
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_H], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_H] += 1
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_L], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_L] += 1
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_A] += 1
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int INC_HL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(value, 1):
        cpu.F |= FLAG_H
    if (value + 1) == 0:
        cpu.F |= FLAG_Z
    cpu.mem.write8(HL, value + 1)
    return 12

cdef int DEC_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_B], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_B] -= 1
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_C], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_C] -= 1
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_D], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_D] -= 1
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_E], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_E] -= 1
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_H], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_H] -= 1
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_L], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_L] -= 1
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_A] -= 1
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_HL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(value, 1):
        cpu.F |= FLAG_H
    if (value - 1) == 0:
        cpu.F |= FLAG_Z
    cpu.mem.write8(HL, value - 1)
    return 12

cdef int ADD_HL_BC(GBCPU cpu):
    cpu.F &= ~(FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_16BIT_ADD(cpu.get_BC(), cpu.get_HL()):
        cpu.F |= FLAG_H
    cdef unsigned int result = cpu.get_BC()
    result += cpu.get_HL()
    if result > 0xffff:
        cpu.F |= FLAG_C
    cpu.set_HL(<unsigned short>result)
    return 8

cdef int ADD_HL_DE(GBCPU cpu):
    cpu.F &= ~(FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_16BIT_ADD(cpu.get_DE(), cpu.get_HL()):
        cpu.F |= FLAG_H
    cdef unsigned int result = cpu.get_DE()
    result += cpu.get_HL()
    if result > 0xffff:
        cpu.F |= FLAG_C
    cpu.set_HL(<unsigned short>result)
    return 8

cdef int ADD_HL_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_16BIT_ADD(cpu.get_HL(), cpu.get_HL()):
        cpu.F |= FLAG_H
    cdef unsigned int result = cpu.get_HL()
    result += cpu.get_HL()
    if result > 0xffff:
        cpu.F |= FLAG_C
    cpu.set_HL(<unsigned short>result)
    return 8

cdef int ADD_HL_SP(GBCPU cpu):
    cpu.F &= ~(FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_16BIT_ADD(cpu.SP, cpu.get_HL()):
        cpu.F |= FLAG_H
    cdef unsigned int result = cpu.SP
    result += cpu.get_HL()
    if result > 0xffff:
        cpu.F |= FLAG_C
    cpu.set_HL(<unsigned short>result)
    return 8

