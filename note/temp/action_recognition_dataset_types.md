# Action Recognition Dataset Types

| Rank | Dataset Name             | Included Data         | Skeleton Data Provided           | EfficientGCNv2 Compatibility                       | Original URL                                      |
|------|-------------------------|-----------------------|----------------------------------|----------------------------------------------------|--------------------------------------------------|
| 1    | NTU RGB+D 60/120        | RGB video, 3D skeleton| Yes (3D joint data)             | Yes, directly usable (Compatible with EfficientGCNv2) | [NTU RGB+D](https://rose1.ntu.edu.sg/dataset/actionRecognition/) |
| 2    | Kinetics-400/600/700    | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [Kinetics Dataset](https://github.com/cvdfoundation/kinetics-dataset) |
| 3    | Something-to-Something V2 | RGB video           | No                              | No, requires pose estimation model to extract skeleton | [SSV2 Dataset](https://paperswithcode.com/dataset/something-something-v2) |
| 4    | UCF101                  | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [UCF101 Dataset](https://www.crcv.ucf.edu/data/UCF101.php) |
| 5    | HMDB51                  | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [HMDB51 Dataset](https://serre-lab.clps.brown.edu/resource/hmdb-a-large-human-motion-database/) |
| 6    | ActivityNet             | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [ActivityNet](https://activity-net.org/)          |
| 7    | Sports-1M               | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [Sports-1M Dataset](https://paperswithcode.com/dataset/sports-1m) |
| 8    | THUMOS14                | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [THUMOS14](https://www.crcv.ucf.edu/THUMOS14/)   |
| 9    | AVA                     | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [AVA Dataset](https://research.google.com/ava/)  |
| 10   | Charades                | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [Charades Dataset](http://vuchallenge.org/charades.html) |
| 11   | SoccerNet               | RGB video             | No                              | No, requires pose estimation model to extract skeleton | [SoccerNet](https://www.soccer-net.org/)         |

## NTU RGB+D Dataset Filename Format Explanation

The filenames in the NTU RGB+D dataset follow a specific format that provides detailed information about each recorded sequence. A typical filename looks like **S001C001P001R001A001.skeleton**, where each part of the name indicates specific attributes of the recording session. This structure allows users to identify the session, camera view, subject, and action class directly from the filename.

### Filename Format: `S###C###P###R###A###.skeleton`

This structured naming convention is designed to make it easy to identify and categorize sequences within the NTU RGB+D dataset. It ensures that all information related to each recording is clearly encoded in the filename, facilitating the organization and retrieval of specific data.

| Section | Code Format | Description                                     |
|---------|-------------|-------------------------------------------------|
| S###    | Session ID  | Indicates the session number where the recording was made (e.g., `S001` for session 1). |
| C###    | Camera ID   | Specifies the camera view used (e.g., `C001` represents the first camera).           |
| P###    | Subject ID  | Denotes the ID of the subject being recorded (e.g., `P001` for the first person).   |
| R###    | Repetition  | Refers to the repetition number of the action sequence (e.g., `R001` for the first repetition). |
| A###    | Action ID   | Indicates the action class being performed (e.g., `A001` for the first action class). |

### Example Breakdown

For a filename like **S001C001P001R001A001.skeleton**:

- **S001**: This refers to **Session 1**.
- **C001**: This indicates the use of **Camera 1**.
- **P001**: This is the ID for **Person 1** performing the action.
- **R001**: This is the **First Repetition** of the action.
- **A001**: This denotes the **First Action Class**.

## Structure of .skeleton file

The `.skeleton` file format provides a comprehensive and sequential record of skeletal movement, consistent with the structure used in the **NTU RGB+D dataset**. It includes detailed 3D coordinates and projections, making it a valuable resource for analyzing human movement in tasks such as action recognition.

🛍️ Example of .skeleton File

```skeleton
69
1
72057594037931576 0 1 1 0 0 0 -0.01927769 0.1346177 2
25
-0.03535797 0.19243 3.681518 252.8367 189.3851 965.624 511.9289 -0.20556 0.06199342 0.9655087 -0.147292 2
-0.02103598 0.4221708 3.606487 254.2135 165.6555 970.1036 443.4965 -0.2406677 0.06732881 0.9573615 -0.1449308 2
-0.007186097 0.6464292 3.520689 255.5999 141.1916 974.6609 373.1437 -0.2755829 0.08422901 0.9400199 -0.1825433 2
...
1
72057594037931576 0 1 1 0 0 0 -0.01943753 0.1344441 2
25
-0.03537421 0.1923714 3.681347 252.8349 189.39 965.6196 511.9432 -0.2060398 0.06206353 0.9654239 -0.1471471 2
-0.02103937 0.4221669 3.606356 254.2131 165.6543 970.103 443.4931 -0.2408029 0.06734198 0.9573452 -0.1448075 2
-0.007165094 0.6464977 3.52061 255.6021 141.1829 974.6676 373.1187 -0.2753649 0.08417659 0.9401126 -0.1824191 2
-0.04228327 0.7691297 3.496261 251.9102 127.7711 964.2279 334.6051 0 0 0 0 2
-0.1350665 0.5772265 3.618807 242.674 150.0573 
...

```

- **First three values** (`-0.03535797 0.19243 3.681518`): The **3D coordinates** (x, y, z) of a joint.
- **Next two values** (`252.8367 189.3851`): The **RGB projection** of the joint.
- **Next two values** (`965.624 511.9289`): The **Depth projection** of the joint.
- The **remaining values** may represent additional information such as tracking confidence or states.

### Does This File Capture Continuous Joint Movement?

Yes, the `.skeleton` file captures the **continuous movement** of joints across multiple frames. Each joint's 3D position is recorded for each frame, allowing for tracking how the person's body moves over time. This format is particularly suitable for tasks like **action recognition**, where the model analyzes how joints move over time to classify the performed action.
