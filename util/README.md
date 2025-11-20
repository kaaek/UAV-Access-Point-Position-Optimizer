This folder contains Python conversions of the MATLAB `util/` helpers used in the project.

Highlights:
- Common/ : pathloss, rate, throughput, spectral efficiency, association, bandwidth initializers
- Clustering/ : kMeans and hierarchical wrappers (prefer sklearn when available)
- Optimizers/ : example PyTorch-based optimizers (bandwidth allocation, UAV position tuning)
- Plotter/ : simple matplotlib visualization helpers

GPU usage:
- The core modules use PyTorch tensors. To use GPU, call `torch.device('cuda')` or set `get_device(prefer_gpu=True)`.
- The demo `run_demo.py` shows how to disable/enable GPU.

Notes:
- These are reference conversions and intentionally lightweight. Replace placeholders with project-specific constraints and exact math if needed.
- Install recommended packages:

  pip install torch numpy matplotlib scikit-learn

