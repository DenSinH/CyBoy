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

cdef int BIT_0_atHL(GBCPU cpu):
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

cdef int BIT_1_atHL(GBCPU cpu):
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

cdef int BIT_2_atHL(GBCPU cpu):
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

cdef int BIT_3_atHL(GBCPU cpu):
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

cdef int BIT_4_atHL(GBCPU cpu):
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

cdef int BIT_5_atHL(GBCPU cpu):
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

cdef int BIT_6_atHL(GBCPU cpu):
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

cdef int BIT_7_atHL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_H
    if (cpu.mem.read8(cpu.get_HL()) & 0x80) == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_B(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_B] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_B] <<= 1
    cpu.registers[REG_B] |= old_carry
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_C(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_C] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_C] <<= 1
    cpu.registers[REG_C] |= old_carry
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_D(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_D] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_D] <<= 1
    cpu.registers[REG_D] |= old_carry
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_E(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_E] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_E] <<= 1
    cpu.registers[REG_E] |= old_carry
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_H(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_H] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_H] <<= 1
    cpu.registers[REG_H] |= old_carry
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_L(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_L] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_L] <<= 1
    cpu.registers[REG_L] |= old_carry
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_A(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (cpu.registers[REG_A] & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    cpu.registers[REG_A] <<= 1
    cpu.registers[REG_A] |= old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RL_atHL(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned char carry = (value & 0x80) >> 7
    if carry:
        cpu.F |= FLAG_C
    
    value <<= 1
    value |= old_carry
    cpu.mem.write8(HL, value)
    if value == 0:
        cpu.F |= FLAG_Z
    return 16

cdef int SWAP_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_B] = (cpu.registers[REG_B] >> 4) | (cpu.registers[REG_B] << 4)
    
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_C] = (cpu.registers[REG_C] >> 4) | (cpu.registers[REG_C] << 4)
    
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_D] = (cpu.registers[REG_D] >> 4) | (cpu.registers[REG_D] << 4)
    
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_E] = (cpu.registers[REG_E] >> 4) | (cpu.registers[REG_E] << 4)
    
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_H] = (cpu.registers[REG_H] >> 4) | (cpu.registers[REG_H] << 4)
    
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_L] = (cpu.registers[REG_L] >> 4) | (cpu.registers[REG_L] << 4)
    
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.registers[REG_A] = (cpu.registers[REG_A] >> 4) | (cpu.registers[REG_A] << 4)
    
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SWAP_atHL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    value = (value >> 4) | (value << 4)
    cpu.mem.write8(HL, value)
    
    if value == 0:
        cpu.F |= FLAG_Z
    return 16

cdef int SRL_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_B] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_B] >>= 1
    
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_C] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_C] >>= 1
    
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_D] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_D] >>= 1
    
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_E] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_E] >>= 1
    
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_H] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_H] >>= 1
    
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_L] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_L] >>= 1
    
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] >>= 1
    
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int SRL_atHL(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    if value & 1:
        cpu.F |= FLAG_C
    value >>= 1
    cpu.mem.write8(HL, value)
    
    if value == 0:
        cpu.F |= FLAG_Z
    return 16

cdef int RR_B(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_B] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_B] >>= 1
    cpu.registers[REG_B] |= carry
    
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_C(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_C] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_C] >>= 1
    cpu.registers[REG_C] |= carry
    
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_D(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_D] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_D] >>= 1
    cpu.registers[REG_D] |= carry
    
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_E(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_E] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_E] >>= 1
    cpu.registers[REG_E] |= carry
    
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_H(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_H] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_H] >>= 1
    cpu.registers[REG_H] |= carry
    
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_L(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_L] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_L] >>= 1
    cpu.registers[REG_L] |= carry
    
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_A(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] & 1:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] >>= 1
    cpu.registers[REG_A] |= carry
    
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

cdef int RR_atHL(GBCPU cpu):
    cdef unsigned char carry = (cpu.F & FLAG_C) << 3
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    if value & 1:
        cpu.F |= FLAG_C
    value >>= 1
    value |= carry
    cpu.mem.write8(HL, value)
    
    if value == 0:
        cpu.F |= FLAG_Z
    return 16

