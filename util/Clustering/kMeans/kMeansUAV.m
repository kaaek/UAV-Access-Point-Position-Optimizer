%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%% 

function [uav_pos, baseline_br, sumlink_mbps] = kMeansUAV(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW)
uav_pos         = kMeans(user_pos, N, AREA, MAX_ITER, TOL);         % meters
p_r             = p_received(user_pos, uav_pos, H_M, H, F, P_T);    % dBm
a               = association(p_r);
baseline_br     = sum(bitrate(p_r, P_N, (BW/M), a),2);              % bps
sumlink         = sum(baseline_br);
sumlink_mbps    = sumlink/1e6;
end