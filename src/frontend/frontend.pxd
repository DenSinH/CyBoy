from libcpp cimport bool

cdef extern from "CyBoyFront.h":
    cdef cppclass Frontend:
        Frontend(
            unsigned char* shutdown,
            unsigned char* data, 
            char* name,
            unsigned char* joypad,
            unsigned int* frame_counter,
            unsigned int width,
            unsigned int height,
            unsigned int scale
        )
        void run()
        void join()
        void bind_callback(char key, void (*callback)(void* data) nogil, void* data)
        void bind_keyboard_input(char key, unsigned char mask)
        void bind_controller_input(char key, unsigned char mask)
        void set_video_sync(bool value)
        void wait_for_frame() nogil
        
ctypedef void (*frontend_callback)(void* data) nogil