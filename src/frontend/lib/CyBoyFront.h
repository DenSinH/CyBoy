#pragma once

#define DLLEXPORT __declspec(dllexport)

#include <thread>
#include <map>
#include <condition_variable>
#include <memory>

// necessary SDL definitions
struct SDL_Window;
struct SDL_Texture;
struct SDL_Renderer;
struct _SDL_GameController;
typedef struct _SDL_GameController SDL_GameController;
struct _SDL_AudioStream;
typedef _SDL_AudioStream SDL_AudioStream;
typedef uint32_t SDL_AudioDeviceID;

#define AUDIO_BUFFER_SIZE 1024


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
            );

    void run();
    void join();
    void bind_callback(char key, void (*callback)(void* data), void* data);
    void bind_keyboard_input(char key, unsigned char mask);
    void bind_controller_input(char button, unsigned char mask);
    void set_video_sync(bool value) { video_sync = value; }
    void wait_for_frame();
    void provide_sample(float left, float right);

private:
    // interaction with emulator
    volatile unsigned char* shutdown;    // shutdown
    volatile const unsigned char* data;  // texture data
    volatile unsigned int* frame_counter;
    std::map<char, key_callback> callbacks       = {};
    std::map<char, unsigned char> keyboard_input = {};
    std::map<char, unsigned char> button_input   = {};
    unsigned char* joypad  = nullptr;
    const char* name       = nullptr;
    SDL_GameController* controller = nullptr;

    // rendering stuff
    const unsigned int width, height, scale;
    SDL_Window* window     = nullptr;
    SDL_Texture* texture   = nullptr;
    SDL_Renderer* renderer = nullptr;
    std::thread thread;

    // video sync stuff
    std::mutex mutex;
    std::condition_variable frame_shown_var;
    volatile bool video_sync = false;
    volatile bool frame_shown = false;

    // audio stuff
    std::mutex audio_buffer_mutex;  // SDL is not thread safe apparently
    static void audio_callback(void* frontend, unsigned char* stream, int length);
    SDL_AudioDeviceID device;
    SDL_AudioStream* stream = nullptr;

    void init();
    void _run();
    void quit();
};