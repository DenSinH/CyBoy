cmake_minimum_required(VERSION 3.19)
project(frontend CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
set(CMAKE_CXX_FLAGS -m64)
set(CMAKE_C_FLAGS -m64)
set(${PROJECT} PROPERTIES LINK_FLAGS /MACHINE:X64)

find_package(SDL2 REQUIRED)
set(BUILD_SHARED_LIBS 1)

add_library(frontend SHARED
        CyBoyFront.h
        CyBoyFront.cpp
)
set_target_properties(frontend PROPERTIES LINKER_LANGUAGE CXX)
target_link_libraries(frontend PRIVATE
        ${SDL2_LIBRARY}
)

message(STATUS "Found SDL2 at ${SDL2_LIBRARY} (${SDL2_INCLUDE_DIR})")
set(SDL2_LIBRARY D:/Data/vcpkg/installed/x64-windows/lib/manual-link/SDL2main.lib;D:/Data/vcpkg/installed/x64-windows/lib/SDL2.lib)
set(SDL2_INCLUDE_DIR D:/Data/vcpkg/installed/x64-windows/include/SDL2)
message(STATUS "Changed SDL2 to ${SDL2_LIBRARY} (${SDL2_INCLUDE_DIR})")

if (NOT WIN32)
    target_link_libraries(frontend PRIVATE -ldl -lpthread)
endif()

target_link_libraries(frontend PRIVATE -static-libgcc -static-libstdc++)
target_include_directories(frontend PRIVATE
        ${SDL2_INCLUDE_DIR}
)

add_custom_command(TARGET frontend POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/frontend.dll ${PROJECT_SOURCE_DIR}/frontend.dll
        COMMENT "Created frontend.dll"
)
add_custom_command(TARGET frontend POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/frontend.lib ${PROJECT_SOURCE_DIR}/frontend.lib
        COMMENT "Created frontend.lib"
)

add_custom_command(TARGET frontend POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/SDL2.dll ${PROJECT_SOURCE_DIR}/SDL2.dll
        COMMENT "Copied SDL2.dll"
)