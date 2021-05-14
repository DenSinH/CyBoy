#pragma once

#define DLLEXPORT __declspec(dllexport)

struct SDL_Window;
struct SDL_Texture;
struct SDL_Renderer;
struct _SDL_GameController;
typedef struct _SDL_GameController SDL_GameController;

#include <thread>
#include <map>
#include <condition_variable>


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
            unsigned char* joypad,
            unsigned int* frame_counter,
            unsigned int width,
            unsigned int height,
            unsigned int scale
            ) :
                width(width),
                height(height),
                scale(scale) {
        this->joypad = joypad;
        this->shutdown = shutdown;
        this->data = data;
        this->name = name;
        this->frame_counter = frame_counter;
    }

    void run();
    void join();
    void bind_callback(char key, void (*callback)(void* data), void* data);
    void bind_keyboard_input(char key, unsigned char mask);
    void bind_controller_input(char button, unsigned char mask);
    void set_frame_skip(bool value) { frame_skip = value; }
    void wait_for_frame();

private:
    volatile unsigned char* shutdown;    // shutdown
    volatile const unsigned char* data;  // texture data
    volatile unsigned int* frame_counter;
    std::map<char, key_callback> callbacks       = {};
    std::map<char, unsigned char> keyboard_input = {};
    std::map<char, unsigned char> button_input   = {};
    unsigned char* joypad  = nullptr;
    const char* name       = nullptr;
    const unsigned int width, height, scale;
    SDL_GameController* controller = nullptr;
    SDL_Window* window     = nullptr;
    SDL_Texture* texture   = nullptr;
    SDL_Renderer* renderer = nullptr;
    std::thread thread;

    std::mutex mutex;
    std::condition_variable frame_shown_var;
    volatile bool frame_skip = false;
    volatile bool frame_shown = false;

    void init();
    void _run();
    void quit();
};