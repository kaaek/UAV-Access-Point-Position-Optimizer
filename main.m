% % 
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
% To-Do: consider calculating the confidence interval before sweeping.
% -----------------------------------------------------------------------
% DO NOT CHANGE BELOW THIS LINE
clc, clearvars % For proper reset at each run
% Dependencies (keep!):
addpath("util\")
addpath("util\Plotter");
addpath("util\Common");
addpath("util\Optimizers");
addpath("util\Optimizers\Helpers");
addpath("util\Clustering\kMeans");
addpath("util\Clustering\Hierarchical");
profile on;
% -----------------------------------------------------------------------
% Bechmark suite init:
[M, N, AREA, H, H_M, F, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW_total, R_MIN, SIDE, TRIALS] = constants(); % TO-DO: add DATA and computational constants to constants.m
[N_vals, M_vals, BW_vals, P_t_vals, Rmin_vals, Area_vals] = benchmark_vals();
% -----------------------------------------------------------------------
% Precompute user positions:
user_pos_trials = cell(1, TRIALS);
for j = 1:TRIALS
    rng(j);
    user_pos_trials{j} = SIDE * rand(2, M);
end
% Common arrays
trials_kmeans_ref       = zeros(1, TRIALS);
trials_kmeans_opt       = zeros(1, TRIALS);
trials_hier_ref         = zeros(1, TRIALS);
trials_hier_opt         = zeros(1, TRIALS);
% -----------------------------------------------------------------------
% N Sweep
sumrate_kmeans_ref_arr  = zeros(1, length(N_vals));
sumrate_kmeans_opt_arr  = zeros(1, length(N_vals));
sumrate_hier_ref_arr    = zeros(1, length(N_vals));
sumrate_hier_opt_arr    = zeros(1, length(N_vals));
for i = 1:length(N_vals)
    n = N_vals(i);
    for j = 1:TRIALS
        user_pos = user_pos_trials{j};
        % K-means Clustering
        [uav_pos_kmeans, ~, sumrate]        = k_means_uav(user_pos, M, n, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
        trials_kmeans_ref(1,j)              = sumrate;
        % Optimize from k-means initial position
        [uav_pos_opt_kmeans, ~, ~, sumrate] = optimize_network(M, n, uav_pos_kmeans, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
        trials_kmeans_opt(1,j)              = sumrate;
        
        % b. Hierarchical Clustering
        [uav_pos_hier, ~, sumrate]          = hierarchical_uav(user_pos, n, H_M, H, F, P_T, P_N, BW_total);
        trials_hier_ref(1,j)                = sumrate;
        % Optimize from hierarchical initial position
        [uav_pos_opt_hier, ~, ~, sumrate]   = optimize_network(M, n, uav_pos_hier, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
        trials_hier_opt(1,j)                = sumrate;
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
plot_sweep (N_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Number of UAVs (N)', 'Variation of the Sum Rate Relative to the Number of UAVs')

% % M Sweep
% sumrate_kmeans_ref_arr  = zeros(1, length(M_vals));
% sumrate_kmeans_opt_arr  = zeros(1, length(M_vals));
% sumrate_hier_ref_arr    = zeros(1, length(M_vals));
% sumrate_hier_opt_arr    = zeros(1, length(M_vals));
% 
% for i = 1:length(M_vals)
%     m = M_vals(i);
%     for j = 1:TRIALS
%         user_pos = user_pos_trials{j};
%         % K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = k_means_uav(user_pos, m, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         % Optimize from k-means initial position
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimize_network(m, N, uav_pos_kmeans, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;
%
%         % Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchical_uav(user_pos, N, H_M, H, F, P_T, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         % Optimize from hierarchical initial position
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimize_network(m, N, uav_pos_hier, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref       = zeros(1, TRIALS);
%     trials_kmeans_opt       = zeros(1, TRIALS);
%     trials_hier_ref         = zeros(1, TRIALS);
%     trials_hier_opt         = zeros(1, TRIALS);
% end
% plot_sweep (M_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Number of Users (M)', 'Variation of the Sum Rate Relative to the Number of Users')
% 
% % BW Sweep
% sumrate_kmeans_ref_arr  = zeros(1, length(BW_vals));
% sumrate_kmeans_opt_arr  = zeros(1, length(BW_vals));
% sumrate_hier_ref_arr    = zeros(1, length(BW_vals));
% sumrate_hier_opt_arr    = zeros(1, length(BW_vals));
% 
% for i = 1:length(BW_vals)
%     bw = BW_vals(i);
%     for j = 1:TRIALS
%         user_pos = user_pos_trials{j};
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = k_means_uav(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, bw);
%         trials_kmeans_ref(1,j)              = sumrate;
%         % Optimize from k-means initial position
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimize_network(M, N, uav_pos_kmeans, bw, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;

%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchical_uav(user_pos, N, H_M, H, F, P_T, P_N, bw);
%         trials_hier_ref(1,j)                = sumrate;
%         % Optimize from hierarchical initial position
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimize_network(M, N, uav_pos_hier, bw, AREA, user_pos, H_M, H, F, P_T, P_N, R_MIN);
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
% plot_sweep (BW_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Total Bandwidth (Hz)', "Variation of the Sum Rate Relative to the Total Bandwidth")
% 
% % P_t sweep
% sumrate_kmeans_ref_arr  = zeros(1, length(P_t_vals));
% sumrate_kmeans_opt_arr  = zeros(1, length(P_t_vals));
% sumrate_hier_ref_arr    = zeros(1, length(P_t_vals));
% sumrate_hier_opt_arr    = zeros(1, length(P_t_vals));
% 
% for i = 1:length(P_t_vals)
%     p_t = P_t_vals(i);
%     for j = 1:TRIALS
%         user_pos = user_pos_trials{j};
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = k_means_uav(user_pos, M, N, AREA, H_M, H, F, p_t, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         % Optimize from k-means initial position
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimize_network(M, N, uav_pos_kmeans, bw, AREA, user_pos, H_M, H, F, p_t, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;

%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchical_uav(user_pos, N, H_M, H, F, p_t, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         % Optimize from hierarchical initial position
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimize_network(M, N, uav_pos_hier, bw, AREA, user_pos, H_M, H, F, p_t, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref       = zeros(1, TRIALS);
%     trials_kmeans_opt       = zeros(1, TRIALS);
%     trials_hier_ref         = zeros(1, TRIALS);
%     trials_hier_opt         = zeros(1, TRIALS);
% end
% plot_sweep (P_t_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Transmit Power (dBm)', "Variation of the Sum Rate Relative to the Transmit Power")
% 
% % R_min sweep
% sumrate_kmeans_ref_arr  = zeros(1, length(Rmin_vals));
% sumrate_kmeans_opt_arr  = zeros(1, length(Rmin_vals));
% sumrate_hier_ref_arr    = zeros(1, length(Rmin_vals));
% sumrate_hier_opt_arr    = zeros(1, length(Rmin_vals));
% 
% for i = 1:length(Rmin_vals)
%     Rmin = Rmin_vals(i);
%     for j = 1:TRIALS
%         user_pos = user_pos_trials{j};
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = k_means_uav(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         % Optimize from k-means initial position
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimize_network(M, N, uav_pos_kmeans, bw, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin);
%         trials_kmeans_opt(1,j)              = sumrate;

%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchical_uav(user_pos, N, H_M, H, F, P_T, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         % Optimize from hierarchical initial position
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimize_network(M, N, uav_pos_hier, bw, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref       = zeros(1, TRIALS);
%     trials_kmeans_opt       = zeros(1, TRIALS);
%     trials_hier_ref         = zeros(1, TRIALS);
%     trials_hier_opt         = zeros(1, TRIALS);
% end
% plot_sweep (Rmin_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Minimum QoS (bps)', "Variation of the Sum Rate Relative to the Minimum QoS")
% 
% % Area sweeps
% sumrate_kmeans_ref_arr  = zeros(1, length(Area_vals));
% sumrate_kmeans_opt_arr  = zeros(1, length(Area_vals));
% sumrate_hier_ref_arr    = zeros(1, length(Area_vals));
% sumrate_hier_opt_arr    = zeros(1, length(Area_vals));
% 
% for i = 1:length(Area_vals)
%     area = Area_vals(i);
%     for j = 1:TRIALS
%         user_pos = user_pos_trials{j};
%         % a. K-means Clustering
%         [uav_pos_kmeans, ~, sumrate]        = k_means_uav(user_pos, M, N, area, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW_total);
%         trials_kmeans_ref(1,j)              = sumrate;
%         % Optimize from k-means initial position
%         [uav_pos_opt_kmeans, ~, ~, sumrate] = optimize_network(M, N, uav_pos_kmeans, bw, area, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_kmeans_opt(1,j)              = sumrate;

%         % b. Hierarchical Clustering
%         [uav_pos_hier, ~, sumrate]          = hierarchical_uav(user_pos, N, H_M, H, F, P_T, P_N, BW_total);
%         trials_hier_ref(1,j)                = sumrate;
%         % Optimize from hierarchical initial position
%         [uav_pos_opt_hier, ~, ~, sumrate]   = optimize_network(M, N, uav_pos_hier, bw, area, user_pos, H_M, H, F, P_T, P_N, R_MIN);
%         trials_hier_opt(1,j)              = sumrate;
%     end
%     sumrate_kmeans_ref_arr(1,i) = mean(trials_kmeans_ref);
%     sumrate_kmeans_opt_arr(1,i) = mean(trials_kmeans_opt);
%     sumrate_hier_ref_arr(1,i)   = mean(trials_hier_ref);
%     sumrate_hier_opt_arr(1,i)   = mean(trials_hier_opt);
%     trials_kmeans_ref       = zeros(1, TRIALS);
%     trials_kmeans_opt       = zeros(1, TRIALS);
%     trials_hier_ref         = zeros(1, TRIALS);
%     trials_hier_opt         = zeros(1, TRIALS);
% end
% plot_sweep (Area_vals, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, 'Area (m^2)', "Variation of the Sum Rate Relative to the Area")

% DO NOT CHANGE BELOW THIS LINE
% -----------------------------------------------------------------------
profile off;
profile viewer;