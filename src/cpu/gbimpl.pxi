include "../generic/macros.pxi"

cdef int pref(GBCPU cpu):
    cdef unsigned char opcode = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cdef instruction instr = cpu.extended_instructions[opcode]
    
    if instr is NULL:
        print(f"Unimplemented extended opcode: {opcode:02x} at {cpu.PC:04x}")
        quit(opcode)
    return instr(cpu)

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
    cpu.SP = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    return 12


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


include "arithmeticimpl.pxi"
include "bitopimpl.pxi"
include "branchimpl.pxi"
include "loadimpl.pxi"