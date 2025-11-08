%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function p_r = p_received(user_pos, uav_pos, H_M, H, F, P_T)
% K, GAMMA, D_0
% p_r - Calculates the received power using the Okumura-Hata model.
% 
% Syntax: p_r = p_r(user_pos, uav_pos, H, K, GAMMA, FREQ, P_T)
%
% Inputs:
%   user_pos - 2xN matrix containing the positions of users (x_m, y_m).
%   uav_pos - 2xM matrix containing the positions of UAVs (x_n, y_n).
%   H - Height of the base station (UAV) in meters.
%   K - Pathloss constant in dB.
%   GAMMA - Path loss exponent.
%   D_0 - Reference distance.
%   P_T - Transmit power in dBm.
%
% Outputs:
%   p_r - Received power at each user in dBm.
%
% Description:
% This function calculates the received power at user locations based on
% the Okumura-Hata model. The received power is computed considering the
% height of the UAV, the frequency of operation, and the urban correction
% factor. The output is given in dBm.
    
if size(user_pos,1) ~= 2
    error('user_pos must be 2xM.');
end
if size(uav_pos,1) ~= 2
    error('uav_pos must be 2xN.');
end

M = size(user_pos, 2); % user_pos(1), user_pos(2) = x_m, y_m
N = size(uav_pos, 2);

x_m = user_pos(1,:); % Vectors
y_m = user_pos(2,:);
x_n = uav_pos(1,:);
y_n = uav_pos(2,:);
p_r = zeros(M, N);
d = zeros(M, N);

for i = 1:M         % For every User
    for j = 1:N     % For every UAV
        dist = sqrt( ...
                            (x_m(i) - x_n(j))^2 + ...
                            (y_m(i) - y_n(j))^2 ...
                            + H^2);         % Euclidian distance
        d(i, j) = dist;
        % L = - K + 10*GAMMA*log10(d(i, j)/D_0);
        C_h = 0.8 + (1.1 * log10(F)-0.7) * H_M - 1.56 * log10(F);
        L_u = 69.55 + 26.16 * log10(F) - 13.82 * log10(H) - C_h + (44.9 - 6.55 * log10(H)) * log10(dist);
        L = L_u - 4.78 * (log10(F))^2 + 18.33 * log10(F) - 40.94;
        p_r(i,j) = P_T - L;                   % dBm
    end
end
end