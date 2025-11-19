%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function br = bitrate(P_R, P_N, BW, ASSOCIATION_MATRIX)
% P_r_lin = 10.^(P_R/10);                                 % convert from dBm → mW
% P_n_lin = 10^(P_N/10);                                  % convert from dBm → mW
% SNR = P_r_lin ./ P_n_lin;
% br = (BW .* log2(1 + SNR) ).* ASSOCIATION_MATRIX;       % Bits per seconds
se = SE(P_R, P_N, ASSOCIATION_MATRIX); % bps / Hz
br = BW .* se; % bps
end
