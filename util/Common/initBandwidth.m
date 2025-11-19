function [bw_needed, feasible] = initBandwidth(user_pos, uav_pos, assoc, Rmin, BW_total, H_M, H, F, P_T, P_N)
    M = size(user_pos,2);
    N = size(uav_pos,2);

    % spectral efficiencies:
    Pr = p_received(user_pos, uav_pos, H_M, H, F, P_T);
    SE = log2(1 + Pr ./ P_N);    % bits/s/Hz

    bw_req = zeros(M,1);
    for k = 1:N
        users_k = find(assoc(:,k) == 1); % returns all users connected to UAV N.
        if isempty(users_k)
            continue
        end
        for u = 1:numel(users_k)
            bw_req(u) = Rmin / SE(u);
        end
    end

    bw_needed = bw_req;
    feasible  = (sum(bw_req) <= BW_total);
end
