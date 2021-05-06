cdef int pref(GBCPU cpu) nogil  # prefixed instruction

# cdef int LD_BC_u16(GBCPU cpu) nogil
# cdef int LD_DE_u16(GBCPU cpu) nogil
# cdef int LD_HL_u16(GBCPU cpu) nogil
# cdef int LD_SP_u16(GBCPU cpu) nogil

cdef int LD_atBC_A(GBCPU cpu) nogil
cdef int LD_atDE_A(GBCPU cpu) nogil
cdef int LD_atHL_Apl(GBCPU cpu) nogil
cdef int LD_atHL_Amn(GBCPU cpu) nogil

cdef int LD_A_atBC(GBCPU cpu) nogil
cdef int LD_A_atDE(GBCPU cpu) nogil
cdef int LD_A_atHLpl(GBCPU cpu) nogil
cdef int LD_A_atHLmn(GBCPU cpu) nogil

cdef int LD_ff00_A(GBCPU cpu) nogil
cdef int LD_A_ff00(GBCPU cpu) nogil

cdef int LD_ffu8_A(GBCPU cpu) nogil
cdef int LD_A_ffu8(GBCPU cpu) nogil

cdef int NOP(GBCPU cpu) nogil
cdef int DI(GBCPU cpu) nogil
cdef int EI(GBCPU cpu) nogil
cdef int RETI(GBCPU cpu) nogil

cdef int DAA(GBCPU cpu) nogil
cdef int SCF(GBCPU cpu) nogil
cdef int CCF(GBCPU cpu) nogil
cdef int CPL(GBCPU cpu) nogil
cdef int HALT(GBCPU cpu) nogil

cdef int POP_AF(GBCPU cpu) nogil  # special case
cdef int LD_u16_SP(GBCPU cpu) nogil
cdef int LD_SP_HL(GBCPU cpu) nogil
cdef int ADD_SP_i8(GBCPU cpu) nogil
cdef int LD_HL_SP_i8(GBCPU cpu) nogil

cdef int RLA(GBCPU cpu) nogil
cdef int RLCA(GBCPU cpu) nogil
cdef int RRA(GBCPU cpu) nogil
cdef int RRCA(GBCPU cpu) nogil

cdef int CP_A_u8(GBCPU cpu) nogil
cdef int AND_A_u8(GBCPU cpu) nogil
cdef int XOR_A_u8(GBCPU cpu) nogil
cdef int OR_A_u8(GBCPU cpu) nogil
cdef int ADD_A_u8(GBCPU cpu) nogil
cdef int ADC_A_u8(GBCPU cpu) nogil
cdef int SBC_A_u8(GBCPU cpu) nogil
cdef int SUB_A_u8(GBCPU cpu) nogil

cdef int LD_u16_A(GBCPU cpu) nogil
cdef int LD_A_u16(GBCPU cpu) nogil

cdef int JP_HL(GBCPU cpu) nogil

include "arithmeticinterp.pxi"
include "bitopinterp.pxi"
include "branchinterp.pxi"
include "loadinterp.pxi"