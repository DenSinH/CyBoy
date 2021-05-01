
# instruction implementations:
include "gbimpl.pxi"

cdef class GBCPU:

    def __cinit__(self, MEM mem):
        
        self.instructions = [
        # + 0          1          2            3          4            5          6           7          8            9          A            B        C           D          E           F
            NOP,       LD_BC_u16, LD_atBC_A,   INC_BC,    INC_B,       DEC_B,     LD_B_u8,    NULL,      LD_u16_SP,   ADD_HL_BC, LD_A_atBC,   DEC_BC,  INC_C,      DEC_C,     LD_C_u8,    NULL,    # 00
            NULL,      LD_DE_u16, LD_atDE_A,   INC_DE,    INC_D,       DEC_D,     LD_D_u8,    RLA,       JR__i8,      ADD_HL_DE, LD_A_atDE,   DEC_DE,  INC_E,      DEC_E,     LD_E_u8,    RRA,     # 10
            JR_NZ_i8,  LD_HL_u16, LD_atHL_Apl, INC_HL,    INC_H,       DEC_H,     LD_H_u8,    DAA,       JR_Z_i8,     ADD_HL_HL, LD_A_atHLpl, DEC_HL,  INC_L,      DEC_L,     LD_L_u8,    CPL,     # 20
            JR_NC_i8,  LD_SP_u16, LD_atHL_Amn, INC_SP,    INC_atHL,    DEC_atHL,  LD_atHL_u8, NULL,      JR_C_i8,     ADD_HL_SP, LD_A_atHLmn, DEC_SP,  INC_A,      DEC_A,     LD_A_u8,    NULL,    # 30
            LD_B_B,    LD_B_C,    LD_B_D,      LD_B_E,    LD_B_H,      LD_B_L,    LD_B_atHL,  LD_B_A,    LD_C_B,      LD_C_C,    LD_C_D,      LD_C_E,  LD_C_H,     LD_C_L,    LD_C_atHL,  LD_C_A,  # 40
            LD_B_B,    LD_D_C,    LD_D_D,      LD_D_E,    LD_D_H,      LD_D_L,    LD_D_atHL,  LD_D_A,    LD_E_B,      LD_E_C,    LD_E_D,      LD_E_E,  LD_E_H,     LD_E_L,    LD_E_atHL,  LD_E_A,  # 50
            LD_B_B,    LD_H_C,    LD_H_D,      LD_H_E,    LD_H_H,      LD_H_L,    LD_H_atHL,  LD_H_A,    LD_L_B,      LD_L_C,    LD_L_D,      LD_L_E,  LD_L_H,     LD_L_L,    LD_L_atHL,  LD_L_A,  # 60
            LD_B_B,    LD_atHL_C, LD_atHL_D,   LD_atHL_E, LD_atHL_H,   LD_atHL_L, NULL,       LD_atHL_A, LD_A_B,      LD_A_C,    LD_A_D,      LD_A_E,  LD_A_H,     LD_A_L,    LD_A_atHL,  LD_A_A,  # 70
            ADD_A_B,   ADD_A_C,   ADD_A_D,     ADD_A_E,   ADD_A_H,     ADD_A_L,   ADD_A_atHL, ADD_A_A,   NULL,        NULL,      NULL,        NULL,    NULL,       NULL,      NULL,       NULL,    # 80
            SUB_A_B,   SUB_A_C,   SUB_A_D,     SUB_A_E,   SUB_A_H,     SUB_A_L,   SUB_A_atHL, SUB_A_A,   NULL,        NULL,      NULL,        NULL,    NULL,       NULL,      NULL,       NULL,    # 90
            NULL,      NULL,      NULL,        NULL,      NULL,        NULL,      NULL,       NULL,      XOR_A_B,     XOR_A_C,   XOR_A_D,     XOR_A_E, XOR_A_H,    XOR_A_L,   XOR_A_atHL, XOR_A_A, # A0
            OR_A_B,    OR_A_C,    OR_A_D,      OR_A_E,    OR_A_H,      OR_A_L,    OR_A_atHL,  OR_A_A,    CP_A_B,      CP_A_C,    CP_A_D,      CP_A_E,  CP_A_H,     CP_A_L,    CP_A_atHL,  CP_A_A,  # B0
            RET_NZ,    POP_BC,    JP_NZ_u16,   JP__u16,   CALL_NZ_u16, PUSH_BC,   ADD_A_u8,   NULL,      RET_Z,       RET_,      JP_Z_u16,    pref,    CALL_Z_u16, CALL__u16, ADC_A_u8,   NULL,    # C0
            RET_NC,    POP_DE,    JP_NC_u16,   NULL,      CALL_NC_u16, PUSH_DE,   SUB_A_u8,   NULL,      RET_C,       NULL,      JP_C_u16,    NULL,    CALL_C_u16, NULL,      NULL,       NULL,    # D0
            LD_ffu8_A, POP_HL,    LD_ff00_A,   NULL,      NULL,        PUSH_HL,   AND_A_u8,   NULL,      ADD_SP_i8,   JP_HL,     LD_u16_A,    NULL,    NULL,       NULL,      XOR_A_u8,   NULL,    # E0
            LD_A_ffu8, POP_AF,    LD_A_ff00,   DI,        NULL,        PUSH_AF,   NULL,       NULL,      LD_HL_SP_i8, LD_SP_HL,  LD_A_u16,    EI,      NULL,       NULL,      CP_A_u8,    NULL,    # F0
        ]

        self.extended_instructions = [
        # + 0        1        2        3        4        5        6           7        8        9        A        B        C        D        E           F
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # 00
            RL_B,    RL_C,    RL_D,    RL_E,    RL_H,    RL_L,    RL_atHL,    RL_A,    RR_B,    RR_C,    RR_D,    RR_E,    RR_H,    RR_L,    RR_atHL,    RR_A,    # 10
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # 20
            SWAP_B,  SWAP_C,  SWAP_D,  SWAP_E,  SWAP_H,  SWAP_L,  SWAP_atHL,  SWAP_A,  SRL_B,   SRL_C,   SRL_D,   SRL_E,   SRL_H,   SRL_L,   SRL_atHL,   RL_A,    # 30
            BIT_0_B, BIT_0_C, BIT_0_D, BIT_0_E, BIT_0_H, BIT_0_L, BIT_0_atHL, BIT_0_A, BIT_1_B, BIT_1_C, BIT_1_D, BIT_1_E, BIT_1_H, BIT_1_L, BIT_1_atHL, BIT_1_A, # 40
            BIT_2_B, BIT_2_C, BIT_2_D, BIT_2_E, BIT_2_H, BIT_2_L, BIT_2_atHL, BIT_2_A, BIT_3_B, BIT_3_C, BIT_3_D, BIT_3_E, BIT_3_H, BIT_3_L, BIT_3_atHL, BIT_3_A, # 50
            BIT_4_B, BIT_4_C, BIT_4_D, BIT_4_E, BIT_4_H, BIT_4_L, BIT_4_atHL, BIT_4_A, BIT_5_B, BIT_5_C, BIT_5_D, BIT_5_E, BIT_5_H, BIT_5_L, BIT_5_atHL, BIT_5_A, # 60
            BIT_6_B, BIT_6_C, BIT_6_D, BIT_6_E, BIT_6_H, BIT_6_L, BIT_6_atHL, BIT_6_A, BIT_7_B, BIT_7_C, BIT_7_D, BIT_7_E, BIT_7_H, BIT_7_L, BIT_7_atHL, BIT_7_A, # 70
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # 80
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # 90
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # A0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # B0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # C0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # D0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # E0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,       NULL,    # F0
        ]

        self.mem = mem

        cdef int i = 0
        for i in range(8):
            self.registers[i] = 0
        self.F = 0
        self.PC = 0
        self.SP = 0

        self.log = open("trace.log", "w+")
