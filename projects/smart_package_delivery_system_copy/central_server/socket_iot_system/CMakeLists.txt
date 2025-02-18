##### Project setup and configuration
cmake_minimum_required(VERSION 3.15)
project(socket_iot_system CXX C)

# Enable Clang tooling support: Creates `compile_commands.json` during the CMake configure step
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++")

### ✅ (how-to); Symbolic link creation for compile_commands.json after the CMake configure step 📅 2025-01-28 05:17:32
# Define paths for compile_commands.json
set(COMPILE_COMMANDS_SRC "${CMAKE_BINARY_DIR}/compile_commands.json")
set(COMPILE_COMMANDS_DEST "${CMAKE_SOURCE_DIR}/build/compile_commands.json")

# Attempt to create the symbolic link after the configure phase
execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${COMPILE_COMMANDS_SRC}" "${COMPILE_COMMANDS_DEST}"
    RESULT_VARIABLE result
    ERROR_VARIABLE error_message
)

# Print the result of the symbolic link creation
if(result)
    # Failed to create the symbolic link, log a warning message
    message(WARNING "Failed to create symbolic link for compile_commands.json: ${error_message}")
else()
    # Successfully created the symbolic link, log a status message
    message(STATUS "Successfully created symbolic link: ${COMPILE_COMMANDS_DEST}")
endif()


set(nano_pb_header_dir /opt/nanopb/include)
set(c_common_sources
    ${nano_pb_header_dir}/pb_encode.c
    ${nano_pb_header_dir}/pb_decode.c
    ${nano_pb_header_dir}/pb_common.c
    src/common/protobuf_c/message_preparer.c
    src/common/protobuf_c/smart_pkg_delivery.pb.c
)

# https://cmake.org/cmake/help/latest/module/FindPkgConfig.html
# https://cmake.org/cmake/help/latest/module/FindProtobuf.html

# include (FindPkgConfig)
# pkg_check_modules (Protobuf protobuf)
# foreach (flag ${pkg_CFLAGS})
#     set (EXTRA_LIBS ${EXTRA_LIBS} ${flag})
#   endforeach (flag)
#   foreach (flag ${pkg_LDFLAGS})
#     set (EXTRA_LIBS ${EXTRA_LIBS} ${flag})
#   endforeach (flag)

# find_package(Protobuf REQUIRED)
# set(Protobuf_INCLUDE_DIRS "/opt/protobuf/release-shared/include")
# set(Protobuf_LIBRARIES "/opt/protobuf/release-shared/lib/libprotobuf.so")
# # set(CMAKE_PREFIX_PATH "/opt/protobuf/release-shared")

# # 🔹 Protobuf 라이브러리가 없을 경우 에러 발생시키기
# if(NOT Protobuf_FOUND)
#     message(FATAL_ERROR "📵 Protobuf not found!")
# else()
#     message(STATUS "🆗 Protobuf found!")
#     message(STATUS "📂 Protobuf Include Directory: ${Protobuf_INCLUDE_DIRS}")
#     message(STATUS "📦 Protobuf Libraries: ${Protobuf_LIBRARIES}")
#     message(STATUS "🔢 Protobuf Version: ${Protobuf_VERSION}")
# endif()
set(cpp_common_sources
    src/common/protobuf_cpp/smart_pkg_delivery.pb.cc
)

##### Define and configure executables
set(IOT_SERVER_DIR src/app/iot_server)
set(IOT_CLIENT_ADDRESS_RECOGNIZER_C_DIR src/app/iot_client-address_recognizer-c)
set(IOT_CLIENT_DELIVERY_ROBOT_DIR src/app/iot_client-delivery_robot)
set(IOT_CLIENT_ELEVATOR_C_DIR src/app/iot_client-elevator-c)
set(IOT_CLIENT_USER_DIR src/app/iot_client-user)

# add_executable(iot_client )
add_executable(iot_server ${cpp_common_sources} ${IOT_SERVER_DIR}/iot_server.cpp ${IOT_SERVER_DIR}/main.cpp)
add_executable(iot_client-delivery_robot ${IOT_CLIENT_DELIVERY_ROBOT_DIR}/iot_client_cpp.cpp ${IOT_CLIENT_DELIVERY_ROBOT_DIR}/main.cpp)
add_executable(iot_client-elevator ${c_common_sources} ${IOT_CLIENT_ELEVATOR_C_DIR}/main.c)
add_executable(iot_client-user ${IOT_CLIENT_USER_DIR}/iot_client_cpp.cpp ${IOT_CLIENT_USER_DIR}/main.cpp)

# set_target_properties(iot_server PROPERTIES CXX_STANDARD 23 CXX_STANDARD_REQUIRED YES)
# set_target_properties(iot_client_cpp PROPERTIES CXX_STANDARD 23 CXX_STANDARD_REQUIRED YES)
# set_target_properties(iot_client_c PROPERTIES C_STANDARD 23 C_STANDARD_REQUIRED YES)


# Common include directory
set(COMMON_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/src/common)
target_include_directories(iot_server PRIVATE ${COMMON_INCLUDE_DIR} ${Protobuf_INCLUDE_DIRS})
# target_include_directories(iot_client-address_recognizer PRIVATE ${COMMON_INCLUDE_DIR})
target_include_directories(iot_client-delivery_robot PRIVATE ${COMMON_INCLUDE_DIR})
target_include_directories(iot_client-elevator PRIVATE ${COMMON_INCLUDE_DIR})
target_include_directories(iot_client-user PRIVATE ${COMMON_INCLUDE_DIR})

target_compile_options(iot_server PRIVATE
    -I/opt/protobuf/release-static/include
    -DNOMINMAX
)

target_link_directories(iot_server PRIVATE
    /opt/protobuf/release-static/lib
)
target_link_libraries(iot_server PRIVATE
    protobuf
    absl_log_internal_check_op
    absl_leak_check
    absl_die_if_null
    absl_log_internal_conditions
    absl_log_internal_message
    absl_examine_stack
    absl_log_internal_format
    absl_log_internal_proto
    absl_log_internal_nullguard
    absl_log_internal_log_sink_set
    absl_log_sink
    absl_log_entry
    absl_flags_internal
    absl_flags_marshalling
    absl_flags_reflection
    absl_flags_private_handle_accessor
    absl_flags_commandlineflag
    absl_flags_commandlineflag_internal
    absl_flags_config
    absl_flags_program_name
    absl_log_initialize
    absl_log_internal_globals
    absl_log_globals
    absl_vlog_config_internal
    absl_log_internal_fnmatch
    absl_raw_hash_set
    absl_hash
    absl_city
    absl_low_level_hash
    absl_hashtablez_sampler
    absl_random_distributions
    absl_random_seed_sequences
    absl_random_internal_pool_urbg
    absl_random_internal_randen
    absl_random_internal_randen_hwaes
    absl_random_internal_randen_hwaes_impl
    absl_random_internal_randen_slow
    absl_random_internal_platform
    absl_random_internal_seed_material
    absl_random_seed_gen_exception
    absl_statusor
    absl_status
    absl_cord
    absl_cordz_info
    absl_cord_internal
    absl_cordz_functions
    absl_exponential_biased
    absl_cordz_handle
    absl_crc_cord_state
    absl_crc32c
    absl_crc_internal
    absl_crc_cpu_detect
    absl_bad_optional_access
    absl_strerror
    absl_str_format_internal
    absl_synchronization
    absl_graphcycles_internal
    absl_kernel_timeout_internal
    absl_stacktrace
    absl_symbolize
    absl_debugging_internal
    absl_demangle_internal
    absl_malloc_internal
    absl_time
    absl_civil_time
    absl_time_zone
    absl_bad_variant_access
    utf8_validity
    utf8_range
    absl_strings
    absl_strings_internal
    absl_string_view
    absl_base
    rt
    absl_spinlock_wait
    absl_int128
    absl_throw_delegate
    absl_raw_logging_internal
    absl_log_severity
)
# ##### Install configuration 📰 TODO
# install(TARGETS iot_server DESTINATION "."
#         RUNTIME DESTINATION bin
#         ARCHIVE DESTINATION lib
#         LIBRARY DESTINATION lib
#         )

# 

