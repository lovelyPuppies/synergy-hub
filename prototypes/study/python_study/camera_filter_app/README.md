# Face Books

📅 Written at 2025-01-13 02:37:36

## 🚧 Prerequisite

- Download **[resource files](https://drive.google.com/file/d/1H4TsQumP04nv-h8B9Yzaibd0h4C2CMC7/view)** and locate in `camera_filter_app/rsrc` directory

## Showcase

- **[📑 PPT](https://docs.google.com/presentation/d/1GJQGkIuFstN4N1v1FjryqKZ_iLx4-1nZ/edit?usp=sharing&ouid=106474024514069876567&rtpof=true&sd=true)**
- **[📽️ Demo Video](https://drive.google.com/file/d/1CWQXUoqDJuuieDAonLfz1mzXtQSG5oGm/view?usp=sharing)**

## 📂 Directory Structure

tree camera_filter_app  
├── 📂 diagrams  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [1-use_case_diagram.md](diagrams/1-use_case_diagram.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [2-activity_diagram.md](diagrams/2-activity_diagram.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [3-sequence-diagram.md](diagrams/3-sequence-diagram.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [4-state_diagram.md](diagrams/4-state_diagram.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [5-class_diagram.md](diagrams/5-class_diagram.md)  
├── 📂 config  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [app_config.py](config/app_config.py)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [**init**.py](config/__init__.py)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [paths.py](config/paths.py)  
├── [filters.py](filters.py)  
├── [**init**.py](__init__.py)  
├── [sendver.py](sendver.py)  
└── 📂 tests  
&nbsp;&nbsp;&nbsp;&nbsp;├── [test_face_detection.ipynb](tests/test_face_detection.ipynb)  
&nbsp;&nbsp;&nbsp;&nbsp;└── [test_face_detection_with_camera.py](tests/test_face_detection_with_camera.py)

## diagrams

---

### Use Case diagram

```mermaid
graph TD
    %% Actors
    user["User"]

    %% System Boundary (Camera App)
    subgraph CameraAppSystem [Camera Application]
        StartCamera["Start Camera"]
        ApplyFilters["Apply Filters"]
        CaptureImage["Capture Image"]
        ZoomInOut["Zoom In/Out"]
        SwitchBackground["Switch Background"]
    end

    %% Relationships
    user --> StartCamera
    user --> ApplyFilters
    user --> CaptureImage
    user --> ZoomInOut
    user --> SwitchBackground

```

---

---

### Activity diagram

```mermaid
%% Activity Diagram for Camera Filter Application in Mermaid format

flowchart TD
    A[Start Application] --> B[Initialize Camera]
    B --> C{Camera Initialized?}
    C -- Yes --> D[Display Video Stream]
    C -- No --> E[Error: Cannot Start Camera]
    D --> F[User Applies Filter]

    %% Applying Filters
    F --> G{Filter Type?}
    G -- Blush --> H[Apply Blush Filter]
    G -- Sunglasses --> I[Apply Sunglasses Filter]
    G -- Rabbit Ears --> J[Apply Rabbit Ears Filter]
    G -- Background --> K[Change Background]

    H --> L[Update Display with Blush]
    I --> L[Update Display with Sunglasses]
    J --> L[Update Display with Rabbit Ears]
    K --> L[Update Display with New Background]

    %% Capture Image
    L --> M[User Captures Image]
    M --> N[Save Image to File]

    %% Ending the Process
    L --> O[Stop Camera]
    O --> P[Exit Application]
```

---

---

### Sequence diagram

```mermaid
sequenceDiagram
    participant User
    participant CameraApp
    participant Filters
    participant MediaPipe

    %% User starts the Camera App
    User->>CameraApp: Start Application
    CameraApp->>CameraApp: Initialize Camera

    alt Camera Initialized
        CameraApp-->>User: Display Video Stream
    else Camera Not Initialized
        CameraApp-->>User: Display Error Message
    end

    %% User applies a filter
    User->>CameraApp: Apply Filter (Blush/Sunglasses/Rabbit Ears)
    CameraApp->>MediaPipe: Process Face Mesh
    MediaPipe-->>CameraApp: Return Face Landmarks

    CameraApp->>Filters: Apply Selected Filter
    Filters-->>CameraApp: Filter Applied

    CameraApp-->>User: Update Video with Filter

    %% User captures an image
    User->>CameraApp: Capture Image
    CameraApp->>CameraApp: Save Image to File
    CameraApp-->>User: Image Saved

    %% User stops the camera
    User->>CameraApp: Stop Camera
    CameraApp->>CameraApp: Stop Camera Stream
    CameraApp-->>User: Camera Stopped

    User->>CameraApp: Exit Application
    CameraApp-->>User: Application Closed


```

---

---

### State diagram

```mermaid
stateDiagram
    %% Initial State
    [*] --> Idle

    %% Idle State
    Idle --> CameraActive : Start Camera
    CameraActive --> Idle : Stop Camera

    %% CameraActive State Transitions
    CameraActive --> ApplyingFilter : Apply Filter
    CameraActive --> CapturingImage : Capture Image
    CameraActive --> ErrorState : Camera Error

    %% Applying Filters
    ApplyingFilter --> CameraActive : Filter Applied

    %% Capturing Image
    CapturingImage --> CameraActive : Image Saved

    %% Error Handling
    ErrorState --> Idle : Resolve Error

    %% Final State
    Idle --> [*] : Exit Application

```

---

---

### Class diagram

```mermaid
classDiagram
    class CameraApp {
        -face_mesh mp_face_mesh
        -FaceMesh face_mesh
        -QTimer timer
        -QGraphicsView view
        -QGraphicsScene scene
        -bool start_stop_camera
        -float zoom_factor
        -dict filter_states
        -list background_images
        -str current_background
        -int current_background_index
        +void initUI()
        +void toggle_start_camera()
        +void zoom_in()
        +void zoom_out()
        +void toggle_filter(str)********
        +void cycle_background()
        +void update_frame()
        +cv2.Mat apply_face_filter(cv2.Mat)
        +void capture_image()
        +void mousePressEvent(QMouseEvent)
        +void mouseMoveEvent(QMouseEvent)
        +void mouseReleaseEvent(QMouseEvent)
    }

    CameraApp --> AppConfig : uses
    CameraApp --> AssetPaths : uses
    CameraApp --> add_blush : calls
    CameraApp --> apply_background_change : calls
    CameraApp --> overlay_rabbit_ears : calls
    CameraApp --> overlay_sunglasses : calls

    class AppConfig {
        <<imported>>
    }

    class AssetPaths {
        <<imported>>
        -str FACE_SUNGLASSES_PATH
        -str FACE_RABBIT_EARS_PATH
        -str BACKGROUND_SPACE_PATH
        -str BACKGROUND_OCEAN_PATH
        -str BACKGROUND_PHOTO_ZONE_PATH
    }

    class add_blush {
        <<function>>
        +void add_blush(cv2.Mat, landmarks)
    }

    class apply_background_change {
        <<function>>
        +cv2.Mat apply_background_change(cv2.Mat, landmarks, background_image)
    }

    class overlay_rabbit_ears {
        <<function>>
        +void overlay_rabbit_ears(cv2.Mat, landmarks)
    }

    class overlay_sunglasses {
        <<function>>
        +void overlay_sunglasses(cv2.Mat, landmarks)
    }

```

## Retrospective

- Unable to write better code due to the use of outdated APIs in the Mediapipe solutions library
