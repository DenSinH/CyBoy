#include "CyBoyFront.h"
#include <SDL.h>

void DLLEXPORT Frontend::run() {
    thread = std::thread(&Frontend::_run, this);
}

void DLLEXPORT Frontend::join() {
    thread.join();
}

void DLLEXPORT Frontend::init() {
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER)) {
        printf("Error initializing SDL2: %s\n", SDL_GetError());
    }

    window = SDL_CreateWindow(
            this->name, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
            160, 144,
            SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI
    );
    renderer = SDL_CreateRenderer(
            window, -1, SDL_RENDERER_ACCELERATED
    );
    texture = SDL_CreateTexture(
            renderer, SDL_PIXELFORMAT_RGB888, SDL_TEXTUREACCESS_STREAMING, 160, 144
    );
}

void DLLEXPORT Frontend::_run() {
    init();
    while (!*shutdown) {
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    *shutdown = 1;
                    quit();
                    return;
            }
            SDL_RenderClear(renderer);
            SDL_RenderPresent(renderer);
        }
    }
}

void DLLEXPORT Frontend::quit() {
    SDL_QuitSubSystem(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER);
    SDL_DestroyWindow(window);
    SDL_Quit();
}