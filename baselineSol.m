%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%% 

function [uav_pos, user_pos] = baselineSol(M,N,AREA,H,K,GAMMA,D_0,P_T,P_N,MAX_ITER,TOL,BW)
user_pos        = AREA * rand(2, M);
uav_pos         = kMeans(user_pos, N, AREA, MAX_ITER, TOL);
p_r             = p_received(user_pos, uav_pos, H, K, GAMMA, D_0, P_T);
a               = assoc(p_r);
baseline_br     = bitrate(p_r, P_N, (BW/M), a);
sumlink = sum(baseline_br);

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

fprintf('Sum of baseline bit rates: %.2f Mbps.\n', sumlink);
end