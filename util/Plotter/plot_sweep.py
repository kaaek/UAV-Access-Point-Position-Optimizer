"""Utilities for plotting parameter sweeps (throughput vs. param)."""
import matplotlib.pyplot as plt
import torch


def plot_sweep(x_values, y_values, xlabel='param', ylabel='value', title=None, show=True, save_path=None):
    plt.figure()
    plt.plot(x_values, y_values, marker='o')
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    if title:
        plt.title(title)
    if save_path:
        plt.savefig(save_path)
    if show:
        plt.show()
