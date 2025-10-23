%%
% author: Khalil El Kaaki & Joe Abi Samra
% 23/10/2025
%%
function a = assoc(p_r)
[M, N] = size(p_r);
a = zeros(M, N);
for i = 1:M
    [~, index_max] = max(p_r(i, :));  % Returns the index of the max
    a(i, index_max) = 1;              % Switches the corresponding association value to 1
end
end