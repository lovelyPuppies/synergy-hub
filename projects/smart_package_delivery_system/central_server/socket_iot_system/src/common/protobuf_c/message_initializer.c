#include "message_initializer.h" // Include the corresponding header file
#include "protobuf_c/smart_pkg_delivery.pb.h"
#include <stdbool.h>
#include <string.h> // For memset (safe initialization)

// 🏗 Initializer function for Request Message (output parameter approach)
void init_request_msg(smart_pkg_delivery_WrapperMsg *wrapper_msg,
                      smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!wrapper_msg)
    return;
  memset(wrapper_msg, 0, sizeof(smart_pkg_delivery_Request));
  wrapper_msg->which_msg_type = smart_pkg_delivery_WrapperMsg_request_tag;
  wrapper_msg->msg_type.request.has_src_type = true;
  wrapper_msg->msg_type.request.src_type = src_type;
  wrapper_msg->msg_type.request.has_src_id = true;
  wrapper_msg->msg_type.request.src_id = src_id;
}

// 🏗 Initializer function for Response Message (output parameter approach)
void init_response_msg(smart_pkg_delivery_WrapperMsg *wrapper_msg,
                       smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!wrapper_msg)
    return;
  memset(wrapper_msg, 0, sizeof(smart_pkg_delivery_Response));
  wrapper_msg->which_msg_type = smart_pkg_delivery_WrapperMsg_response_tag;
  wrapper_msg->msg_type.response.has_src_type = true;
  wrapper_msg->msg_type.response.src_type = src_type;
  wrapper_msg->msg_type.response.has_src_id = true;
  wrapper_msg->msg_type.response.src_id = src_id;
}

// 🏗 Initializer function for NodeEvent Message (output parameter approach)
void init_node_event_msg(smart_pkg_delivery_WrapperMsg *wrapper_msg,
                         smart_pkg_delivery_NodeType src_type,
                         uint32_t src_id) {
  // 🚧 NULL check
  if (!wrapper_msg)
    return;
  memset(wrapper_msg, 0, sizeof(smart_pkg_delivery_NodeEvent));
  wrapper_msg->which_msg_type = smart_pkg_delivery_WrapperMsg_node_event_tag;
  wrapper_msg->msg_type.node_event.has_src_type = true;
  wrapper_msg->msg_type.node_event.src_type = src_type;
  wrapper_msg->msg_type.node_event.has_src_id = true;
  wrapper_msg->msg_type.node_event.src_id = src_id;
}
// // 🏗 Initializer function for Request Message (output parameter approach)
// void init_request_msg(smart_pkg_delivery_Request *msg,
//                       smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
//   // 🚧 NULL check
//   if (!msg)
//     return;
//   memset(msg, 0, sizeof(smart_pkg_delivery_Request));
//   msg->has_src_type = true;
//   msg->src_type = src_type;
//   msg->has_src_id = true;
//   msg->src_id = src_id;
// }

// // 🏗 Initializer function for Response Message (output parameter approach)
// void init_response_msg(smart_pkg_delivery_Response *msg,
//                        smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
//   // 🚧 NULL check
//   if (!msg)
//     return;
//   memset(msg, 0, sizeof(smart_pkg_delivery_Response));
//   msg->has_src_type = true;
//   msg->src_type = src_type;
//   msg->src_id = src_id;
// }

// // 🏗 Initializer function for NodeEvent Message (output parameter approach)
// void init_node_event_msg(smart_pkg_delivery_NodeEvent *msg,
//                          smart_pkg_delivery_NodeType src_type,
//                          uint32_t src_id) {
//   // 🚧 NULL check
//   if (!msg)
//     return;
//   memset(msg, 0, sizeof(smart_pkg_delivery_NodeEvent));
//   msg->has_src_type = true;
//   msg->src_type = src_type;
//   msg->has_src_id = true;
//   msg->src_id = src_id;
// }