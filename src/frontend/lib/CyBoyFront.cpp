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
            window, -1, SDL_RENDERER_ACCELERATED
    );
    texture = SDL_CreateTexture(
            renderer, SDL_PIXELFORMAT_RGBX8888, SDL_TEXTUREACCESS_STREAMING, width, height
    );
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
                case SDL_KEYDOWN: {
                    char key = SDL_GetKeyFromScancode(event.key.keysym.scancode);
                    if (callbacks.contains(key)) {
                        key_callback callback = callbacks[key];
                        callback.callback(callback.data);
                    }
                    break;
                }
            }

            if ((SDL_GetTicks() - ticks) > 500) {
                float framerate = (float)(1000.0 * *frame_counter) / (float)(SDL_GetTicks() - ticks);
                std::snprintf(title, sizeof(title), "%s (%.1f fps)", name, framerate);
                SDL_SetWindowTitle(window, title);
                ticks = SDL_GetTicks();
                *frame_counter = 0;
            }

            SDL_RenderClear(renderer);
            SDL_UpdateTexture(texture, nullptr, (const void *) data, 4 * width);
            SDL_RenderCopy(renderer, texture, nullptr, nullptr);
            SDL_RenderPresent(renderer);
        }
    }
}

void DLLEXPORT Frontend::quit() {
    SDL_QuitSubSystem(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER);
    SDL_DestroyWindow(window);
    SDL_Quit();
}