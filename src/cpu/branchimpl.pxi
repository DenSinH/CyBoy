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

cdef int CALL_NZ_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_Z):
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL_NC_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_C):
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL_Z_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_Z:
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL_C_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_C:
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL__u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if True:
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int RET_NZ(GBCPU cpu):
    if not (cpu.F & FLAG_Z):
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_NC(GBCPU cpu):
    if not (cpu.F & FLAG_C):
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_Z(GBCPU cpu):
    if cpu.F & FLAG_Z:
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_C(GBCPU cpu):
    if cpu.F & FLAG_C:
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_(GBCPU cpu):
    if True:
        cpu.POP_PC()
        return 20
    return 8

cdef int JP_NZ_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_Z):
        cpu.PC = addr
        return 16
    return 12

cdef int JP_NC_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_C):
        cpu.PC = addr
        return 16
    return 12

cdef int JP_Z_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_Z:
        cpu.PC = addr
        return 16
    return 12

cdef int JP_C_u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_C:
        cpu.PC = addr
        return 16
    return 12

cdef int JP__u16(GBCPU cpu):
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if True:
        cpu.PC = addr
        return 16
    return 12

