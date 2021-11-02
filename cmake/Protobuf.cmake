macro(configure_protobuf)
    option(protobuf_BUILD_TESTS "" OFF)
    option(protobuf_BUILD_EXAMPLES "" OFF)
    option(protobuf_WITH_ZLIB "" OFF)
    option(protobuf_BUILD_SHARED_LIBS "" OFF)

    set(CMAKE_POSITION_INDEPENDENT_CODE ON)

    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../third_party/protobuf/cmake)

    # Protobuf "namespaced" target is only added post protobuf 3.5.1. As a
    # result, for older versions, we will manually add alias.
    if(NOT TARGET protobuf::libprotobuf)
      add_library(protobuf::libprotobuf ALIAS libprotobuf)
      add_library(protobuf::libprotobuf-lite ALIAS libprotobuf-lite)
      add_executable(protobuf::protoc ALIAS protoc)
    endif()

    set(Protobuf_PROTOC_EXECUTABLE protobuf::protoc)
endmacro()

configure_protobuf()

function(protobuf_generate_cpp SRCS HDRS)
    set(PROTOS ${ARGN})

    foreach(proto ${PROTOS})
        get_filename_component(PROTO_NAME "${proto}" NAME_WLE)
        get_filename_component(PROTO_ABS "${proto}" ABSOLUTE)

        set(PROTO_SRC    "${CMAKE_CURRENT_BINARY_DIR}/${PROTO_NAME}.pb.cc")
        set(PROTO_HEADER "${CMAKE_CURRENT_BINARY_DIR}/${PROTO_NAME}.pb.h")

        message(STATUS "Protobuf ${PROTO_ABS} -> ${PROTO_SRC} ${PROTO_HEADER}")

        file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

        message(STATUS ${CMAKE_CURRENT_BINARY_DIR})

        add_custom_command(
            OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${PROTO_NAME}.pb.cc"
                   "${CMAKE_CURRENT_BINARY_DIR}/${PROTO_NAME}.pb.h"
            COMMAND ${Protobuf_PROTOC_EXECUTABLE}
            ARGS --cpp_out ${CMAKE_CURRENT_BINARY_DIR} -I${CMAKE_CURRENT_SOURCE_DIR} ${PROTO_ABS}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS "${PROTO_ABS}" protobuf::libprotobuf protobuf::protoc
            COMMENT "${PROTO_ABS} -> ${PROTO_SRC} ${PROTO_HEADER}"
        )

        list(APPEND SOURCES "${PROTO_SRC}")
        list(APPEND HEADERS "${PROTO_HEADER}")
    endforeach()

    set_source_files_properties(${SOURCES} ${HEADERS} PROPERTIES GENERATED TRUE)
    set(${SRCS} ${SOURCES} PARENT_SCOPE)
    set(${HDRS} ${HEADERS} PARENT_SCOPE)
endfunction()
