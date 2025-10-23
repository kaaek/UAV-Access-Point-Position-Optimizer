%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function br = bitrate(p_r, p_n, BW, a)
% BITRATE Calculate the bitrate based on received power, noise power, bandwidth, and channel gains.
% 
%   br = BITRATE(p_r, p_n, BW, a) computes the bitrate in bits per second.
%   Inputs:
%       p_r - Received power in dBm (vector)
%       p_n - Noise power in dBm (scalar)
%       BW  - Bandwidth in Hz (scalar)
%       a   - association (matrix)
%   Outputs:
%       br  - Bitrate in bits per second (vector)
    P_r_lin = 10.^(p_r/10);    % convert from dBm → mW
    P_n_lin = 10.^(p_n/10);    % convert from dBm → mW
    SNR = sum(P_r_lin .* a, 2) ./ P_n_lin;
    br = BW .* log2(1 + SNR);
end
