#include "CyBoyFront.h"
#include <SDL.h>
#include <string>

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
    if (!*shutdown && !frame_skip)
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

void DLLEXPORT Frontend::init() {
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER)) {
        printf("Error initializing SDL2: %s\n", SDL_GetError());
    }

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
    SDL_DestroyWindow(window);
    SDL_Quit();
}