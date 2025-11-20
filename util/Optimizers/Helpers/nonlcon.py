"""Non-linear constraint helpers (placeholders).

In the MATLAB project these likely enforce QoS and resource constraints. Here we
provide placeholders and clear API comments for replacement with project-specific logic.
"""
import torch


def qos_constraint(bitrates: torch.Tensor, min_bitrate: float) -> torch.Tensor:
    """Return violations (>0) for any link whose bitrate is below min_bitrate."""
    return torch.clamp(min_bitrate - bitrates, min=0.0)


def bandwidth_constraint(bws: torch.Tensor, total_bw: float) -> torch.Tensor:
    """Return positive violation if sum(bws) > total_bw."""
    return torch.clamp(torch.sum(bws) - total_bw, min=0.0)
