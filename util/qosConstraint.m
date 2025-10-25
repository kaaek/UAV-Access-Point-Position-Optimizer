%%
% author: Khalil El Kaaki & Joe Abi Samra
%
%%

function [c, ceq] = qosConstraint(br, Rmin)
    c = Rmin - br;      % ensures rates >= Rmin (inequality constraint for fmincon, c should be less than or equal to zero.)
    ceq = [];           % Equality constraints (we have none)
end
