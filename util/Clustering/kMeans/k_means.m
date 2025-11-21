%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function uav_pos = k_means(user_pos, N, AREA, MAX_ITER, TOL)
% kMeans - Places UAVs based on user positions using k-means clustering
%
% Inputs:
%   user_pos - 2xM matrix of user positions (x_m, y_m)
%   N - Number of UAVs/clusters
%   AREA - Total area (assumes square: AREA = side^2)
%   MAX_ITER - Maximum number of iterations
%   tol - Convergence tolerance
%
% Outputs:
%   uav_pos - 2xN matrix of UAV positions

M = size(user_pos, 2);
if size(user_pos, 1) ~= 2
    error('user_pos must have dimension 2xM.');
end

side = sqrt(AREA);

centroids = side * rand(2, N);

for iter = 1:MAX_ITER
    prev_centroids = centroids;
    
    % Vectorized distance computation: (Mx1) - (1xN) broadcasts to MxN
    dx = user_pos(1, :)' - centroids(1, :);  % Mx1 - 1xN = MxN
    dy = user_pos(2, :)' - centroids(2, :);  % Mx1 - 1xN = MxN
    distance = sqrt(dx.^2 + dy.^2);          % MxN
    
    [~, assoc] = min(distance, [], 2);       % Mx1: assign each user to closest UAV
    
    % Update centroids based on new association
    for n = 1:N
        connectedUsers = find(assoc == n);
        if ~isempty(connectedUsers)
            centroids(:, n) = mean(user_pos(:, connectedUsers), 2);
        else
            centroids(:, n) = side * rand(2, 1); % Retry by reinitializing
        end
    end
    
    if max(sqrt(sum((centroids - prev_centroids).^2, 1))) < TOL
        break;
    end
end

uav_pos = centroids; % 2xN
end
