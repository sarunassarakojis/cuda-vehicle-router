function (configure_target_executable target_name src)
    add_executable (${target_name} ${src})
    set_target_properties (${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
endfunction ()

function (configure_target_library target_name headers src)
    add_library (${target_name} SHARED ${headers} ${src})
    set_target_properties (${target_name} PROPERTIES PUBLIC_HEADER "${headers}")
endfunction ()

cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

set (PROJECT_NAME cuda-vehicle-router)
project (${PROJECT_NAME} LANGUAGES CXX CUDA)

set (SRC "src")
set (HEADERS ${SRC}/cuda_router_library.h
             ${SRC}/router_library.h)
set (SOURCES ${SRC}/entry.cpp
             ${SRC}/cuda_router_library.cu
             ${SRC}/router_library.cpp)
set (SOURCE ${HEADERS} ${SOURCES})

configure_target_executable (${PROJECT_NAME} "${SOURCE}")

set (LIBRARY_NAME "${PROJECT_NAME}-lib")
configure_target_library (${LIBRARY_NAME} "${HEADERS}" "${SOURCES}")

install (TARGETS ${LIBRARY_NAME} PUBLIC_HEADER DESTINATION include
                                 ARCHIVE DESTINATION lib CONFIGURATIONS Release Debug
                                 RUNTIME DESTINATION bin CONFIGURATIONS Release Debug)