function (add_jni_includes_to_target target_name)
    target_include_directories (${target_name} PRIVATE 
	        $ENV{JAVA_HOME}/include $ENV{JAVA_HOME}/include/win32)
endfunction ()

function (configure_target_executable target_name src)
    add_executable (${target_name} ${src})
    set_target_properties (${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
    add_jni_includes_to_target(${target_name})
endfunction ()

function (configure_target_library target_name src)
    add_library (${target_name} SHARED ${src})
    add_jni_includes_to_target(${target_name})
endfunction ()

cmake_minimum_required (VERSION 3.10 FATAL_ERROR)
find_package (Java 1.8 REQUIRED COMPONENTS Development)

set (PROJECT_NAME cuda-vehicle-router)
project (${PROJECT_NAME} LANGUAGES CXX CUDA)

set (SRC "src")
set (SOURCES ${SRC}/entry.cpp
             ${SRC}/cuda_router_library.cuh
             ${SRC}/cuda_router_library.cu
             ${SRC}/router_library.h
             ${SRC}/router_library.cpp
             ${SRC}/native_interface.h
             ${SRC}/native_interface.cpp)

configure_target_executable (${PROJECT_NAME} "${SOURCES}")

set (LIBRARY_NAME "${PROJECT_NAME}-lib")
configure_target_library (${LIBRARY_NAME} "${SOURCES}")