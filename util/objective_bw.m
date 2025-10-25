function neg_sum_rate = objective_bw(b, USER_POS, UAV_POS, H, K, GAMMA, D_0, P_T, P_N)
p_r = p_received(USER_POS, UAV_POS, H, K, GAMMA, D_0, P_T);
a = assoc(p_r);
br = bitrate(p_r, P_N, b, a); % Inputs in dBm
neg_sum_rate = -sum(br);
end