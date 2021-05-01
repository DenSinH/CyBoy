from src.system cimport GB

cpdef main():
    cdef GB gb
    gb = GB()
    gb.load_rom("files/blargg/cpu_instrs/individual/01-special.gb")
    gb.load_bootrom("files/DMG_ROM.bin")

    print("Starting")
    gb.run()
