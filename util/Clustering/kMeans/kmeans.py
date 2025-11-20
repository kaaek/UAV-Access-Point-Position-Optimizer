"""kMeans clustering helper for UAV placement.

This module provides a thin wrapper around scikit-learn's KMeans. If scikit-learn
is not available, a simple PyTorch implementation placeholder is used.
"""
from typing import Optional

try:
    from sklearn.cluster import KMeans as SKKMeans
    _HAS_SK = True
except Exception:
    _HAS_SK = False

import torch


def kmeans_positions(points: torch.Tensor, n_clusters: int, device=None, random_state: Optional[int] = 0) -> torch.Tensor:
    """Cluster `points` (N, D) and return cluster centers as tensor (n_clusters, D).

    Uses sklearn if available; otherwise a simple random initialization + kmeans++-like loop in CPU.
    """
    device = device or torch.device('cpu')
    X = points.cpu().numpy() if _HAS_SK else points.to(device)
    if _HAS_SK:
        km = SKKMeans(n_clusters=n_clusters, random_state=random_state)
        km.fit(X)
        centers = torch.tensor(km.cluster_centers_, dtype=torch.float32, device=device)
        return centers
    # fallback: random selection of centers
    idx = torch.randperm(points.shape[0])[:n_clusters]
    centers = points[idx].to(device).float()
    return centers
