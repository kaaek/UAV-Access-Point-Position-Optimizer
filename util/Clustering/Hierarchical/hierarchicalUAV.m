function [uav_pos_hier, baseline_br, sumlink_mbps] = hierarchicalUAV(user_pos, N, H_M, H, F, P_T)
M = size(user_pos, 2); % user_pos is 2xM
% Compute pairwise distances (Euclidean)
distMat = pdist(user_pos');  % Mx2 -> MxM distances
% Build linkage tree
Z = linkage(distMat, 'ward');  % Ward's method
% Assign users to N clusters
cluster_idx = cluster(Z, 'maxclust', N);  % 1..N for each user
% Compute UAV positions as cluster centroids
uav_pos_hier = zeros(2, N);
for i = 1:N
    members = user_pos(:, cluster_idx == i);
    uav_pos_hier(:, i) = mean(members, 2);
end

p_r             = p_received(user_pos, uav_pos_hier, H_M, H, F, P_T);
a               = association(p_r);
baseline_br     = sum(bitrate(p_r, P_N, (BW/M), a),2); % bps
sumlink         = sum(baseline_br);
sumlink_mbps    = sumlink/1e6;
end
