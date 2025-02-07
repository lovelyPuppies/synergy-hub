#pragma once

#include <vector>
#include <string>


#ifdef _WIN32
  #define IOT_CLIENT_EXPORT __declspec(dllexport)
#else
  #define IOT_CLIENT_EXPORT
#endif

IOT_CLIENT_EXPORT void iot_client();
IOT_CLIENT_EXPORT void iot_client_print_vector(const std::vector<std::string> &strings);
