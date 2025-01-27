function pie_Bar_chart_PC_finalClean(DataFolder, MAP, i_group, i_mouseDay, i_map, j_map, j_mouseDay, dayLabel, groupNameLabelPool, j_group)



%% on the left plot average aA pie chart
k_group = 5;
totalPlaceCellNum_aA = sum(MAP{k_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map} & MAP{k_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map});


numSpace_aA = sum(nan2false(MAP{k_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{k_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');
fraction_spaceAssociated = numSpace_aA ./ totalPlaceCellNum_aA

numReward_aA = sum(nan2false(MAP{k_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{k_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');
fraction_rewardAssociated = numReward_aA ./ totalPlaceCellNum_aA;

numMix_aA = sum(nan2false(MAP{k_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{k_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');
fraction_neither_space_nor_reward =  numMix_aA./ totalPlaceCellNum_aA;



% on the right 4 columns: light blue and red: aAAA, dark blue and red aABB
% i_group
% novel group
totalPlaceCellNum = sum(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map} & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
% nan free version for each category
% day i_mosueDay
isSpaceIdx_i = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}); % get nan free index for today
isRewardIdx_i = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map});  % get nan free index for today
isMixIdx_i = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}); % get nan free index for today
% day j_mouseDay
isSpaceIdx_j = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{j_mouseDay, j_mouseDay, j_map});
isRewardIdx_j = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{j_mouseDay, j_mouseDay, j_map}); 
isMixIdx_j = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{j_mouseDay, j_mouseDay, j_map}); 


% space associated today
% space associated, where does it come/go from/to

numSpace = sum(nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');

isSpace_isSpace_i = sum(isSpaceIdx_i & isSpaceIdx_j) / numSpace;
isSpace_isReward_i = sum(isSpaceIdx_i & isRewardIdx_j) / numSpace;
isSpace_isMix_i = sum(isSpaceIdx_i & isMixIdx_j)/numSpace;
% isSpace_isTypeFree = sum(isSpaceIdx_i & logical(1-MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})) / numSpace;% is space i_mouseDay, type-free j_mouseDay
% reward associated today
% reward associated, where does it come/go from/to
numReward = sum(nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');

isReward_isSpace_i = sum(isRewardIdx_i & isSpaceIdx_j) / numReward;
isReward_isReward_i = sum(isRewardIdx_i & isRewardIdx_j) / numReward;
isReward_isMix_i = sum(isRewardIdx_i & isMixIdx_j) / numReward;
% isReward_isTypeFree = sum(isRewardIdx_i & logical(1-MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})) / numReward;% is space i_mouseDay, type-free j_mouseDay


% mixed associated today
% mixed associated, where does it come/go from/to
numMix = sum(nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');

isMix_isSpace_i = sum(isMixIdx_i & isSpaceIdx_j) / numMix;
isMix_isReward_i = sum(isMixIdx_i & isRewardIdx_j) / numMix;
isMix_isMix_i = sum(isMixIdx_i & isMixIdx_j) / numMix;
% isMix_isTypeFree = sum(isMixIdx_i & logical(1-MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})) / numMix; % is space i_mouseDay, type-free j_mouseDay



% distribution of place field position change for space
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
idx2 = nan2false(MAP{j_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
y1 = abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{j_mouseDay, j_mouseDay, j_map}(idx1));
y2 = abs(MAP{j_group}.map(i_map).peakPositionChange_allMice{j_mouseDay, j_mouseDay, j_map}(idx2));
[N1, E1] = histcounts(y1, 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'probability')
[N2, E2] = histcounts(y2, 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'probability')
figure;
plot(E1(2:end), N1, 'k'); hold on;
plot(E2(2:end), N2, 'r'); hold on;
box off; ylim([-0.01 0.3])
set(gca, 'TickDir', 'out')
title('previous Allo-PCs PF position change')

% distribution of PF position change for reward pc
idx1 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
idx2 = nan2false(MAP{j_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
y1 = abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{j_mouseDay, j_mouseDay, j_map}(idx1));
y2 = abs(MAP{j_group}.map(i_map).peakPositionChange_allMice{j_mouseDay, j_mouseDay, j_map}(idx2));
[N1, E1] = histcounts(y1, 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'probability')
[N2, E2] = histcounts(y2, 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'probability')
figure;
plot(E1(2:end), N1, 'k'); hold on;
plot(E2(2:end), N2, 'r'); hold on;
box off; ylim([-0.01 0.3])
set(gca, 'TickDir', 'out')
title('previous Ego-PCs PF position change')

% distribution of PF position change for mix pc
idx1 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}) & nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
idx2 = nan2false(MAP{j_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}) & nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
y1 = abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{j_mouseDay, j_mouseDay, j_map}(idx1));
y2 = abs(MAP{j_group}.map(i_map).peakPositionChange_allMice{j_mouseDay, j_mouseDay, j_map}(idx2));
[N1, E1] = histcounts(y1, 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'probability')
[N2, E2] = histcounts(y2, 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'probability')
figure;
plot(E1(2:end), N1, 'k'); hold on;
plot(E2(2:end), N2, 'r'); hold on;
box off; ylim([-0.01 0.3])
set(gca, 'TickDir', 'out')
title('previous Mix-PCs PF position change')



% on the right 4 columns: light blue and red: aAAA, dark blue and red aABB
% i_group
i_group = j_group
% novel group
totalPlaceCellNum = sum(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map} & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})
% nan free version for each category
% day i_mosueDay
isSpaceIdx_i = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}); % get nan free index for today
isRewardIdx_i = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map});  % get nan free index for today
isMixIdx_i = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}); % get nan free index for today
% day j_mouseDay
isSpaceIdx_j = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{j_mouseDay, j_mouseDay, j_map});
isRewardIdx_j = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{j_mouseDay, j_mouseDay, j_map}); 
isMixIdx_j = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{j_mouseDay, j_mouseDay, j_map}); 


% space associated today
% space associated, where does it come/go from/to

numSpace = sum(nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');

isSpace_isSpace_j = sum(isSpaceIdx_i & isSpaceIdx_j) / numSpace;
isSpace_isReward_j = sum(isSpaceIdx_i & isRewardIdx_j) / numSpace;
isSpace_isMix_j = sum(isSpaceIdx_i & isMixIdx_j)/numSpace;
% isSpace_isTypeFree = sum(isSpaceIdx_i & logical(1-MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})) / numSpace;% is space i_mouseDay, type-free j_mouseDay
% reward associated today
% reward associated, where does it come/go from/to
numReward = sum(nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');

isReward_isSpace_j = sum(isRewardIdx_i & isSpaceIdx_j) / numReward;
isReward_isReward_j = sum(isRewardIdx_i & isRewardIdx_j) / numReward;
isReward_isMix_j = sum(isRewardIdx_i & isMixIdx_j) / numReward;
% isReward_isTypeFree = sum(isRewardIdx_i & logical(1-MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map})) / numReward;% is space i_mouseDay, type-free j_mouseDay


% mixed associated today
% mixed associated, where does it come/go from/to
numMix = sum(nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}) & MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}, 'omitnan');

isMix_isSpace_j = sum(isMixIdx_i & isSpaceIdx_j) / numMix;
isMix_isReward_j = sum(isMixIdx_i & isRewardIdx_j) / numMix;
isMix_isMix_j = sum(isMixIdx_i & isMixIdx_j) / numMix;

colorMap = cbrewer('qual', 'Set1', 9)
h = figure;
subplot(2,2,[1,3]);
p11 = pie([fraction_rewardAssociated, fraction_spaceAssociated , fraction_neither_space_nor_reward], '%.1f%%');
legend({ 'Egocentric', 'Allocentric','Mix'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'LineWidth', 2.5); set(gca, 'FontSize', 10); set(gca, 'FontName', 'Helvetica'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
p11(2).FontSize = 10; p11(4).FontSize = 10; p11(6).FontSize = 10
p11(1).FaceColor = colorMap(1, :); p11(3).FaceColor = colorMap(2, :);p11(5).FaceColor = colorMap(9, :);

p11(1).EdgeColor = 'none';p11(3).EdgeColor = 'none';p11(5).EdgeColor = 'none';
xticks([1,2,3,4]); xticklabels({'Allo', 'Ego', 'Mix'})
title([groupNameLabelPool{k_group}, ' - PC type, day: ', dayLabel{i_mouseDay}]);set(gca, 'FontSize', 15)


colorMap = cbrewer('qual', 'Paired', 12)
subplot(2,2,2);
p12 = bar([isSpace_isSpace_j, isSpace_isReward_j, isSpace_isSpace_i, isSpace_isReward_i], 'stacked');
title(['Allocentric --> day: ', dayLabel{j_mouseDay}])
set(gca, 'FontSize', 10); set(gca, 'FontName', 'Helvetica'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]); 
p12.FaceColor = 'flat';p12.EdgeColor = 'none';xlim([0 5])
ylim([0 0.81]); yticks([0 0.2 0.4 0.6 0.8])
xticks([1,2,3,4]); xticklabels({'Allo', 'Ego', 'Allo', 'Ego'})
p12.CData(1,:) = colorMap(2, :); p12.CData(2,:) = colorMap(6, :); p12.CData(3,:) = colorMap(1, :); p12.CData(4,:) = colorMap(5, :);

% p12.CData(1,:) = colorMap(1, :); p12.CData(2,:) = colorMap(5, :); p12.CData(3,:) = colorMap(2, :); p12.CData(4,:) = colorMap(6, :);
box off;set(gca, 'FontSize', 15)
pbaspect([1 0.5 1])


subplot(2,2,4);
p13 = bar([isReward_isSpace_j, isReward_isReward_j, isReward_isSpace_i, isReward_isReward_i]);
title(['Egocentric --> day: ', dayLabel{j_mouseDay}])
set(gca, 'FontSize', 10); set(gca, 'FontName', 'Helvetica'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]); 
p13.FaceColor = 'flat';p13.EdgeColor = 'none';
xlim([0 5]);ylim([0 0.81]); yticks([0 0.2 0.4 0.6 0.8])
xticks([1,2,3,4]); xticklabels({'Allo', 'Ego', 'Allo', 'Ego'})
% p13.CData(1,:) = colorMap(1, :); p13.CData(2,:) = colorMap(5, :); p13.CData(3,:) = colorMap(2, :); p13.CData(4,:) = colorMap(6, :);
p13.CData(1,:) = colorMap(2, :); p13.CData(2,:) = colorMap(6, :); p13.CData(3,:) = colorMap(1, :); p13.CData(4,:) = colorMap(5, :);
set(gca, 'FontSize', 15); box off;
pbaspect([1 0.5 1])

% fig source data
x = [isSpace_isSpace_j, isSpace_isReward_j, isSpace_isSpace_i, isSpace_isReward_i]
y = [isReward_isSpace_j, isReward_isReward_j, isReward_isSpace_i, isReward_isReward_i]

disp('Bar plot across day')





