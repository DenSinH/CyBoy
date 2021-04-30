cdef int LD_B_u8(GBCPU cpu):
    cpu.registers[REG_B] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_C_u8(GBCPU cpu):
    cpu.registers[REG_C] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_D_u8(GBCPU cpu):
    cpu.registers[REG_D] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_E_u8(GBCPU cpu):
    cpu.registers[REG_E] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_H_u8(GBCPU cpu):
    cpu.registers[REG_H] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_L_u8(GBCPU cpu):
    cpu.registers[REG_L] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_A_u8(GBCPU cpu):
    cpu.registers[REG_A] = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    return 8

cdef int LD_HL_u8(GBCPU cpu):
    cpu.set_HL(cpu.mem.read8(cpu.PC))
    cpu.PC += 1
    return 12

