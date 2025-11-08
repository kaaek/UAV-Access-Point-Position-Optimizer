function [uav_pos, baseline_br, sumlink_mbps] = gridSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, BW)
% GRIDSOL - Computes UAV positions and baseline bitrate for a grid layout.
%
% Syntax:  [uav_pos, baseline_br, sumlink_mbps] = gridSol(user_pos, M, N, AREA, H, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW)
%
% Inputs:
%    user_pos - 2xK matrix of user positions (x, y)
%    M        - Number of subcarriers
%    N        - Number of UAVs
%    AREA     - Total area for the grid layout
%    H        - Height of the UAVs
%    K        - Number of users
%    GAMMA    - Path loss exponent
%    D_0      - Reference distance for path loss
%    P_T      - Transmit power of the UAVs (dBm)
%    P_N      - Noise power (dBm)
%    MAX_ITER - Maximum number of iterations for convergence
%    TOL      - Tolerance for convergence
%    BW       - Bandwidth of the system
%
% Outputs:
%    uav_pos      - 2xN matrix of UAV positions (x, y)
%    baseline_br   - 1xN vector of baseline bitrates for each UAV (bps)
%    sumlink_mbps  - Total link throughput (Mbps)
%
% Example:
%    [uav_pos, baseline_br, sumlink_mbps] = gridSol(user_pos, 64, 10, 10000, 100, 5, 2, 1, 30, -100, 1000, 1e-6, 20e6);
side            = ceil(sqrt(AREA));
uav_pos         = zeros(2, N);
uav_pos(1, :)   = linspace(0, side, N);
uav_pos(2, :)   = linspace(0, side, N);
p_r             = p_received(user_pos, uav_pos, H_M, H, F, P_T); % dBm
a               = assoc(p_r);
baseline_br     = bitrate(p_r, P_N, (BW/M), a);                         % bps
sumlink         = sum(baseline_br);

sumlink_mbps = sumlink/1e6;
end