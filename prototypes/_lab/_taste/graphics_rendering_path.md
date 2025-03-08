# Graphics Rendering Path Differences: Platform Plugins (EGLFS, LinuxFB) vs. Windowing Systems and Display Servers (X11, Wayland)

📅 Written at 2025-01-05 11:30:17

## Rendering Path Differences Table

| Layer                        | EGLFS                               | LinuxFB                   | X11                             | Wayland                             |
| ---------------------------- | ----------------------------------- | ------------------------- | ------------------------------- | ----------------------------------- |
| 1) Application Layer         | OpenGL/OpenGL ES/Vulkan             | OpenGL/Software Rendering | OpenGL/OpenGL ES/Vulkan         | OpenGL/OpenGL ES/Vulkan             |
| 2) Graphics Management Layer | -                                   | -                         | -                               | -                                   |
| 2a) Rendering Context        | EGL (OpenGL/OpenGL ES)              | N/A                       | GLX                             | EGL (OpenGL/OpenGL ES)              |
| 2b) Surface Creation         | EGL Surface                         | Framebuffer Surface       | GLX Pixmap                      | EGL Surface                         |
| 2c) Command Submission       | OpenGL/OpenGL ES Commands (via EGL) | CPU-Based Commands        | OpenGL Commands (via GLX)       | OpenGL/OpenGL ES Commands (via EGL) |
| 3) GPU Driver Layer          | -                                   | -                         | -                               | -                                   |
| 3a) Driver Processing        | GPU Driver                          | CPU Processing            | GPU Driver                      | GPU Driver                          |
| 3b) Rendering Execution      | GPU Hardware                        | CPU (Software Rendering)  | GPU Hardware                    | GPU Hardware                        |
| 3c) Framebuffer Write        | GPU Framebuffer Write               | CPU Framebuffer Write     | GPU Framebuffer Write           | GPU Framebuffer Write               |
| 4) Display Management Layer  | -                                   | -                         | -                               | -                                   |
| 4a) Display Server           | N/A                                 | N/A                       | X Server                        | Wayland Compositor                  |
| 4b) Framebuffer Management   | GBM (GPU Buffer Management)         | LinuxFB                   | DRM-KMS (GPU Buffer Management) | GBM (GPU Buffer Management)         |
| 5) Output Layer              | -                                   | -                         | -                               | -                                   |
| 5a) Display Controller       | DRM/KMS                             | DRM/KMS                   | DRM/KMS                         | DRM/KMS                             |
| 5b) Display Device           | HDMI/LCD/VGA                        | HDMI/LCD/VGA              | HDMI/LCD/VGA                    | HDMI/LCD/VGA                        |

---

## Rendering Path Examples

### LinuxFB Rendering Path

```plaintext
Application → CPU → LinuxFB → DRM/KMS → Display
```

### EGLFS Rendering Path

```plaintext
Application → EGL → GPU → GBM → DRM/KMS → Display
```

### X11 Rendering Path

```plaintext
Application → GLX → X Server → GPU → X Server (Low Level: DRM/KMS) → DRM/KMS → Display
```

### Wayland Rendering Path

```plaintext
Application → EGL → Wayland Compositor → GPU → GBM → DRM/KMS → Display
```

---

## Explanation of Each Layer

### 1) Application Layer

**Purpose:**
Defines the application and the graphics API used for rendering commands.

🛍️ e.g.

- **OpenGL** (Open Graphics Library): A cross-platform graphics API used for rendering 2D and 3D vector graphics.
- **OpenGL ES** (OpenGL for Embedded Systems): A lightweight version of OpenGL, optimized for embedded systems and mobile devices.
- **Vulkan**: A low-overhead API providing high-performance access to GPU resources.
- **DirectX**: A collection of APIs for handling multimedia tasks on Windows platforms.

---

### 2) Graphics Management Layer

**Purpose:**
Manages the rendering context, surface creation, and submission of rendering commands.

#### 2a) Rendering Context

**Purpose:**
Creates the environment required for issuing graphics commands.

- **❔ What is Rendering?**

  Rendering is the process of generating images from models, textures, and shaders by executing graphical computations. It transforms data into a visual representation, often through APIs like OpenGL or Vulkan.

🛍️ e.g.

- **EGL (Embedded-System Graphics Library)**  
  Manages OpenGL and OpenGL ES contexts and surfaces, enabling rendering for embedded systems.
- **GLX (OpenGL Extension to X)**  
  Provides OpenGL context management for X11, acting as a bridge between OpenGL and the X Server.
- **Vulkan Instance**  
  Initializes Vulkan and establishes connections with the GPU for rendering.

---

#### 2b) Surface Creation

**Purpose:**
Allocates and manages surfaces for rendering graphics.

- **❔ What is a Surface?**

  A surface is a designated area in memory where rendering results are stored. It can represent a window on the screen (visible surface) or an off-screen buffer used for intermediate computations (off-screen rendering). Surfaces are essential for managing the output of rendering processes.

🛍️ e.g.

- **EGL Surface**  
  A drawable surface for OpenGL ES rendering, used for displaying or off-screen rendering.
- **GLX Pixmap**  
  A memory buffer for off-screen rendering in X11, typically used for rendering content that is not directly displayed.
- **Vulkan Swapchain**  
  Manages a queue of images presented sequentially to the display, facilitating double or triple buffering in Vulkan.

---

#### 2c) Command Submission

**Purpose:**
Sends rendering commands to the GPU or CPU for processing.

🛍️ e.g.

- **OpenGL Commands**: Instructions for rendering with OpenGL.
- **OpenGL ES Commands**: Lightweight rendering instructions optimized for embedded systems.
- **Vulkan Commands**: Explicit and low-level instructions for Vulkan rendering.
- **CPU-Based Commands**: Software-rendering instructions executed by the CPU.

---

### 3) GPU Driver Layer

**Purpose:**
Interacts with GPU hardware to process rendering commands and manage the framebuffer.

#### 3a) Driver Processing

**Purpose:**
Processes rendering commands from the application or graphics management layer.

🛍️ e.g.

- **NVIDIA Driver**: Optimized driver for NVIDIA GPUs.
- **AMD Driver**: Optimized driver for AMD GPUs.

---

#### 3b) Rendering Execution

**Purpose:**
Executes rendering tasks on the GPU hardware or CPU.

🛍️ e.g.

- **GPU Hardware**: Executes tasks using dedicated graphics hardware.
- **CPU Processing**: Handles rendering tasks in software when GPU is unavailable.

---

#### 3c) Framebuffer Write

**Purpose:**
Writes rendered content to a framebuffer for display output.

🛍️ e.g.

- **GPU Framebuffer**: GPU-managed memory where rendered data is written.
- **CPU Framebuffer**: Framebuffer where CPU-rendered data is written directly.

---

### 4) Display Management Layer

**Purpose:**
Manages composition and framebuffer content for the display.

#### 4a) Display Server

**Purpose:**
Composites rendered outputs from applications and manages display resources.

🛍️ e.g.

- **X Server**: Handles composition and resource management for X11.
- **Wayland Compositor**: Manages surfaces and display output for Wayland.

---

#### 4b) Framebuffer Management

**Purpose:**
Handles framebuffer allocation and management for display output.

🛍️ e.g.

- **GBM (Generic Buffer Management)**: Allocates and manages GPU buffers for rendering and display.
- **EGLFS (EGL Full-Screen)**: Direct GPU access to manage buffers.
- **LinuxFB (Linux Framebuffer)**: Manages CPU-rendered framebuffer devices.

---

### 5) Output Layer

**Purpose:**
Translates framebuffer content into signals for display devices.

#### 5a) Display Controller

**Purpose:**
Uses DRM/KMS to manage display hardware and drive the display device.

🛍️ e.g.

- **DRM (Direct Rendering Manager)**: Manages graphics rendering and buffer sharing.
- **KMS (Kernel Mode Setting)**: Configures display settings (resolution, refresh rate).

---

#### 5b) Display Device

**Purpose:**
The physical device that displays the rendered content.

🛍️ e.g.

- **HDMI**: Digital display interface for high-definition output.
- **LCD**: Liquid crystal display used in monitors and embedded devices.
- **VGA**: Analog display interface for older monitors.
