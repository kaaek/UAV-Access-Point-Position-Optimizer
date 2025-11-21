%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function a = association(p_r)
% ASSOC - Associates each row of a matrix with the index of its maximum value.
%
% Syntax: 
%   a = assoc(p_r)
%
% Inputs:
%   p_r - A matrix of size MxN where M is the number of rows and N is the number of columns.
%
% Outputs:
%   a - A binary matrix of the same size as p_r, where each row contains a 1 at the index of the maximum value
%       from the corresponding row of p_r, and 0s elsewhere.
%
% Example:
%   p_r = [0.1, 0.5, 0.3; 0.4, 0.2, 0.6];
%   a = assoc(p_r);
%   % a will be [0 1 0; 0 0 1]

[M, N] = size(p_r);
a = zeros(M, N);
[~, index_max] = max(p_r, [], 2);  % Returns Mx1 indices of max values along columns
a(sub2ind(size(a), (1:M)', index_max)) = 1;  % Vectorized assignment
end