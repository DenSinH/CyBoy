cdef extern from "CyBoyFront.h":
    cdef cppclass Frontend:
        Frontend(
            unsigned char* shutdown,
            unsigned char* data, 
            char* name,
            unsigned int width,
            unsigned int height,
            unsigned int scale
        )
        void run()
        void join()