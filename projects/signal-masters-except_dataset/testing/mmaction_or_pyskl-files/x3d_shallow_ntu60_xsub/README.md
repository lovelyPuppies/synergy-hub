# Learning process

If you want to check the required files for training and test, clone or folk the [Pyskl Github repository](https://github.com/kennymckormick/pyskl/tree/main).

## Train command

```bash
bash tools/dist_train.sh configs/posec3d/x3d_shallow_ntu60_xsub/joint.py 1 -
-validate --test-last --test-best
```

## Test command

```bash
bash tools/dist_test.sh configs/posec3d/x3d_shallow_ntu60_xsub/joint.py work
_dirs/posec3d/x3d_shallow_ntu60_xsub/joint/latest.pth 1 --eval top_k_accuracy mean_class_accuracy --out result.pkl
```

## Last model learning output

```plaintxt
2024-10-16 11:44:38,092 - pyskl - INFO - Epoch [24][12520/12529]        lr: 1.092e-09, eta: 0:00:02, time: 0.229, data_time: 0.000, memory: 3119, top1_acc: 0.8250, top5_acc: 0.9781, loss_cls: 0.5920, loss: 0.5920, grad_norm: 2.8631
2024-10-16 11:44:40,934 - pyskl - INFO - Saving checkpoint at 24 epochs
[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>] 16487/16487, 148.7 task/s, elapsed: 111s, ETA:     0s

2024-10-16 11:46:32,870 - pyskl - INFO - Evaluating top_k_accuracy ...
2024-10-16 11:46:32,920 - pyskl - INFO - 
top1_acc        0.8411
top5_acc        0.9842
2024-10-16 11:46:32,920 - pyskl - INFO - Evaluating mean_class_accuracy ...
2024-10-16 11:46:32,925 - pyskl - INFO - 
mean_acc        0.8409
2024-10-16 11:46:32,926 - pyskl - INFO - The previous best checkpoint /home/wbfw109v2/repo/intel-edge-academy-6/external/pyskl/work_dirs/posec3d/x3d_shallow_ntu60_xsub/joint/best_top1_acc_epoch_23.pth was removed
2024-10-16 11:46:32,938 - pyskl - INFO - Now best checkpoint is saved as best_top1_acc_epoch_24.pth.
2024-10-16 11:46:32,939 - pyskl - INFO - Best top1_acc is 0.8411 at 24 epoch.
2024-10-16 11:46:32,940 - pyskl - INFO - Epoch(val) [24][516]   top1_acc: 0.8411, top5_acc: 0.9842, mean_class_accuracy: 0.8409
2024-10-16 11:46:37,933 - pyskl - INFO - 16487 videos remain after valid thresholding
[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>] 16487/16487, 6.7 task/s, elapsed: 2443s, ETA:     0s
Evaluating top_k_accuracy ...

top1_acc        0.8473
top5_acc        0.9853

Evaluating mean_class_accuracy ...

mean_acc        0.8471
2024-10-16 12:27:21,725 - pyskl - INFO - Testing results of the last checkpoint
2024-10-16 12:27:21,725 - pyskl - INFO - top1_acc: 0.8473
2024-10-16 12:27:21,725 - pyskl - INFO - top5_acc: 0.9853
2024-10-16 12:27:21,725 - pyskl - INFO - mean_class_accuracy: 0.8471
2024-10-16 12:27:21,725 - pyskl - INFO - load checkpoint from local path: ./work_dirs/posec3d/x3d_shallow_ntu60_xsub/joint/best_top1_acc_epoch_24.pth
[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>] 16487/16487, 6.8 task/s, elapsed: 2418s, ETA:     0s^T
Evaluating top_k_accuracy ...

top1_acc        0.8473
top5_acc        0.9853

Evaluating mean_class_accuracy ...

mean_acc        0.8471
2024-10-16 13:07:41,197 - pyskl - INFO - Testing results of the best checkpoint
2024-10-16 13:07:41,197 - pyskl - INFO - top1_acc: 0.8473
2024-10-16 13:07:41,197 - pyskl - INFO - top5_acc: 0.9853
2024-10-16 13:07:41,197 - pyskl - INFO - mean_class_accuracy: 0.8471
[rank0]:[W1016 13:07:41.150472886 ProcessGroupNCCL.cpp:1168] Warning: WARNING: process group has NOT been destroyed before we destruct ProcessGroupNCCL. On normal program exit, the application should call destroy_process_group to ensure that any pending NCCL operations have finished in this process. In rare cases this process can exit before this point and block the progress of another member of the process group. This constraint has always been present,  but this warning has only been added since PyTorch 2.4 (function operator())

```
