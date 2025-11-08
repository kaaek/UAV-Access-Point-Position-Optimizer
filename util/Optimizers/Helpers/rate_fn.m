function R = rate_fn(x, N, SIDE, BW_total, user_pos, H_M, H, F, P_T, P_N)
    uav_xy_norm     = reshape(x(1:2*N), 2, N);
    b_norm          = x(2*N+1:end);
    uav_xy          = uav_xy_norm * SIDE;             % rescale positions
    B               = b_norm * BW_total;                   % rescale bandwidths
    P_r             = p_received(user_pos, uav_xy, H_M, H, F, P_T);
    A               = association(P_r);
    R               = bitrate_safe(P_r, P_N, B, A);
    R               = max(R, [], 2);  % Take the max along each row (user)
end