function [sumlink_mbps_kmeans, sumlink_mbps_grid, sumlink_mbps_random, sumlink_mbps_fm_kmeans, sumlink_mbps_fm_grid, sumlink_mbps_fm_random] = analysis (M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total, Rmin, user_pos)
% 1. Baseline solution (K-means)
[uav_pos_kmeans, br_kmeans, sumlink_mbps_kmeans] = kMeansSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);

figure;
subplot(1, 2, 1);
scatter(user_pos(1, :), user_pos(2, :), 'b', 'filled');
hold on;
scatter(uav_pos_kmeans(1, :), uav_pos_kmeans(2, :), 'r', 'filled');
title(['Users and K-Means UAV Locations (N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
legend('Users', 'UAVs');
grid on;

subplot(1, 2, 2);
bar(br_kmeans(:));
title(['K-Means Bit Rate per User (N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('User Index');
ylabel('Baseline Bit Rate (bps)');
grid on;

% 2. Another baseline: grid placement
[uav_pos_grid, br_grid, sumlink_mbps_grid] = gridSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, BW_total);

figure;
subplot(1, 2, 1);
scatter(user_pos(1, :), user_pos(2, :), 'b', 'filled');
hold on;
scatter(uav_pos_grid(1, :), uav_pos_grid(2, :), 'r', 'filled');
title(['Users and Grid UAV Locations (N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
legend('Users', 'UAVs');
grid on;

subplot(1, 2, 2);
bar(br_grid(:));
title(['Grid Bit Rate per User (N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('User Index');
ylabel('Baseline Bit Rate (bps)');
grid on;

% 3. Another baseline: Random UAV positions
[uav_pos_random, baseline_br, sumlink_mbps_random] = randomSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, BW_total, Rmin);

figure;
subplot(1, 2, 1);
scatter(user_pos(1, :), user_pos(2, :), 'b', 'filled');
hold on;
scatter(uav_pos_random(1, :), uav_pos_random(2, :), 'r', 'filled');
title(['Users and Random UAV Locations (N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
legend('Users', 'UAVs');
grid on;

subplot(1, 2, 2);
bar(baseline_br(:));
title(['Random Bit Rate per User (N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('User Index');
ylabel('Baseline Bit Rate (bps)');
grid on;

% 4. Optimize UAV positions (Global Search, built on top of fmincon)
uav_pos_gs_kmeans   = optimizeUAVPositions(N, AREA, uav_pos_kmeans, user_pos, H_M, H, F, P_T, P_N, BW_total, Rmin); % Outputs Nx2 matrix
uav_pos_gs_grid     = optimizeUAVPositions(N, AREA, uav_pos_grid, user_pos, H_M, H, F, P_T, P_N, BW_total, Rmin); % Outputs Nx2 matrix
uav_pos_gs_random   = optimizeUAVPositions(N, AREA, uav_pos_random, user_pos, H_M, H, F, P_T, P_N, BW_total, Rmin); % Outputs Nx2 matrix

% 5. Optimize Bandwidth allocation (fmincon)
uav_pos_gs_kmeans = uav_pos_gs_kmeans.';   % now 2×N (transpose)
uav_pos_gs_grid = uav_pos_gs_grid.';
uav_pos_gs_random = uav_pos_gs_random.';
[~, br_kmeans, sumlink_mbps_fm_kmeans]   = optimizeBandwidthAllocation(M, BW_total, user_pos, uav_pos_gs_kmeans, H_M, H, F, P_T, P_N, Rmin);
[~, br_grid, sumlink_mbps_fm_grid]       = optimizeBandwidthAllocation(M, BW_total, user_pos, uav_pos_gs_grid, H_M, H, F, P_T, P_N, Rmin);
[~, br_random, sumlink_mbps_fm_random]   = optimizeBandwidthAllocation(M, BW_total, user_pos, uav_pos_gs_random, H_M, H, F, P_T, P_N, Rmin);

figure;

subplot(1, 2, 1);
scatter(user_pos(1,:), user_pos(2,:), 'b', 'filled');
hold on;
scatter(uav_pos_gs_kmeans(1,:), uav_pos_gs_kmeans(2,:), 'r', 'filled');
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
title(['User and Optimized UAV Positions (K-Means Starting Point, N = ' num2str(N) ', H = ' num2str(H) ')']);
legend('Users', 'UAVs');
grid on;
hold off;

subplot(1, 2, 2);
bar(br_kmeans);
title(['Optimized Bit Rate per User (K-means Starting Point, N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('User Index');
ylabel('Bit Rate (bps)');
grid on;

figure;

subplot(1, 2, 1);
scatter(user_pos(1,:), user_pos(2,:), 'b', 'filled');
hold on;
scatter(uav_pos_gs_grid(1,:), uav_pos_gs_grid(2,:), 'r', 'filled');
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
title(['User and Optimized UAV Positions (Grid Starting Points, N = ' num2str(N) ', H = ' num2str(H) ')']);
legend('Users', 'UAVs');
grid on;
hold off;

subplot(1, 2, 2);
bar(br_grid);
title(['Optimized Bit Rate per User (Grid Starting Points, N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('User Index');
ylabel('Bit Rate (bps)');
grid on;

figure;

subplot(1, 2, 1);
scatter(user_pos(1,:), user_pos(2,:), 'b', 'filled');
hold on;
scatter(uav_pos_gs_random(1,:), uav_pos_gs_random(2,:), 'r', 'filled');
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
title(['User and Optimized UAV Positions (Random Starting Points, N = ' num2str(N) ', H = ' num2str(H) ')']);
legend('Users', 'UAVs');
grid on;
hold off;

subplot(1, 2, 2);
bar(br_random);
title(['Optimized Bit Rate per User (Random Starting Points, N = ' num2str(N) ', H = ' num2str(H) ')']);
xlabel('User Index');
ylabel('Bit Rate (bps)');
grid on;

% fprintf('--------------------------------------------------\n');
% fprintf(' BASELINE SOLUTIONS \n');
% fprintf('--------------------------------------------------\n');
% fprintf('Sum of k-means bit rate: %.2f Mbps.\n', sumlink_mbps_kmeans);
% fprintf('Sum of grid-placement bit rate: %.2f Mbps.\n', sumlink_mbps_grid);
% fprintf('Sum of random-placement bit rate: %.2f Mbps.\n', sumlink_mbps_random);
% fprintf('--------------------------------------------------\n');
% fprintf(' OPTIMIZED SOLUTIONS \n');
% fprintf('--------------------------------------------------\n');
% fprintf('Sum of k-mens bit rate after optimization: %.2f Mbps\n', sumlink_mbps_fm_kmeans);
% fprintf('Sum of grid-placement bit rate after optimization: %.2f Mbps\n', sumlink_mbps_fm_grid);
% fprintf('Sum of random-placement bit rate after optimization: %.2f Mbps\n', sumlink_mbps_fm_random);
% fprintf('--------------------------------------------------\n');
end