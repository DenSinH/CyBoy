# CyBoy
A GameBoy emulator written in Cython

I wrote the frontend for it in C++ with SDL2, then wrote bindings for that in Cython, so that I can use threads for the frontend. Supports saving. The `main.py` file checks whether the frontend.dll is still up to date, or if it has been rebuilt, and copies it over if necessary.

I get framerates of about 3000fps on my machine. I think the biggest performance gain comes from the fact that the entire emulator runs without the GIL (global interpreter lock), and is essentially C++ code, albeit written in a very obfuscated way.
I could have optimized it more, especially the TIMA register, but I got higher framerates than I expected already, so I didn't mind too much. To edit the controls, take a look at `src/CyBoy.pyx` in the function `spawn_frontend`. Also supports controllers through SDL2.

It was very fun to figure out what Cython is like, and to know how to link C/C++ to python with it.

To run the emulator, I created a virtual python 3.9 environment, and installed Cython on it. Then `run.bat` would setup the cython extension, and `main.py` would import it and run it. To run it yourself, simply install the Cython module, and run the commands similar to those in `run.bat`. It will generate `.cpp` and `.pyd` files (in place) that python can import. `main.py` will load the ROM you tell it to, and start the emulator.
