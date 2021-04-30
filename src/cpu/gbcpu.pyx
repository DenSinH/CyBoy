
# instruction implementations:
include "gbimpl.pxi"

cdef class GBCPU:

    def __cinit__(self, MEM mem):
        
        self.instructions = [
        # + 0     1          2            3     4     5     6     7     8        9        A        B        C        D        E         F
            NULL, LD_BC_u16, LD_atBC_A,   NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 00
            NULL, LD_DE_u16, LD_atDE_A,   NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 10
            NULL, LD_HL_u16, LD_atHL_Apl, NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 20
            NULL, LD_SP_u16, LD_atHL_Amn, NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 30
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 40
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 50
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 60
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 70
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 80
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 90
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, XOR_A_B, XOR_A_C, XOR_A_D, XOR_A_E, XOR_A_H, XOR_A_L, XOR_A_HL, XOR_A_A, # A0
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # B0
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    pref,    NULL,    NULL,    NULL,     NULL,    # C0
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # D0
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # E0
            NULL, NULL,      NULL,        NULL, NULL, NULL, NULL, NULL, NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # F0
        ]

        self.extended_instructions = [
        # + 0        1        2        3        4        5        6         7        8        9        A        B        C        D        E        F
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 00
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 10
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 20
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 30
            BIT_0_B, BIT_0_C, BIT_0_D, BIT_0_E, BIT_0_H, BIT_0_L, BIT_0_HL, BIT_0_A, BIT_1_B, BIT_1_C, BIT_1_D, BIT_1_E, BIT_1_H, BIT_1_L, BIT_1_HL, BIT_1_A, # 40
            BIT_2_B, BIT_2_C, BIT_2_D, BIT_2_E, BIT_2_H, BIT_2_L, BIT_2_HL, BIT_2_A, BIT_3_B, BIT_3_C, BIT_3_D, BIT_3_E, BIT_3_H, BIT_3_L, BIT_3_HL, BIT_3_A, # 50
            BIT_4_B, BIT_4_C, BIT_4_D, BIT_4_E, BIT_4_H, BIT_4_L, BIT_4_HL, BIT_4_A, BIT_5_B, BIT_5_C, BIT_5_D, BIT_5_E, BIT_5_H, BIT_5_L, BIT_5_HL, BIT_5_A, # 60
            BIT_6_B, BIT_6_C, BIT_6_D, BIT_6_E, BIT_6_H, BIT_6_L, BIT_6_HL, BIT_6_A, BIT_7_B, BIT_7_C, BIT_7_D, BIT_7_E, BIT_7_H, BIT_7_L, BIT_7_HL, BIT_7_A, # 70
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 80
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # 90
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # A0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # B0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # C0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # D0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # E0
            NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,    NULL,     NULL,    # F0
        ]

        self.mem = mem

        cdef int i = 0
        for i in range(8):
            self.registers[i] = 0
        self.F = 0
        self.PC = 0
        self.SP = 0
