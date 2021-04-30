

class generator:

    def __init__(self, interp, impl):
        self.interp = interp
        self.impl   = impl

    def __enter__(self):
        self.interp = open(self.interp, "w+")
        self.impl = open(self.impl, "w+")
        return self

    def __exit__(self, *args):
        self.interp.close()
        self.impl.close()

    def generate_r8(self, name, code, code_HL):
        for r8 in ["B", "C", "D", "E", "H", "L", "A"]:
            self.interp.write((f"cdef int {name}(GBCPU cpu)\n").format(r8=r8))
            self.impl.write((f"cdef int {name}(GBCPU cpu):\n").format(r8=r8))
            self.impl.write("    " + "\n    ".join(code.strip().format(r8=r8).split("\n")) + "\n\n")

        self.interp.write((f"cdef int {name}(GBCPU cpu)\n").format(r8="HL"))
        self.impl.write((f"cdef int {name}(GBCPU cpu):\n").format(r8="HL"))
        self.impl.write("    " + "\n    ".join(code_HL.strip().split("\n")) + "\n\n")

    def generate_bitop(self, name, code, code_HL):
        for bit in range(8):
            for r8 in ["B", "C", "D", "E", "H", "L", "A"]:
                self.interp.write((f"cdef int {name}(GBCPU cpu)\n").format(bit=bit, hex=hex(1 << bit), r8=r8))
                self.impl.write((f"cdef int {name}(GBCPU cpu):\n").format(bit=bit, hex=hex(1 << bit), r8=r8))
                self.impl.write("    " + "\n    ".join(code.strip().format(bit=bit, hex=hex(1 << bit), r8=r8).split("\n")) + "\n\n")

            self.interp.write((f"cdef int {name}(GBCPU cpu)\n").format(bit=bit, hex=hex(1 << bit), r8="HL"))
            self.impl.write((f"cdef int {name}(GBCPU cpu):\n").format(bit=bit, hex=hex(1 << bit), r8="HL"))
            self.impl.write("    " + "\n    ".join(code_HL.format(bit=bit, hex=hex(1 << bit)).strip().split("\n")) + "\n\n")

    def generate_cond(self, name, code, *conds):
        for cond in conds:
            print(cond)
            cond_code = "True"
            if cond == "Z":
                cond_code = "cpu.F & FLAG_Z"
            elif cond == "NZ":
                cond_code = "not (cpu.F & FLAG_Z)"
            elif cond == "C":
                cond_code = "cpu.F & FLAG_C"
            elif cond == "NC":
                cond_code = "not (cpu.F & FLAG_C)"

            self.interp.write((f"cdef int {name}(GBCPU cpu)\n").format(cond=cond, code=cond_code))
            self.impl.write((f"cdef int {name}(GBCPU cpu):\n").format(cond=cond, code=cond_code, if_cond=f"if {cond_code}:"))
            self.impl.write("    " + "\n    ".join(code.strip().format(cond=cond, code=cond_code, if_cond=f"if {cond_code}:").split("\n")) + "\n\n")
            

