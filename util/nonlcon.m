%%
% author: Khalil El Kaaki & Joe Abi Samra
%
%%

function [c, ceq] = nonlcon(x, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin)
% nonlcon - Nonlinear constraint function for optimization
%
% Syntax: [c, ceq] = nonlcon(x, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW, Rmin)
%
% Inputs:
%   x       - Optimization variable vector containing UAV positions (2*N elements)
%   user_pos - Matrix of user positions (2 x M)
%   H       - Height of the base station (UAV) in meters.
%   K       - Pathloss Constant (dB)
%   GAMMA   - Path loss exponent
%   D_0     - Reference distance (m)
%   P_T     - Transmit power (dBm)
%   P_N     - Noise power (dBm)
%   BW      - Bandwidth (MHz)
%   Rmin    - Minimum required rate for users (Mbps)
%
% Outputs:
%   c       - Inequality constraints (Rmin - r <= 0)
%   ceq     - Equality constraints (not used, returns empty)
%
% Description:
% This function computes the nonlinear constraints for an optimization problem
% involving UAV positioning to ensure that the rate received by each user meets
% a specified minimum requirement. The function calculates the received power,
% signal-to-noise ratio (SNR), and the achievable rate for each user based on
% the positions of the UAVs and the given parameters. The output constraints
% are used in optimization routines to guide the search for optimal UAV locations.

% reshape UAVs coordinate matrix
N = numel(x)/2;
uav_pos = reshape(x, 2, N);

% received "power" matrix 
p_r_raw = p_received(user_pos, uav_pos, H, K, GAMMA, D_0, P_T);   % users x UAVs

% Convert to linear Watts safely
% Case A: p_r_raw is in dBm (typical: negatives like -80 dBm)
% Case B: p_r_raw is complex channel gain -> use |.|^2 (power)
% Case C: p_r_raw already in Watts (nonnegative real) -> use as-is
if ~isreal(p_r_raw)
    % complex -> assume channel gain; convert to power (relative), then scale by Tx if needed
    p_r_lin = abs(p_r_raw).^2;   % nonnegative
elseif any(p_r_raw(:) <= 0)      
    
    p_r_lin = 10.^((p_r_raw - 30)/10);
else
    
    p_r_lin = p_r_raw;
end

% one-hot association on the same metric used for rate 
A = assoc(p_r_lin);                        % users x UAVs, one '1' per row
Pr_sel = sum(p_r_lin .* A, 2);             % selected link power per user (Watts)
Pr_sel = max(Pr_sel, realmin);             % avoid zeros

%  noise & bandwidth (units) 
Pn_W  = 10.^((P_N - 30)/10);               % dBm -> Watts
BW_Hz = BW * 1e6;
Kusers = size(user_pos, 2);
b_k   = (BW_Hz / Kusers) * ones(Kusers,1); % per-user bandwidth share

% SNR and rate (REAL) 
SNR = Pr_sel ./ max(Pn_W, realmin);        % >= 0
r   = b_k .* log2(1 + SNR);                % guaranteed real

%  QoS inequality: r >= Rmin  ->  Rmin - r <= 0 
c   = Rmin - r;
ceq = [];
end
