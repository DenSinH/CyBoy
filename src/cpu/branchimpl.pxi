cdef int JR_NZ_i8(GBCPU cpu):
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if not (cpu.F & FLAG_Z):
        cpu.PC += offset
        return 12
    return 8

cdef int JR_NC_i8(GBCPU cpu):
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if not (cpu.F & FLAG_C):
        cpu.PC += offset
        return 12
    return 8

cdef int JR_Z_i8(GBCPU cpu):
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if cpu.F & FLAG_Z:
        cpu.PC += offset
        return 12
    return 8

cdef int JR_C_i8(GBCPU cpu):
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if cpu.F & FLAG_C:
        cpu.PC += offset
        return 12
    return 8

cdef int JR__i8(GBCPU cpu):
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if True:
        cpu.PC += offset
        return 12
    return 8

