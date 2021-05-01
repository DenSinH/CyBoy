include "../generic/macros.pxi"

cdef int pref(GBCPU cpu):
    cdef unsigned char opcode = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cdef instruction instr = cpu.extended_instructions[opcode]
    
    if instr is NULL:
        print(f"Unimplemented extended opcode: {opcode:02x} at {cpu.PC - 1:04x}")
        quit(opcode)
    return instr(cpu)

# cdef int LD_BC_u16(GBCPU cpu):
#     cpu.set_BC(cpu.mem.read16(cpu.PC))
#     cpu.PC += 2
#     return 12
# 
# cdef int LD_DE_u16(GBCPU cpu):
#     cpu.set_DE(cpu.mem.read16(cpu.PC))
#     cpu.PC += 2
#     return 12
# 
# cdef int LD_HL_u16(GBCPU cpu):
#     cpu.set_HL(cpu.mem.read16(cpu.PC))
#     cpu.PC += 2
#     return 12
#
# cdef int LD_SP_u16(GBCPU cpu):
#     cpu.SP = cpu.mem.read16(cpu.PC)
#     cpu.PC += 2
#     return 12


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


cdef int LD_A_atBC(GBCPU cpu):
    cdef unsigned short addr = cpu.get_BC()
    cpu.registers[REG_A] = cpu.mem.read8(addr)

cdef int LD_A_atDE(GBCPU cpu):
    cdef unsigned short addr = cpu.get_DE()
    cpu.registers[REG_A] = cpu.mem.read8(addr)

cdef int LD_A_atHLpl(GBCPU cpu):
    cdef unsigned short addr = cpu.get_HL()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    cpu.set_HL(addr + 1)

cdef int LD_A_atHLmn(GBCPU cpu):
    cdef unsigned short addr = cpu.get_HL()
    cpu.registers[REG_A] = cpu.mem.read8(addr)
    cpu.set_HL(addr - 1)


cdef int LD_ff00_A(GBCPU cpu):
    cdef unsigned short address = 0xff00 + cpu.registers[REG_C]
    cpu.mem.write8(address, cpu.registers[REG_A])

cdef int LD_A_ff00(GBCPU cpu):
    cdef unsigned short address = 0xff00 + cpu.registers[REG_C]
    cpu.registers[REG_A] = cpu.mem.read8(address)

    
cdef int LD_ffu8_A(GBCPU cpu):
    cdef unsigned char offs = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.mem.write8(0xff00 + offs, cpu.registers[REG_A])


cdef int LD_A_ffu8(GBCPU cpu):
    cdef unsigned char offs = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cpu.registers[REG_A] = cpu.mem.read8(0xff00 + offs)

    



include "arithmeticimpl.pxi"
include "bitopimpl.pxi"
include "branchimpl.pxi"
include "loadimpl.pxi"