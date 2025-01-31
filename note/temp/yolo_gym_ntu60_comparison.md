# Comprehensive Overview of YOLO, GYM, NTU60, and COCO Keypoint-based Datasets

📅 Written at {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

This document provides a detailed comparison of keypoints (joints) in various datasets used for pose estimation: **YOLO**, **GYM [2D Skeleton]**, **NTU RGB+D 60**, **UCF101**, **HMDB51**, **Diving48**, and **Kinetics400**. The comparison includes the number of keypoints, the names of each keypoint, and their correspondence across datasets. Many of these datasets follow the **COCO Keypoints** format for human pose estimation.

## 1. COCO Keypoint-based Datasets

Several datasets use the **COCO Keypoints** format, which defines 17 major joints for human pose estimation. These datasets, including **YOLO**, **GYM**, **UCF101**, **HMDB51**, **Diving48**, and **Kinetics400**, are based on this format.

### COCO Keypoints:

| Keypoint Index | Keypoint Name  |
| -------------- | -------------- |
| 0              | Nose           |
| 1              | Left Eye       |
| 2              | Right Eye      |
| 3              | Left Ear       |
| 4              | Right Ear      |
| 5              | Left Shoulder  |
| 6              | Right Shoulder |
| 7              | Left Elbow     |
| 8              | Right Elbow    |
| 9              | Left Wrist     |
| 10             | Right Wrist    |
| 11             | Left Hip       |
| 12             | Right Hip      |
| 13             | Left Knee      |
| 14             | Right Knee     |
| 15             | Left Ankle     |
| 16             | Right Ankle    |

### Datasets using COCO Keypoints

The following datasets use the **COCO Keypoints** format, which defines 17 major joints for human pose estimation. The reference URLs provided confirm the use of COCO Keypoints format in these datasets.

## 1. YOLO Pose Dataset

- **COCO Keypoints**: 17 keypoints
- **Reference URL**:
  - [YOLO Model Documentation](https://github.com/ultralytics/yolov5/wiki/Train-Custom-Data)

## 2. GYM [2D Skeleton] Dataset

- **COCO Keypoints**: 17 keypoints
- **Reference URL**:
  - [GYM Dataset COCO Keypoints](https://github.com/open-mmlab/mmaction2/blob/master/tools/data/gym/preprocess_coco_keypoints.py)

## 3. UCF101 [2D Skeleton] Dataset

- **COCO Keypoints**: 17 keypoints
- **Reference URL**:
  - [UCF101 Dataset](https://github.com/open-mmlab/mmaction2/blob/master/tools/data/ucf101/preprocess_coco_keypoints.py)

## 4. HMDB51 [2D Skeleton] Dataset

- **COCO Keypoints**: 17 keypoints
- **Reference URL**:
  - [HMDB51 Dataset](https://github.com/open-mmlab/mmaction2/blob/master/tools/data/hmdb51/preprocess_coco_keypoints.py)

## 5. Diving48 [2D Skeleton] Dataset

- **COCO Keypoints**: 17 keypoints
- **Reference URL**:
  - [Diving48 Dataset](https://github.com/open-mmlab/mmaction2/blob/master/tools/data/diving48/preprocess_coco_keypoints.py)

## 6. Kinetics400 [2D Skeleton] Dataset

- **COCO Keypoints**: 17 keypoints
- **Reference URL**:
  - [Kinetics400 Dataset](https://github.com/open-mmlab/mmaction2/blob/master/tools/data/kinetics400/preprocess_coco_keypoints.py)

### Other Kinetics Datasets

- **Kinetics500** and **Kinetics600** are additional datasets in the Kinetics series, but **Kinetics400** is most commonly used for 2D skeleton-based pose estimation.
- Reference: [Kinetics500 Data](https://deepmind.com/research/open-source/kinetics)

## 2. NTU RGB+D 60 and 120 Datasets

The **NTU RGB+D 60** and **NTU RGB+D 120** datasets use **25 keypoints**, which provide more detailed 3D skeleton representations. These datasets are widely used for 3D pose estimation tasks.

### NTU60 Keypoints:

| NTU60 Keypoint Index | Keypoint Name      |
| -------------------- | ------------------ |
| 0                    | Neck               |
| 1                    | Head top           |
| 2                    | Right Shoulder     |
| 3                    | Right Elbow        |
| 4                    | Right Wrist        |
| 5                    | Left Shoulder      |
| 6                    | Left Elbow         |
| 7                    | Left Wrist         |
| 8                    | Right Hip          |
| 9                    | Right Knee         |
| 10                   | Right Ankle        |
| 11                   | Left Hip           |
| 12                   | Left Knee          |
| 13                   | Left Ankle         |
| 14                   | Spine              |
| 15                   | Base Spine         |
| 16                   | Right Hand         |
| 17                   | Left Hand          |
| 18                   | Right Foot         |
| 19                   | Left Foot          |
| 20                   | Left Finger tip    |
| 21                   | Right Finger tip   |
| 22                   | Left Knee outward  |
| 23                   | Right Knee outward |
| 24                   | Pelvis             |

### Comparison of YOLO and NTU60 Keypoints

While both **YOLO** and **NTU60** datasets aim to capture human poses, **NTU60** has more keypoints for a detailed 3D skeleton representation. Therefore, not all keypoints from YOLO have a direct match in NTU60.

| YOLO Keypoint Index | YOLO Keypoint Name | NTU60 Keypoint Index | NTU60 Keypoint Name | Matching Status |
| ------------------- | ------------------ | -------------------- | ------------------- | --------------- |
| 0                   | Nose               | 1                    | Head top            | Partial Match   |
| 1                   | Left Eye           | -                    | -                   | No Match        |
| 2                   | Right Eye          | -                    | -                   | No Match        |
| 3                   | Left Ear           | -                    | -                   | No Match        |
| 4                   | Right Ear          | -                    | -                   | No Match        |
| 5                   | Left Shoulder      | 5                    | Left Shoulder       | Match           |
| 6                   | Right Shoulder     | 2                    | Right Shoulder      | Match           |
| 7                   | Left Elbow         | 6                    | Left Elbow          | Match           |
| 8                   | Right Elbow        | 3                    | Right Elbow         | Match           |
| 9                   | Left Wrist         | 7                    | Left Wrist          | Match           |
| 10                  | Right Wrist        | 4                    | Right Wrist         | Match           |
| 11                  | Left Hip           | 11                   | Left Hip            | Match           |
| 12                  | Right Hip          | 8                    | Right Hip           | Match           |
| 13                  | Left Knee          | 12                   | Left Knee           | Match           |
| 14                  | Right Knee         | 9                    | Right Knee          | Match           |
| 15                  | Left Ankle         | 13                   | Left Ankle          | Match           |
| 16                  | Right Ankle        | 10                   | Right Ankle         | Match           |

### Summary

- **YOLO** and other **COCO Keypoints-based datasets** (such as GYM, UCF101, HMDB51, Diving48, and Kinetics400) use the same 17 keypoints.
- **NTU RGB+D 60** dataset uses **25 keypoints**, which provides a more detailed skeleton representation, especially for 3D pose estimation.
- While some keypoints are directly comparable between **YOLO** and **NTU60**, the additional keypoints in **NTU60** allow for more detailed body part tracking, such as the spine, hands, and feet.
