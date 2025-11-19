function plotNetwork(user_pos, uav_pos, H_M, H, F, P_T, figTitle)
% Plot UAVs vs Users
figure; 
sgtitle(figTitle);
% subplot(1, 2, 1);
grid off;
scatter(user_pos(1,:), user_pos(2,:), 50, 'b', 'filled'); hold on;
scatter(uav_pos(1,:), uav_pos(2,:), 100, 'r', 'x', 'LineWidth', 2);
legend('Users','UAVs');
xlabel('x [m]');
ylabel('y [m]');
title("Network Map");
% Lines connecting each user to associated UAV
P_r = p_received(user_pos, uav_pos, H_M, H, F, P_T);
A = association(P_r);
[M, ~] = size(A);
for m = 1:M
    n_assoc = find(A(m,:) == 1);
    h = plot([user_pos(1,m), uav_pos(1,n_assoc)], ...
         [user_pos(2,m), uav_pos(2,n_assoc)], 'y--');
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    h.Color = [0.5 0.5 0.5 0.5];
end
% % Plot user bitrates
% subplot(1, 2, 2);
% bar(Rate_opt);
% xlabel('User index');
% ylabel('Rate [bps]');
% title('Rate per User');
% grid on;
% end
