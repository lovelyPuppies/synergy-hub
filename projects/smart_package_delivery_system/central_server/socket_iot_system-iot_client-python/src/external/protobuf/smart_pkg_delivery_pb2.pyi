from google.protobuf.internal import containers as _containers
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class NodeType(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    UNSPECIFIED: _ClassVar[NodeType]
    SERVER: _ClassVar[NodeType]
    CLIENT_ADDRESS_RECOGNIZER: _ClassVar[NodeType]
    CLIENT_USER: _ClassVar[NodeType]
    CLIENT_DELIVERY_ROBOT: _ClassVar[NodeType]
    CLIENT_ELEVATOR: _ClassVar[NodeType]
UNSPECIFIED: NodeType
SERVER: NodeType
CLIENT_ADDRESS_RECOGNIZER: NodeType
CLIENT_USER: NodeType
CLIENT_DELIVERY_ROBOT: NodeType
CLIENT_ELEVATOR: NodeType

class InteractionMsg(_message.Message):
    __slots__ = ("src_type", "src_id", "src_name", "dest_type", "dest_id", "dest_name", "request", "response", "node_event")
    SRC_TYPE_FIELD_NUMBER: _ClassVar[int]
    SRC_ID_FIELD_NUMBER: _ClassVar[int]
    SRC_NAME_FIELD_NUMBER: _ClassVar[int]
    DEST_TYPE_FIELD_NUMBER: _ClassVar[int]
    DEST_ID_FIELD_NUMBER: _ClassVar[int]
    DEST_NAME_FIELD_NUMBER: _ClassVar[int]
    REQUEST_FIELD_NUMBER: _ClassVar[int]
    RESPONSE_FIELD_NUMBER: _ClassVar[int]
    NODE_EVENT_FIELD_NUMBER: _ClassVar[int]
    src_type: NodeType
    src_id: int
    src_name: str
    dest_type: NodeType
    dest_id: int
    dest_name: str
    request: Request
    response: Response
    node_event: NodeEvent
    def __init__(self, src_type: _Optional[_Union[NodeType, str]] = ..., src_id: _Optional[int] = ..., src_name: _Optional[str] = ..., dest_type: _Optional[_Union[NodeType, str]] = ..., dest_id: _Optional[int] = ..., dest_name: _Optional[str] = ..., request: _Optional[_Union[Request, _Mapping]] = ..., response: _Optional[_Union[Response, _Mapping]] = ..., node_event: _Optional[_Union[NodeEvent, _Mapping]] = ...) -> None: ...

class Request(_message.Message):
    __slots__ = ("client_register_request", "get_pkg_infos_request", "set_elevator_status_request", "move_delivery_robot_request")
    CLIENT_REGISTER_REQUEST_FIELD_NUMBER: _ClassVar[int]
    GET_PKG_INFOS_REQUEST_FIELD_NUMBER: _ClassVar[int]
    SET_ELEVATOR_STATUS_REQUEST_FIELD_NUMBER: _ClassVar[int]
    MOVE_DELIVERY_ROBOT_REQUEST_FIELD_NUMBER: _ClassVar[int]
    client_register_request: ClientRegisterRequest
    get_pkg_infos_request: GetPkgInfosRequest
    set_elevator_status_request: SetElevatorStatusRequest
    move_delivery_robot_request: MoveDeliveryRobotRequest
    def __init__(self, client_register_request: _Optional[_Union[ClientRegisterRequest, _Mapping]] = ..., get_pkg_infos_request: _Optional[_Union[GetPkgInfosRequest, _Mapping]] = ..., set_elevator_status_request: _Optional[_Union[SetElevatorStatusRequest, _Mapping]] = ..., move_delivery_robot_request: _Optional[_Union[MoveDeliveryRobotRequest, _Mapping]] = ...) -> None: ...

class Response(_message.Message):
    __slots__ = ("ack_status", "execution_status", "client_register_response", "get_pkg_info_response", "set_elevator_status_response", "move_delivery_robot_response")
    ACK_STATUS_FIELD_NUMBER: _ClassVar[int]
    EXECUTION_STATUS_FIELD_NUMBER: _ClassVar[int]
    CLIENT_REGISTER_RESPONSE_FIELD_NUMBER: _ClassVar[int]
    GET_PKG_INFO_RESPONSE_FIELD_NUMBER: _ClassVar[int]
    SET_ELEVATOR_STATUS_RESPONSE_FIELD_NUMBER: _ClassVar[int]
    MOVE_DELIVERY_ROBOT_RESPONSE_FIELD_NUMBER: _ClassVar[int]
    ack_status: AckStatus
    execution_status: ExecutionStatus
    client_register_response: ClientRegisterResponse
    get_pkg_info_response: GetPkgInfoResponse
    set_elevator_status_response: SetElevatorStatusResponse
    move_delivery_robot_response: MoveDeliveryRobotResponse
    def __init__(self, ack_status: _Optional[_Union[AckStatus, _Mapping]] = ..., execution_status: _Optional[_Union[ExecutionStatus, _Mapping]] = ..., client_register_response: _Optional[_Union[ClientRegisterResponse, _Mapping]] = ..., get_pkg_info_response: _Optional[_Union[GetPkgInfoResponse, _Mapping]] = ..., set_elevator_status_response: _Optional[_Union[SetElevatorStatusResponse, _Mapping]] = ..., move_delivery_robot_response: _Optional[_Union[MoveDeliveryRobotResponse, _Mapping]] = ...) -> None: ...

class NodeEvent(_message.Message):
    __slots__ = ("pkg_arrival_event", "elevator_status_event", "delivery_status_event")
    PKG_ARRIVAL_EVENT_FIELD_NUMBER: _ClassVar[int]
    ELEVATOR_STATUS_EVENT_FIELD_NUMBER: _ClassVar[int]
    DELIVERY_STATUS_EVENT_FIELD_NUMBER: _ClassVar[int]
    pkg_arrival_event: PkgArrivalEvent
    elevator_status_event: ElevatorStatusEvent
    delivery_status_event: DeliveryStatusEvent
    def __init__(self, pkg_arrival_event: _Optional[_Union[PkgArrivalEvent, _Mapping]] = ..., elevator_status_event: _Optional[_Union[ElevatorStatusEvent, _Mapping]] = ..., delivery_status_event: _Optional[_Union[DeliveryStatusEvent, _Mapping]] = ...) -> None: ...

class AckStatus(_message.Message):
    __slots__ = ("status_code", "message")
    class StatusCode(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
        __slots__ = ()
        UNSPECIFIED: _ClassVar[AckStatus.StatusCode]
        ACK_RECEIVED: _ClassVar[AckStatus.StatusCode]
        ACK_INVALID: _ClassVar[AckStatus.StatusCode]
    UNSPECIFIED: AckStatus.StatusCode
    ACK_RECEIVED: AckStatus.StatusCode
    ACK_INVALID: AckStatus.StatusCode
    STATUS_CODE_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_FIELD_NUMBER: _ClassVar[int]
    status_code: AckStatus.StatusCode
    message: str
    def __init__(self, status_code: _Optional[_Union[AckStatus.StatusCode, str]] = ..., message: _Optional[str] = ...) -> None: ...

class ExecutionStatus(_message.Message):
    __slots__ = ("status_code", "message")
    class StatusCode(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
        __slots__ = ()
        UNSPECIFIED: _ClassVar[ExecutionStatus.StatusCode]
        SUCCESS: _ClassVar[ExecutionStatus.StatusCode]
        FAILED: _ClassVar[ExecutionStatus.StatusCode]
    UNSPECIFIED: ExecutionStatus.StatusCode
    SUCCESS: ExecutionStatus.StatusCode
    FAILED: ExecutionStatus.StatusCode
    STATUS_CODE_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_FIELD_NUMBER: _ClassVar[int]
    status_code: ExecutionStatus.StatusCode
    message: str
    def __init__(self, status_code: _Optional[_Union[ExecutionStatus.StatusCode, str]] = ..., message: _Optional[str] = ...) -> None: ...

class ClientRegisterRequest(_message.Message):
    __slots__ = ("identity_type", "identity_id", "identity_name")
    IDENTITY_TYPE_FIELD_NUMBER: _ClassVar[int]
    IDENTITY_ID_FIELD_NUMBER: _ClassVar[int]
    IDENTITY_NAME_FIELD_NUMBER: _ClassVar[int]
    identity_type: NodeType
    identity_id: int
    identity_name: str
    def __init__(self, identity_type: _Optional[_Union[NodeType, str]] = ..., identity_id: _Optional[int] = ..., identity_name: _Optional[str] = ...) -> None: ...

class ClientRegisterResponse(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class GetPkgInfosRequest(_message.Message):
    __slots__ = ("user_id",)
    USER_ID_FIELD_NUMBER: _ClassVar[int]
    user_id: int
    def __init__(self, user_id: _Optional[int] = ...) -> None: ...

class GetPkgInfoResponse(_message.Message):
    __slots__ = ("pkgs",)
    PKGS_FIELD_NUMBER: _ClassVar[int]
    pkgs: _containers.RepeatedCompositeFieldContainer[Pkg]
    def __init__(self, pkgs: _Optional[_Iterable[_Union[Pkg, _Mapping]]] = ...) -> None: ...

class MoveDeliveryRobotRequest(_message.Message):
    __slots__ = ("delivery_robot_id", "destination_address")
    DELIVERY_ROBOT_ID_FIELD_NUMBER: _ClassVar[int]
    DESTINATION_ADDRESS_FIELD_NUMBER: _ClassVar[int]
    delivery_robot_id: int
    destination_address: AptAddress
    def __init__(self, delivery_robot_id: _Optional[int] = ..., destination_address: _Optional[_Union[AptAddress, _Mapping]] = ...) -> None: ...

class MoveDeliveryRobotResponse(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class SetElevatorStatusRequest(_message.Message):
    __slots__ = ("elevator_id", "elevator_status")
    ELEVATOR_ID_FIELD_NUMBER: _ClassVar[int]
    ELEVATOR_STATUS_FIELD_NUMBER: _ClassVar[int]
    elevator_id: int
    elevator_status: Elevator.Status
    def __init__(self, elevator_id: _Optional[int] = ..., elevator_status: _Optional[_Union[Elevator.Status, _Mapping]] = ...) -> None: ...

class SetElevatorStatusResponse(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class PkgArrivalEvent(_message.Message):
    __slots__ = ("address",)
    ADDRESS_FIELD_NUMBER: _ClassVar[int]
    address: AptAddress
    def __init__(self, address: _Optional[_Union[AptAddress, _Mapping]] = ...) -> None: ...

class ElevatorStatusEvent(_message.Message):
    __slots__ = ("elevator_id", "elevator_status")
    ELEVATOR_ID_FIELD_NUMBER: _ClassVar[int]
    ELEVATOR_STATUS_FIELD_NUMBER: _ClassVar[int]
    elevator_id: int
    elevator_status: Elevator.Status
    def __init__(self, elevator_id: _Optional[int] = ..., elevator_status: _Optional[_Union[Elevator.Status, _Mapping]] = ...) -> None: ...

class DeliveryStatusEvent(_message.Message):
    __slots__ = ("delivery_robot_id", "delivery_status")
    DELIVERY_ROBOT_ID_FIELD_NUMBER: _ClassVar[int]
    DELIVERY_STATUS_FIELD_NUMBER: _ClassVar[int]
    delivery_robot_id: int
    delivery_status: DeliveryRobot.DeliveryStatus
    def __init__(self, delivery_robot_id: _Optional[int] = ..., delivery_status: _Optional[_Union[DeliveryRobot.DeliveryStatus, str]] = ...) -> None: ...

class Elevator(_message.Message):
    __slots__ = ("id", "status")
    class DoorOpenStatus(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
        __slots__ = ()
        UNSPECIFIED: _ClassVar[Elevator.DoorOpenStatus]
        CLOSED: _ClassVar[Elevator.DoorOpenStatus]
        OPEN: _ClassVar[Elevator.DoorOpenStatus]
    UNSPECIFIED: Elevator.DoorOpenStatus
    CLOSED: Elevator.DoorOpenStatus
    OPEN: Elevator.DoorOpenStatus
    class Status(_message.Message):
        __slots__ = ("current_floor", "door_open_status")
        CURRENT_FLOOR_FIELD_NUMBER: _ClassVar[int]
        DOOR_OPEN_STATUS_FIELD_NUMBER: _ClassVar[int]
        current_floor: int
        door_open_status: Elevator.DoorOpenStatus
        def __init__(self, current_floor: _Optional[int] = ..., door_open_status: _Optional[_Union[Elevator.DoorOpenStatus, str]] = ...) -> None: ...
    ID_FIELD_NUMBER: _ClassVar[int]
    STATUS_FIELD_NUMBER: _ClassVar[int]
    id: int
    status: Elevator.Status
    def __init__(self, id: _Optional[int] = ..., status: _Optional[_Union[Elevator.Status, _Mapping]] = ...) -> None: ...

class DeliveryRobot(_message.Message):
    __slots__ = ("id", "delivery_status")
    class DeliveryStatus(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
        __slots__ = ()
        UNSPECIFIED: _ClassVar[DeliveryRobot.DeliveryStatus]
        PENDING: _ClassVar[DeliveryRobot.DeliveryStatus]
        IN_TRANSIT: _ClassVar[DeliveryRobot.DeliveryStatus]
        DELIVERED: _ClassVar[DeliveryRobot.DeliveryStatus]
    UNSPECIFIED: DeliveryRobot.DeliveryStatus
    PENDING: DeliveryRobot.DeliveryStatus
    IN_TRANSIT: DeliveryRobot.DeliveryStatus
    DELIVERED: DeliveryRobot.DeliveryStatus
    ID_FIELD_NUMBER: _ClassVar[int]
    DELIVERY_STATUS_FIELD_NUMBER: _ClassVar[int]
    id: int
    delivery_status: DeliveryRobot.DeliveryStatus
    def __init__(self, id: _Optional[int] = ..., delivery_status: _Optional[_Union[DeliveryRobot.DeliveryStatus, str]] = ...) -> None: ...

class PkgRoom(_message.Message):
    __slots__ = ("id", "lockers")
    class Locker(_message.Message):
        __slots__ = ("locker_id", "access_code", "pkg_id")
        LOCKER_ID_FIELD_NUMBER: _ClassVar[int]
        ACCESS_CODE_FIELD_NUMBER: _ClassVar[int]
        PKG_ID_FIELD_NUMBER: _ClassVar[int]
        locker_id: int
        access_code: str
        pkg_id: int
        def __init__(self, locker_id: _Optional[int] = ..., access_code: _Optional[str] = ..., pkg_id: _Optional[int] = ...) -> None: ...
    ID_FIELD_NUMBER: _ClassVar[int]
    LOCKERS_FIELD_NUMBER: _ClassVar[int]
    id: int
    lockers: _containers.RepeatedCompositeFieldContainer[PkgRoom.Locker]
    def __init__(self, id: _Optional[int] = ..., lockers: _Optional[_Iterable[_Union[PkgRoom.Locker, _Mapping]]] = ...) -> None: ...

class User(_message.Message):
    __slots__ = ("id", "address")
    ID_FIELD_NUMBER: _ClassVar[int]
    ADDRESS_FIELD_NUMBER: _ClassVar[int]
    id: int
    address: AptAddress
    def __init__(self, id: _Optional[int] = ..., address: _Optional[_Union[AptAddress, _Mapping]] = ...) -> None: ...

class Pkg(_message.Message):
    __slots__ = ("id", "address", "sender_id", "receiver_id", "photo_bytes")
    ID_FIELD_NUMBER: _ClassVar[int]
    ADDRESS_FIELD_NUMBER: _ClassVar[int]
    SENDER_ID_FIELD_NUMBER: _ClassVar[int]
    RECEIVER_ID_FIELD_NUMBER: _ClassVar[int]
    PHOTO_BYTES_FIELD_NUMBER: _ClassVar[int]
    id: int
    address: AptAddress
    sender_id: int
    receiver_id: int
    photo_bytes: bytes
    def __init__(self, id: _Optional[int] = ..., address: _Optional[_Union[AptAddress, _Mapping]] = ..., sender_id: _Optional[int] = ..., receiver_id: _Optional[int] = ..., photo_bytes: _Optional[bytes] = ...) -> None: ...

class AptAddress(_message.Message):
    __slots__ = ("apt_complex", "building_num", "unit_num")
    APT_COMPLEX_FIELD_NUMBER: _ClassVar[int]
    BUILDING_NUM_FIELD_NUMBER: _ClassVar[int]
    UNIT_NUM_FIELD_NUMBER: _ClassVar[int]
    apt_complex: str
    building_num: int
    unit_num: int
    def __init__(self, apt_complex: _Optional[str] = ..., building_num: _Optional[int] = ..., unit_num: _Optional[int] = ...) -> None: ...
