function plot_sweep (x, sumrate_kmeans_ref_arr, sumrate_kmeans_opt_arr, sumrate_hier_ref_arr, sumrate_hier_opt_arr, xlabelText, figTitle)
figure;
hold on;
plot(x, sumrate_kmeans_ref_arr, '-o', 'DisplayName', 'K-Means Reference');
plot(x, sumrate_kmeans_opt_arr, '-x', 'DisplayName', 'K-Means Optimized');
plot(x, sumrate_hier_ref_arr, '-s', 'DisplayName', 'Hierarchical Reference');
plot(x, sumrate_hier_opt_arr, '-d', 'DisplayName', 'Hierarchical Optimized');
hold off;
xlabel(xlabelText);
ylabel('Sum Rate (bps)');
title(figTitle);
legend show;
grid on;
end