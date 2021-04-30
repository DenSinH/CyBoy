

cdef int pref(GBCPU cpu):
    cdef unsigned char opcode = cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    cdef instruction instr = cpu.extended_instructions[opcode]
    
    if instr is NULL:
        print(f"Unimplemented extended opcode: {opcode:02x}")
        quit(opcode)
    return instr(cpu)

cdef int LD_SP_u16(GBCPU cpu):
    cpu.SP = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    return 12