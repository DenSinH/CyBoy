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

include "arithmeticinterp.pxi"
include "bitopinterp.pxi"
include "branchinterp.pxi"
include "loadinterp.pxi"