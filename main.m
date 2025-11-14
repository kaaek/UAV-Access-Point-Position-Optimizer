%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%

clc, clearvars
% Dependencies (keep!)
addpath("util\")
addpath("util\Plotter");
addpath("util\Common");
addpath("util\Optimizers");
addpath("util\Optimizers\Helpers");
addpath("util\Clustering\kMeans");
addpath("util\Clustering\Hierarchical");

% user_pos = SIDE * rand(2,M);
% [uav_pos_kmeans, baseline_br, sumlink] = kMeansUAV(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
% plotNetwork(user_pos, uav_pos_kmeans, baseline_br, H_M, H, F, P_T, 'Reference K-Means Clustering');
% % % Optimized K means
% [uav_pos_opt_kmeans, ~, Rate_opt_kmeans] = optimizeNetwork(M, N, uav_pos_kmeans, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin);
% plotNetwork(user_pos, uav_pos_opt_kmeans, Rate_opt_kmeans, H_M, H, F, P_T, 'OPtimized K-Means Clustering');
% % % 
% [uav_pos_hier, baseline_br, ~] = hierarchicalUAV(user_pos, N);
% plotNetwork(user_pos, uav_pos_hier, baseline_br, H_M, H, F, P_T, 'Reference Hierarchy Clustering');
% % % Optimized Hierarchical
% [uav_pos_opt_hier, ~, Rate_opt_hier] = optimizeNetwork(M, N, uav_pos_hier, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin);
% plotNetwork(user_pos, uav_pos_opt_hier, Rate_opt_hier, H_M, H, F, P_T, 'Hierarchy');

[M, N, AREA, H, H_M, F, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW_total, R_MIN, SIDE, TRIALS] = constants();

N_vals      = [1 2 6 10 14 18 24 30];
M_vals      = [20 50 100 200 500 700];
BW_vals     = [20e6, 40e6, 80e6, 160e6];
P_t_vals    = [20, 30, 40]; % dBm
Rmin_vals   = [50e3, 200e3, 1e6]; % bps
Area_vals   = [1e6, 4e6, 9e6, 16e6]; % m^2

sumrate_kmeans_ref_arr  = zeros(1, length(N_vals));
sumrate_kmeans_opt_arr  = zeros(1, length(N_vals));
sumrate_hier_ref_arr    = zeros(1, length(N_vals));
sumrate_hier_opt_arr    = zeros(1, length(N_vals));
trials_kmeans_ref       = zeros(1, TRIALS);
trials_kmeans_opt       = zeros(1, TRIALS);
trials_hier_ref         = zeros(1, TRIALS);
trials_hier_opt         = zeros(1, TRIALS);


% To-Do: confidence interval
for i = 1:length(N_vals)
    n = N_vals(i);
    for j = 1:TRIALS
        rng(j);                         % Renew the seed for each iteration
        user_pos = SIDE * rand(2,M);    % Renew user positions
        % a. K-means Clustering
        [uav_pos_kmeans, ~, sumrate]        = kMeansUAV(user_pos, M, n, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
        trials_kmeans_ref(1,j)              = sumrate;
        [uav_pos_opt_kmeans, ~, ~, sumrate] = optimizeNetwork(M, n, uav_pos_kmeans, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
        trials_kmeans_opt(1,j)              = sumrate;
        % b. Hierarchical Clustering
        [uav_pos_hier, ~, sumrate]          = hierarchicalUAV(user_pos, n, H_M, H, F, P_T, P_N, BW_total);
        trials_hier_ref(1,j)                = sumrate;
        [uav_pos_opt_hier, ~, ~, sumrate]   = optimizeNetwork(M, n, uav_pos_hier, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
        trials_hier_opt(1,j)              = sumrate;
    end
    sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
    sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
    sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
    sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
    trials_kmeans_ref = zeros(1, TRIALS);
    trials_kmeans_opt = zeros(1, TRIALS);
    trials_hier_ref   = zeros(1, TRIALS);
    trials_hier_opt   = zeros(1, TRIALS);
end
plotSweep (N_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Number of UAVs (N)', 'Variation of the Sum Rate Relative to the Number of UAVs')


% for i = 1:length(M_vals)
%     m = M_vals(i);
%     for j = 1:TRIALS
%         rng(j);                         % Renew the seed for each iteration
%         user_pos = SIDE * rand(2,m);    % Renew user positions
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = kMeansUAV(user_pos, m, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimizeNetwork(m, N, uav_pos_kmeans, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;
%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchicalUAV(user_pos, N, H_M, H, F, P_T, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimizeNetwork(m, N, uav_pos_hier, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref = zeros(TRIALS, 1);
%     trials_kmeans_opt = zeros(TRIALS, 1);
%     trials_hier_ref   = zeros(TRIALS, 1);
%     trials_hier_opt   = zeros(TRIALS, 1);
% end
% plotSweep (M_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Number of Users (M)', 'Variation of the Sum Rate Relative to the Number of Users')
% 
% 
% for i = 1:length(BW_vals)
%     bw = BW_vals(i);
%     for j = 1:TRIALS
%         rng(j);                         % Renew the seed for each iteration
%         user_pos = SIDE * rand(2,m);    % Renew user positions
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = kMeansUAV(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, bw);
%         trials_kmeans_ref(1,j)              = sumrate;
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimizeNetwork(M, N, uav_pos_kmeans, bw, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;
%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchicalUAV(user_pos, N, H_M, H, F, P_T, P_N, bw);
%         trials_hier_ref(1,j)                = sumrate;
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimizeNetwork(M, N, uav_pos_hier, bw, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref = zeros(TRIALS, 1);
%     trials_kmeans_opt = zeros(TRIALS, 1);
%     trials_hier_ref   = zeros(TRIALS, 1);
%     trials_hier_opt   = zeros(TRIALS, 1);
% end
% plotSweep (BW_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Total Bandwidth (Hz)', "Variation of the Sum Rate Relative to the Total Bandwidth")
% 
% 
% for i = 1:length(BW_vals)
%     p_t = P_t_vals(i);
%     for j = 1:TRIALS
%         rng(j);                         % Renew the seed for each iteration
%         user_pos = SIDE * rand(2,m);    % Renew user positions
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = kMeansUAV(user_pos, M, N, AREA, H_M, H, F, p_t, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimizeNetwork(M, N, uav_pos_kmeans, bw, AREA, user_pos, H_M, H, F, p_t, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;
%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchicalUAV(user_pos, N, H_M, H, F, p_t, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimizeNetwork(M, N, uav_pos_hier, bw, AREA, user_pos, H_M, H, F, p_t, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref = zeros(TRIALS, 1);
%     trials_kmeans_opt = zeros(TRIALS, 1);
%     trials_hier_ref   = zeros(TRIALS, 1);
%     trials_hier_opt   = zeros(TRIALS, 1);
% end
% plotSweep (P_t_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Transmit Power (dBm)', "Variation of the Sum Rate Relative to the Transmit Power")
% 
% 
% for i = 1:length(Rmin_vals)
%     Rmin = Rmin_vals(i);
%     for j = 1:TRIALS
%         rng(j);                         % Renew the seed for each iteration
%         user_pos = SIDE * rand(2,m);    % Renew user positions
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = kMeansUAV(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimizeNetwork(M, N, uav_pos_kmeans, bw, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin);
%         trials_kmeans_opt(1,j)              = sumrate;
%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchicalUAV(user_pos, N, H_M, H, F, P_T, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimizeNetwork(M, N, uav_pos_hier, bw, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref = zeros(TRIALS, 1);
%     trials_kmeans_opt = zeros(TRIALS, 1);
%     trials_hier_ref   = zeros(TRIALS, 1);
%     trials_hier_opt   = zeros(TRIALS, 1);
% end
% plotSweep (Rmin_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Minimum QoS (bps)', "Variation of the Sum Rate Relative to the Minimum QoS")
% 
% 
% for i = 1:length(Area_vals)
%     area = Area_vals(i);
%     for j = 1:TRIALS
%         rng(j);                         % Renew the seed for each iteration
%         user_pos = SIDE * rand(2,m);    % Renew user positions
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = kMeansUAV(user_pos, M, N, area, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimizeNetwork(M, N, uav_pos_kmeans, bw, area, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;
%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchicalUAV(user_pos, N, H_M, H, F, P_T, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimizeNetwork(M, N, uav_pos_hier, bw, area, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref = zeros(TRIALS, 1);
%     trials_kmeans_opt = zeros(TRIALS, 1);
%     trials_hier_ref   = zeros(TRIALS, 1);
%     trials_hier_opt   = zeros(TRIALS, 1);
% end
% plotSweep (Area_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Area (m^2)', "Variation of the Sum Rate Relative to the Area")