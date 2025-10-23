%%
% author: Khalil El Kaaki
% 23/10/2025
%%

clc, clearvars
addpath("util\");

rng(42);                % Generator seed

M           = 50;        % Users
N           = 5;        % UAVs
AREA        = 2000;
H           = 100;      % meters
K           = 30;
GAMMA       = 3;
D_0         = 1;
P_T         = 30;       % dBm
P_N         = 2;        % dBm
MAX_ITER    = 50;
TOL         = 1e-3;     % Tolerance for k-means convergence
BW          = 40;       % MHz

user_pos        = AREA * rand(2, M);
uav_pos         = kMeans(user_pos, N, AREA, MAX_ITER, TOL);
p_r             = p_received(user_pos, uav_pos, H, K, GAMMA, D_0, P_T);
a               = assoc(p_r);
baseline_br     = bitrate(p_r, P_N, (BW/M), a)*1e6;
sumlink         = sum(baseline_br);

% Scatter plot for UAVs and users
figure;
scatter(user_pos(1, :), user_pos(2, :), 'b', 'filled'); % Users in blue
hold on;
scatter(uav_pos(1, :), uav_pos(2, :), 'r', 'filled'); % UAVs in red
title('Scatter Plot of Users and UAVs');
xlabel('X Position');
ylabel('Y Position');
legend('Users', 'UAVs');
grid on;

% Plot baseline_br vs user
figure;
bar(baseline_br(:));
title('Baseline Bit Rate per User');
xlabel('User Index');
ylabel('Baseline Bit Rate (bps)');
grid on;

fprintf('Sum of baseline bit rates: %.2f\n', sumlink);

