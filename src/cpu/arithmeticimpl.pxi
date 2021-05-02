cdef int XOR_A_B(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_B]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_C(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_C]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_D(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_D]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_E(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_E]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_H(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_H]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_L(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_L]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_A(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_A]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int XOR_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.registers[REG_A] ^= value
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int OR_A_B(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_B]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_C(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_C]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_D(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_D]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_E(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_E]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_H(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_H]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_L(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_L]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_A(GBCPU cpu):
    cpu.registers[REG_A] |= cpu.registers[REG_A]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int OR_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.registers[REG_A] |= value
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int AND_A_B(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_B]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_C(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_C]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_D(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_D]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_E(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_E]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_H(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_H]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_L(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_L]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_A(GBCPU cpu):
    cpu.registers[REG_A] &= cpu.registers[REG_A]
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int AND_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.registers[REG_A] &= value
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_H
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int SUB_A_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_B]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_B]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_B]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_C]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_C]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_C]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_D]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_D]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_D]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_E]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_E]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_E]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_H]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_H]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_H]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_L]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_L]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_L]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_A]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_A]) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_A]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SUB_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], value):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>value) < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int ADD_A_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_B]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_B]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_B]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_C]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_C]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_C]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_D]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_D]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_D]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_E]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_E]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_E]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_H]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_H]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_H]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_L]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_L]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_L]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_A]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_A]) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_A]
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADD_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], value):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>value) > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += value
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int ADC_A_B(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_B], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_B]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_B] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_C(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_C], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_C]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_C] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_D(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_D], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_D]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_D] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_E(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_E], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_E]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_E] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_H(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_H], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_H]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_H] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_L(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_L], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_L]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_L] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_A(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_A], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_A]) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += cpu.registers[REG_A] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int ADC_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], value, old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) + (<int>value) + old_carry > 0xff:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] += value + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int SBC_A_B(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_B], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_B]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_B] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_C(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_C], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_C]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_C] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_D(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_D], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_D]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_D] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_E(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_E], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_E]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_E] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_H(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_H], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_H]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_H] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_L(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_L], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_L]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_L] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_A(GBCPU cpu):
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_A], old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_A]) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= cpu.registers[REG_A] + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int SBC_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], value, old_carry):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>value) - old_carry < 0:
        cpu.F |= FLAG_C
    cpu.registers[REG_A] -= value + old_carry
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int CP_A_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_B]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_B]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_B]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_C]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_C]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_C]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_D]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_D]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_D]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_E]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_E]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_E]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_H]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_H]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_H]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_L]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_L]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_L]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_A]):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_A]) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == cpu.registers[REG_A]:
        cpu.F |= FLAG_Z
    return 4

cdef int CP_A_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], value):
        cpu.F |= FLAG_H
    if (<int>cpu.registers[REG_A]) - (<int>value) < 0:
        cpu.F |= FLAG_C
    if cpu.registers[REG_A] == value:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

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

cdef int INC_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    if HALF_CARRY_8BIT_ADD(value, 1):
        cpu.F |= FLAG_H
    value += 1
    if value == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
    return 12

cdef int DEC_B(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_B], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_B] -= 1
    if cpu.registers[REG_B] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_C(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_C], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_C] -= 1
    if cpu.registers[REG_C] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_D(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_D], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_D] -= 1
    if cpu.registers[REG_D] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_E(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_E], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_E] -= 1
    if cpu.registers[REG_E] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_H(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_H], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_H] -= 1
    if cpu.registers[REG_H] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_L(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_L], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_L] -= 1
    if cpu.registers[REG_L] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_A(GBCPU cpu):
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], 1):
        cpu.F |= FLAG_H
    cpu.registers[REG_A] -= 1
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 4

cdef int DEC_atHL(GBCPU cpu):
    cdef unsigned short HL = cpu.get_HL()
    cdef unsigned char value = cpu.mem.read8(HL)
    
    cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
    cpu.F |= FLAG_N
    if HALF_CARRY_8BIT_SUB(value, 1):
        cpu.F |= FLAG_H
    value -= 1
    if value == 0:
        cpu.F |= FLAG_Z
    
    cpu.mem.write8(HL, value)
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

cdef int INC_BC(GBCPU cpu):
    cpu.set_BC(cpu.get_BC() + 1)
    return 8

cdef int INC_DE(GBCPU cpu):
    cpu.set_DE(cpu.get_DE() + 1)
    return 8

cdef int INC_HL(GBCPU cpu):
    cpu.set_HL(cpu.get_HL() + 1)
    return 8

cdef int INC_SP(GBCPU cpu):
    cpu.SP = (cpu.SP + 1)
    return 8

cdef int DEC_BC(GBCPU cpu):
    cpu.set_BC(cpu.get_BC() - 1)
    return 8

cdef int DEC_DE(GBCPU cpu):
    cpu.set_DE(cpu.get_DE() - 1)
    return 8

cdef int DEC_HL(GBCPU cpu):
    cpu.set_HL(cpu.get_HL() - 1)
    return 8

cdef int DEC_SP(GBCPU cpu):
    cpu.SP = (cpu.SP - 1)
    return 8

