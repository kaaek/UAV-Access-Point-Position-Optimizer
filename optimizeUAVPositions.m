%%
% author: Khalil El Kaaki & Joe Abi Samra
% 25/10/2025
%%

function uav_pos_opt = optimizeUAVPositions(N, AREA, uav_pos, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin)
% This function optimizes the positions of UAVs to maximize the proportional fairness of the bitrate received by users.
%
% Inputs:
%   N       - Number of UAVs
%   AREA    - Size of the area (2x1 vector specifying the width and height)
%   uav_pos - Initial positions of the UAVs (Nx2 matrix)
%   user_pos - Positions of the users (Mx2 matrix)
%   H       - Channel height
%   K       - Path loss exponent
%   GAMMA   - Minimum required signal-to-noise ratio
%   D_0     - Reference distance for path loss
%   P_T     - Transmit power of the UAVs
%   P_N     - Noise power
%   BW      - Bandwidth available for transmission
%   Rmin    - Minimum required data rate
%
% Outputs:
%   uav_pos_opt - Optimized positions of the UAVs (Nx2 matrix)
%
% Example:
%   uav_pos_opt = optimizeUAVPositions(N, AREA, uav_pos, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin);

% Bounds
lb = repelem([0;0], N);
ub = repelem([AREA;AREA], N);

opts = optimoptions('fmincon', ...
  'Algorithm','interior-point', ...
  'Display','iter', ...
  'MaxIterations', 1000, ...
  'MaxFunctionEvaluations', 5e5, ...
  'StepTolerance', 1e-12, ...
  'OptimalityTolerance', 1e-6);

uav_pos_flat = reshape(uav_pos', [], 1); % Flatten the matrix (needed so that it can be passed to fmincon), now looks like: [x1, y1, x2, y2, ..., xN, yN]

% Objective Function
br = @(x) bitrate( ...
                       p_received(user_pos, reshape(x,2,N), H, K, GAMMA, D_0, P_T), ...
                       P_N, ...
                       BW/size(user_pos,2), ...
                       assoc(p_received(user_pos, reshape(x,2,N), H, K, GAMMA, D_0, P_T)) ...
                     );
objective_fn = @(br) -sum(log(br)); % proportional fairness
obj = @(x) objective_fn(br(x));

% Global Solver
problem = createOptimProblem('fmincon','x0',uav_pos_flat,'objective',obj, ...
                            'lb',lb,'ub',ub,'nonlcon',@(x) nonlcon(x,user_pos,H,K,GAMMA,D_0,P_T,P_N,BW,Rmin), ...
                            'options',opts);
gs = GlobalSearch('Display','iter','MaxTime', 600);
[x_opt,~] = run(gs, problem);

% % fmincon % deprecated
% [x_opt, ~] = fmincon( ...
%                         obj, ...
%                         uav_pos_flat, [], [], [], [], lb, ub, ...
%                         @(x) nonlcon(x,user_pos,H,K,GAMMA,D_0,P_T,P_N,BW,Rmin), ...
%                         opts);

uav_pos_opt = reshape(x_opt, 2, N).'; % Builds from a flat coordinates vector an N x 2 matrix
fprintf('Optimized UAV positions (meters):\n');
format short g         
disp(uav_pos_opt)

figure;
scatter(user_pos(1,:), user_pos(2,:), 'b', 'filled');
hold on;
scatter(uav_pos_opt(:,1), uav_pos_opt(:,2), 'r', 'filled'); % Plot optimized UAV positions
xlabel('X Position (meters)');
ylabel('Y Position (meters)');
title('User and Optimized UAV Positions');
legend('Users', 'UAVs');
grid on;
hold off;
end