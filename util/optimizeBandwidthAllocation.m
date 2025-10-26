%%
% author: Khalil El Kaaki & Joe Abi Samra
% 25/10/2025
%%

function [B_opt, br_opt, sum_br_opt_mbps] = optimizeBandwidthAllocation(M, BW_total, user_pos, opt_uav_pos, H_M, H, F, P_T, P_N, Rmin)
%OPTIMIZEBANDWIDTHALLOCATION Optimize bandwidth allocation for users
%   [B_OPT, BR_OPT] = OPTIMIZEBANDWIDTHALLOCATION(M, BW_TOTAL, USER_POS, 
%   OPT_UAV_POS, H, K, GAMMA, D_0, P_T, P_N, RMIN) optimally allocates 
%   bandwidth among M users given the total bandwidth BW_TOTAL. 
%   The function takes into account user positions (USER_POS), the 
%   position of the UAV (OPT_UAV_POS), channel conditions (H), 
%   the number of users (K), the signal-to-noise ratio (GAMMA), 
%   the reference distance (D_0), the transmit power (P_T), 
%   the noise power (P_N), and the minimum required rate (RMIN).
%
%   Outputs:
%   B_OPT - Optimized bandwidth allocation for each user (Hz)
%   BR_OPT - Resulting bit rates for each user (bps)
%
%   Example:
%   [B_opt, br_opt] = optimizeBandwidthAllocation(5, 100e6, user_positions, 
%   uav_position, channel_conditions, num_users, snr_values, reference_distance, 
%   transmit_power, noise_power, min_rate);

B0 = ones(M,1) * (BW_total / M);    % fmincon's initial guess: uniform bandwidth allocation, Hz
lb = zeros(M,1);                    % Lower bound, bps
ub = ones(M,1) * BW_total;          % Upper bound: no user gets more than total BW, bps
A = ones(1,M);
b = BW_total;                       % Hz

p_r = p_received(user_pos, opt_uav_pos, H_M, H, F, P_T);
a = assoc(p_r);

% Objective Function
br = @(B) bitrate(p_r, P_N, B, a);
objective_fn = @(br) -sum(log(br)); % proportional fairness
obj = @(B) objective_fn(br(B));

nonlcon = @(B) qosConstraint(br(B), ...
                             Rmin);
opts = optimoptions('fmincon', ...
  'Algorithm','interior-point', ...
  'Display','none', ...
  'MaxIterations', 50, ...
  'MaxFunctionEvaluations', 5e5, ...
  'StepTolerance', 1e-6, ...
  'OptimalityTolerance', 1e-3);

B_opt = fmincon(obj, B0, A, b, [], [], lb, ub, nonlcon, opts);

% Calculate the resulting bitrate (due to optimal bandwidth allocation)
br_opt = bitrate(p_r, P_N, B_opt, a); % bps
sum_br_opt_mbps = sum(br_opt)/1e6;
end
