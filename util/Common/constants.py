"""Project constants and helpers.

This module exposes default parameters and a helper to pick device (cpu/cuda).
"""
from typing import Dict

import torch


def get_device(prefer_gpu: bool = True) -> torch.device:
    """Return torch.device('cuda') if available and requested, else cpu."""
    if prefer_gpu and torch.cuda.is_available():
        return torch.device('cuda')
    return torch.device('cpu')


def default_params() -> Dict:
    """Return a small dictionary of default wireless params used across modules.

    keys:
      - bandwidth_hz: total system bandwidth (Hz)
      - noise_power_dbm: noise power in dBm
      - tx_power_dbm: transmitter power in dBm
      - frequency_hz: carrier frequency
      - pathloss_exponent: typical path-loss exponent
    """
    return {
        "bandwidth_hz": 10e6,
        "noise_power_dbm": -174 + 10 * torch.log10(torch.tensor(10e6)).item(),
        "tx_power_dbm": 23.0,  # 200 mW
        "frequency_hz": 2.4e9,
        "pathloss_exponent": 2.2,
    }
