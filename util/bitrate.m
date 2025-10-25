%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function br = bitrate(P_R, P_N, BW, A)
% BITRATE Calculate the bitrate based on received power, noise power, bandwidth, and channel gains.
% 
%   br = BITRATE(p_r, p_n, BW, a) computes the bitrate in bits per second.
%   Inputs:
%       p_r - Received power in dBm (vector)
%       p_n - Noise power in dBm (scalar)
%       BW  - Bandwidth in Hz (scalar)
%       a   - association (matrix)
%   Outputs:
%       br  - Bitrate in bps (vector)
P_r_lin = 10.^(P_R/10);    % convert from dBm → mW
P_n_lin = 10.^(P_N/10);    % convert from dBm → mW
SNR = sum(P_r_lin .* A, 2) ./ P_n_lin;
br = BW .* log2(1 + SNR); % bps
end
