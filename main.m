%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%

clc, clearvars
addpath("util\");

rng(42);                % Generator seed

M           = 50;       % Users
N           = 5;        % UAVs
AREA        = 2000;
H           = 100;      % height, meters
K           = 30;       % dB
GAMMA       = 3;        
D_0         = 1;        % meters
P_T         = 30;       % dBm
P_N         = -91;      % dBm 
MAX_ITER    = 50;
TOL         = 1e-3;     % Tolerance for k-means convergence
BW_total    = 40e6;     % Hz
Rmin        = 0.2E6;    % Set minimum bit rate

% 1. Baseline solution (K-means)
[uav_pos, user_pos] = baselineSol(M, N, AREA, H, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW_total);

% 2. Optimize UAV positions (Global Search, built on top of fmincon)
uav_pos_opt = optimizeUAVPositions(N, AREA, uav_pos, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW_total, Rmin); % Outputs Nx2 matrix

% 3. Optimize Bandwidth allocation (fmincon)
uav_pos_opt = uav_pos_opt.';   % now 2×N (transpose)
[~, br_opt] = optimizeBandwidthAllocation(M, BW_total, user_pos, uav_pos_opt, H, K, GAMMA, D_0, P_T, P_N, Rmin);

writematrix(uav_pos_opt, 'uav_positions.csv');
writematrix(br_opt, 'bitrates.csv');
