import os
import shutil

# copy over dlls
# todo: 32 vs 64 bit
FRONTEND_DLL_PATH = "./src/frontend.dll"
FRONTEND_DLL_LIB_PATH = "./src/frontend/lib/frontend.dll"
SDL_DLL_PATH = "./src/SDL2.dll"
SDL_DLL_LIB_PATH = "./SDL/x64/SDL2.dll"
if __name__ == "__main__":
    if not os.path.exists(FRONTEND_DLL_PATH) or os.path.getmtime(FRONTEND_DLL_PATH) < os.path.getmtime(FRONTEND_DLL_LIB_PATH):
        print("refresh frontend.dll")
        shutil.copy2(FRONTEND_DLL_LIB_PATH, FRONTEND_DLL_PATH)
    if not os.path.exists(SDL_DLL_PATH):
        shutil.copy2(SDL_DLL_LIB_PATH, SDL_DLL_PATH)

    from src.CyBoy import GB
    gb = GB()
    # gb.load_rom("files/blargg/cpu_instrs/cpu_instrs.gb")
    # gb.load_rom("files/gekkio/mbc5/rom_16Mb.gb")
    # gb.load_rom("files/Dr. Mario.gb")
    # gb.load_rom("files/Metroid II.gb")
    gb.load_rom("files/dmg-acid2.gb")
    # gb.load_rom("files/Pokemon Blue.gb")
    # gb.load_bootrom("files/DMG_ROM.bin")
    gb.skip_bootrom()

    print("Starting")
    gb.run()