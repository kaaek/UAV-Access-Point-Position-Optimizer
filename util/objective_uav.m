function neg_sum_rate = objective_uav(x, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW)
    % objective_uav - Objective function for UAV placement optimization
    %
    % Syntax:  neg_sum_rate = objective_uav(x, user_pos, H, K, GAMMA, D_0, P_T, P_N, BW)
    %
    % Inputs:
    %    x       - A vector containing the coordinates of the UAVs, 
    %              formatted as [x1, y1, x2, y2, ..., xM, yM]
    %    user_pos - A matrix containing the positions of the users, 
    %               where each column represents a user's position.
    %    H       - Channel gain matrix.
    %    K       - Number of users.
    %    GAMMA   - Minimum required signal-to-noise ratio.
    %    D_0     - Reference distance for path loss calculations.
    %    P_T     - Transmit power of the UAVs.
    %    P_N     - Noise power.
    %    BW      - Bandwidth available for communication.
    %
    % Outputs:
    %    neg_sum_rate - Negative sum rate of the bitrates for the users, 
    %                   which is minimized by the optimization algorithm.
    %
    % Description:
    %    This function calculates the negative sum rate of the bitrates 
    %    for users served by UAVs based on their positions. The function 
    %    takes the coordinates of the UAVs and various parameters related 
    %    to the communication environment to compute the received power, 
    %    user association, and ultimately the bitrates. The negative sum 
    %    rate is returned for minimization purposes in optimization routines.
    % assuming the decision variables (coordinates) are passed concatenated
    % like: [x1, y1, x2, y2, ..., xM, yM]

    N       = numel(x)/2; % Therefore the number of UAVs is half the flattened coordinate array
    uav_pos = reshape(x, 2, N); % Reshapes the 1x2N Matrix to a 2xN matrix [[x1...xN]; [y1...yN]]
    p_r     = p_received(user_pos, uav_pos, H, K, GAMMA, D_0, P_T);
    a       = assoc(p_r);
    br      = bitrate(p_r, P_N, BW/size(user_pos,2), a);
    neg_sum_rate = -sum(br);  % fmincon minimizes this



end
