#include "message_preparer.h" // Include the corresponding header file
#include "protobuf_c/smart_pkg_delivery.pb.h"
#include <stdbool.h>
#include <string.h> // For memset (safe initialization)

// 🏗 Prepare function for Request Message (returns request pointer)
smart_pkg_delivery_Request *
prepare_request_msg(smart_pkg_delivery_InteractionMsg *interaction_msg,
                    smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!interaction_msg)
    return NULL;
  memset(interaction_msg, 0, sizeof(smart_pkg_delivery_InteractionMsg));
  interaction_msg->which_msg_type =
      smart_pkg_delivery_InteractionMsg_request_tag;
  interaction_msg->msg_type.request.has_src_type = true;
  interaction_msg->msg_type.request.src_type = src_type;
  interaction_msg->msg_type.request.has_src_id = true;
  interaction_msg->msg_type.request.src_id = src_id;

  return &interaction_msg->msg_type.request;
}

// 🏗 Prepare function for Response Message (returns response pointer)
smart_pkg_delivery_Response *
prepare_response_msg(smart_pkg_delivery_InteractionMsg *interaction_msg,
                     smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!interaction_msg)
    return NULL;
  memset(interaction_msg, 0, sizeof(smart_pkg_delivery_InteractionMsg));
  interaction_msg->which_msg_type =
      smart_pkg_delivery_InteractionMsg_response_tag;
  interaction_msg->msg_type.response.has_src_type = true;
  interaction_msg->msg_type.response.src_type = src_type;
  interaction_msg->msg_type.response.has_src_id = true;
  interaction_msg->msg_type.response.src_id = src_id;

  return &interaction_msg->msg_type.response;
}

// 🏗 Prepare function for NodeEvent Message (returns node event pointer)
smart_pkg_delivery_NodeEvent *
prepare_node_event_msg(smart_pkg_delivery_InteractionMsg *interaction_msg,
                       smart_pkg_delivery_NodeType src_type, uint32_t src_id) {
  // 🚧 NULL check
  if (!interaction_msg)
    return NULL;

  memset(interaction_msg, 0, sizeof(smart_pkg_delivery_InteractionMsg));
  interaction_msg->which_msg_type =
      smart_pkg_delivery_InteractionMsg_node_event_tag;
  interaction_msg->msg_type.node_event.has_src_type = true;
  interaction_msg->msg_type.node_event.src_type = src_type;
  interaction_msg->msg_type.node_event.has_src_id = true;
  interaction_msg->msg_type.node_event.src_id = src_id;

  return &interaction_msg->msg_type.node_event;
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