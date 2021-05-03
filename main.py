

if __name__ == "__main__":
    from src.CyBoy import GB
    gb = GB()
    gb.load_rom("files/blargg/cpu_instrs/individual/01-special.gb")
    # gb.load_bootrom("files/DMG_ROM.bin")
    gb.skip_bootrom()

    print("Starting")
    gb.run()