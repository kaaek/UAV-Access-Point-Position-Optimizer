"""Bitrate helper functions.

Provides safe wrappers, conversion utilities, and a simple bitrate calculator.
"""
import torch
from typing import Optional

from .rate_fn import rate_shannon


def bitrate_from_pr(pr_watts: torch.Tensor, bw_hz: float, noise_dbm: Optional[float] = None, device=None) -> torch.Tensor:
    """Return the bitrate (bits/s) for a given received power and allocated bandwidth."""
    device = device or torch.device('cpu')
    return rate_shannon(pr_watts, bw_hz, noise_dbm, device=device)


def safe_bitrate(pr_watts: torch.Tensor, bw_hz: float, noise_dbm: Optional[float] = None, min_rate=1.0, device=None) -> torch.Tensor:
    """Clip bitrate to a minimum stable value to avoid numerical issues."""
    r = bitrate_from_pr(pr_watts, bw_hz, noise_dbm, device=device)
    return torch.clamp(r, min=min_rate)
