function (configure_target_executable target_name src)
    add_executable (${${target_name}} ${${src}})
    set_target_properties (${${target_name}} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
endfunction ()

function (configure_target_library target_name src)
    add_library (${${target_name}} SHARED ${${src}})
endfunction ()

cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

set (PROJECT_NAME cuda-vehicle-router)
project (${PROJECT_NAME} LANGUAGES CXX CUDA)

set (SRC "src")
set (SOURCES ${SRC}/entry.cpp
             ${SRC}/cuda_router_library.cuh
             ${SRC}/cuda_router_library.cu
             ${SRC}/router_library.h
             ${SRC}/router_library.cpp)

configure_target_executable (PROJECT_NAME SOURCES)

set (LIBRARY "${PROJECT_NAME}-lib")
configure_target_library (LIBRARY SOURCES)