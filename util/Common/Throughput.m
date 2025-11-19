function th = Throughput(OFFLOADING, DATA, bandwidth, USER_POS, uav_pos, H_M, H, F, P_T, P_N, C_M, F_N, F_M)
P_R = p_received(USER_POS, uav_pos, H_M, H, F, P_T);
ASSOCIATION_MATRIX = association(P_R);
T_ul_m = DATA / (bandwidth .* SE(P_R, P_N, ASSOCIATION_MATRIX));
T_comp_m = C_M/ F_N;
T_local_m = C_M/F_M;
OFFLOADING_COMPLEMENT = 1 - OFFLOADING;
th = (DATA * OFFLOADING .* 1/(2 * T_ul_m + T_comp_m)) + (DATA * OFFLOADING_COMPLEMENT .* 1/T_local_m);
end