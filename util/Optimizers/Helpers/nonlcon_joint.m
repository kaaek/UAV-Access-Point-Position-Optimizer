function [c, ceq] = nonlcon_joint(x, N, M, user_pos, H_M, H, F, P_T, P_N, BW_total, Rmin, SIDE)
    % Extract normalized variables
    uav_xy_norm = reshape(x(1:2*N), 2, N);
    b_norm = x(2*N+1:end);

    % Rescale to physical units
    uav_xy = uav_xy_norm * SIDE;
    B = b_norm * BW_total;

    % Received power, association, and rate
    P_r = p_received(user_pos, uav_xy, H_M, H, F, P_T);
    A = association(P_r);
    R = sum(bitrate(P_r, P_N, B, A),2);

    % Constraints
    c_qos = Rmin - R;        % QoS constraint: R >= Rmin
    c_bw_norm = sum(b_norm) - 1;  % Bandwidth normalization constraint
    c = [c_qos(:); c_bw_norm];
    ceq = [];
end
