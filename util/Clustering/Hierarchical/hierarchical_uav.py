"""Hierarchical clustering wrapper — placeholder.

This helper is intentionally minimal: it calls sklearn's AgglomerativeClustering if available
otherwise returns a simple fallback grouping.
"""
import torch

try:
    from sklearn.cluster import AgglomerativeClustering
    _HAS_SK = True
except Exception:
    _HAS_SK = False


def hierarchical_centers(points: torch.Tensor, n_clusters: int, uav_altitude: float = 50.0, device=None) -> torch.Tensor:
    device = device or torch.device('cpu')
    pts = points.cpu().numpy() if _HAS_SK else points.to(device)
    if _HAS_SK:
        model = AgglomerativeClustering(n_clusters=n_clusters)
        labels = model.fit_predict(pts)
        centers = []
        for k in range(n_clusters):
            sel = pts[labels == k]
            centers.append(sel.mean(axis=0))
        import numpy as np
        centers = torch.tensor(np.stack(centers), dtype=torch.float32, device=device)
    else:
        # fallback: pick first n_clusters points
        centers = points[:n_clusters].to(device).float()
    # ensure 3D and altitude
    if centers.shape[1] == 2:
        zcol = torch.full((centers.shape[0], 1), float(uav_altitude), device=device)
        centers = torch.cat([centers, zcol], dim=1)
    else:
        centers[:, 2] = float(uav_altitude)
    return centers
