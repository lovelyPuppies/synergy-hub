# Embedded Systems Architecture in MSA (Microservice Architecture)

📅 Written at 2024-10-11 21:09:14

## 🛍️ e.g. Directory Structure and Patterns (Including CQRS, DDD)

```plaintext
📦 ProjectRoot
├── 📁 external/ (External Submodules)
├── 📁 include/ (Shared Header Files - Global and Module-specific)
│   ├── system_config.hpp
│   ├── device_config.hpp
│   ├── Clock/
│   │   ├── clock.hpp
│   │   └── clock_utils.hpp
│   ├── Stopwatch/
│   │   ├── stopwatch.hpp
│   │   └── stopwatch_utils.hpp
│   └── Timer/
│       ├── timer.hpp
│       └── timer_utils.hpp
├── 📁 src/ (Source Code Files - Implementations)
│   ├── main.cpp
│   ├── Clock/
│   │   ├── clock.cpp
│   │   └── clock_utils.cpp
│   ├── Stopwatch/
│   │   ├── stopwatch.cpp
│   │   └── stopwatch_utils.cpp
│   └── Timer/
│       ├── timer.cpp
│       └── timer_utils.cpp
├── 📁 lib/ (Project-Specific Libraries)
│   ├── ⚙️ peripherals/ (Peripheral Drivers - Low-Level Implementation)
│   │   ├── gpio/
│   │   │   ├── gpio_driver.hpp
│   │   │   └── gpio_driver.cpp
│   │   ├── pwm/
│   │   │   ├── pwm_driver.hpp
│   │   │   └── pwm_driver.cpp
│   │   └── uart/
│   │       ├── uart_driver.hpp
│   │       └── uart_driver.cpp
│   ├── 🧩 drivers/ (Device-Specific Drivers)
│   │   ├── motor_driver/
│   │   │   ├── motor_driver.hpp
│   │   │   └── motor_driver.cpp
│   │   ├── display_driver/
│   │   │   ├── display_driver.hpp
│   │   │   └── display_driver.cpp
│   │   └── sensor_driver/
│   │       ├── sensor_driver.hpp
│   │       └── sensor_driver.cpp
│   └── 🏗️ modules/ (Domain Modules - Domain-Driven Design & CQRS)
│       ├── clock/
│       │   ├── clock_controller.hpp
│       │   ├── clock_controller.cpp
│       │   ├── clock_service.hpp
│       │   └── clock_service.cpp
│       ├── stopwatch/
│       │   ├── stopwatch_controller.hpp
│       │   ├── stopwatch_controller.cpp
│       │   ├── stopwatch_service.hpp
│       │   └── stopwatch_service.cpp
│       └── timer/
│           ├── timer_controller.hpp
│           ├── timer_controller.cpp
│           ├── timer_service.hpp
│           └── timer_service.cpp
├── 📁 app/ (Application Logic - Model-View-Presenter)
│   ├── ClockApp/ (Clock Micro-App)
│   │   ├── clock_presenter.hpp
│   │   ├── clock_presenter.cpp
│   │   ├── clock_view.hpp
│   │   └── clock_view.cpp
│   ├── StopwatchApp/ (Stopwatch Micro-App)
│   │   ├── stopwatch_presenter.hpp
│   │   ├── stopwatch_presenter.cpp
│   │   ├── stopwatch_view.hpp
│   │   └── stopwatch_view.cpp
│   └── TimerApp/ (Timer Micro-App)
│       ├── timer_presenter.hpp
│       ├── timer_presenter.cpp
│       ├── timer_view.hpp
│       └── timer_view.cpp
├── 📝 config/ (Configuration Files - System & Device Specific)
│   ├── system_config.hpp
│   └── device_config.hpp
├── 🧪 test/ (Testing and Debugging)
│   ├── unit/
│   │   ├── clock_test.cpp
│   │   ├── stopwatch_test.cpp
│   │   └── timer_test.cpp
│   └── integration/
│       ├── system_integration_test.cpp
│       └── hardware_integration_test.cpp
├── platformio.ini (PlatformIO Project Configuration)
└── README.md

```

## Patterns Overview

1. **⚙️ Peripherals (Low-Level Implementation)**

   - **Implementation Principle**: **Bare-Metal Programming**
   - **Description**: Directly interfacing with hardware peripherals, using low-level register manipulation suitable for microcontrollers.
   - **Not a Pattern**: This is not a software design pattern but an approach for programming in resource-constrained environments.

2. **🧩 Drivers (Device-Specific Drivers)**

   - **Pattern**: **Adapter Pattern**
   - **Description**: Transforms hardware-specific functions into a consistent interface that the application modules can use. Helps keep modules independent of hardware changes.

3. **🏗️ Modules (Domain Modules - DDD & CQRS)**

   - **Pattern**: **Domain-Driven Design (DDD)** & **Command Query Responsibility Segregation (CQRS)**
   - **Description**:
     - **DDD**: Organizes the system based on the core domains and subdomains (Bounded Contexts) of the application. For embedded systems, this helps maintain clear separation and control over different functional parts, like timers, displays, and motors.
     - **CQRS**: Separates commands (actions that change state) and queries (actions that retrieve data) for each module, ensuring clear and efficient handling of tasks.
   - **Example**:
     - **Clock Module**: CQRS separates time updates (commands) from time display (queries).
     - **Stopwatch Module**: Starts/stops/reset commands are distinct from queries retrieving elapsed time.

4. **🏢 Application Logic (Layered Architecture)**

   - **Pattern**: **Layered Architecture Pattern**
   - **Description**: This pattern organizes the codebase into distinct layers, such as low-level peripherals, hardware drivers, and application logic. Each layer has its own responsibility and interacts only with the layers directly below or above it, ensuring modularity and clear separation of concerns.
   - **Application**: In the `lib/` folder, components are organized based on their function:
     - **Peripherals**: Low-level access to hardware.
     - **Drivers**: Abstraction layer converting hardware access into usable modules.
     - **Application Modules**: High-level logic that uses drivers to achieve the intended functionality.

5. **📱 Application Logic (Model-View-Presenter - MVP)**

   - **Pattern**: **Model-View-Presenter (MVP)**
   - **Description**: Separates application logic into models (data), views (UI elements like LED or LCD displays), and presenters (controllers managing interactions). MVP is common in embedded systems for decoupling UI interactions from logic, making the application easier to test and modify.
   - **Example**:
     - **ClockApp**: The presenter handles the time update and interacts with the clock view to update the display.
     - **TimerApp**: The presenter manages countdown events and updates the timer display when conditions are met.

6. **📝 Configurations**

   - **Pattern**: **Configuration Management**
   - **Description**: Centralizes system and device configurations to ensure flexibility when adapting to different hardware setups or system requirements. This practice is aligned with software architecture principles rather than specific design patterns.

7. **🧪 Testing (Unit and Integration Testing)**
   - **Pattern**: **Test-Driven Development (TDD)** & **Behavior-Driven Development (BDD)**
   - **Description**:
     - **TDD**: Focuses on writing tests before implementation to drive the design and ensure correctness.
     - **BDD**: Extends TDD by defining behavior and requirements of each module in terms of its interactions.
   - **Example**: Unit tests for individual functions and integration tests for verifying the coordination between modules (e.g., Timer + Display).

## Full Application Patterns Overview

1. **Domain-Driven Design (DDD)**

   - **Usage**: In the modules, DDD helps maintain a clear separation between functional areas like timers, displays, and other hardware components. This makes it easier to update and manage specific areas without affecting the entire application.
   - **Application**: The clock, timer, and stopwatch modules each have their own bounded context, with their behavior and logic encapsulated.

2. **CQRS (Command Query Responsibility Segregation)**

   - **Usage**: CQRS is applied to separate read and write operations within each domain module, which helps optimize the interaction with sensors and displays without unnecessary overhead.
   - **Application**: In the stopwatch app, the "start," "pause," and "reset" commands are handled separately from queries retrieving time.

3. **Event-Driven Architecture (EDA)**

   - **Usage**: For modules that require real-time responses (e.g., sensor updates or timer countdowns), EDA ensures that events are processed efficiently.
   - **Implementation**: By utilizing interrupts (ISRs) in low-level code, this event-driven pattern reacts to hardware events like button presses.

4. **Layered Architecture Pattern**
   - **Usage**: This pattern is used to structure the codebase in distinct layers within the `lib/` directory. Each layer has its defined responsibilities, making it easier to maintain and extend the system.
   - **Application**: Ensures clear separation between hardware interaction, device abstraction, and application-level operations.

## Summary

This directory structure and pattern usage ensure that the project is modular, maintainable, and scalable. It leverages well-established patterns like **DDD**, **CQRS**, **MVP**, and **Layered Architecture** to organize application logic effectively while also using **EDA** and **TDD** for efficient event handling and testing.

By clearly segmenting each module and organizing the project with a focus on scalable architecture, the design ensures that both small-scale embedded systems (using MCUs) and more advanced systems (like Jetson Nano) can manage complexity while remaining adaptable to new hardware configurations.
