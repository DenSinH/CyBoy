import pyximport
import os

RELEASE = True

# from distutils import sysconfig
# sysconfig.get_config_vars()["CC"] = "clang"
# sysconfig.get_config_vars()["CXX"] = "clang++"
# sysconfig.get_config_vars()["CFLAGS"] = "-Ofast" if RELEASE else "-O0"
# sysconfig.get_config_vars()["CPPFLAGS"] = "-Ofast -fopt" if RELEASE else "-O0"
# sysconfig.get_config_vars()["OPT"] = "-std-compile-opts -std-link-opts -O3"

# from Cython.Distutils.old_build_ext import optimization
# print(optimization.state)

pyximport.install(
    build_dir=os.path.abspath("./build"),
    pyximport=True,
    setup_args={
        "options": {
            "build_ext": {
                "cython_directives": {
                    "optimize.use_switch": True,
                    "boundscheck": RELEASE,
                    "wraparound": RELEASE,
                    "cdivision": RELEASE,
                    "profile": not RELEASE,
                    "warn.undeclared": not RELEASE,
                    "warn.unused": not RELEASE,
                    "warn.unused_arg": not RELEASE,
                    "warn.unused_result": not RELEASE
                }
            }
        },
        "script_args": ["--cython-cplus"],
    },
    language_level=3,
    reload_support=True,
)

if __name__ == "__main__":
    from src.system import GB
    gb = GB()
    gb.load_rom("files/blargg/cpu_instrs/individual/01-special.gb")
    # gb.load_bootrom("files/DMG_ROM.bin")
    gb.skip_bootrom()

    print("Starting")
    gb.run()