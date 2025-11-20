function [N_vals, M_vals, BW_vals, P_t_vals, Rmin_vals, Area_vals] = benchmarkVals()
N_vals      = [1 2 6 10 14 18 24 30];
M_vals      = [20 50 100 200 500 700];
BW_vals     = [20e6, 40e6, 80e6, 160e6];
P_t_vals    = [20, 30, 40]; % dBm
Rmin_vals   = [50e3, 200e3, 1e6]; % bps
Area_vals   = [1e6, 4e6, 9e6, 16e6]; % m^2
end