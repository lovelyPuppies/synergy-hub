#pragma once

#include <vector>
#include <string>


#ifdef _WIN32
  #define IOT_SERVER_EXPORT __declspec(dllexport)
#else
  #define IOT_SERVER_EXPORT
#endif

IOT_SERVER_EXPORT void iot_server();
IOT_SERVER_EXPORT void iot_server_print_vector(const std::vector<std::string> &strings);
