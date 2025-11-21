function [bw_needed, feasible] = init_bandwidth(user_pos, uav_pos, assoc, Rmin, BW_total, H_M, H, F, P_T, P_N)
    M = size(user_pos,2);

    % Spectral efficiencies: MxN matrix
    Pr = p_received(user_pos, uav_pos, H_M, H, F, P_T);
    SE_matrix = log2(1 + Pr ./ P_N);    % bits/s/Hz, MxN

    % For each user, find the UAV they're associated with
    % assoc is MxN binary matrix, so find which column is 1 for each row
    [user_indices, uav_indices] = find(assoc);
    
    % Extract SE values for associated (user, UAV) pairs
    se_values = SE_matrix(sub2ind(size(SE_matrix), user_indices, uav_indices));
    
    % Calculate bandwidth requirements: Rmin / SE
    bw_req = zeros(M, 1);
    bw_req(user_indices) = Rmin ./ se_values;

    bw_needed = bw_req;
    feasible  = (sum(bw_req) <= BW_total);
end
