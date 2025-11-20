"""Simple bandwidth initializers.

Provides equal split and simple heuristic methods to seed optimization.
"""
import torch
from typing import Optional


def equal_split(total_bw_hz: float, n_links: int, device=None) -> torch.Tensor:
    device = device or torch.device('cpu')
    per = total_bw_hz / float(max(n_links, 1))
    return torch.full((n_links,), per, dtype=torch.float32, device=device)


def proportional_split(total_bw_hz: float, weights: torch.Tensor, device=None) -> torch.Tensor:
    device = device or torch.device('cpu')
    w = weights.to(device).float()
    wsum = torch.sum(w)
    if wsum <= 0:
        return equal_split(total_bw_hz, w.shape[0], device=device)
    return total_bw_hz * (w / wsum)
