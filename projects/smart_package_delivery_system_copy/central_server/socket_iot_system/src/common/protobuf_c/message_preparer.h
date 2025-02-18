#ifndef MESSAGE_PREPARER_H
#define MESSAGE_PREPARER_H

// NanoPB-generated header file
#include "smart_pkg_delivery.pb.h"

smart_pkg_delivery_Request *
prepare_request_msg(smart_pkg_delivery_InteractionMsg *interaction_msg,
                    smart_pkg_delivery_NodeType src_type, uint32_t src_id);
smart_pkg_delivery_Response *
prepare_response_msg(smart_pkg_delivery_InteractionMsg *interaction_msg,
                     smart_pkg_delivery_NodeType src_type, uint32_t src_id);
smart_pkg_delivery_NodeEvent *
prepare_node_event_msg(smart_pkg_delivery_InteractionMsg *interaction_msg,
                       smart_pkg_delivery_NodeType src_type, uint32_t src_id);

#endif // MESSAGE_PREPARER_H
