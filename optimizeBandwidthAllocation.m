function [B_opt, br_opt] = optimizeBandwidthAllocation(M, BW_total, user_pos, opt_uav_pos, H, K, GAMMA, D_0, P_T, P_N, Rmin)

B0 = ones(M,1) * (BW_total / M);    % fmincon's initial guess: uniform bandwidth allocation, Hz
lb = zeros(M,1);                    % Lower bound, bps
ub = ones(M,1) * BW_total;          % Upper bound: no user gets more than total BW, bps
p_r = p_received(user_pos, opt_uav_pos, H, K, GAMMA, D_0, P_T);
a = assoc(p_r);

obj = @(B) -1*sum(bitrate(p_r, P_N, B, a));

A = ones(1,M);
b = BW_total; % Hz
nonlcon = @(B) qosConstraint(   bitrate(p_r, P_N, B, a), ...
                                Rmin);

% opts = optimoptions('fmincon','Algorithm','interior-point','Display','iter');
opts = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter', ...
    'MaxIterations', 1000, ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-12, ...
    'OptimalityTolerance', 1e-6);
B_opt = fmincon(obj, B0, A, b, [], [], lb, ub, nonlcon, opts);

% Calculate the resulting bitrate (due to optimal bandwidth allocation)
p_r = p_received(user_pos, opt_uav_pos, H, K, GAMMA, D_0, P_T); % dBm
a = assoc(p_r);
br_opt = bitrate(p_r, P_N, B_opt, a); % bps
sum_br_opt = sum(br_opt);
fprintf('Sum of bit rates after optimization: %.2f Mbps\n', sum_br_opt/1e6);

figure;
bar(br_opt);
title('Optimized Bit Rate per User');
xlabel('User Index');
ylabel('Bit Rate (bps)');
grid on;

figure;
bar(B_opt);
title('Optimized Bandwidth Allocation per User');
xlabel('User Index');
ylabel('Bandwidth (Hz)');
grid on;
end
