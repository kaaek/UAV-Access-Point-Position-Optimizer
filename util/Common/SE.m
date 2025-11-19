function se = SE(P_R, P_N, ASSOCIATION_MATRIX)
% Calculates the spectral efficiency (bps / Hz) → MxN matrix
% Assuming P_r and P_n is in dBm
P_r_lin = 10.^(P_R/10);     % MxN
P_n_lin = 10^(P_N/10);      % scalar
SNR = P_r_lin ./ P_n_lin;   % MxN
se = log2(1 + SNR) .* ASSOCIATION_MATRIX; % MxN
end