"""Throughput computations built on rate_fn."""
from typing import Optional
import torch

from .rate_fn import rate_shannon
from .constants import default_params


def throughput_from_pr(pr_watts: torch.Tensor, bandwidth_hz: float, noise_dbm: Optional[float] = None, device=None) -> torch.Tensor:
    """Return throughput in bits/s computed by Shannon formula."""
    device = device or torch.device('cpu')
    return rate_shannon(pr_watts, bandwidth_hz, noise_dbm, device=device)
