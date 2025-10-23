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
K           = 30;
GAMMA       = 3;
D_0         = 1;
P_T         = 30;       % dBm
P_N         = 2;        % dBm
MAX_ITER    = 50;
TOL         = 1e-3;     % Tolerance for k-means convergence
BW          = 40;       % MHz

uav_pos = baselineSol(M,N,AREA,H,K,GAMMA,D_0,P_T,P_N,MAX_ITER,TOL,BW);
uav_pos_flat = reshape(uav_pos', [], 1);
obj = objective_uav(uav_pos_flat, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW)

