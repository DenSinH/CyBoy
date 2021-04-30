cdef int pref(GBCPU cpu)  # prefixed instruction

cdef int LD_BC_u16(GBCPU cpu)
cdef int LD_DE_u16(GBCPU cpu)
cdef int LD_HL_u16(GBCPU cpu)
cdef int LD_SP_u16(GBCPU cpu)

cdef int LD_atBC_A(GBCPU cpu)
cdef int LD_atDE_A(GBCPU cpu)
cdef int LD_atHL_Apl(GBCPU cpu)
cdef int LD_atHL_Amn(GBCPU cpu)

include "arithmeticinterp.pxi"
include "bitopinterp.pxi"
include "branchinterp.pxi"
include "loadinterp.pxi"