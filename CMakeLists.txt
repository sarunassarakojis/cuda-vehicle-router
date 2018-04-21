function (configure_target_executable target_name src)
    add_executable (${target_name} ${src})
    set_target_properties (${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
endfunction ()

function (configure_target_library target_name headers src)
    add_library (${target_name} SHARED ${headers} ${src})
    set_target_properties (${target_name} PROPERTIES PUBLIC_HEADER "${headers}")
endfunction ()

function (add_install_rules_for_shared_library target_name)
    include (GenerateExportHeader)
    SET (EXPORTS_FILE ${PROJECT_BINARY_DIR}/../${SRC}/router_library_exports.h)

    generate_export_header (${target_name} EXPORT_MACRO_NAME ROUTER_LIB_EXPORT 
            EXPORT_FILE_NAME ${EXPORTS_FILE})
    install (TARGETS ${target_name} PUBLIC_HEADER DESTINATION include
            ARCHIVE DESTINATION lib CONFIGURATIONS Release
            RUNTIME DESTINATION bin CONFIGURATIONS Release)
    install (TARGETS ${target_name} ARCHIVE DESTINATION Debug/lib CONFIGURATIONS Debug
            RUNTIME DESTINATION Debug/bin CONFIGURATIONS Debug)
    install (FILES ${EXPORTS_FILE} DESTINATION include CONFIGURATIONS Debug Release)
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
add_install_rules_for_shared_library (${LIBRARY_NAME})