function (configure_target_executable target_name src)
    add_executable (${target_name} entry.cpp)

    set_target_properties (${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
    target_include_directories (${target_name} PRIVATE ${HEADERS_DIR})
    target_link_libraries (${target_name} PRIVATE ${LIBRARY_NAME})
endfunction ()

function (configure_target_library target_name headers src)
    set (CMAKE_DEBUG_POSTFIX d)

    add_library (${target_name} SHARED ${headers} ${src})
    set_target_properties (${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
    target_include_directories (${target_name} PRIVATE ${HEADERS_DIR})
    target_link_libraries (${target_name} PUBLIC spdlog::spdlog PUBLIC fmt::fmt-header-only)
endfunction ()

function (add_install_rules_for_shared_library target_name)
    include (GenerateExportHeader)
    SET (EXPORTS_FILE library_exports.h)

    generate_export_header (${target_name} EXPORT_MACRO_NAME LIBRARY_EXPORT 
            EXPORT_FILE_NAME ${HEADERS_DIR}/${EXPORTS_FILE})
    install (TARGETS ${target_name} CONFIGURATIONS Debug
            ARCHIVE DESTINATION debug/lib
            RUNTIME DESTINATION debug/bin)
    install (TARGETS ${target_name} CONFIGURATIONS Release
            ARCHIVE DESTINATION lib
            RUNTIME DESTINATION bin)
    install (DIRECTORY ${HEADERS_DIR}/ DESTINATION include)
endfunction ()

set (HEADERS_DIR ${PROJECT_SOURCE_DIR}/include)
set (PUBLIC_API ${HEADERS_DIR}/routing/cuda_router_library.h
        ${HEADERS_DIR}/routing/router_library.h
        ${HEADERS_DIR}/utilities/device/device_query.h
        ${HEADERS_DIR}/utilities/device/device_types.h
        ${HEADERS_DIR}/utilities/logging.h)
set (SOURCES routing/cuda_router_library.cu
        routing/router_library.cpp
        utilities/device/device_query.cpp
        utilities/logging.cpp)

set (LIBRARY_NAME "${PROJECT_NAME}-lib")
configure_target_library (${LIBRARY_NAME} "${PUBLIC_API}" "${SOURCES}")

configure_target_executable (${PROJECT_NAME} entry.cpp)

add_install_rules_for_shared_library (${LIBRARY_NAME})
