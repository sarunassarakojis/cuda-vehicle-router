function (configure_target_executable target_name src)
    add_executable (${target_name} ${src})
    set_target_properties (${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
endfunction ()

function (configure_target_library target_name headers src)
    set (CMAKE_DEBUG_POSTFIX d)

    add_library (${target_name} SHARED ${headers} ${src})
    set_target_properties (${target_name} PROPERTIES PUBLIC_HEADER "${headers}" 
            CUDA_SEPARABLE_COMPILATION ON)
endfunction ()

function (add_install_rules_for_shared_library target_name)
    include (GenerateExportHeader)
    SET (EXPORTS_FILE router_library_exports.h)

    generate_export_header (${target_name} EXPORT_MACRO_NAME ROUTER_LIB_EXPORT 
            EXPORT_FILE_NAME ${EXPORTS_FILE})
    install (TARGETS ${target_name} CONFIGURATIONS Debug
            PUBLIC_HEADER DESTINATION include
            ARCHIVE DESTINATION debug/lib
            RUNTIME DESTINATION debug/bin)
    install (TARGETS ${target_name} CONFIGURATIONS Release
            PUBLIC_HEADER DESTINATION include
            ARCHIVE DESTINATION lib
            RUNTIME DESTINATION bin)
    install (FILES ${EXPORTS_FILE} DESTINATION include)
endfunction ()

project (cuda-vehicle-router LANGUAGES CXX CUDA)

set (HEADERS cuda_router_library.h
             router_library.h)
set (SOURCES cuda_router_library.cu
             router_library.cpp)

set (EXE_SOURCE ${HEADERS} ${SOURCES} entry.cpp)
configure_target_executable (${PROJECT_NAME} "${EXE_SOURCE}")

set (LIBRARY_NAME "${PROJECT_NAME}-lib")
configure_target_library (${LIBRARY_NAME} "${HEADERS}" "${SOURCES}")
add_install_rules_for_shared_library (${LIBRARY_NAME})
