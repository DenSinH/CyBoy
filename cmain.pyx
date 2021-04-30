from src.system cimport GB

cpdef main():
    cdef GB gb
    gb = GB()
    gb.load_bootrom("files/DMG_ROM.bin")

    print("starting")
    gb.run()
