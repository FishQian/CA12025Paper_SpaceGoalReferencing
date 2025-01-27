function h = plotBar_meanSEM(stats, xTickLabel, yLabel, yLimit, varargin)
%% h = plotBar_meanSEM(stats, xTickLabel, yLabel)
% stats is a cell, each represents one variable


h = figure;
[dim1 dim2] = size(stats);
for i_stat = 1:max(dim1, dim2)
    n = length(stats{i_stat});
    meanX = mean(stats{i_stat}, 'omitnan');
    semX1 = std(stats{i_stat}, 'omitnan') / sqrt(n);
    br = bar(i_stat, meanX, 'k'); br.FaceAlpha = 0.2; hold on;
    er = errorbar(i_stat, meanX, semX1, 'o', 'LineWidth', 2, 'MarkerSize',10, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;
    scatter(0.25*(rand(1,n)-0.5) + ones(1,n) * i_stat, stats{i_stat}, 75, 'filled', 'LineWidth', 2); hold on;
    
end
box off
xticks(1:length(stats));
xticklabels(xTickLabel)
ylabel(yLabel); ylim(yLimit)
ax = gca; ax.FontSize = 20;
end