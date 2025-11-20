"""Top-level network optimization combining bandwidth and UAV placement (example).

This function composes the smaller optimizers as a demonstration of a joint process.
"""
from typing import Optional
import torch

from .optimize_bandwidth_allocation import optimize_bandwidth_allocation
from .optimize_uav_positions import optimize_uav_positions


def optimize_network(uav_pos_init: torch.Tensor, ue_pos: torch.Tensor, tx_power_dbm: float, total_bw_hz: float, device=None) -> dict:
    device = device or torch.device('cpu')
    # step 1: place uavs (quick run)
    uav_pos = optimize_uav_positions(uav_pos_init, ue_pos, tx_power_dbm, total_bw_per_ue=total_bw_hz / ue_pos.shape[0], num_steps=50, device=device)
    # step 2: compute received powers per ue using best-uav mapping
    from ..Common.p_received import p_received
    pr = p_received(uav_pos, ue_pos, tx_power_dbm=tx_power_dbm, device=device)
    best_pr, _ = torch.max(pr, dim=0)
    # step 3: allocate bandwidth among UEs
    bw_alloc = optimize_bandwidth_allocation(best_pr, total_bw_hz, num_steps=200, device=device)
    return {"uav_pos": uav_pos, "bandwidth": bw_alloc}
