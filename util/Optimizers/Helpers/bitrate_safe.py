"""Safe bitrate wrapper for optimizers."""
import torch


def bitrate_safe(pr_watts: torch.Tensor, bw_hz: torch.Tensor, noise_dbm: float = None, min_rate: float = 1.0, rate_fn=None, device=None) -> torch.Tensor:
    """Compute bitrate and clamp to minimum (safe) to avoid bad gradients.

    rate_fn: function(pr, bw) -> rate
    """
    device = device or torch.device('cpu')
    if rate_fn is None:
        # lazy import to avoid circular
        from ..Helpers import rate_fn as _rate_fn
        rate_fn = _rate_fn.rate_shannon
    r = rate_fn(pr_watts, bw_hz, noise_dbm, device=device)
    return torch.clamp(r, min=min_rate)
