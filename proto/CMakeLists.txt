protobuf_generate_cpp(SRCS HDRS person.proto)

message("src: ${SRCS}")
message("headers: ${HDRS}")

add_library(person_proto STATIC ${SRCS} ${HDRS})

target_link_libraries(person_proto PUBLIC protobuf::libprotobuf)
