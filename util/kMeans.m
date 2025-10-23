%%
% author: Khalil El Kaaki
% 23/10/2025
%%

function uav_pos = kMeans(user_pos, N, AREA, MAX_ITER, TOL)
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

[M_dim, M] = size(user_pos);
if M_dim ~= 2
    error('user_pos must have dimension 2xM.');
end

side = sqrt(AREA);

centroids = side * rand(2, N);

for iter = 1:MAX_ITER
    prev_centroids = centroids; % Initialize centroids randomly
    
    distance = zeros(M, N);
    for n = 1:N     % For each UAV
        distance(:, n) = sqrt((user_pos(1, :) - centroids(1, n)).^2 + ... % Compute the distance to all users
                              (user_pos(2, :) - centroids(2, n)).^2);
    end
    
    
    [~, assoc] = min(distance, [], 2); % association matrix: Mx1. Assign each user to the closest UAV
    
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
