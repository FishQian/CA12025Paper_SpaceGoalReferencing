function plotSingleRepresentation_crossV(map1, map2, isNormalization, mapName, varargin)

% use map1 index to plot map2 representation
map = map1
[mx, ii] = max(map, [], 1, 'omitnan')
[ii_sort, sortIdx] = sort(ii);
map_sort = map2(:, sortIdx);

if isNormalization
    
    map_sort = map_sort ./ max(map_sort, [], 1, 'omitnan')
    
end

figure;
h = imagesc(map_sort', [0 1]); 
% colormap gray;
% x = gray
% colormap(flipud(x))
% colormap(parula(5))
colormap jet
xticks([14 39]); xticklabels({'50cm', '140cm'})
ylabel('place cell index')
if size(varargin,1) >0
title([mapName, ', day:', varargin{1}])
else
    title([mapName])
end
ax = gca; ax.FontSize = 15;
xticks([1 25 50]); xticklabels({'0', '90', '180'}); box off; set(gca, 'FontSize', 15); 
yticks([1 size(map2, 2)]);set(gca,'TickDir','out'); 
ax = gca; ax.XAxis.FontWeight = 'bold'; ax.YAxis.FontWeight = 'bold'
colorbar
end