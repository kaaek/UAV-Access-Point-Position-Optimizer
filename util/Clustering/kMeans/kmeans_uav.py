"""kMeans wrapper specialized for UAV placement in 3D.

Exposes a convenience function that accepts ground user positions (N,2 or N,3)
and returns UAV positions in 3D (uav_z is a fixed altitude).
"""
import torch
from .kmeans import kmeans_positions


def kmeans_uav_positions(ground_points: torch.Tensor, n_uav: int, uav_altitude: float = 50.0, device=None) -> torch.Tensor:
    device = device or torch.device('cpu')
    pts = ground_points.to(device).float()
    if pts.ndim == 2 and pts.shape[1] == 2:
        # lift to 3D by adding zeros for z
        pts3 = torch.cat([pts, torch.zeros((pts.shape[0], 1), device=device)], dim=1)
    else:
        pts3 = pts
    centers = kmeans_positions(pts3, n_uav, device=device)
    # enforce altitude
    centers[:, 2] = float(uav_altitude)
    return centers
