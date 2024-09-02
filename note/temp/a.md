
# GPU Usage Summary for Jetson Nano with YOLO Model Execution

The following summary provides insights into the GPU usage observed during the execution of the YOLO model on a Jetson Nano. We analyzed the `tegrastats` logs to understand the GPU's activity.

## Key Observations

1. **GPU Usage Indicator (`GR3D_FREQ`)**:
   - **0%**: Indicates that the GPU is idle or not actively used.
   - **68% to 99%**: Shows active GPU usage during the processing of tasks, such as YOLO inference.

2. **Sample Log Analysis**:
   ```
   GR3D_FREQ 0%  -> GPU idle (not used)
   GR3D_FREQ 68% -> GPU moderately active (inference start)
   GR3D_FREQ 99% -> GPU fully active (peak usage during inference)
   ```

3. **Temperature and Resource Utilization**:
   - **GPU Temperature**: Between 31°C and 33.5°C during execution.
   - **CPU Utilization**: Spikes were observed alongside GPU usage, indicating that both CPU and GPU resources were employed.

## Example Logs

Below is a sample from the `tegrastats` logs showing the GPU activity.

```
RAM 2589/3956MB (lfb 1x2MB) SWAP 23/6074MB (cached 3MB) CPU [31%@1036,22%@1036,5%@1036,4%@1036] EMC_FREQ 0% GR3D_FREQ 99%
RAM 2590/3956MB (lfb 1x2MB) SWAP 23/6074MB (cached 3MB) CPU [8%@1479,37%@1479,27%@1479,9%@1479] EMC_FREQ 0% GR3D_FREQ 99%
```

## Conclusion

The logs confirm that the GPU was actively utilized during the YOLO inference, with the `GR3D_FREQ` metric reaching up to **99%**. This indicates that the inference workload leveraged the GPU for computation, ensuring optimized performance.

If further monitoring is needed, tools like `tegrastats` and `jtop` can be employed to track GPU usage in real time during different stages of inference.

## Additional Monitoring Commands

To ensure CUDA availability and GPU readiness:
```bash
python3 -c "import torch; print(torch.cuda.is_available())"
```

For continuous GPU monitoring:
```bash
sudo tegrastats
```
