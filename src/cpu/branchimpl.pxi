cdef int JR_NZ_i8(GBCPU cpu) nogil:
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if not (cpu.F & FLAG_Z):
        cpu.PC += offset
        return 12
    return 8

cdef int JR_NC_i8(GBCPU cpu) nogil:
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if not (cpu.F & FLAG_C):
        cpu.PC += offset
        return 12
    return 8

cdef int JR_Z_i8(GBCPU cpu) nogil:
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if cpu.F & FLAG_Z:
        cpu.PC += offset
        return 12
    return 8

cdef int JR_C_i8(GBCPU cpu) nogil:
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if cpu.F & FLAG_C:
        cpu.PC += offset
        return 12
    return 8

cdef int JR__i8(GBCPU cpu) nogil:
    cdef char offset = <char>cpu.mem.read8(cpu.PC)
    cpu.PC += 1
    if True:
        cpu.PC += offset
        return 12
    return 8

cdef int CALL_NZ_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_Z):
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL_NC_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_C):
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL_Z_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_Z:
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL_C_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_C:
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int CALL__u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if True:
        cpu.PUSH_PC()
        cpu.PC = addr
        return 24
    return 12

cdef int RET_NZ(GBCPU cpu) nogil:
    if not (cpu.F & FLAG_Z):
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_NC(GBCPU cpu) nogil:
    if not (cpu.F & FLAG_C):
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_Z(GBCPU cpu) nogil:
    if cpu.F & FLAG_Z:
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_C(GBCPU cpu) nogil:
    if cpu.F & FLAG_C:
        cpu.POP_PC()
        return 20
    return 8

cdef int RET_(GBCPU cpu) nogil:
    cpu.POP_PC()
    return 16

cdef int JP_NZ_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_Z):
        cpu.PC = addr
        return 16
    return 12

cdef int JP_NC_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if not (cpu.F & FLAG_C):
        cpu.PC = addr
        return 16
    return 12

cdef int JP_Z_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_Z:
        cpu.PC = addr
        return 16
    return 12

cdef int JP_C_u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if cpu.F & FLAG_C:
        cpu.PC = addr
        return 16
    return 12

cdef int JP__u16(GBCPU cpu) nogil:
    cdef unsigned short addr = cpu.mem.read16(cpu.PC)
    cpu.PC += 2
    if True:
        cpu.PC = addr
        return 16
    return 12

cdef int RST_00(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x00
    return 16

cdef int RST_08(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x08
    return 16

cdef int RST_10(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x10
    return 16

cdef int RST_18(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x18
    return 16

cdef int RST_20(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x20
    return 16

cdef int RST_28(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x28
    return 16

cdef int RST_30(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x30
    return 16

cdef int RST_38(GBCPU cpu) nogil:
    cpu.PUSH_PC()
    cpu.PC = 0x38
    return 16

