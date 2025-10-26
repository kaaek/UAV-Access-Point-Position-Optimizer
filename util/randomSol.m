function [uav_pos, baseline_br, sumlink_mbps] = randomSol(user_pos, M, N, AREA, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin)
side = ceil(sqrt(AREA));
lb = repelem([0;0], N);
ub = repelem([side;side], N);

best_f = inf;
best_x = [];

opts = optimoptions('fmincon', ...
  'Algorithm','interior-point', ...
  'Display','none', ...
  'MaxIterations', 50, ...
  'MaxFunctionEvaluations', 5e5, ...
  'StepTolerance', 1e-6, ...
  'OptimalityTolerance', 1e-3);


% Objective Function
br = @(x) bitrate( ...
                       p_received(user_pos, reshape(x,2,N), H, K, GAMMA, D_0, P_T), ...
                       P_N, ...
                       BW/size(user_pos,2), ...
                       assoc(p_received(user_pos, reshape(x,2,N), H, K, GAMMA, D_0, P_T)) ...
                     );
objective_fn = @(br) -sum(log(br)); % proportional fairness
obj = @(x) objective_fn(br(x));

for i = 1:10  % 10 random starts
    x0 = lb + (ub - lb).*rand(size(lb));  % random initial point
    [x, fval] = fmincon(obj, x0, [], [], [], [], lb, ub, @(x) nonlcon(x,user_pos, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin), opts);
    if fval < best_f
        best_f = fval;
        best_x = x;
    end
end

uav_pos         = reshape(best_x, 2, N);
p_r             = p_received(user_pos, uav_pos, H, K, GAMMA, D_0, P_T); % dBm
a               = assoc(p_r);
baseline_br     = bitrate(p_r, P_N, (BW/M), a);                         % bps
sumlink         = sum(baseline_br);

sumlink_mbps = sumlink/1e6;
end