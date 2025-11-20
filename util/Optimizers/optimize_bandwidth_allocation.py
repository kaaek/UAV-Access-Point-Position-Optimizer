"""A small example optimizer to allocate bandwidth among links to maximize sum rate.

This is a simple PyTorch gradient-ascent example (projected gradient) to show how
GPU acceleration can be used. Replace or extend with more advanced solvers as needed.
"""
import torch
from typing import Optional

from ..Common.rate_fn import rate_shannon


def optimize_bandwidth_allocation(pr_watts: torch.Tensor, total_bw_hz: float, num_steps: int = 200, lr: float = 1e5, device=None) -> torch.Tensor:
    """Optimize per-link bandwidth (vector) to maximize sum of rates.

    pr_watts: (N_links,) or (N_tx, N_rx) depending on grouping; function assumes a flat vector of effective pr per link.
    returns: (N_links,) tensor of allocated bandwidths in Hz summing to total_bw_hz.
    """
    device = device or torch.device('cpu')
    pr = pr_watts.to(device).float()
    n = pr.numel()
    # initialize equal split (as parameters in log-space to ensure positivity)
    bw = torch.full((n,), total_bw_hz / float(n), dtype=torch.float32, device=device, requires_grad=True)
    opt = torch.optim.Adam([bw], lr=1e-1)
    for i in range(num_steps):
        opt.zero_grad()
        rates = rate_shannon(pr, bw, device=device)
        # objective: negative sum rate (we minimize)
        loss = -torch.sum(rates)
        loss.backward()
        opt.step()
        # projection: ensure positivity and sum constraint
        with torch.no_grad():
            bw.clamp_(min=1.0)
            bw *= total_bw_hz / bw.sum()
    return bw.detach()
