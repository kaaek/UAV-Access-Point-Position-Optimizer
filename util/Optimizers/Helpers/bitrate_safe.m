function R_safe = bitrate_safe(P_r, P_N, B, A)
    R_raw =     bitrate(P_r, P_N, B, A);     % call existing helper
    R_safe =    max(R_raw, 1e-9);           % clamp minimum to 1e-9
end