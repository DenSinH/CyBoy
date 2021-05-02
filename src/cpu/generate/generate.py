from generator import generator

with generator("src/cpu/arithmeticinterp.pxi", "src/cpu/arithmeticimpl.pxi") as g:
    g.generate_r8(
        "XOR_A_{r8}",
        """
cpu.registers[REG_A] ^= cpu.registers[REG_{r8}]
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "OR_A_{r8}",
        """
cpu.registers[REG_A] |= cpu.registers[REG_{r8}]
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "AND_A_{r8}",
        """
cpu.registers[REG_A] &= cpu.registers[REG_{r8}]
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cpu.F |= FLAG_H
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "SUB_A_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cpu.F |= FLAG_N
if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_{r8}]):
    cpu.F |= FLAG_H
if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_{r8}]) < 0:
    cpu.F |= FLAG_C
cpu.registers[REG_A] -= cpu.registers[REG_{r8}]
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "ADD_A_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cpu.F |= FLAG_N
if HALF_CARRY_8BIT_ADD(cpu.registers[REG_A], cpu.registers[REG_{r8}]):
    cpu.F |= FLAG_H
if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_{r8}]) > 0xff:
    cpu.F |= FLAG_C
cpu.registers[REG_A] += cpu.registers[REG_{r8}]
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "ADC_A_{r8}",
        """
cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if HALF_CARRY_8BIT_ADD_C(cpu.registers[REG_A], cpu.registers[REG_{r8}], old_carry):
    cpu.F |= FLAG_H
if (<int>cpu.registers[REG_A]) + (<int>cpu.registers[REG_{r8}]) + old_carry > 0xff:
    cpu.F |= FLAG_C
cpu.registers[REG_A] += cpu.registers[REG_{r8}] + old_carry
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "SBC_A_{r8}",
        """
cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cpu.F |= FLAG_N
if HALF_CARRY_8BIT_SUB_C(cpu.registers[REG_A], cpu.registers[REG_{r8}], old_carry):
    cpu.F |= FLAG_H
if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_{r8}]) - old_carry < 0:
    cpu.F |= FLAG_C
cpu.registers[REG_A] -= cpu.registers[REG_{r8}] + old_carry
if cpu.registers[REG_A] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "CP_A_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cpu.F |= FLAG_N
if HALF_CARRY_8BIT_SUB(cpu.registers[REG_A], cpu.registers[REG_{r8}]):
    cpu.F |= FLAG_H
if (<int>cpu.registers[REG_A]) - (<int>cpu.registers[REG_{r8}]) < 0:
    cpu.F |= FLAG_C
if cpu.registers[REG_A] == cpu.registers[REG_{r8}]:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "INC_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
if HALF_CARRY_8BIT_ADD(cpu.registers[REG_{r8}], 1):
    cpu.F |= FLAG_H
cpu.registers[REG_{r8}] += 1
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r8(
        "DEC_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
cpu.F |= FLAG_N
if HALF_CARRY_8BIT_SUB(cpu.registers[REG_{r8}], 1):
    cpu.F |= FLAG_H
cpu.registers[REG_{r8}] -= 1
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 4)

    g.generate_r16(
        "ADD_HL_{r16}",
        """
cpu.F &= ~(FLAG_N | FLAG_H | FLAG_C)
if HALF_CARRY_16BIT_ADD(cpu.{get_r16}, cpu.get_HL()):
    cpu.F |= FLAG_H
cdef unsigned int result = cpu.{get_r16}
result += cpu.get_HL()
if result > 0xffff:
    cpu.F |= FLAG_C
cpu.set_HL(<unsigned short>result)
return 8
""",
    "BC", "DE", "HL", "SP"
    )

    g.generate_r16(
        "INC_{r16}",
        """
cpu.{set_r16}(cpu.{get_r16} + 1)
return 8
""",
    "BC", "DE", "HL", "SP"
    )

    g.generate_r16(
        "DEC_{r16}",
        """
cpu.{set_r16}(cpu.{get_r16} - 1)
return 8
""",
    "BC", "DE", "HL", "SP"
    )


with generator("src/cpu/bitopinterp.pxi", "src/cpu/bitopimpl.pxi") as g:
    g.generate_bitop(
        "BIT_{bit}_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
cpu.F |= FLAG_H
if (cpu.registers[REG_{r8}] & {hex}) == 0:
    cpu.F |= FLAG_Z
return 8
""",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H)
cpu.F |= FLAG_H
if (cpu.mem.read8(cpu.get_HL()) & {hex}) == 0:
    cpu.F |= FLAG_Z
return 12
""")

    g.generate_bitop(
        "RES_{bit}_{r8}",
        """
cpu.registers[REG_{r8}] &= ~{hex}
return 8
""",
        """
cdef unsigned short HL = cpu.get_HL()
cpu.mem.write8(HL, cpu.mem.read8(HL) & ~{hex})
return 16
""")
    
    g.generate_bitop(
        "SET_{bit}_{r8}",
        """
cpu.registers[REG_{r8}] |= {hex}
return 8
""",
        """
cdef unsigned short HL = cpu.get_HL()
cpu.mem.write8(HL, cpu.mem.read8(HL) | {hex})
return 16
""")

    g.generate_r8(
        "RL_{r8}",
        """
cdef unsigned char old_carry = (cpu.F & FLAG_C) >> 4
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cdef unsigned char carry = (cpu.registers[REG_{r8}] & 0x80) >> 7
if carry:
    cpu.F |= FLAG_C

cpu.registers[REG_{r8}] <<= 1
cpu.registers[REG_{r8}] |= old_carry
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "RLC_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cdef unsigned char carry = (cpu.registers[REG_{r8}] & 0x80) >> 7
if carry:
    cpu.F |= FLAG_C

cpu.registers[REG_{r8}] <<= 1
cpu.registers[REG_{r8}] |= carry
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "RRC_{r8}",
        """
cdef unsigned char carry = cpu.registers[REG_{r8}] & 1
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if carry:
    cpu.F |= FLAG_C
cpu.registers[REG_{r8}] >>= 1
cpu.registers[REG_{r8}] |= carry
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "SLA_{r8}",
        """
cdef unsigned char carry = cpu.registers[REG_{r8}] & 0x80
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if carry:
    cpu.F |= FLAG_C
cpu.registers[REG_{r8}] <<= 1
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "SRA_{r8}",
        """
cdef unsigned char carry = cpu.registers[REG_{r8}] & 0x80
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if carry:
    cpu.F |= FLAG_C
cpu.registers[REG_{r8}] = <unsigned char>((<char>cpu.registers[REG_{r8}]) >> 1)
if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "SWAP_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
cpu.registers[REG_{r8}] = (cpu.registers[REG_{r8}] >> 4) | (cpu.registers[REG_{r8}] << 4)

if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "SRL_{r8}",
        """
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if cpu.registers[REG_{r8}] & 1:
    cpu.F |= FLAG_C
cpu.registers[REG_{r8}] >>= 1

if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

    g.generate_r8(
        "RR_{r8}",
        """
cdef unsigned char carry = (cpu.F & FLAG_C) << 3
cpu.F &= ~(FLAG_Z | FLAG_N | FLAG_H | FLAG_C)
if cpu.registers[REG_{r8}] & 1:
    cpu.F |= FLAG_C
cpu.registers[REG_{r8}] >>= 1
cpu.registers[REG_{r8}] |= carry

if cpu.registers[REG_{r8}] == 0:
    cpu.F |= FLAG_Z
""", 8)

with generator("src/cpu/branchinterp.pxi", "src/cpu/branchimpl.pxi") as g:
    g.generate_cond(
        "JR_{cond}_i8",
        """
cdef char offset = <char>cpu.mem.read8(cpu.PC)
cpu.PC += 1
{if_cond}
    cpu.PC += offset
    return 12
return 8
""",
    "NZ", "NC", "Z", "C", "")

    g.generate_cond(
        "CALL_{cond}_u16",
        """
cdef unsigned short addr = cpu.mem.read16(cpu.PC)
cpu.PC += 2
{if_cond}
    cpu.PUSH_PC()
    cpu.PC = addr
    return 24
return 12
""",
    "NZ", "NC", "Z", "C", "")

    g.generate_cond(
        "RET_{cond}",
        """
{if_cond}
    cpu.POP_PC()
    return 20
return 8
""",
    "NZ", "NC", "Z", "C", "")

    g.generate_cond(
        "JP_{cond}_u16",
        """
cdef unsigned short addr = cpu.mem.read16(cpu.PC)
cpu.PC += 2
{if_cond}
    cpu.PC = addr
    return 16
return 12
""",
    "NZ", "NC", "Z", "C", "")

    for vec in [0, 8, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38]:
        g.generate_manual(
            f"RST_{vec:02x}",
            f"""
cpu.PUSH_PC()
cpu.PC = 0x{vec:02x}
return 16
""")

with generator("src/cpu/loadinterp.pxi", "src/cpu/loadimpl.pxi") as g:
    g.generate_r8(
        "LD_{r8}_u8",
        """
cpu.registers[REG_{r8}] = cpu.mem.read8(cpu.PC)
cpu.PC += 1
""", 8, HL=False)
    g.generate_manual(
    "LD_atHL_u8",
        """
cpu.mem.write8(cpu.get_HL(), cpu.mem.read8(cpu.PC))
cpu.PC += 1
return 12
""")
    
    for r8 in ["B", "C", "D", "E", "H", "L", "A"]:
        g.generate_r8(
            f"LD_{{r8}}_{r8}",
            f"""
cpu.registers[REG_{{r8}}] = cpu.registers[REG_{r8}]
    """, 4, HL=False)
        g.generate_manual(
            f"LD_atHL_{r8}",
            f"""
cpu.mem.write8(cpu.get_HL(), cpu.registers[REG_{r8}])
return 8
""")
    
    g.generate_r8(
            "LD_{r8}_atHL",
            """
cpu.registers[REG_{r8}] = cpu.mem.read8(cpu.get_HL())
    """, 4, HL=False)

    g.generate_r16(
        "LD_{r16}_u16",
        """
cpu.{set_r16}(cpu.mem.read16(cpu.PC))
cpu.PC += 2
return 12
""",
    "BC", "DE", "HL", "SP")

    g.generate_r16(
        "PUSH_{r16}",
        """
cpu.SP -= 2
cpu.mem.write16(cpu.SP, cpu.{get_r16})
return 16
""",
    "BC", "DE", "HL", "AF")

    g.generate_r16(
        "POP_{r16}",
        """
cpu.{set_r16}(cpu.mem.read16(cpu.SP))
cpu.SP += 2
return 12
""",
    "BC", "DE", "HL")