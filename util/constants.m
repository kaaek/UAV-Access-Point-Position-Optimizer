function [M, N, AREA, H, H_M, F, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW_total, R_MIN, SIDE, TRIALS] = constants()
% rng(42);                % Generator seed
M           = 50;       % Users
N           = 5;        % UAVs
AREA        = 9e6;    % meters squared
H           = 100;      % height, meters
H_M         = 1.5;
F           = 500e6;    % Hz
K           = 30;       % dB
GAMMA       = 3;        
D_0         = 1;        % meters
P_T         = 30;       % dBm
P_N         = -91;      % dBm 
MAX_ITER    = 50;
TOL         = 1e-3;     % Tolerance for k-means convergence
BW_total    = 40e6;     % Hz
R_MIN       = 0.2E6;    % Set minimum bit rate
SIDE        = sqrt(AREA);
TRIALS      = 50;
end