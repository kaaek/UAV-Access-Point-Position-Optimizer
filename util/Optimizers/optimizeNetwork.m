function [uav_pos_opt, Bandwidth_opt, Rate_opt, sumrate_mbps] = optimizeNetwork(M, N, INITIAL_UAV_POS, BW_total, AREA, user_pos, H_M, H, F, P_T, P_N, Rmin)
SIDE = ceil(sqrt(AREA));

% Solver setup

% Optimizer options
solverOptions = optimoptions('fmincon', 'Algorithm','interior-point', ...
  'Display','iter', ...
  'MaxIterations', 10, ...
  'MaxFunctionEvaluations', 1e6, ...
  'StepTolerance', 1e-6, ...
  'OptimalityTolerance', 1e-6);

% Decision Vector
UAV_POS_FLAT_norm = reshape(INITIAL_UAV_POS / SIDE, [], 1);  % divide by SIDE to normalize
INIT_BANDWIDTHS_norm = ones(M,1) / M;                         % normalized sum = 1
decision_vector = [UAV_POS_FLAT_norm; INIT_BANDWIDTHS_norm];
LOWER_BOUND = zeros(2*N + M, 1);
UPPER_BOUND = ones(2*N + M, 1);

% Dimension Check:
nVars = numel(decision_vector);
assert(numel(LOWER_BOUND) == nVars && numel(UPPER_BOUND) == nVars, ...
    'LB/UB must match length(decision_vector). Got %d vs LB=%d, UB=%d', ...
    nVars, numel(LOWER_BOUND), numel(UPPER_BOUND));

% Objective function: proportional fairness, x is a placeholder for the decision vector
objectiveFunction = @(x) -sum(log(max(rate_fn(x, N, SIDE, BW_total, user_pos, H_M, H, F, P_T, P_N),1e-9)));

% Optimization Problem
problem = createOptimProblem('fmincon', ...
    'x0', decision_vector, ...
    'objective', objectiveFunction, ...
    'lb', LOWER_BOUND, ...
    'ub', UPPER_BOUND, ...
    'nonlcon', @(x) nonlcon_joint(x, N, M, user_pos, H_M, H, F, P_T, P_N, BW_total, Rmin, SIDE), ...
    'options', solverOptions);

gs = GlobalSearch('Display','iter','MaxTime',600);
[x_opt] = run(gs, problem);

uav_pos_opt     = reshape(x_opt(1:2*N),2,N)*SIDE;
Bandwidth_opt   = x_opt(2*N+1:end) * BW_total;
Rate_opt        = rate_fn(x_opt, N, SIDE, BW_total, user_pos, H_M, H, F, P_T, P_N);
sumrate_mbps    = sum(Rate_opt)/1e6;
end