#pragma once

#define DLLEXPORT __declspec(dllexport)

struct SDL_Window;
struct SDL_Texture;
struct SDL_Renderer;

#include <thread>
#include <map>


struct key_callback {
    void (*callback)(void* data);
    void* data;
};

class DLLEXPORT Frontend {
public:
    explicit Frontend(
            unsigned char* shutdown,
            const unsigned char* data,
            const char* name,
            unsigned int* frame_counter,
            unsigned int width,
            unsigned int height,
            unsigned int scale
            ) :
                width(width),
                height(height),
                scale(scale) {
        this->shutdown = shutdown;
        this->data = data;
        this->name = name;
        this->frame_counter = frame_counter;
    }

    void run();
    void join();
    void bind_callback(char key, void (*callback)(void* data), void* data);

private:
    volatile unsigned char* shutdown;    // shutdown
    volatile const unsigned char* data;  // texture data
    volatile unsigned int* frame_counter;
    std::map<char, key_callback> callbacks;
    const char* name       = nullptr;
    const unsigned int width, height, scale;
    SDL_Window* window     = nullptr;
    SDL_Texture* texture   = nullptr;
    SDL_Renderer* renderer = nullptr;
    std::thread thread;

    void init();
    void _run();
    void quit();
};