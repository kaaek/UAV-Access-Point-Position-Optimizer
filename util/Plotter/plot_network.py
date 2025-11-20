"""Plotting helpers for networks (matplotlib).

These are lightweight helpers to visualize UAVs and UEs in 2D/3D.
"""
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

import torch


def plot_network(uav_pos: torch.Tensor, ue_pos: torch.Tensor, show=True, save_path: str = None):
    u = uav_pos.cpu().numpy()
    ue = ue_pos.cpu().numpy()
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(ue[:, 0], ue[:, 1], ue[:, 2] if ue.shape[1] > 2 else 0, c='blue', label='UE')
    ax.scatter(u[:, 0], u[:, 1], u[:, 2], c='red', marker='^', s=80, label='UAV')
    ax.set_xlabel('X (m)')
    ax.set_ylabel('Y (m)')
    ax.set_zlabel('Z (m)')
    ax.legend()
    if save_path:
        plt.savefig(save_path)
    if show:
        plt.show()
    return fig
