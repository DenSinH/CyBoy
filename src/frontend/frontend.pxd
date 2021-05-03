cdef extern from "CyBoyFront.h":
    cdef cppclass Frontend:
        Frontend(unsigned char* shutdown, unsigned char* data, char* name)
        void run()
        void join()