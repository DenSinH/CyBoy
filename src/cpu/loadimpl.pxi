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

cdef int LD_atHL_u8(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.mem.read8(cpu.PC))
    cpu.PC += 1
    return 12

cdef int LD_B_B(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_B]
    return 4

cdef int LD_C_B(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_B]
    return 4

cdef int LD_D_B(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_B]
    return 4

cdef int LD_E_B(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_B]
    return 4

cdef int LD_H_B(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_B]
    return 4

cdef int LD_L_B(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_B]
    return 4

cdef int LD_A_B(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_B]
    return 4

cdef int LD_atHL_B(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_B])
    return 8

cdef int LD_B_C(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_C]
    return 4

cdef int LD_C_C(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_C]
    return 4

cdef int LD_D_C(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_C]
    return 4

cdef int LD_E_C(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_C]
    return 4

cdef int LD_H_C(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_C]
    return 4

cdef int LD_L_C(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_C]
    return 4

cdef int LD_A_C(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_C]
    return 4

cdef int LD_atHL_C(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_C])
    return 8

cdef int LD_B_D(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_D]
    return 4

cdef int LD_C_D(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_D]
    return 4

cdef int LD_D_D(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_D]
    return 4

cdef int LD_E_D(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_D]
    return 4

cdef int LD_H_D(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_D]
    return 4

cdef int LD_L_D(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_D]
    return 4

cdef int LD_A_D(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_D]
    return 4

cdef int LD_atHL_D(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_D])
    return 8

cdef int LD_B_E(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_E]
    return 4

cdef int LD_C_E(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_E]
    return 4

cdef int LD_D_E(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_E]
    return 4

cdef int LD_E_E(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_E]
    return 4

cdef int LD_H_E(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_E]
    return 4

cdef int LD_L_E(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_E]
    return 4

cdef int LD_A_E(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_E]
    return 4

cdef int LD_atHL_E(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_E])
    return 8

cdef int LD_B_H(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_H]
    return 4

cdef int LD_C_H(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_H]
    return 4

cdef int LD_D_H(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_H]
    return 4

cdef int LD_E_H(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_H]
    return 4

cdef int LD_H_H(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_H]
    return 4

cdef int LD_L_H(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_H]
    return 4

cdef int LD_A_H(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_H]
    return 4

cdef int LD_atHL_H(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_H])
    return 8

cdef int LD_B_L(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_L]
    return 4

cdef int LD_C_L(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_L]
    return 4

cdef int LD_D_L(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_L]
    return 4

cdef int LD_E_L(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_L]
    return 4

cdef int LD_H_L(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_L]
    return 4

cdef int LD_L_L(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_L]
    return 4

cdef int LD_A_L(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_L]
    return 4

cdef int LD_atHL_L(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_L])
    return 8

cdef int LD_B_A(GBCPU cpu):
    cpu.registers[REG_B] = cpu.registers[REG_A]
    return 4

cdef int LD_C_A(GBCPU cpu):
    cpu.registers[REG_C] = cpu.registers[REG_A]
    return 4

cdef int LD_D_A(GBCPU cpu):
    cpu.registers[REG_D] = cpu.registers[REG_A]
    return 4

cdef int LD_E_A(GBCPU cpu):
    cpu.registers[REG_E] = cpu.registers[REG_A]
    return 4

cdef int LD_H_A(GBCPU cpu):
    cpu.registers[REG_H] = cpu.registers[REG_A]
    return 4

cdef int LD_L_A(GBCPU cpu):
    cpu.registers[REG_L] = cpu.registers[REG_A]
    return 4

cdef int LD_A_A(GBCPU cpu):
    cpu.registers[REG_A] = cpu.registers[REG_A]
    return 4

cdef int LD_atHL_A(GBCPU cpu):
    cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_A])
    return 8

cdef int LD_B_atHL(GBCPU cpu):
    cpu.registers[REG_B] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_C_atHL(GBCPU cpu):
    cpu.registers[REG_C] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_D_atHL(GBCPU cpu):
    cpu.registers[REG_D] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_E_atHL(GBCPU cpu):
    cpu.registers[REG_E] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_H_atHL(GBCPU cpu):
    cpu.registers[REG_H] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_L_atHL(GBCPU cpu):
    cpu.registers[REG_L] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_A_atHL(GBCPU cpu):
    cpu.registers[REG_A] = cpu.mem.read8(cpu.get_HL())
    return 4

cdef int LD_BC_u16(GBCPU cpu):
    cpu.set_BC(cpu.mem.read16(cpu.PC))
    cpu.PC += 2
    return 12

cdef int LD_DE_u16(GBCPU cpu):
    cpu.set_DE(cpu.mem.read16(cpu.PC))
    cpu.PC += 2
    return 12

cdef int LD_HL_u16(GBCPU cpu):
    cpu.set_HL(cpu.mem.read16(cpu.PC))
    cpu.PC += 2
    return 12

cdef int LD_SP_u16(GBCPU cpu):
    cpu.SP = (cpu.mem.read16(cpu.PC))
    cpu.PC += 2
    return 12

cdef int PUSH_BC(GBCPU cpu):
    cpu.SP -= 2
    cpu.mem.write16(cpu.SP, cpu.get_BC())
    return 16

cdef int PUSH_DE(GBCPU cpu):
    cpu.SP -= 2
    cpu.mem.write16(cpu.SP, cpu.get_DE())
    return 16

cdef int PUSH_HL(GBCPU cpu):
    cpu.SP -= 2
    cpu.mem.write16(cpu.SP, cpu.get_HL())
    return 16

cdef int PUSH_AF(GBCPU cpu):
    cpu.SP -= 2
    cpu.mem.write16(cpu.SP, cpu.get_AF())
    return 16

cdef int POP_BC(GBCPU cpu):
    cpu.set_BC(cpu.mem.read16(cpu.SP))
    cpu.SP += 2
    return 12

cdef int POP_DE(GBCPU cpu):
    cpu.set_DE(cpu.mem.read16(cpu.SP))
    cpu.SP += 2
    return 12

cdef int POP_HL(GBCPU cpu):
    cpu.set_HL(cpu.mem.read16(cpu.SP))
    cpu.SP += 2
    return 12

