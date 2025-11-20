"""Simple association utilities: assign each UE to strongest UAV by received power."""
import torch
from typing import Tuple

from .p_received import p_received


def associate(tx_pos: torch.Tensor, rx_pos: torch.Tensor, tx_power_dbm: float = 23.0, frequency_hz: float = 2.4e9, pathloss_exponent: float = 2.2, device=None) -> torch.Tensor:
    """Return indices of associated tx (UAV) for each rx (UE).

    tx_pos: (N_tx, 3)
    rx_pos: (N_rx, 3)
    returns: (N_rx,) LongTensor of indices in [0, N_tx)
    """
    device = device or torch.device('cpu')
    pr = p_received(tx_pos, rx_pos, tx_power_dbm=tx_power_dbm, frequency_hz=frequency_hz, pathloss_exponent=pathloss_exponent, device=device)
    # pr: (N_tx, N_rx) -> choose argmax over tx for each rx
    best = torch.argmax(pr, dim=0)
    return best
