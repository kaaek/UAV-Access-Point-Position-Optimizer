%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%% 

function [uav_pos, baseline_br, sumlink_mbps] = kMeansSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW)
% baselineSol - Computes the optimal positions for UAVs and users, and calculates the baseline bit rate.
%
% Syntax: [uav_pos, user_pos] = baselineSol(M, N, AREA, H, K, GAMMA, D_0, P_T, P_N, MAX_ITER, TOL, BW)
%
% Inputs:
%   M       - Number of users
%   N       - Number of UAVs
%   AREA    - Area dimensions (2x1 vector) in meters
%   H       - Height of the UAVs in meters
%   K       - Path loss exponent
%   GAMMA   - Signal-to-noise ratio threshold
%   D_0     - Reference distance in meters
%   P_T     - Transmit power in dBm
%   P_N     - Noise power in dBm
%   MAX_ITER - Maximum number of iterations for k-means
%   TOL     - Tolerance for convergence in k-means
%   BW      - Bandwidth in Hz
%
% Outputs:
%   uav_pos - Positions of the UAVs (2xN matrix) in meters
%   user_pos - Positions of the users (2xM matrix) in meters
%
% Description:
%   This function randomly generates user positions within a specified area,
%   applies k-means clustering to determine optimal UAV positions, and calculates
%   the received power at each user. It then associates users with UAVs and computes
%   the baseline bit rate for each user based on the received power.

uav_pos         = kMeans(user_pos, N, AREA, MAX_ITER, TOL);             % meters
p_r             = p_received(user_pos, uav_pos, H_M, H, F, P_T); % dBm
a               = assoc(p_r);
baseline_br     = bitrate(p_r, P_N, (BW/M), a);                         % bps
sumlink         = sum(baseline_br);

sumlink_mbps = sumlink/1e6;
end