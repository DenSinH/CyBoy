cdef int pref(GBCPU cpu)  # prefixed instruction

# cdef int LD_BC_u16(GBCPU cpu)
# cdef int LD_DE_u16(GBCPU cpu)
# cdef int LD_HL_u16(GBCPU cpu)
# cdef int LD_SP_u16(GBCPU cpu)

cdef int LD_atBC_A(GBCPU cpu)
cdef int LD_atDE_A(GBCPU cpu)
cdef int LD_atHL_Apl(GBCPU cpu)
cdef int LD_atHL_Amn(GBCPU cpu)

cdef int LD_A_atBC(GBCPU cpu)
cdef int LD_A_atDE(GBCPU cpu)
cdef int LD_A_atHLpl(GBCPU cpu)
cdef int LD_A_atHLmn(GBCPU cpu)

cdef int LD_ff00_A(GBCPU cpu)
cdef int LD_A_ff00(GBCPU cpu)

cdef int LD_ffu8_A(GBCPU cpu)
cdef int LD_A_ffu8(GBCPU cpu)

cdef int NOP(GBCPU cpu)
cdef int DI(GBCPU cpu)
cdef int EI(GBCPU cpu)
cdef int RETI(GBCPU cpu)

cdef int DAA(GBCPU cpu)
cdef int SCF(GBCPU cpu)
cdef int CCF(GBCPU cpu)
cdef int CPL(GBCPU cpu)

cdef int POP_AF(GBCPU cpu)  # special case
cdef int LD_u16_SP(GBCPU cpu)
cdef int LD_SP_HL(GBCPU cpu)
cdef int ADD_SP_i8(GBCPU cpu)
cdef int LD_HL_SP_i8(GBCPU cpu)

cdef int RLA(GBCPU cpu)
cdef int RRA(GBCPU cpu)

cdef int CP_A_u8(GBCPU cpu)
cdef int AND_A_u8(GBCPU cpu)
cdef int XOR_A_u8(GBCPU cpu)
cdef int OR_A_u8(GBCPU cpu)
cdef int ADD_A_u8(GBCPU cpu)
cdef int ADC_A_u8(GBCPU cpu)
cdef int SBC_A_u8(GBCPU cpu)
cdef int SUB_A_u8(GBCPU cpu)

cdef int LD_u16_A(GBCPU cpu)
cdef int LD_A_u16(GBCPU cpu)

cdef int JP_HL(GBCPU cpu)

include "arithmeticinterp.pxi"
include "bitopinterp.pxi"
include "branchinterp.pxi"
include "loadinterp.pxi"