⚓ Efficient GCN v2 ; https://arxiv.org/pdf/2106.15125

# Introduction
🖼️ Fig. 1. The overall pipeline of our approach
## Related Work
### 2.1 Skeleton-based Action Recognition
### 2.2 Efficient Models
### 2.3 Attention Models
## Preliminary Techniques
### 3.1 Data Preprocessing
🖼️ Fig. 4. Standard convolution vs. separable convolution for skeleton-based action recognition
### 3.2 Graph Convolution
### 3.3 Separable Convolution
## EfficientGCN
🖼️ Fig. 5. The overview of the proposed EfficientGCN model
### 4.1 Model Architecture
🖼️ Fig. 6. The details of various convolutional layers
- **L**: Length of Kernel
- **$C_{\mathrm{rd}}$**: Reduced number of Channels
- **$C_{\mathrm{ep}}$**: Expanded number of Channels
- **rep**: Number of repetitions
- **$C_{\mathrm{in}}$**: Input Channels
- **$C_{\mathrm{out}}$**: Output Channels
### 4.2 Block Details
### 4.3 Scaling Strategy
🖼️ Fig. 7. The overview of the proposed ST-JointAtt module
- **C**: Number of Channels
- **T**: Time (number of frames)
- **V**: Joints (number of joints). Vertices.
### 4.4 Spatial Temporal Joint Attention
### 4.5 Loss Function
### 4.6 Discussion
## Experimental Results
### 5.1 Datasets
#### 5.1.1 NTU RGB+D 60
#### 5.1.2 NTU RGB+D 120
### 5.2 Implementation Details
### 5.3 Ablation Studies
#### 5.3.1 Comparisons of TC Layers
#### 5.3.2 Comparisons of Attention Modules
#### 5.3.3 Necessity of Data Preprocessing
#### 5.3.4 Necessity of Early Fused Architecture
### 5.4 Comparisons of Compound Scaling Strategies
### 5.5 Comparisons with SOTA Methods
#### 5.5.1 NTU RGB+D 60 Dataset
#### 5.5.2 NTU RGB+D 120 Dataset
#### 5.5.3 Model Complexity
### 5.6 Discussion and Visualization
#### 5.6.1 Confusion Matrices and Failure Cases
#### 5.6.2 Attention Maps
#### 5.6.3 Class Activation Maps
### 5.7 Generalization of EfficientGCN
# Conclusion
# References
# Appendix A: Network Architecture
# Appendix B: Grid Search for Receptive Field
