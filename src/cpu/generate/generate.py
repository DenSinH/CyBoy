from generator import generator

with generator("src/cpu/arithmeticinterp.pxi", "src/cpu/arithmeticimpl.pxi") as g:
    g.generate_r8(
        "XOR_A_{r8}",
        """
cpu.registers[REG_A] ^= cpu.registers[REG_{r8}]
cpu.F = 0
if cpu.registers[REG_A] == 0:
    cpu.F = FLAG_Z
return 4
""",
        """
cpu.registers[REG_A] ^= cpu.mem.read8(cpu.get_HL())
cpu.F &= 0x0f
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
return 8
""",
    )

with generator("src/cpu/bitopinterp.pxi", "src/cpu/bitopimpl.pxi") as g:
    g.generate_bitop(
        "BIT_{bit}_{r8}",
        """
cpu.F &= 0x1f
cpu.F |= 0x20  # Z01- flag
if (cpu.registers[REG_{r8}] & {hex}) == 0:
    cpu.F |= FLAG_Z
return 4
""",
        """
cpu.F &= 0x1f
cpu.F |= 0x20  # Z01- flag
if (cpu.mem.read8(cpu.get_HL()) & {hex}) == 0:
    cpu.F |= FLAG_Z
return 8
""",
    )