from distutils.core import setup 
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
from Cython.Compiler import Options
import os

# os.environ["CC"] = "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Tools\\Llvm\\x64\\bin\\clang++.exe"
os.environ["CC"] = "clang"
os.environ["CXX"] = "clang++"
os.environ["LDSHARED"] = "clang -shared"

Options.fast_fail = True

def make_ext(name, *sources):
    return Extension(
        name,
        [*sources],
        language="c++",
        libraries=["frontend"],
        library_dirs=["./src/frontend/lib"],
        include_dirs=["."],
        extra_compile_args=["/O2"]  # msvc bleh
    )

ext_modules = [
    make_ext(file.removesuffix(".pyx").replace("/", "."), file) for file in [
            "src/cpu/gbcpu.pyx",
            "src/mem/mem.pyx",
            "src/mem/mappers/mapper.pyx",
            "src/mem/mappers/MBC1.pyx",
            "src/mem/mappers/MBC2.pyx",
            "src/mem/mappers/MBC3.pyx",
            "src/mem/mappers/MBC5.pyx",
            "src/mem/IO.pyx",
            "src/ppu/gbppu.pyx",
            "src/apu/gbapu.pyx",
            "src/apu/channels/channel.pyx",
            "src/apu/channels/square.pyx",
            "src/CyBoy.pyx"
    ]
]

setup(
    name="CyBoy",
    cmdclass={"build_ext": build_ext},
    ext_modules=cythonize(
        ext_modules,
        compiler_directives={
            "boundscheck": False,
            "wraparound": False,
            "cdivision": True,
        },
        language_level=3,
        # nthreads=4
    ),
    include_dirs=[
        "./src/frontend/lib",  # frontend c++ library
    ]
)