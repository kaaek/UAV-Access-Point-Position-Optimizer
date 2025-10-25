function [c, ceq] = nonlcon(x, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin)
    % --- reshape UAVs ---
    N = numel(x)/2;
    uav_pos = reshape(x, 2, N);

    % --- received "power" matrix from your function ---
    p_r_raw = p_received(user_pos, uav_pos, H, K, GAMMA, D_0, P_T);   % users x UAVs

    % --- convert to linear Watts safely ---
    % Case A: p_r_raw is in dBm (typical: negatives like -80 dBm)
    % Case B: p_r_raw is complex channel gain -> use |.|^2 (power)
    % Case C: p_r_raw already in Watts (nonnegative real) -> use as-is
    if ~isreal(p_r_raw)
        % complex -> assume channel gain; convert to power (relative), then scale by Tx if needed
        p_r_lin = abs(p_r_raw).^2;   % nonnegative
    elseif any(p_r_raw(:) <= 0)      % strong hint it's in dBm
        % dBm -> W
        p_r_lin = 10.^((p_r_raw - 30)/10);
    else
        % looks like Watts already
        p_r_lin = p_r_raw;
    end

    % --- one-hot association on the same metric used for rate ---
    A = assoc(p_r_lin);                        % users x UAVs, one '1' per row
    Pr_sel = sum(p_r_lin .* A, 2);             % selected link power per user (Watts)
    Pr_sel = max(Pr_sel, realmin);             % avoid zeros

    % --- noise & bandwidth (units) ---
    Pn_W  = 10.^((P_N - 30)/10);               % dBm -> Watts
    BW_Hz = BW * 1e6;
    Kusers = size(user_pos, 2);
    b_k   = (BW_Hz / Kusers) * ones(Kusers,1); % per-user bandwidth share

    % --- SNR and rate (REAL) ---
    SNR = Pr_sel ./ max(Pn_W, realmin);        % >= 0
    r   = b_k .* log2(1 + SNR);                % guaranteed real

    % --- QoS inequality: r >= Rmin  ->  Rmin - r <= 0 ---
    c   = Rmin - r;
    ceq = [];
end
