cdef int XOR_A_B(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_B]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_C(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_C]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_D(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_D]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_E(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_E]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_H(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_H]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_L(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_L]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_A(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.registers[REG_A]
    cpu.F = 0
    if cpu.registers[REG_A] == 0:
        cpu.F = FLAG_Z
    return 4

cdef int XOR_A_HL(GBCPU cpu):
    cpu.registers[REG_A] ^= cpu.mem.read8(cpu.get_HL())
    cpu.F &= 0x0f
    if cpu.registers[REG_A] == 0:
        cpu.F |= FLAG_Z
    return 8

