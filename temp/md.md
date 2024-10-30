https://www.mermaidchart.com/app/projects/638a6e76-1714-4b3d-93c1-a0fa3196a871/diagrams/658593b0-9340-48f1-8359-cab46641bed1/version/v0.1/edit

```
flowchart TD
    %% Declaration with styling
    
    subgraph "User Access Group"
        MobileApp["TCP Connector (Mobile App)"]:::user
        WebBrowser["Web Browser"]:::user
    end

    subgraph "Raspberry Pi Control Group"
        RaspberryPi["Raspberry Pi"]:::pi
        APM["Apache, MariaDB, PHP"]:::software
    end

    subgraph "Smart Trash Bin Unit"
      subgraph "External STM32 Control Group"
          ButtonModule["Button Module (Send Command)"]:::sensor
          BluetoothModuleExt["Bluetooth Module (External)"]:::software
      end
      subgraph "Internal STM32 Control Group"
        InternalSTM32["Internal STM32"]:::internal
        UltrasonicSensor["Ultrasonic Sensor (Load Measurement)"]:::sensor
        MotorControl["Motor Control Module"]:::actuator
        SubMotorControl["Sub Motor Control (Lid Open/Close)"]:::actuator
        LCD["LCD Display (Show Load Data)"]:::display
        BluetoothModuleInt["Bluetooth Module (Internal)"]:::software
        WiFiModule["WiFi Module"]:::software
      end
    end

    %% Processes
    ButtonModule -->|"Button Press (Send Command)"| BluetoothModuleExt:::command
    BluetoothModuleExt -->|"Transmit Command (via Bluetooth)"| RaspberryPi:::command
    RaspberryPi -->|"Forward Command to Internal STM32"| BluetoothModuleInt:::data
    BluetoothModuleInt -->|"Receive Command"| InternalSTM32:::data

    InternalSTM32 -->|"Load Level Measurement"| UltrasonicSensor:::sensor
    UltrasonicSensor -->|"Load Data"| InternalSTM32:::data
    InternalSTM32 -->|"Show Load Data"| LCD:::display
    InternalSTM32 -->|"Send Load Data"| WiFiModule:::data
    WiFiModule -->|"Send Load Data"| RaspberryPi:::data

    InternalSTM32 -->|"Lid Open/Close"| SubMotorControl:::command

    RaspberryPi -->|"Log Load Data and Commands"| APM:::log
    WebBrowser -->|"Access Logs and Statistics"| APM:::log

    %% Garbage Bag Sealing Command Group
    MobileApp -. "Garbage Bag Sealing Command" .-> APM
    APM -. "Garbage Bag Sealing Command" .-> RaspberryPi
    RaspberryPi -. "Garbage Bag Sealing Command" .-> InternalSTM32
    InternalSTM32 -->|"Garbage Bag Sealing Command"| MotorControl:::command

    %% Node and Edge Styling
    classDef external fill:#B3D9FF,stroke:#1C6EA4,stroke-width:2px;
    classDef internal fill:#C3FDB8,stroke:#4CAF50,stroke-width:2px;
    classDef pi fill:#FFE4B5,stroke:#FF8C00,stroke-width:2px;
    classDef user fill:#FFD1DC,stroke:#FF69B4,stroke-width:2px;
    classDef sensor fill:#F0E68C,stroke:#DAA520,stroke-width:1.5px;
    classDef actuator fill:#D8BFD8,stroke:#9932CC,stroke-width:1.5px;
    classDef software fill:#E0FFFF,stroke:#20B2AA,stroke-width:2px;
    classDef command stroke-dasharray: 5 5,stroke:#000,stroke-width:2px;
    classDef data stroke:#4682B4,stroke-width:2px;
    classDef log fill:#FFFACD,stroke:#FFD700,stroke-width:2px;
    classDef display fill:#E6E6FA,stroke:#8A2BE2,stroke-width:2px;

```