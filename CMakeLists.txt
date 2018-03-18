cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

project (cuda-vehicle-router LANGUAGES CXX CUDA)

set (SOURCES src/entry.cpp)
add_executable (cuda-vehicle-router ${SOURCES})