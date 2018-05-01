cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

project (cuda-vehicle-router LANGUAGES CXX CUDA)

find_package (spdlog REQUIRED)
find_package (fmt REQUIRED)

add_subdirectory (src)
