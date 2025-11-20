"""Rate function (Shannon capacity) using PyTorch.

Rate = bandwidth * log2(1 + SNR)
SNR computed from received power and noise power.
"""
import torch
from typing import Optional

from .constants import default_params


def snr_from_pr(pr_watts: torch.Tensor, noise_power_watts: float) -> torch.Tensor:
    return pr_watts / (noise_power_watts + 1e-12)


def noise_watts_from_dbm(noise_dbm: float) -> float:
    mW = 10 ** (noise_dbm / 10.0)
    return mW / 1000.0


def rate_shannon(pr_watts: torch.Tensor, bandwidth_hz: float, noise_dbm: Optional[float] = None, device=None) -> torch.Tensor:
    """Compute rate in bits/s from received power tensor and bandwidth.

    pr_watts: (...,) tensor of powers
    bandwidth_hz: scalar total bandwidth allocated to that link
    noise_dbm: optional, if None taken from default_params
    Returns same-shape tensor of rates in bits/s.
    """
    device = device or torch.device('cpu')
    if noise_dbm is None:
        noise_dbm = default_params()["noise_power_dbm"]
    noise_watts = noise_watts_from_dbm(noise_dbm)
    snr = snr_from_pr(pr_watts.to(device), noise_watts)
    rate = bandwidth_hz * torch.log2(1 + snr)
    return rate
