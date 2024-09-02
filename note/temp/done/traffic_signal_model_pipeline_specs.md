# Traffic Signal Model Pipline Specifications

## YOLO11 Detection Model Specifications

### Model Comparisons (COCO Dataset)

| Model   | Size (pixels) | $mAP^{val}_{50-95}$ | Speed (CPU ONNX, ms) | Speed (T4 TensorRT10, ms) | Params (M) | FLOPs (B) |
|---------|---------------|---------------------|----------------------|--------------------------|------------|-----------|
| YOLO11n | 640           | 39.5                | 56.1 ± 0.8           | 1.5 ± 0.0                | 2.6        | 6.5       |
| YOLO11s | 640           | 47.0                | 90.0 ± 1.2           | 2.5 ± 0.0                | 9.4        | 21.5      |
| YOLO11m | 640           | 51.5                | 183.2 ± 2.0          | 4.7 ± 0.1                | 20.1       | 68.0      |
| YOLO11l | 640           | 53.4                | 238.6 ± 1.4          | 6.2 ± 0.1                | 25.3       | 86.9      |
| YOLO11x | 640           | 54.7                | 462.8 ± 6.7          | 11.3 ± 0.2               | 56.9       | 194.9     |

#### YOLO11 Detection Notes

- **$mAP^{val}$ values** are for single-model single-scale on the [COCO val2017 dataset](https://cocodataset.org/##home).
- **Speed** values are averaged over COCO val images using an Amazon EC2 P4d instance.
  - CPU results are based on the ONNX runtime.
  - GPU results are based on TensorRT10 with an NVIDIA T4 GPU.

#### Example Commands

- To reproduce $mAP^{val}$ results:

  ```bash
  yolo val detect data=coco.yaml device=0


## EfficientGCN Model Comparisons

### Overview

The table below compares the EfficientGCN models (B0, B2, B4) with state-of-the-art methods on the X-sub benchmark in terms of accuracy (%), FLOPs ($\times 10^9$), and parameter count ($\times 10^6$). The models are directly compared with EfficientGCN-B0, B2, and B4, respectively.

### EfficientGCN-B0

| Model           | Accuracy (%) | FLOPs ($\times 10^9$) | Ratio   | ## Params ($\times 10^6$) | Ratio   |
|-----------------|--------------|-----------------------|---------|--------------------------|---------|
| **EfficientGCN-B0** | 90.2         | 2.73                 | 1x      | 0.29                     | 1x      |
| ST-GCN [11]     | 81.5         | 16.32*                | 5.98×   | 3.01*                    | 10.69×  |
| SR-TSL [42]     | 84.8         | 4.20*                 | 1.54×   | 19.07                    | 65.76×  |
| RA-GCNv1 [14]   | 85.2         | 32.80*                | 12.02×  | 6.21                     | 21.41×  |
| RA-GCNv2 [31]   | 87.3         | 32.80*                | 12.02×  | 6.21                     | 21.41×  |
| AS-GCN [48]     | 86.8         | 30.09*                | 11.02×  | 5.19                     | 17.91×  |
| 2s-AGCN [13]    | 88.5         | 37.32*                | 13.67×  | 6.94*                    | 23.93×  |
| SGN [36]        | 89.0         | –                     | –       | 0.69                     | 2.39×   |
| AGC-LSTM [41]   | 89.2         | 22.98*                | 8.42×   | 22.98*                   | 78.93×  |
| DGNN [16]       | 89.9         | 41.76*                | 15.30×  | 3.61                     | 12.39×  |
| NAS-GCN [50]    | 89.4         | –                     | –       | 2.07                     | 7.06×   |
| PL-GCN [49]     | 89.7         | –                     | –       | 20.77                    | 71.38×  |

### EfficientGCN-B2

| Model              | Accuracy (%) | FLOPs ($\times 10^9$) | Ratio   | ## Params ($\times 10^6$) | Ratio   |
|--------------------|--------------|-----------------------|---------|--------------------------|---------|
| **EfficientGCN-B2**| 91.4         | 4.05                 | 1x      | 0.75                     | 1x      |
| 4s-Shift-GCN [51]  | 90.7         | 10.06*                | 2.47×   | 4.76*                    | 5.41×   |
| DC-GCN+ADG [32]    | 91.0         | 25.77*                | 6.35×   | 4.96*                    | 5.63×   |
| PA-ResGCN-B19 [27] | 91.3         | 18.52*                | 4.57×   | 6.47*                    | 7.14×   |

### EfficientGCN-B4

| Model             | Accuracy (%) | FLOPs ($\times 10^9$) | Ratio   | ## Params ($\times 10^6$) | Ratio   |
|-------------------|--------------|-----------------------|---------|--------------------------|---------|
| **EfficientGCN-B4**| 92.1         | 8.36                 | 1x      | 1.43                     | 1x      |
| MS-G3D [18]       | 92.1         | 48.88*                | 5.85×   | 14.0                     | 5.82×   |
| Dynamic-GCN [34]  | 91.5         | –                     | –       | 10.2                     | 4.24×   |
| MST-GCN [19]      | 91.5         | –                     | –       | 12.0                     | 10.91×  |

| **EfficientGCN-B2**| 91.4         | 4.05                 | 1x      | 0.75                     | 1x      |
| **EfficientGCN-B0** | 90.2         | 2.73                 | 1x      | 0.29                     | 1x      |
| **EfficientGCN-B4**| 92.1         | 8.36                 | 1x      | 1.43                     | 1x      |

| Model   | Size (pixels) | $mAP^{val}_{50-95}$ | Speed (CPU ONNX, ms) | Speed (T4 TensorRT10, ms) | Params (M) | FLOPs (B) |
|---------|---------------|---------------------|----------------------|--------------------------|------------|-----------|
| YOLO11n | 640           | 39.5                | 56.1 ± 0.8           | 1.5 ± 0.0                | 2.6        | 6.5       |
| YOLO11s | 640           | 47.0                | 90.0 ± 1.2           | 2.5 ± 0.0                | 9.4        | 21.5      |
| YOLO11m | 640           | 51.5                | 183.2 ± 2.0          | 4.7 ± 0.1                | 20.1       | 68.0      |
| YOLO11l | 640           | 53.4                | 238.6 ± 1.4          | 6.2 ± 0.1                | 25.3       | 86.9      |
| YOLO11x | 640           | 54.7                | 462.8 ± 6.7          | 11.3 ± 0.2               | 56.9       | 194.9     |

## Assume that (Mediapipe pose + hand landmark) requires 1 GFLOPS

## FLOPS Calculation for TurtleBot 3 LiDAR Module (HLS-LFCD-LDS), Intel RealSense D435, and CAN Communication

### Components Overview

- **HLS-LFCD-LDS (2D LiDAR)**: This is the default LiDAR module used in **TurtleBot 3**. It is a 2D LiDAR sensor that provides 360-degree scanning capabilities for obstacle detection and environment mapping.
- **Intel RealSense D435**: A depth camera providing depth maps for object detection and environment modeling.
- **CAN Communication and Vehicle Control Algorithms**: This includes basic vehicle control such as speed and direction control using CAN communication, as well as basic path planning and obstacle avoidance.

### FLOPS Requirements for Each Component (1 FPS Basis)

1. **HLS-LFCD-LDS (2D LiDAR)**: 1-3 GFLOPS
2. **Intel RealSense D435 (Depth Map Generation Only)**: 1-5 GFLOPS
3. **CAN Communication and Vehicle Control Algorithms**: 4-8 GFLOPS

#### Total FLOPS Calculation

The total maximum FLOPS needed when all components are operating simultaneously is:

- $\text{Total FLOPS} = (\text{LiDAR}) + (\text{D435}) + (\text{CAN Communication and Vehicle Control})$

  $= 3 \text{ GFLOPS} + 5 \text{ GFLOPS} + 8 \text{ GFLOPS}$

  $= 16 \text{ GFLOPS}$
