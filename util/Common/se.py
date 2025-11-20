"""Spectral Efficiency utilities.

SE = rate / bandwidth (bits/s/Hz)
"""
import torch
from typing import Optional

from .rate_fn import rate_shannon


def spectral_efficiency(pr_watts: torch.Tensor, bandwidth_hz: float, noise_dbm: Optional[float] = None, device=None) -> torch.Tensor:
    device = device or torch.device('cpu')
    rate = rate_shannon(pr_watts, bandwidth_hz, noise_dbm, device=device)
    return rate / (bandwidth_hz + 1e-12)
