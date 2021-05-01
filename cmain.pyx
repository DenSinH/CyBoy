from src.system cimport GB


cpdef main():
    cdef GB gb
    gb = GB()
    gb.load_rom("files/blargg/cpu_instrs/individual/09-op r,r.gb")
    # gb.load_bootrom("files/DMG_ROM.bin")
    gb.skip_bootrom()

    print("Starting")
    gb.run()
