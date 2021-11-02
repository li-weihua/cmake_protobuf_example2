cmake_minimum_required(VERSION 3.18)

project(Test LANGUAGES CXX)

if (NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 14)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF) # do not use gnu extension
endif()

include(cmake/Dependencies.cmake)

add_subdirectory(proto)

add_executable(run main.cc)
target_include_directories(run PUBLIC ${CMAKE_BINARY_DIR})
target_link_libraries(run PUBLIC person_proto)
