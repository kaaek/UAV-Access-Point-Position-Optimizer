"""Small demo to validate the converted utilities.

Run this to see a tiny example when you want to check everything is wired up.
Requires: torch, matplotlib (optional), sklearn (optional).
"""
import torch
from util.Common.constants import get_device, default_params
from util.Common.init_bandwidth import equal_split
from util.Clustering.kMeans.kmeans_uav import kmeans_uav_positions
from util.Common.association import associate
from util.Optimizers.optimize_network import optimize_network
from util.Plotter.plot_network import plot_network


def demo(use_gpu: bool = True):
    device = get_device(prefer_gpu=use_gpu)
    print(f"Using device: {device}")
    # create random UEs in a 500x500 area
    n_ues = 20
    n_uav = 3
    ue_xy = torch.rand((n_ues, 2), device=device) * 500.0
    ue_z = torch.zeros((n_ues, 1), device=device)
    ue_pos = torch.cat([ue_xy, ue_z], dim=1)
    # initial UAV positions via kmeans
    uav_init = kmeans_uav_positions(ue_pos, n_uav, uav_altitude=50.0, device=device)
    print('UAV init positions:', uav_init)
    params = default_params()
    out = optimize_network(uav_init, ue_pos, params['tx_power_dbm'], total_bw_hz=params['bandwidth_hz'], device=device)
    print('Optimized bandwidth:', out['bandwidth'])
    try:
        plot_network(out['uav_pos'], ue_pos)
    except Exception as e:
        print('Plot failed (matplotlib missing?):', e)


if __name__ == '__main__':
    demo(use_gpu=False)
