# instruction implementations:
include "gbimpl.pxi"

cdef class GBCPU:

    def __cinit__(self, MEM mem):
        self.shutdown = 0
        
        self.instructions = [
        # + 0          1          2            3          4            5          6           7          8            9          A            B        C           D          E           F
            NOP,       LD_BC_u16, LD_atBC_A,   INC_BC,    INC_B,       DEC_B,     LD_B_u8,    RLCA,      LD_u16_SP,   ADD_HL_BC, LD_A_atBC,   DEC_BC,  INC_C,      DEC_C,     LD_C_u8,    RRCA,    # 00
            NULL,      LD_DE_u16, LD_atDE_A,   INC_DE,    INC_D,       DEC_D,     LD_D_u8,    RLA,       JR__i8,      ADD_HL_DE, LD_A_atDE,   DEC_DE,  INC_E,      DEC_E,     LD_E_u8,    RRA,     # 10
            JR_NZ_i8,  LD_HL_u16, LD_atHL_Apl, INC_HL,    INC_H,       DEC_H,     LD_H_u8,    DAA,       JR_Z_i8,     ADD_HL_HL, LD_A_atHLpl, DEC_HL,  INC_L,      DEC_L,     LD_L_u8,    CPL,     # 20
            JR_NC_i8,  LD_SP_u16, LD_atHL_Amn, INC_SP,    INC_atHL,    DEC_atHL,  LD_atHL_u8, SCF,       JR_C_i8,     ADD_HL_SP, LD_A_atHLmn, DEC_SP,  INC_A,      DEC_A,     LD_A_u8,    CCF,     # 30
            LD_B_B,    LD_B_C,    LD_B_D,      LD_B_E,    LD_B_H,      LD_B_L,    LD_B_atHL,  LD_B_A,    LD_C_B,      LD_C_C,    LD_C_D,      LD_C_E,  LD_C_H,     LD_C_L,    LD_C_atHL,  LD_C_A,  # 40
            LD_D_B,    LD_D_C,    LD_D_D,      LD_D_E,    LD_D_H,      LD_D_L,    LD_D_atHL,  LD_D_A,    LD_E_B,      LD_E_C,    LD_E_D,      LD_E_E,  LD_E_H,     LD_E_L,    LD_E_atHL,  LD_E_A,  # 50
            LD_H_B,    LD_H_C,    LD_H_D,      LD_H_E,    LD_H_H,      LD_H_L,    LD_H_atHL,  LD_H_A,    LD_L_B,      LD_L_C,    LD_L_D,      LD_L_E,  LD_L_H,     LD_L_L,    LD_L_atHL,  LD_L_A,  # 60
            LD_atHL_B, LD_atHL_C, LD_atHL_D,   LD_atHL_E, LD_atHL_H,   LD_atHL_L, HALT,       LD_atHL_A, LD_A_B,      LD_A_C,    LD_A_D,      LD_A_E,  LD_A_H,     LD_A_L,    LD_A_atHL,  LD_A_A,  # 70
            ADD_A_B,   ADD_A_C,   ADD_A_D,     ADD_A_E,   ADD_A_H,     ADD_A_L,   ADD_A_atHL, ADD_A_A,   ADC_A_B,     ADC_A_C,   ADC_A_D,     ADC_A_E, ADC_A_H,    ADC_A_L,   ADC_A_atHL, ADC_A_A, # 80
            SUB_A_B,   SUB_A_C,   SUB_A_D,     SUB_A_E,   SUB_A_H,     SUB_A_L,   SUB_A_atHL, SUB_A_A,   SBC_A_B,     SBC_A_C,   SBC_A_D,     SBC_A_E, SBC_A_H,    SBC_A_L,   SBC_A_atHL, SBC_A_A, # 90
            AND_A_B,   AND_A_C,   AND_A_D,     AND_A_E,   AND_A_H,     AND_A_L,   AND_A_atHL, AND_A_A,   XOR_A_B,     XOR_A_C,   XOR_A_D,     XOR_A_E, XOR_A_H,    XOR_A_L,   XOR_A_atHL, XOR_A_A, # A0
            OR_A_B,    OR_A_C,    OR_A_D,      OR_A_E,    OR_A_H,      OR_A_L,    OR_A_atHL,  OR_A_A,    CP_A_B,      CP_A_C,    CP_A_D,      CP_A_E,  CP_A_H,     CP_A_L,    CP_A_atHL,  CP_A_A,  # B0
            RET_NZ,    POP_BC,    JP_NZ_u16,   JP__u16,   CALL_NZ_u16, PUSH_BC,   ADD_A_u8,   RST_00,    RET_Z,       RET_,      JP_Z_u16,    pref,    CALL_Z_u16, CALL__u16, ADC_A_u8,   RST_08,  # C0
            RET_NC,    POP_DE,    JP_NC_u16,   NULL,      CALL_NC_u16, PUSH_DE,   SUB_A_u8,   RST_10,    RET_C,       RETI,      JP_C_u16,    NULL,    CALL_C_u16, NULL,      SBC_A_u8,   RST_18,  # D0
            LD_ffu8_A, POP_HL,    LD_ff00_A,   NULL,      NULL,        PUSH_HL,   AND_A_u8,   RST_20,    ADD_SP_i8,   JP_HL,     LD_u16_A,    NULL,    NULL,       NULL,      XOR_A_u8,   RST_28,  # E0
            LD_A_ffu8, POP_AF,    LD_A_ff00,   DI,        NULL,        PUSH_AF,   OR_A_u8,    RST_30,    LD_HL_SP_i8, LD_SP_HL,  LD_A_u16,    EI,      NULL,       NULL,      CP_A_u8,    RST_38,  # F0
        ]

        self.extended_instructions = [
        # + 0        1        2        3        4        5        6           7        8        9        A        B        C        D        E           F
            RLC_B,   RLC_C,   RLC_D,   RLC_E,   RLC_H,   RLC_L,   RLC_atHL,   RLC_A,   RRC_B,   RRC_C,   RRC_D,   RRC_E,   RRC_H,   RRC_L,   RRC_atHL,   RRC_A,   # 00
            RL_B,    RL_C,    RL_D,    RL_E,    RL_H,    RL_L,    RL_atHL,    RL_A,    RR_B,    RR_C,    RR_D,    RR_E,    RR_H,    RR_L,    RR_atHL,    RR_A,    # 10
            SLA_B,   SLA_C,   SLA_D,   SLA_E,   SLA_H,   SLA_L,   SLA_atHL,   SLA_A,   SRA_B,   SRA_C,   SRA_D,   SRA_E,   SRA_H,   SRA_L,   SRA_atHL,   SRA_A,   # 20
            SWAP_B,  SWAP_C,  SWAP_D,  SWAP_E,  SWAP_H,  SWAP_L,  SWAP_atHL,  SWAP_A,  SRL_B,   SRL_C,   SRL_D,   SRL_E,   SRL_H,   SRL_L,   SRL_atHL,   SRL_A,   # 30
            BIT_0_B, BIT_0_C, BIT_0_D, BIT_0_E, BIT_0_H, BIT_0_L, BIT_0_atHL, BIT_0_A, BIT_1_B, BIT_1_C, BIT_1_D, BIT_1_E, BIT_1_H, BIT_1_L, BIT_1_atHL, BIT_1_A, # 40
            BIT_2_B, BIT_2_C, BIT_2_D, BIT_2_E, BIT_2_H, BIT_2_L, BIT_2_atHL, BIT_2_A, BIT_3_B, BIT_3_C, BIT_3_D, BIT_3_E, BIT_3_H, BIT_3_L, BIT_3_atHL, BIT_3_A, # 50
            BIT_4_B, BIT_4_C, BIT_4_D, BIT_4_E, BIT_4_H, BIT_4_L, BIT_4_atHL, BIT_4_A, BIT_5_B, BIT_5_C, BIT_5_D, BIT_5_E, BIT_5_H, BIT_5_L, BIT_5_atHL, BIT_5_A, # 60
            BIT_6_B, BIT_6_C, BIT_6_D, BIT_6_E, BIT_6_H, BIT_6_L, BIT_6_atHL, BIT_6_A, BIT_7_B, BIT_7_C, BIT_7_D, BIT_7_E, BIT_7_H, BIT_7_L, BIT_7_atHL, BIT_7_A, # 70
            RES_0_B, RES_0_C, RES_0_D, RES_0_E, RES_0_H, RES_0_L, RES_0_atHL, RES_0_A, RES_1_B, RES_1_C, RES_1_D, RES_1_E, RES_1_H, RES_1_L, RES_1_atHL, RES_1_A, # 80
            RES_2_B, RES_2_C, RES_2_D, RES_2_E, RES_2_H, RES_2_L, RES_2_atHL, RES_2_A, RES_3_B, RES_3_C, RES_3_D, RES_3_E, RES_3_H, RES_3_L, RES_3_atHL, RES_3_A, # 90
            RES_4_B, RES_4_C, RES_4_D, RES_4_E, RES_4_H, RES_4_L, RES_4_atHL, RES_4_A, RES_5_B, RES_5_C, RES_5_D, RES_5_E, RES_5_H, RES_5_L, RES_5_atHL, RES_5_A, # A0
            RES_6_B, RES_6_C, RES_6_D, RES_6_E, RES_6_H, RES_6_L, RES_6_atHL, RES_6_A, RES_7_B, RES_7_C, RES_7_D, RES_7_E, RES_7_H, RES_7_L, RES_7_atHL, RES_7_A, # B0
            SET_0_B, SET_0_C, SET_0_D, SET_0_E, SET_0_H, SET_0_L, SET_0_atHL, SET_0_A, SET_1_B, SET_1_C, SET_1_D, SET_1_E, SET_1_H, SET_1_L, SET_1_atHL, SET_1_A, # C0
            SET_2_B, SET_2_C, SET_2_D, SET_2_E, SET_2_H, SET_2_L, SET_2_atHL, SET_2_A, SET_3_B, SET_3_C, SET_3_D, SET_3_E, SET_3_H, SET_3_L, SET_3_atHL, SET_3_A, # D0
            SET_4_B, SET_4_C, SET_4_D, SET_4_E, SET_4_H, SET_4_L, SET_4_atHL, SET_4_A, SET_5_B, SET_5_C, SET_5_D, SET_5_E, SET_5_H, SET_5_L, SET_5_atHL, SET_5_A, # E0
            SET_6_B, SET_6_C, SET_6_D, SET_6_E, SET_6_H, SET_6_L, SET_6_atHL, SET_6_A, SET_7_B, SET_7_C, SET_7_D, SET_7_E, SET_7_H, SET_7_L, SET_7_atHL, SET_7_A, # F0
        ]

        self.mem = mem
        self.mem.bind_cpu(<void (*)(void*) nogil>&GBCPU.interrupt, <void*>self)

        cdef int i = 0
        for i in range(8):
            self.registers[i] = 0
        self.F = 0
        self.PC = 0
        self.SP = 0

        self.log = open("trace.log", "w+")

    cdef void interrupt(GBCPU self) nogil:
        # printf("attempting interrupt %02x & %02x (%d)\n", self.mem.IO.IF_, self.mem.IO.IE, self.IME)
        cdef unsigned char ack = self.mem.IO.IF_ & self.mem.IO.IE
        if not ack:
            return 
        self.halted = 0
        
        if not self.IME:
            return

        cdef unsigned char INT = 1
        cdef unsigned short vector = 0x40
        while INT != 0x20:
            if ack & INT:
                self.IME = 0
                self.mem.IO.IF_ = self.mem.IO.IF_ & ~INT  # clear requested interrupt
                self.PUSH_PC()
                self.PC = vector
                self.halted = 0
                return
            vector += 8
            INT <<= 1