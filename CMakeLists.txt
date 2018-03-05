cmake_minimum_required (3.10)

project (cuda-vehicle-router)

set (SOURCES entry.cpp)
add_executable (cuda-vehicle-router ${SOURCES})