"""Received power and pathloss models (PyTorch).

Functions accept positions and tx power and return received power in linear units (watts)
or dBm as requested. Designed to operate on torch tensors and optionally use GPU.
"""
from typing import Tuple
import torch

from .constants import default_params


def free_space_pathloss(tx_pos: torch.Tensor, rx_pos: torch.Tensor, frequency_hz: float, device=None) -> torch.Tensor:
    """Compute free-space pathloss (linear factor) between tx and rx.

    tx_pos: (N_tx, 3) tensor
    rx_pos: (N_rx, 3) tensor
    returns: (N_tx, N_rx) pathloss linear factor (0-1)
    """
    device = device or torch.device('cpu')
    tx = tx_pos.to(device)
    rx = rx_pos.to(device)
    # pairwise distances
    d = torch.cdist(tx, rx)  # (N_tx, N_rx)
    # avoid zeros
    d = torch.clamp(d, min=1e-3)
    c = 3e8
    lam = c / frequency_hz
    # FSPL factor (ratio), using (lambda/(4*pi*d))^2
    fspl = (lam / (4 * torch.pi * d)) ** 2
    return fspl


def received_power_txdbm_to_watts(tx_power_dbm: float) -> float:
    """Convert dBm to watts."""
    mW = 10 ** ((tx_power_dbm) / 10.0)
    return mW / 1000.0


def p_received(tx_pos: torch.Tensor, rx_pos: torch.Tensor, tx_power_dbm: float = 23.0, frequency_hz: float = 2.4e9, pathloss_exponent: float = 2.0, device=None) -> torch.Tensor:
    """Compute received power at each rx from each tx (watts).

    Returns tensor of shape (N_tx, N_rx) giving received power in watts.
    Uses a simplified log-distance model with free-space at short ranges.
    """
    device = device or torch.device('cpu')
    fspl = free_space_pathloss(tx_pos, rx_pos, frequency_hz, device=device)
    tx_watts = received_power_txdbm_to_watts(tx_power_dbm)
    # apply additional loss from pathloss exponent (use distance influence)
    # fspl already contains 1/d^2 dependence; for general exponent, approximate via d^{-(pathloss_exponent)}
    # derive distance from fspl: fspl ~ lambda^2/(16 pi^2 d^2) => d^2 ~ const/fspl => d^{pathloss_exponent} ~ (const/fspl)^{pathloss_exponent/2}
    # easier: compute distance explicitly
    tx = tx_pos.to(device)
    rx = rx_pos.to(device)
    d = torch.cdist(tx, rx)
    d = torch.clamp(d, min=1e-3)
    # reference distance 1 m
    ref = 1.0
    extra_loss = (d / ref) ** (-(pathloss_exponent - 2.0))
    pr = tx_watts * fspl * extra_loss
    return pr
