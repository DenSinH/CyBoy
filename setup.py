from distutils.core import setup 
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize


def make_ext(name, source):
    return Extension(
        name,
        [source],
        language="c++",
        libraries=["frontend"],
        library_dirs=["./src/frontend/lib"],
        include_dirs=["."],
        extra_compile_args=["/O2"]  # msvc bleh
    )

ext_modules = [
    *(make_ext(file.removesuffix(".pyx").replace("/", "."), file) for file in [
            "src/cpu/gbcpu.pyx",
            "src/mem/mem.pyx",
            "src/mem/IO.pyx",
            "src/ppu/gbppu.pyx",
    ]),
    Extension(
        "src.CyBoy",
        ["src/CyBoy.pyx"],
        language="c++",
        libraries=["frontend"],
        library_dirs=["./src/frontend/lib"],
        include_dirs=["."]
    ),
]

setup(
    name="CyBoy",
    cmdclass={"build_ext": build_ext},
    ext_modules=cythonize(
        ext_modules, 
        nthreads=4, 
        compiler_directives={
            "boundscheck": False,
            "wraparound": False,
            "cdivision": True,
        },
        language_level=3
    ),
    include_dirs=[
        "./src/frontend/lib",  # frontend c++ library
    ]
)