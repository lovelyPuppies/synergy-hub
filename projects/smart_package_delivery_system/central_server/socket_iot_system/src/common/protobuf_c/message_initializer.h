#ifndef MESSAGE_INITIALIZER_H
#define MESSAGE_INITIALIZER_H

// NanoPB-generated header file
#include "smart_pkg_delivery.pb.h"

// 📝 Initializer function prototypes using the output parameter approach
void init_request_msg(smart_pkg_delivery_Request *msg,
                      smart_pkg_delivery_NodeType src_type, uint32_t src_id);
void init_response_msg(smart_pkg_delivery_Response *msg,
                       smart_pkg_delivery_NodeType src_type, uint32_t src_id);
void init_node_event_msg(smart_pkg_delivery_NodeEvent *msg,
                         smart_pkg_delivery_NodeType src_type, uint32_t src_id);

#endif // MESSAGE_INITIALIZER_H
