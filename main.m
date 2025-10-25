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
P_N         = -91;      % dBm 
MAX_ITER    = 50;
TOL         = 1e-3;     % Tolerance for k-means convergence
BW          = 40;       % MHz
Rmin = 0.2E6;           % Set minimum bit rate

% 1. Baseline solution (K-means)
[uav_pos, user_pos] = baselineSol(M,N,AREA,H,K,GAMMA,D_0,P_T,P_N,MAX_ITER,TOL,BW);

% Bounds
lb = repelem([0;0], N);
ub = repelem([AREA;AREA], N);
opts = optimoptions('fmincon', 'Algorithm','interior-point', 'Display','iter');
uav_pos_flat = reshape(uav_pos', [], 1); % Flatten the matrix (needed so that it can be passed to fmincon), now looks like: [x1, y1, x2, y2, ..., xN, yN]

obj = objective_uav(uav_pos_flat, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW); % Helper that describes the objective function.
[x_opt, fval] = fmincon(@(x)objective_uav(x,user_pos,H,K,GAMMA,D_0,P_T,P_N,BW), ...
                        x0, [], [], [], [], lb, ub, ...
                        @(x) nonlcon(x,user_pos,H,K,GAMMA,D_0,P_T,P_N,BW,Rmin), ...
                        opts);
uav_pos_opt =   reshape(x_opt, 2, N).'; % Builds from a flat coordinates vector a 2D matrix with the first row being the x-coordinates and the second row being the y-coordinates.


fprintf('Optimized UAV positions (meters):\n');
format short g         
disp(uav_pos_opt)
