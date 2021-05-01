cdef int BIT_0_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_0_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x1) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_1_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_1_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x2) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_2_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_2_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x4) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_3_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_3_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x8) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_4_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_4_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x10) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_5_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_5_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x20) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_6_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_6_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x40) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int BIT_7_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_B] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_C] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_D] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_E] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_H] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_L] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.registers[REG_A] & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int BIT_7_HL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_B] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_B] <<= 1
    cpu.registers[REG_B] |= carry
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_C] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_C] <<= 1
    cpu.registers[REG_C] |= carry
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_D] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_D] <<= 1
    cpu.registers[REG_D] |= carry
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_E] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_E] <<= 1
    cpu.registers[REG_E] |= carry
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_H] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_H] <<= 1
    cpu.registers[REG_H] |= carry
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_L] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_L] <<= 1
    cpu.registers[REG_L] |= carry
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_A] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_A] <<= 1
    cpu.registers[REG_A] |= carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_HL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (value & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    value <<= 1
    value |= carry
    cpu.mem.write8(HL, value)
    if value == 0:
        cpu.F |= FLAG_Z
    return 16

