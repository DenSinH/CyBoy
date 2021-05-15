#include "CyBoyFront.h"
#include <SDL.h>
#include <string>

Frontend::Frontend(unsigned char *shutdown, const unsigned char *data, const char *name, unsigned char *joypad,
                   unsigned int *frame_counter, unsigned int width, unsigned int height, unsigned int scale) :
        width(width),
        height(height),
        scale(scale) {
    this->joypad = joypad;
    this->shutdown = shutdown;
    this->data = data;
    this->name = name;
    this->frame_counter = frame_counter;
}

void DLLEXPORT Frontend::run() {
    thread = std::thread(&Frontend::_run, this);
}

void DLLEXPORT Frontend::join() {
    thread.join();
}

void Frontend::bind_callback(char key, void (*callback)(void* data), void* data) {
    callbacks[key] = {  .callback=callback, .data=data };
}

void Frontend::bind_keyboard_input(char key, unsigned char mask){
    keyboard_input[key] = mask;
}

void Frontend::bind_controller_input(char button, unsigned char mask){
    button_input[button] = mask;
}

void Frontend::wait_for_frame() {
    if (!*shutdown && video_sync)
    {
        frame_shown = false;
        std::unique_lock<std::mutex> lock(mutex);

        // prevent deadlocks on shutdown
        while (!frame_shown_var.wait_for(
                lock,
                std::chrono::milliseconds(16),
                [&]{ return frame_shown; }
                )) {
            if (*shutdown) {
                return;
            }
        }
    }
}

void Frontend::provide_sample(float left, float right) {
    if (!stream) return;
    while (stream && (SDL_AudioStreamAvailable(stream) > 0.5 * 32768 * sizeof(float))) {
        // more than half a second of audio available, stop providing samples
        // stream might have been destroyed
        if (!audio_sync) return;
    }

    float samples[2] = { left, right };
    audio_buffer_mutex.lock();
    SDL_AudioStreamPut(stream, samples, 2 * sizeof(float));
    audio_buffer_mutex.unlock();
}

void Frontend::audio_callback(void* _frontend, unsigned char* stream, int length) {
    auto frontend = (Frontend*)_frontend;
    frontend->audio_buffer_mutex.lock();
    int gotten = 0;
    if (SDL_AudioStreamAvailable(frontend->stream)) {
        // buffer samples we provided
        gotten = SDL_AudioStreamGet(frontend->stream, stream, length);
    }
    frontend->audio_buffer_mutex.unlock();

    if (gotten < length) {
        int gotten_samples = gotten / sizeof(float);
        float* out = ((float*)stream) + gotten_samples;

        float sample = 0;
        if (gotten) {
            // last sample the APU generated
            sample = *(((float*)stream) + gotten_samples - 1);
        }

        for (int i = gotten_samples; i < length / sizeof(float); i++) {
            *out++ = sample;
        }
    }
}

void DLLEXPORT Frontend::init() {
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER)) {
        printf("Error initializing SDL2: %s\n", SDL_GetError());
    }

    // video initialization
    window = SDL_CreateWindow(
            this->name, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
            scale * width, scale * height,
            SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
    );
    renderer = SDL_CreateRenderer(
            window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
    );
    texture = SDL_CreateTexture(
            renderer, SDL_PIXELFORMAT_RGBX8888, SDL_TEXTUREACCESS_STREAMING, width, height
    );

    // audio initialization
    SDL_AudioSpec gb_spec = {
            .freq     = 44100,
            .format   = AUDIO_F32SYS,
            .channels = 2,
            .samples  = AUDIO_BUFFER_SIZE,
            .callback = &Frontend::audio_callback,
            .userdata = this,
    };

    device = SDL_OpenAudioDevice(nullptr, 0, &gb_spec, nullptr, 0);
    if (!device) {
        printf("Unable to open an audio device: %s\n", SDL_GetError());
    }
    stream = SDL_NewAudioStream(
            AUDIO_F32SYS, 2, 32768,
            AUDIO_F32SYS, 2, 44100
    );
    SDL_PauseAudioDevice(device, false);

    // joypad initialization
    if (SDL_NumJoysticks() < 0) {
        printf("No gamepads detected\n");
    }
    else {
        for (int i = 0; i < SDL_NumJoysticks(); i++) {
            if (SDL_IsGameController(i)) {
                controller = SDL_GameControllerOpen(i);

                if (!controller) {
                    printf("Failed to connect to gamecontroller at index %d\n", i);
                    continue;
                }

                printf("Connected game controller at index %d\n", i);
                return;
            }
        }
    }
    printf("No gamepads detected (only joysticks)\n");
}

void DLLEXPORT Frontend::_run() {
    init();
    unsigned int ticks = SDL_GetTicks();
    char title[50];
    while (!*shutdown) {
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    *shutdown = 1;
                    quit();
                    return;
                case SDL_CONTROLLERDEVICEADDED:
                    controller =  SDL_GameControllerOpen(event.cdevice.which);
                    if (controller == nullptr) {
                        printf("Error with connected gamepad\n");
                    }
                    break;
                case SDL_KEYDOWN: {
                    char key = SDL_GetKeyFromScancode(event.key.keysym.scancode);
                    if (callbacks.contains(key)) {
                        key_callback callback = callbacks[key];
                        callback.callback(callback.data);
                    }
                    if (keyboard_input.contains(key)) {
                        *joypad |= keyboard_input[key];
                    }
                    break;
                }
                case SDL_KEYUP: {
                    char key = SDL_GetKeyFromScancode(event.key.keysym.scancode);
                    if (keyboard_input.contains(key)) {
                        *joypad &= ~keyboard_input[key];
                    }
                    break;
                }
                case SDL_CONTROLLERBUTTONDOWN: {
                    char button = event.cbutton.button;
                    if (button_input.contains(button)) {
                        *joypad |= button_input[button];
                    }
                    break;
                }
                case SDL_CONTROLLERBUTTONUP: {
                    char button = event.cbutton.button;
                    if (button_input.contains(button)) {
                        *joypad &= ~button_input[button];
                    }
                    break;
                }
            }
        }

        if ((SDL_GetTicks() - ticks) > 500) {
            float framerate = (float)(1000.0 * *frame_counter) / (float)(SDL_GetTicks() - ticks);
            std::snprintf(title, sizeof(title), "%s (%.1f fps)", name, framerate);
            SDL_SetWindowTitle(window, title);
            ticks = SDL_GetTicks();
            *frame_counter = 0;
        }

        {
            std::lock_guard<std::mutex> lock(mutex);
            frame_shown = true;
        }
        frame_shown_var.notify_one();

        SDL_RenderClear(renderer);
        SDL_UpdateTexture(texture, nullptr, (const void *) data, 4 * width);
        SDL_RenderCopy(renderer, texture, nullptr, nullptr);
        SDL_RenderPresent(renderer);
    }
    frame_shown = true;
    frame_shown_var.notify_one();
}

void DLLEXPORT Frontend::quit() {
    SDL_QuitSubSystem(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER);
    if (stream) {
        SDL_FreeAudioStream(stream);
        stream = nullptr;
    }
    if (device) {
        SDL_CloseAudioDevice(device);
    }
    SDL_CloseAudio();
    SDL_DestroyWindow(window);
    SDL_Quit();
}