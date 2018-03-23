cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

project (cuda-vehicle-router LANGUAGES CXX CUDA)

set (SOURCES src/entry.cpp
             src/router_libraries.cuh
			 src/router_libraries.cu)

add_executable (cuda-vehicle-router ${SOURCES})

set_target_properties (cuda-vehicle-router PROPERTIES CUDA_SEPARABLE_COMPILATION ON)