
function plotSpeedCorr(MAP, i_group, j_group, i_mouseDay, dayLabel, groupNameLabelPool)

%% trial-to-trial speed correlation
figure; 
stdshade(MAP{i_group}.speedCorr{i_mouseDay}(:, 76:end), 0.25, 'r'); hold on;
stdshade(MAP{j_group}.speedCorr{i_mouseDay}(:, 76:end), 0.25, 'k');
box off; legend('boxoff');
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'Out')
ylim([-0.75 1.0]); yticks(-0.75:0.25:1)
legend('', groupNameLabelPool{i_group}, '', groupNameLabelPool{j_group}, 'Location', 'northeast')
xticks([0 25 50 75 100 125]);
xticklabels({'75', '100', '125', '150', '175', '200'})
xlabel('trial'); ylabel('speed correlation')


%% each section, speed corr box chart
% first group
b11 = MAP{i_group}.speedCorr{i_mouseDay}(:, 76:end);
d11 = []
for i = 1:5
   d11 = [d11, median(b11(:, 1+25*(i-1):25*i), 2, 'omitnan')] 
end

columnIdx = 1:5; columnIdxM = repmat(columnIdx, size(d11,1), 1); columnIdxV = columnIdxM(:);
binEdges = 1:6; bins = {'pre section', 'first section', 'second section', 'third section', 'fourth section'}
groupCC1 = discretize(columnIdxV, binEdges, 'categorical', bins);
% figure; 
% histogram(d11(:,2), 'Normalization', 'probability', 'BinWidth', 0.1); hold on; 
% histogram(d11(:,3), 'Normalization', 'probability', 'BinWidth', 0.1); hold on; 
% histogram(d11(:,5), 'Normalization', 'probability', 'BinWidth', 0.1)
% 


[h1, p1] = kstest2(d11(:,1), d11(:,5))
[h1, p1] = kstest2(d11(:,2), d11(:,5))
[h1, p1] = kstest2(d11(:,3), d11(:,5))
[h1, p1] = kstest2(d11(:,4), d11(:,5))

median(d11, 1, 'omitnan')
groupByColor1 = i_group * ones(size(d11(:)));

% second group


b12 = MAP{j_group}.speedCorr{i_mouseDay}(:, 76:end);
d12 = []
for i = 1:5
   d12 = [d12, median(b12(:, 1+25*(i-1):25*i), 2, 'omitnan')] 
    
end

% figure; 
% histogram(d12(:,2), 'Normalization', 'probability', 'BinWidth', 0.1); hold on; 
% histogram(d12(:,4), 'Normalization', 'probability', 'BinWidth', 0.1)
[h1, p1] = kstest2(d12(:,2), d12(:,5))
[h1, p1] = kstest2(d12(:,3), d12(:,5))
[h1, p1] = kstest2(d12(:,4), d12(:,5))

median(d12, 1, 'omitnan')
[h1, p1] = kstest2(d11(:,1), d12(:,1))

columnIdx = 1:5; columnIdxM = repmat(columnIdx, size(d12,1), 1); columnIdxV = columnIdxM(:);
binEdges = 1:6; bins = {'pre section', 'first section', 'second section', 'third section', 'fourth section'}
groupCC2 = discretize(columnIdxV, binEdges, 'categorical', bins);groupByColor2 = j_group * ones(size(d12(:)));
figure;
bc = boxchart([groupCC1; groupCC2], [d11(:); d12(:)], 'GroupByColor', [groupByColor1; groupByColor2])
legend(groupNameLabelPool{i_group}, groupNameLabelPool{j_group}, 'Location', 'eastoutside')
box off; legend('boxoff');
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'Out')
bc(1).BoxFaceColor = 'r'; bc(1).MarkerColor = 'r'; bc(1).LineWidth = 0.5
bc(2).BoxFaceColor = 'k'; bc(2).MarkerColor = 'k'; bc(2).LineWidth = 0.5
yticks([-1:0.25:1]);

[h1, p1] = kstest2(d11(:,5), d12(:,5))







%% instead of median of section, get all data out
% first group
b11 = MAP{i_group}.speedCorr{i_mouseDay}(:, 76:end);
d11 = []
for i = 1:5
    idx = 1+25*(i-1):25*i;
    d_tmp = b11(:, idx);
    
    d11 = [d11, d_tmp(:)] ;
end

columnIdx = 1:5; columnIdxM = repmat(columnIdx, size(d11,1), 1); columnIdxV = columnIdxM(:);
binEdges = 1:6; bins = {'pre section', 'first section', 'second section', 'third section', 'fourth section'}
groupCC1 = discretize(columnIdxV, binEdges, 'categorical', bins);


[h1, p1] = kstest2(d11(:,1), d11(:,5))
[h1, p1] = kstest2(d11(:,2), d11(:,5))
[h1, p1] = kstest2(d11(:,3), d11(:,5))
[h1, p1] = kstest2(d11(:,4), d11(:,5))


[h1, p1] = ttest2(d11(:,1), d11(:,5))
[h1, p1] = ttest2(d11(:,2), d11(:,5))
[h1, p1] = ttest2(d11(:,3), d11(:,5))
[h1, p1] = ttest2(d11(:,4), d11(:,5))

median(d11, 1, 'omitnan')
groupByColor1 = i_group * ones(size(d11(:)));

% second group


b12 = MAP{j_group}.speedCorr{i_mouseDay}(:, 76:end);
d12 = []
for i = 1:5
     idx = 1+25*(i-1):25*i;
    d_tmp = b12(:, idx);
    
    d12 = [d12, d_tmp(:)] ;
    
end

% figure; 
% histogram(d12(:,2), 'Normalization', 'probability', 'BinWidth', 0.1); hold on; 
% histogram(d12(:,4), 'Normalization', 'probability', 'BinWidth', 0.1)
[h1, p1] = kstest2(d12(:,2), d12(:,5))
[h1, p1] = kstest2(d12(:,3), d12(:,5))
[h1, p1] = kstest2(d12(:,4), d12(:,5))

median(d12, 1, 'omitnan')
[h1, p1] = kstest2(d11(:,1), d12(:,1))

columnIdx = 1:5; columnIdxM = repmat(columnIdx, size(d12,1), 1); columnIdxV = columnIdxM(:);
binEdges = 1:6; bins = {'pre section', 'first section', 'second section', 'third section', 'fourth section'}
groupCC2 = discretize(columnIdxV, binEdges, 'categorical', bins);groupByColor2 = j_group * ones(size(d12(:)));
figure;
bc = boxchart([groupCC1; groupCC2], [d11(:); d12(:)], 'GroupByColor', [groupByColor1; groupByColor2])
legend(groupNameLabelPool{i_group}, groupNameLabelPool{j_group}, 'Location', 'eastoutside')
box off; legend('boxoff');
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'Out')
bc(1).BoxFaceColor = 'r'; bc(1).MarkerColor = 'r'; bc(1).LineWidth = 0.5
bc(2).BoxFaceColor = 'k'; bc(2).MarkerColor = 'k'; bc(2).LineWidth = 0.5
yticks([-1:0.25:1]);

[h1, p1] = kstest2(d11(:,5), d12(:,5))

