#include "message_initializer.h" // Include the corresponding header file
#include <string.h>              // For memset (safe initialization)

// 🏗 Initializer function for Request Message (output parameter approach)
void init_request_msg(smart_pkg_delivery_Request *msg,
                      smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!msg)
    return;
  memset(msg, 0, sizeof(smart_pkg_delivery_Request));
  msg->src_type = src_type;
  msg->src_id = src_id;
}

// 🏗 Initializer function for Response Message (output parameter approach)
void init_response_msg(smart_pkg_delivery_Response *msg,
                       smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!msg)
    return;
  memset(msg, 0, sizeof(smart_pkg_delivery_Response));
  msg->src_type = src_type;
  msg->src_id = src_id;
}

// 🏗 Initializer function for NodeEvent Message (output parameter approach)
void init_node_event_msg(smart_pkg_delivery_NodeEvent *msg,
                         smart_pkg_delivery_NodeType src_type,
                         uint32_t src_id) {
  // 🚧 NULL check
  if (!msg)
    return;
  memset(msg, 0, sizeof(smart_pkg_delivery_NodeEvent));
  msg->src_type = src_type;
  msg->src_id = src_id;
}