cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

set (PROJECT_NAME cuda-vehicle-router)
project (${PROJECT_NAME} LANGUAGES CXX CUDA)

set (SRC "src")
set (SOURCES ${SRC}/entry.cpp
             ${SRC}/cuda_router_library.cuh
             ${SRC}/cuda_router_library.cu
             ${SRC}/router_library.h
             ${SRC}/router_library.cpp)

add_executable (${PROJECT_NAME} ${SOURCES})
set (LIBRARY "${PROJECT_NAME}-lib")
add_library (${LIBRARY} STATIC ${SOURCES})

set_target_properties (cuda-vehicle-router PROPERTIES CUDA_SEPARABLE_COMPILATION ON)