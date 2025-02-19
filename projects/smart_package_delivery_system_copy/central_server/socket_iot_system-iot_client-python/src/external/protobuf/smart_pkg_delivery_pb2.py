# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# NO CHECKED-IN PROTOBUF GENCODE
# source: smart_pkg_delivery.proto
# Protobuf Python Version: 5.29.3
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import runtime_version as _runtime_version
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
_runtime_version.ValidateProtobufRuntimeVersion(
    _runtime_version.Domain.PUBLIC,
    5,
    29,
    3,
    '',
    'smart_pkg_delivery.proto'
)
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x18smart_pkg_delivery.proto\x12\x12smart_pkg_delivery\"\xda\x02\n\x0eInteractionMsg\x12.\n\x08src_type\x18\x01 \x01(\x0e\x32\x1c.smart_pkg_delivery.NodeType\x12\x0e\n\x06src_id\x18\x02 \x01(\r\x12\x10\n\x08src_name\x18\x03 \x01(\t\x12/\n\tdest_type\x18\x04 \x01(\x0e\x32\x1c.smart_pkg_delivery.NodeType\x12\x0f\n\x07\x64\x65st_id\x18\x05 \x01(\r\x12\x11\n\tdest_name\x18\x06 \x01(\t\x12.\n\x07request\x18\x07 \x01(\x0b\x32\x1b.smart_pkg_delivery.RequestH\x00\x12\x30\n\x08response\x18\x08 \x01(\x0b\x32\x1c.smart_pkg_delivery.ResponseH\x00\x12\x33\n\nnode_event\x18\t \x01(\x0b\x32\x1d.smart_pkg_delivery.NodeEventH\x00\x42\n\n\x08msg_type\"\xda\x02\n\x07Request\x12L\n\x17\x63lient_register_request\x18\x01 \x01(\x0b\x32).smart_pkg_delivery.ClientRegisterRequestH\x00\x12G\n\x15get_pkg_infos_request\x18\x02 \x01(\x0b\x32&.smart_pkg_delivery.GetPkgInfosRequestH\x00\x12S\n\x1bset_elevator_status_request\x18\x03 \x01(\x0b\x32,.smart_pkg_delivery.SetElevatorStatusRequestH\x00\x12S\n\x1bmove_delivery_robot_request\x18\x04 \x01(\x0b\x32,.smart_pkg_delivery.MoveDeliveryRobotRequestH\x00\x42\x0e\n\x0crequest_type\"\xd4\x03\n\x08Response\x12\x31\n\nack_status\x18\x01 \x01(\x0b\x32\x1d.smart_pkg_delivery.AckStatus\x12=\n\x10\x65xecution_status\x18\x02 \x01(\x0b\x32#.smart_pkg_delivery.ExecutionStatus\x12N\n\x18\x63lient_register_response\x18\x03 \x01(\x0b\x32*.smart_pkg_delivery.ClientRegisterResponseH\x00\x12G\n\x15get_pkg_info_response\x18\x04 \x01(\x0b\x32&.smart_pkg_delivery.GetPkgInfoResponseH\x00\x12U\n\x1cset_elevator_status_response\x18\x05 \x01(\x0b\x32-.smart_pkg_delivery.SetElevatorStatusResponseH\x00\x12U\n\x1cmove_delivery_robot_response\x18\x06 \x01(\x0b\x32-.smart_pkg_delivery.MoveDeliveryRobotResponseH\x00\x42\x0f\n\rresponse_type\"\xef\x01\n\tNodeEvent\x12@\n\x11pkg_arrival_event\x18\x01 \x01(\x0b\x32#.smart_pkg_delivery.PkgArrivalEventH\x00\x12H\n\x15\x65levator_status_event\x18\x02 \x01(\x0b\x32\'.smart_pkg_delivery.ElevatorStatusEventH\x00\x12H\n\x15\x64\x65livery_status_event\x18\x03 \x01(\x0b\x32\'.smart_pkg_delivery.DeliveryStatusEventH\x00\x42\x0c\n\nevent_type\"\x9d\x01\n\tAckStatus\x12=\n\x0bstatus_code\x18\x01 \x01(\x0e\x32(.smart_pkg_delivery.AckStatus.StatusCode\x12\x0f\n\x07message\x18\x02 \x01(\t\"@\n\nStatusCode\x12\x0f\n\x0bUNSPECIFIED\x10\x00\x12\x10\n\x0c\x41\x43K_RECEIVED\x10\x01\x12\x0f\n\x0b\x41\x43K_INVALID\x10\x02\"\x9f\x01\n\x0f\x45xecutionStatus\x12\x43\n\x0bstatus_code\x18\x01 \x01(\x0e\x32..smart_pkg_delivery.ExecutionStatus.StatusCode\x12\x0f\n\x07message\x18\x02 \x01(\t\"6\n\nStatusCode\x12\x0f\n\x0bUNSPECIFIED\x10\x00\x12\x0b\n\x07SUCCESS\x10\x01\x12\n\n\x06\x46\x41ILED\x10\x02\"x\n\x15\x43lientRegisterRequest\x12\x33\n\ridentity_type\x18\x01 \x01(\x0e\x32\x1c.smart_pkg_delivery.NodeType\x12\x13\n\x0bidentity_id\x18\x02 \x01(\r\x12\x15\n\ridentity_name\x18\x03 \x01(\t\"\x18\n\x16\x43lientRegisterResponse\"%\n\x12GetPkgInfosRequest\x12\x0f\n\x07user_id\x18\x01 \x01(\r\";\n\x12GetPkgInfoResponse\x12%\n\x04pkgs\x18\x01 \x03(\x0b\x32\x17.smart_pkg_delivery.Pkg\"r\n\x18MoveDeliveryRobotRequest\x12\x19\n\x11\x64\x65livery_robot_id\x18\x01 \x01(\r\x12;\n\x13\x64\x65stination_address\x18\x02 \x01(\x0b\x32\x1e.smart_pkg_delivery.AptAddress\"\x1b\n\x19MoveDeliveryRobotResponse\"m\n\x18SetElevatorStatusRequest\x12\x13\n\x0b\x65levator_id\x18\x01 \x01(\r\x12<\n\x0f\x65levator_status\x18\x02 \x01(\x0b\x32#.smart_pkg_delivery.Elevator.Status\"\x1b\n\x19SetElevatorStatusResponse\"B\n\x0fPkgArrivalEvent\x12/\n\x07\x61\x64\x64ress\x18\x01 \x01(\x0b\x32\x1e.smart_pkg_delivery.AptAddress\"h\n\x13\x45levatorStatusEvent\x12\x13\n\x0b\x65levator_id\x18\x01 \x01(\r\x12<\n\x0f\x65levator_status\x18\x02 \x01(\x0b\x32#.smart_pkg_delivery.Elevator.Status\"{\n\x13\x44\x65liveryStatusEvent\x12\x19\n\x11\x64\x65livery_robot_id\x18\x01 \x01(\r\x12I\n\x0f\x64\x65livery_status\x18\x02 \x01(\x0e\x32\x30.smart_pkg_delivery.DeliveryRobot.DeliveryStatus\"\xec\x01\n\x08\x45levator\x12\n\n\x02id\x18\x01 \x01(\r\x12\x33\n\x06status\x18\x02 \x01(\x0b\x32#.smart_pkg_delivery.Elevator.Status\x1a\x66\n\x06Status\x12\x15\n\rcurrent_floor\x18\x01 \x01(\r\x12\x45\n\x10\x64oor_open_status\x18\x02 \x01(\x0e\x32+.smart_pkg_delivery.Elevator.DoorOpenStatus\"7\n\x0e\x44oorOpenStatus\x12\x0f\n\x0bUNSPECIFIED\x10\x00\x12\n\n\x06\x43LOSED\x10\x01\x12\x08\n\x04OPEN\x10\x02\"\xb5\x01\n\rDeliveryRobot\x12\n\n\x02id\x18\x01 \x01(\r\x12I\n\x0f\x64\x65livery_status\x18\x03 \x01(\x0e\x32\x30.smart_pkg_delivery.DeliveryRobot.DeliveryStatus\"M\n\x0e\x44\x65liveryStatus\x12\x0f\n\x0bUNSPECIFIED\x10\x00\x12\x0b\n\x07PENDING\x10\x01\x12\x0e\n\nIN_TRANSIT\x10\x02\x12\r\n\tDELIVERED\x10\x03\"\x8c\x01\n\x07PkgRoom\x12\n\n\x02id\x18\x01 \x01(\r\x12\x33\n\x07lockers\x18\x02 \x03(\x0b\x32\".smart_pkg_delivery.PkgRoom.Locker\x1a@\n\x06Locker\x12\x11\n\tlocker_id\x18\x01 \x01(\r\x12\x13\n\x0b\x61\x63\x63\x65ss_code\x18\x02 \x01(\t\x12\x0e\n\x06pkg_id\x18\x03 \x01(\r\"C\n\x04User\x12\n\n\x02id\x18\x01 \x01(\r\x12/\n\x07\x61\x64\x64ress\x18\x02 \x01(\x0b\x32\x1e.smart_pkg_delivery.AptAddress\"\x7f\n\x03Pkg\x12\n\n\x02id\x18\x01 \x01(\r\x12/\n\x07\x61\x64\x64ress\x18\x02 \x01(\x0b\x32\x1e.smart_pkg_delivery.AptAddress\x12\x11\n\tsender_id\x18\x03 \x01(\r\x12\x13\n\x0breceiver_id\x18\x04 \x01(\r\x12\x13\n\x0bphoto_bytes\x18\x05 \x01(\x0c\"I\n\nAptAddress\x12\x13\n\x0b\x61pt_complex\x18\x01 \x01(\t\x12\x14\n\x0c\x62uilding_num\x18\x02 \x01(\r\x12\x10\n\x08unit_num\x18\x03 \x01(\r*\x87\x01\n\x08NodeType\x12\x0f\n\x0bUNSPECIFIED\x10\x00\x12\n\n\x06SERVER\x10\x01\x12\x1d\n\x19\x43LIENT_ADDRESS_RECOGNIZER\x10\x02\x12\x0f\n\x0b\x43LIENT_USER\x10\x03\x12\x19\n\x15\x43LIENT_DELIVERY_ROBOT\x10\x04\x12\x13\n\x0f\x43LIENT_ELEVATOR\x10\x05\x62\x08\x65\x64itionsp\xe8\x07')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'smart_pkg_delivery_pb2', _globals)
if not _descriptor._USE_C_DESCRIPTORS:
  DESCRIPTOR._loaded_options = None
  _globals['_NODETYPE']._serialized_start=3453
  _globals['_NODETYPE']._serialized_end=3588
  _globals['_INTERACTIONMSG']._serialized_start=49
  _globals['_INTERACTIONMSG']._serialized_end=395
  _globals['_REQUEST']._serialized_start=398
  _globals['_REQUEST']._serialized_end=744
  _globals['_RESPONSE']._serialized_start=747
  _globals['_RESPONSE']._serialized_end=1215
  _globals['_NODEEVENT']._serialized_start=1218
  _globals['_NODEEVENT']._serialized_end=1457
  _globals['_ACKSTATUS']._serialized_start=1460
  _globals['_ACKSTATUS']._serialized_end=1617
  _globals['_ACKSTATUS_STATUSCODE']._serialized_start=1553
  _globals['_ACKSTATUS_STATUSCODE']._serialized_end=1617
  _globals['_EXECUTIONSTATUS']._serialized_start=1620
  _globals['_EXECUTIONSTATUS']._serialized_end=1779
  _globals['_EXECUTIONSTATUS_STATUSCODE']._serialized_start=1725
  _globals['_EXECUTIONSTATUS_STATUSCODE']._serialized_end=1779
  _globals['_CLIENTREGISTERREQUEST']._serialized_start=1781
  _globals['_CLIENTREGISTERREQUEST']._serialized_end=1901
  _globals['_CLIENTREGISTERRESPONSE']._serialized_start=1903
  _globals['_CLIENTREGISTERRESPONSE']._serialized_end=1927
  _globals['_GETPKGINFOSREQUEST']._serialized_start=1929
  _globals['_GETPKGINFOSREQUEST']._serialized_end=1966
  _globals['_GETPKGINFORESPONSE']._serialized_start=1968
  _globals['_GETPKGINFORESPONSE']._serialized_end=2027
  _globals['_MOVEDELIVERYROBOTREQUEST']._serialized_start=2029
  _globals['_MOVEDELIVERYROBOTREQUEST']._serialized_end=2143
  _globals['_MOVEDELIVERYROBOTRESPONSE']._serialized_start=2145
  _globals['_MOVEDELIVERYROBOTRESPONSE']._serialized_end=2172
  _globals['_SETELEVATORSTATUSREQUEST']._serialized_start=2174
  _globals['_SETELEVATORSTATUSREQUEST']._serialized_end=2283
  _globals['_SETELEVATORSTATUSRESPONSE']._serialized_start=2285
  _globals['_SETELEVATORSTATUSRESPONSE']._serialized_end=2312
  _globals['_PKGARRIVALEVENT']._serialized_start=2314
  _globals['_PKGARRIVALEVENT']._serialized_end=2380
  _globals['_ELEVATORSTATUSEVENT']._serialized_start=2382
  _globals['_ELEVATORSTATUSEVENT']._serialized_end=2486
  _globals['_DELIVERYSTATUSEVENT']._serialized_start=2488
  _globals['_DELIVERYSTATUSEVENT']._serialized_end=2611
  _globals['_ELEVATOR']._serialized_start=2614
  _globals['_ELEVATOR']._serialized_end=2850
  _globals['_ELEVATOR_STATUS']._serialized_start=2691
  _globals['_ELEVATOR_STATUS']._serialized_end=2793
  _globals['_ELEVATOR_DOOROPENSTATUS']._serialized_start=2795
  _globals['_ELEVATOR_DOOROPENSTATUS']._serialized_end=2850
  _globals['_DELIVERYROBOT']._serialized_start=2853
  _globals['_DELIVERYROBOT']._serialized_end=3034
  _globals['_DELIVERYROBOT_DELIVERYSTATUS']._serialized_start=2957
  _globals['_DELIVERYROBOT_DELIVERYSTATUS']._serialized_end=3034
  _globals['_PKGROOM']._serialized_start=3037
  _globals['_PKGROOM']._serialized_end=3177
  _globals['_PKGROOM_LOCKER']._serialized_start=3113
  _globals['_PKGROOM_LOCKER']._serialized_end=3177
  _globals['_USER']._serialized_start=3179
  _globals['_USER']._serialized_end=3246
  _globals['_PKG']._serialized_start=3248
  _globals['_PKG']._serialized_end=3375
  _globals['_APTADDRESS']._serialized_start=3377
  _globals['_APTADDRESS']._serialized_end=3450
# @@protoc_insertion_point(module_scope)
