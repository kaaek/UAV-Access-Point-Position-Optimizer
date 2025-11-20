"""Example optimizer to adjust UAV positions to improve sum throughput.

This is a small gradient-based example: UAV positions are parameterized and
we take gradient steps on sum rate computed via PyTorch.
"""
import torch
from typing import Optional

from ..Common.p_received import p_received
from ..Common.rate_fn import rate_shannon


def optimize_uav_positions(tx_pos_init: torch.Tensor, ue_pos: torch.Tensor, tx_power_dbm: float, total_bw_per_ue: float, num_steps: int = 200, lr: float = 1.0, device=None) -> torch.Tensor:
    device = device or torch.device('cpu')
    # tx_pos_init shape: (N_uav, 3) requires gradients
    uav_pos = tx_pos_init.to(device).clone().detach().float()
    uav_pos.requires_grad = True
    opt = torch.optim.Adam([uav_pos], lr=lr)
    for i in range(num_steps):
        opt.zero_grad()
        pr = p_received(uav_pos, ue_pos.to(device), tx_power_dbm=tx_power_dbm, device=device)
        # pr: (N_uav, N_ue) -> choose best UAV per UE
        best_pr, _ = torch.max(pr, dim=0)
        rates = rate_shannon(best_pr, total_bw_per_ue, device=device)
        loss = -torch.sum(rates)
        loss.backward()
        opt.step()
        # optionally enforce altitude constraints (z>10)
        with torch.no_grad():
            uav_pos[:, 2].clamp_(min=10.0)
    return uav_pos.detach()
