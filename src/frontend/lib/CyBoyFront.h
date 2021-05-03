#pragma once

#define DLLEXPORT __declspec(dllexport)

struct SDL_Window;
struct SDL_Texture;
struct SDL_Renderer;

#include <thread>

class DLLEXPORT Frontend {
public:
    explicit Frontend(unsigned char* shutdown, const unsigned char* data, const char* name) {
        this->shutdown = shutdown;
        this->data = data;
        this->name = name;
    }

    void run();
    void join();

private:
    volatile unsigned char* shutdown;  // shutdown
    volatile const unsigned char* data;      // texture data
    const char* name = nullptr;
    SDL_Window* window;
    SDL_Texture* texture;
    SDL_Renderer* renderer;
    std::thread thread;

    void init();
    void _run();
    void quit();
};