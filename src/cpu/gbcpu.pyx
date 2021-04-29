

cdef class GBCPU:

    def __cinit__(self, MEM mem):
        self.mem = mem

        cdef int i = 0
        for i in range(8):
            self.registers[i] = 0
        self.F = 0
        self.PC = 0
        self.SP = 0