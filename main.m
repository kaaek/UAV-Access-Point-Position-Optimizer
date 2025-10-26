%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%

clc, clearvars
addpath("util\");

rng(42);                % Generator seed

M           = 50;       % Users
N           = 5;        % UAVs
AREA        = 9000000;    % meters squared
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
Rmin        = 0.2E6;    % Set minimum bit rate
user_pos    = ceil(sqrt(AREA)) * rand(2, M); 

% 1. N sweep
N_vals = [2 3 4 5 6 8 10];
sumlink_mbps_kmeans_arr = zeros(length(N_vals), 1);
sumlink_mbps_grid_arr = zeros(length(N_vals), 1);
sumlink_mbps_random_arr = zeros(length(N_vals), 1);
sumlink_mbps_fm_kmeans_arr = zeros(length(N_vals), 1);
sumlink_mbps_fm_grid_arr = zeros(length(N_vals), 1);
sumlink_mbps_fm_random_arr = zeros(length(N_vals), 1);
for i = 1:length(N_vals)
    n = N_vals(i);
    % [sumlink_mbps_kmeans, sumlink_mbps_grid, sumlink_mbps_random, sumlink_mbps_fm_kmeans, sumlink_mbps_fm_grid, sumlink_mbps_fm_random] = analysis(M, n, AREA, H, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW_total, Rmin, user_pos);
    [sumlink_mbps_kmeans, sumlink_mbps_grid, sumlink_mbps_random, sumlink_mbps_fm_kmeans, sumlink_mbps_fm_grid, sumlink_mbps_fm_random] = analysis(M, n, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total, Rmin, user_pos);
    sumlink_mbps_kmeans_arr(1,i) = sumlink_mbps_kmeans;
    sumlink_mbps_grid_arr(1,i) = sumlink_mbps_grid;
    sumlink_mbps_random_arr(1,i) = sumlink_mbps_random;
    sumlink_mbps_fm_kmeans_arr(1,i) = sumlink_mbps_fm_kmeans;
    sumlink_mbps_fm_grid_arr(1,i) = sumlink_mbps_fm_grid;
    sumlink_mbps_fm_random_arr(1,i) = sumlink_mbps_fm_random;
end

figure('Name', 'Variation of Bitrate With Number of UAVs');
hold on;
plot(N_vals, sumlink_mbps_kmeans_arr(1,:), '-o', 'DisplayName', 'K-Means');
plot(N_vals, sumlink_mbps_grid_arr(1,:), '-s', 'DisplayName', 'Grid');
plot(N_vals, sumlink_mbps_random_arr(1,:), '-d', 'DisplayName', 'Random');
plot(N_vals, sumlink_mbps_fm_kmeans_arr(1,:), '-^', 'DisplayName', 'K-Means Optimized');
plot(N_vals, sumlink_mbps_fm_grid_arr(1,:), '-v', 'DisplayName', 'Grid Optimized');
plot(N_vals, sumlink_mbps_fm_random_arr(1,:), '-x', 'DisplayName', 'Random Optimized');
hold off;

title('Bitrate vs Number of UAVs');
xlabel('Number of UAVs (N)');
ylabel('Bitrate (Mbps)');
legend('show');
grid on;

fprintf('--------------------------------------------------\n');
fprintf(' BASELINE SOLUTIONS \n');
fprintf('--------------------------------------------------\n');
fprintf('mean of k-means bit rate: %.2f Mbps.\n', mean(sumlink_mbps_kmeans));
fprintf('mean of grid-placement bit rate: %.2f Mbps.\n', mean(sumlink_mbps_grid));
fprintf('mean of random-placement bit rate: %.2f Mbps.\n', mean(sumlink_mbps_random));
fprintf('--------------------------------------------------\n');
fprintf(' OPTIMIZED SOLUTIONS \n');
fprintf('--------------------------------------------------\n');
fprintf('mean of k-mens bit rate after optimization: %.2f Mbps\n', mean(sumlink_mbps_fm_kmeans));
fprintf('mean of grid-placement bit rate after optimization: %.2f Mbps\n', mean(sumlink_mbps_fm_grid));
fprintf('mean of random-placement bit rate after optimization: %.2f Mbps\n', mean(sumlink_mbps_fm_random));
fprintf('--------------------------------------------------\n');

% % H sweep
% H_vals = [200 300 400 500];
% for i = 1:length(H_vals)
%     h = H_vals(i);
%     analysis(M, N, AREA, H_M, h, F, P_T, P_N, MAX_ITER, TOL, BW_total, Rmin, user_pos);
% end
