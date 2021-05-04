cdef extern from "CyBoyFront.h":
    cdef cppclass Frontend:
        Frontend(
            unsigned char* shutdown,
            unsigned char* data, 
            char* name,
            unsigned int* frame_counter,
            unsigned int width,
            unsigned int height,
            unsigned int scale
        )
        void run()
        void join()
        void bind_callback(char key, void (*callback)(void* data) nogil, void* data)
        
ctypedef void (*frontend_callback)(void* data) nogil