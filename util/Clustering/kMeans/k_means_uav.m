%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%% 

function [uav_pos, rate, sumlink_mbps] = k_means_uav(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW)
uav_pos         = k_means(user_pos, N, AREA, MAX_ITER, TOL);         % 2xN matrix in meters
p_r             = p_received(user_pos, uav_pos, H_M, H, F, P_T);    % MxN matrix in dBm
a               = association(p_r);
rate            = sum(bitrate(p_r, P_N, (BW/M), a),2);              % MxN matrix in bps
sumlink         = sum(rate);
sumlink_mbps    = sumlink/1e6;                                      % scalar
end