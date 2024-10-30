# Smart Trash Bin Database Design

This document outlines the design of the MariaDB database for managing Smart Trash Bin Units, their communication, and logging of operations. The design includes an alias system for easier identification of device pairs (external and internal STM32).

---

## Database Tables

### 1. `Devices` Table
The `Devices` table stores the mapping between external and internal STM32 devices, along with a unique alias for easier identification.

| **Column Name**  | **Type**         | **Constraints**         | **Description**                        |
|-------------------|------------------|--------------------------|----------------------------------------|
| `id`             | INT             | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for the device pair.  |
| `alias`          | VARCHAR(100)    | UNIQUE, NOT NULL         | Alias for the device pair (e.g., "Trash Bin 1"). |
| `external_mac`   | VARCHAR(50)     | UNIQUE, NOT NULL         | MAC address of the external STM32.      |
| `internal_mac`   | VARCHAR(50)     | UNIQUE, NOT NULL         | MAC address of the internal STM32.      |

---

### 2. `Commands` Table
The `Commands` table records communication messages between devices, specifying the source and target MAC addresses and the command status.

| **Column Name**  | **Type**         | **Constraints**         | **Description**                        |
|-------------------|------------------|--------------------------|----------------------------------------|
| `id`             | INT             | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for the command.      |
| `device_alias`   | VARCHAR(100)    | FOREIGN KEY REFERENCES `Devices`(`alias`) | Alias of the device pair involved in the command. |
| `source_mac`     | VARCHAR(50)     | NOT NULL                 | MAC address of the command sender.      |
| `target_mac`     | VARCHAR(50)     | NOT NULL                 | MAC address of the command receiver.    |
| `command_type`   | ENUM            | `OPEN`, `CLOSE`          | Type of command being sent.             |
| `status`         | ENUM            | `SENT`, `ACK_RECEIVED`, `COMPLETED` | Current status of the command.          |
| `timestamp`      | DATETIME        | NOT NULL                 | Timestamp of when the command was created. |

---

### 3. `Logs` Table
The `Logs` table records all events, including communication between devices and operational data like trash fill level.

| **Column Name**  | **Type**         | **Constraints**         | **Description**                        |
|-------------------|------------------|--------------------------|----------------------------------------|
| `id`             | INT             | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for the log entry.    |
| `device_alias`   | VARCHAR(100)    | FOREIGN KEY REFERENCES `Devices`(`alias`) | Alias of the device pair involved in the log. |
| `source_mac`     | VARCHAR(50)     | NOT NULL                 | MAC address of the log sender.          |
| `target_mac`     | VARCHAR(50)     | NOT NULL                 | MAC address of the log receiver.        |
| `event_type`     | ENUM            | `OPEN`, `CLOSE`, `FILL_LEVEL` | Type of event being logged.             |
| `timestamp`      | DATETIME        | NOT NULL                 | Timestamp of the logged event.          |
| `details`        | TEXT            | NULLABLE                 | Additional details (e.g., trash fill level). |

---

## Example Data

### `Devices` Table
| `id` | `alias`       | `external_mac`      | `internal_mac`      |
|------|---------------|---------------------|---------------------|
| 1    | Trash Bin 1   | AA:BB:CC:DD:EE:01   | FF:GG:HH:II:JJ:01   |
| 2    | Trash Bin 2   | AA:BB:CC:DD:EE:02   | FF:GG:HH:II:JJ:02   |

---

### `Commands` Table
| `id` | `device_alias` | `source_mac`       | `target_mac`       | `command_type` | `status`       | `timestamp`           |
|------|----------------|--------------------|--------------------|----------------|----------------|-----------------------|
| 1    | Trash Bin 1    | AA:BB:CC:DD:EE:01  | FF:GG:HH:II:JJ:01  | OPEN           | SENT           | 2024-11-25 10:00:00   |
| 2    | Trash Bin 1    | AA:BB:CC:DD:EE:01  | FF:GG:HH:II:JJ:01  | OPEN           | ACK_RECEIVED   | 2024-11-25 10:00:01   |

---

### `Logs` Table
| `id` | `device_alias` | `source_mac`       | `target_mac`       | `event_type`   | `timestamp`           | `details`            |
|------|----------------|--------------------|--------------------|----------------|-----------------------|----------------------|
| 1    | Trash Bin 1    | AA:BB:CC:DD:EE:01  | FF:GG:HH:II:JJ:01  | OPEN           | 2024-11-25 10:00:00   | Command sent.        |
| 2    | Trash Bin 1    | FF:GG:HH:II:JJ:01  | Raspberry Pi MAC   | FILL_LEVEL     | 2024-11-25 10:04:00   | Fill level: 70%.     |

---

## Benefits of the Design
1. **Alias-Based Identification**: 
   - The `alias` field in the `Devices` table allows for easier identification and management of device pairs, without relying solely on MAC addresses.

2. **Traceability**:
   - Logs and commands explicitly record both the sender (`source_mac`) and receiver (`target_mac`) MAC addresses, ensuring traceability of all communication.

3. **Scalability**:
   - New Smart Trash Bin Units can be added seamlessly by creating new entries in the `Devices` table and linking them to the `Commands` and `Logs` tables.

4. **Flexibility**:
   - The use of aliases and detailed logging makes it easier to manage and debug multi-device systems.

---

This design ensures robust management of Smart Trash Bin Units and facilitates efficient communication and logging.
