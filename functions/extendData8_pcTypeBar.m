function extendData8_pcTypeBar(DataFolder, MAP, i_group, i_mouseDay, j_mouseDay, i_map, j_map, dayLabel, groupNameLabelPool)
%% bar plot and pie chart of all types of PC: both pre and post, pre only, post only, silent cells

idx_allo = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map});
idx_ego = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map});
idx_mix = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map});

% allo - PC, where do they go
idx = idx_allo;

num_PC_PrePost = sum(idx & nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');
num_PC_PreOnly = sum(idx & nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');
num_PC_PostOnly = sum(idx & nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{j_mouseDay, j_mouseDay, i_map}), 'omitnan');
num_SilentCell = sum(idx & ~nan2false(MAP{i_group}.map(i_map).isPC_i_or_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');

numAllCellThisType = sum(idx, 'omitnan')

prct_PC_PrePost = num_PC_PrePost / numAllCellThisType;
prct_PC_PreOnly = num_PC_PreOnly / numAllCellThisType;
prct_PC_PostOnly = num_PC_PostOnly / numAllCellThisType;
prct_SilentCell = num_SilentCell / numAllCellThisType;

% nan free version for each category
% day i_mosueDay

num_Allo = sum(idx & nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan'); % get nan free index for today
num_Ego = sum(idx & nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan');  % get nan free index for today
num_Mix = sum(idx & nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan'); % get nan free index for today

prct_Allo = num_Allo / numAllCellThisType; % get nan free index for today
prct_Ego = num_Ego / numAllCellThisType;  % get nan free index for today
prct_Mix = num_Mix / numAllCellThisType; % get nan free index for today


% of PCs with Pre and Post PFs, relative fractions for 3 types of PCs
rela_prct_Allo = num_Allo/num_PC_PrePost;
rela_prct_Ego= num_Ego/num_PC_PrePost;
rela_prct_Mix = num_Mix/num_PC_PrePost;

colorMap = cbrewer('qual', 'Set1', 9)
h = figure;
subplot(1,2,1);
p11 = pie([rela_prct_Allo, rela_prct_Ego, rela_prct_Mix], '%.1f%%');
legend({'Allo', 'Ego', 'Mix'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'LineWidth', 2.5); set(gca, 'FontSize', 10); set(gca, 'FontName', 'Helvetica'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
p11(1).EdgeColor = 'w'; p11(3).EdgeColor = 'w'; p11(5).EdgeColor = 'w'
p11(2).FontSize = 10; p11(4).FontSize = 10; p11(6).FontSize = 10
p11(1).FaceColor = colorMap(2, :); p11(3).FaceColor = colorMap(1, :);p11(5).FaceColor = colorMap(9, :);
title([groupNameLabelPool{i_group}, ' - PC type, day: ', dayLabel{j_mouseDay}])

subplot(1,2,2);
p2 = bar(1, [prct_Mix prct_Ego prct_Allo], 'stack'); hold on;
p2(1).FaceColor = colorMap(9,:);p2(2).FaceColor = colorMap(1,:);p2(3).FaceColor = colorMap(2,:);
p2(1).EdgeColor = 'none'; p2(2).EdgeColor = 'none';p2(3).EdgeColor = 'none';
p12 = bar(2, prct_PC_PreOnly); p12.FaceColor = colorMap(3, :); p12.EdgeColor = 'none'; 
p13 = bar(3, prct_PC_PostOnly); p13.FaceColor = colorMap(3, :); p13.EdgeColor = 'none'; 
p14 = bar(4, prct_SilentCell); p14.FaceColor = colorMap(4, :); p14.EdgeColor = 'none'; 

title([groupNameLabelPool{i_group}, ' day: ', dayLabel{j_mouseDay}])
set(gca, 'FontSize', 15); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]); 
% p12.FaceColor = 'flat';p12.EdgeColor = 'none'; 
ylim([0 0.81]); yticks(0:0.2:0.8);; xlim([0 5])
xticks([1,2,3,4]); xticklabels({'Pre and Post', 'Pre only', 'Post only', 'Silent'})
ylabel('Fraction of recorded cells')
% p12.CData(1,:) = colorMap(5, :); p12.CData(2,:) = colorMap(7, :); p12.CData(3,:) = colorMap(3, :);
box off; pbaspect([1 1 1])
sgtitle(['allo-PC @ day: ', dayLabel{i_mouseDay}, ' to day: ', dayLabel{j_mouseDay}])
prct_PC_PrePost
prct_PC_PreOnly
prct_PC_PostOnly
prct_SilentCell

if i_group == 3
    ExtendedFig7b_pre_and_post = [prct_Mix; prct_Ego; prct_Allo];
    ExtendedFig7b_pre_only = prct_PC_PreOnly;
    ExtendedFig7b_post_only = prct_PC_PostOnly;
    ExtendedFig7b_notPC = prct_SilentCell;
elseif i_group == 4
    ExtendedFig7a_pre_and_post = [prct_Mix; prct_Ego; prct_Allo];
    ExtendedFig7a_pre_only = prct_PC_PreOnly;
    ExtendedFig7a_post_only = prct_PC_PostOnly;
    ExtendedFig7a_notPC = prct_SilentCell;
end

% fishPrint(h, 'landscape', 'normalized', [0 0.25 1 0.5], [DataFolder, '/PCTypeHistoryTrack/PCTypePieChart_historyTrack', '-N-Day_', dayLabel{i_mouseDay}, '-compare_day', dayLabel{j_mouseDay}])
saveas(h, [DataFolder, '/ExtendedData8_pcTypeBar_allo', '-',  groupNameLabelPool{i_group}, '-Day_', dayLabel{i_mouseDay}, '-Day_', dayLabel{j_mouseDay},'.fig']);

%% Ego - PC, where do they go
idx = idx_ego;

num_PC_PrePost = sum(idx & nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');
num_PC_PreOnly = sum(idx & nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');
num_PC_PostOnly = sum(idx & nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{j_mouseDay, j_mouseDay, i_map}), 'omitnan');
num_SilentCell = sum(idx & ~nan2false(MAP{i_group}.map(i_map).isPC_i_or_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');

numAllCellThisType = sum(idx, 'omitnan')

prct_PC_PrePost = num_PC_PrePost / numAllCellThisType;
prct_PC_PreOnly = num_PC_PreOnly / numAllCellThisType;
prct_PC_PostOnly = num_PC_PostOnly / numAllCellThisType;
prct_SilentCell = num_SilentCell / numAllCellThisType;


% nan free version for each category
% day i_mosueDay

num_Allo = sum(idx & nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan'); % get nan free index for today
num_Ego = sum(idx & nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan');  % get nan free index for today
num_Mix = sum(idx & nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan'); % get nan free index for today

prct_Allo = num_Allo / numAllCellThisType; % get nan free index for today
prct_Ego = num_Ego / numAllCellThisType;  % get nan free index for today
prct_Mix = num_Mix / numAllCellThisType; % get nan free index for today


% of PCs with Pre and Post PFs, relative fractions for 3 types of PCs
rela_prct_Allo = num_Allo/num_PC_PrePost;
rela_prct_Ego= num_Ego/num_PC_PrePost;
rela_prct_Mix = num_Mix/num_PC_PrePost;

colorMap = cbrewer('qual', 'Set1', 9)
h = figure;
subplot(1,2,1);
p11 = pie([rela_prct_Allo, rela_prct_Ego, rela_prct_Mix], '%.1f%%');
legend({'Allo', 'Ego', 'Mix'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'LineWidth', 2.5); set(gca, 'FontSize', 10); set(gca, 'FontName', 'Helvetica'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
p11(1).EdgeColor = 'w'; p11(3).EdgeColor = 'w'; p11(5).EdgeColor = 'w'
p11(2).FontSize = 10; p11(4).FontSize = 10; p11(6).FontSize = 10
p11(1).FaceColor = colorMap(2, :); p11(3).FaceColor = colorMap(1, :);p11(5).FaceColor = colorMap(9, :);
title([groupNameLabelPool{i_group}, ' - PC type, day: ', dayLabel{j_mouseDay}])

subplot(1,2,2);
p2 = bar(1, [prct_Mix prct_Ego prct_Allo], 'stack'); hold on;
p2(1).FaceColor = colorMap(9,:);p2(2).FaceColor = colorMap(1,:);p2(3).FaceColor = colorMap(2,:);
p2(1).EdgeColor = 'none'; p2(2).EdgeColor = 'none';p2(3).EdgeColor = 'none';
% p12 = bar([2,3,4], [prct_PC_PreOnly, prct_PC_PostOnly, prct_SilentCell])
p12 = bar(2, prct_PC_PreOnly); p12.FaceColor = colorMap(3, :); p12.EdgeColor = 'none'; 
p13 = bar(3, prct_PC_PostOnly); p13.FaceColor = colorMap(3, :); p13.EdgeColor = 'none'; 
p14 = bar(4, prct_SilentCell); p14.FaceColor = colorMap(4, :); p14.EdgeColor = 'none'; 

title([groupNameLabelPool{i_group}, ' day: ', dayLabel{j_mouseDay}])
set(gca, 'FontSize', 15); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]); 
% p12.FaceColor = 'flat';p12.EdgeColor = 'none'; 
ylim([0 0.81]); yticks(0:0.2:0.8);; xlim([0 5])
xticks([1,2,3,4]); xticklabels({'Pre and Post', 'Pre only', 'Post only', 'Silent'})
ylabel('Fraction of recorded cells')
% p12.CData(1,:) = colorMap(5, :); p12.CData(2,:) = colorMap(7, :); p12.CData(3,:) = colorMap(3, :);
box off; pbaspect([1 1 1])
sgtitle(['ego-PC @ day: ', dayLabel{i_mouseDay}, ' to day: ', dayLabel{j_mouseDay}])
prct_PC_PrePost
prct_PC_PreOnly
prct_PC_PostOnly
prct_SilentCell


if i_group == 3
    ExtendedFig7d_pre_and_post = [prct_Mix; prct_Ego; prct_Allo];
    ExtendedFig7d_pre_only = prct_PC_PreOnly;
    ExtendedFig7d_post_only = prct_PC_PostOnly;
    ExtendedFig7d_notPC = prct_SilentCell;
elseif i_group == 4
    ExtendedFig7c_pre_and_post = [prct_Mix; prct_Ego; prct_Allo];
    ExtendedFig7c_pre_only = prct_PC_PreOnly;
    ExtendedFig7c_post_only = prct_PC_PostOnly;
    ExtendedFig7c_notPC = prct_SilentCell;
    
end


% fishPrint(h, 'landscape', 'normalized', [0 0.25 1 0.5], [DataFolder, '/PCTypeHistoryTrack/PCTypePieChart_historyTrack', '-N-Day_', dayLabel{i_mouseDay}, '-compare_day', dayLabel{j_mouseDay}])
saveas(h, [DataFolder, '/ExtendedData8_pcTypeBar_ego', '-',  groupNameLabelPool{i_group}, '-Day_', dayLabel{i_mouseDay}, '-Day_', dayLabel{j_mouseDay},'.fig']);

%% Mix - PC, where do they go
idx = idx_mix;

num_PC_PrePost = sum(idx & nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');
num_PC_PreOnly = sum(idx & nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');
num_PC_PostOnly = sum(idx & nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{j_mouseDay, j_mouseDay, i_map}), 'omitnan');
num_SilentCell = sum(idx & ~nan2false(MAP{i_group}.map(i_map).isPC_i_or_j{j_mouseDay, j_mouseDay, j_map}), 'omitnan');

numAllCellThisType = sum(idx, 'omitnan');

prct_PC_PrePost = num_PC_PrePost / numAllCellThisType;
prct_PC_PreOnly = num_PC_PreOnly / numAllCellThisType;
prct_PC_PostOnly = num_PC_PostOnly / numAllCellThisType;
prct_SilentCell = num_SilentCell / numAllCellThisType;


% nan free version for each category
% day i_mosueDay

num_Allo = sum(idx & nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan'); % get nan free index for today
num_Ego = sum(idx & nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan');  % get nan free index for today
num_Mix = sum(idx & nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{j_mouseDay, j_mouseDay, j_map}), 'omitnan'); % get nan free index for today

prct_Allo = num_Allo / numAllCellThisType; % get nan free index for today
prct_Ego = num_Ego / numAllCellThisType;  % get nan free index for today
prct_Mix = num_Mix / numAllCellThisType; % get nan free index for today


% of PCs with Pre and Post PFs, relative fractions for 3 types of PCs
rela_prct_Allo = num_Allo/num_PC_PrePost;
rela_prct_Ego= num_Ego/num_PC_PrePost;
rela_prct_Mix = num_Mix/num_PC_PrePost;

colorMap = cbrewer('qual', 'Set1', 9)
h = figure;
subplot(1,2,1);
p11 = pie([rela_prct_Allo, rela_prct_Ego, rela_prct_Mix], '%.1f%%');
legend({'Allo', 'Ego', 'Mix'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'LineWidth', 2.5); set(gca, 'FontSize', 10); set(gca, 'FontName', 'Helvetica'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
p11(1).EdgeColor = 'w'; p11(3).EdgeColor = 'w'; p11(5).EdgeColor = 'w'
p11(2).FontSize = 10; p11(4).FontSize = 10; p11(6).FontSize = 10
p11(1).FaceColor = colorMap(2, :); p11(3).FaceColor = colorMap(1, :);p11(5).FaceColor = colorMap(9, :);
title([groupNameLabelPool{i_group}, ' - PC type, day: ', dayLabel{j_mouseDay}])

subplot(1,2,2);
p2 = bar(1, [prct_Mix prct_Ego prct_Allo], 'stack'); hold on;
p2(1).FaceColor = colorMap(9,:);p2(2).FaceColor = colorMap(1,:);p2(3).FaceColor = colorMap(2,:);
p2(1).EdgeColor = 'none'; p2(2).EdgeColor = 'none';p2(3).EdgeColor = 'none';
% p12 = bar([2,3,4], [prct_PC_PreOnly, prct_PC_PostOnly, prct_SilentCell])
p12 = bar(2, prct_PC_PreOnly); p12.FaceColor = colorMap(3, :); p12.EdgeColor = 'none'; 
p13 = bar(3, prct_PC_PostOnly); p13.FaceColor = colorMap(3, :); p13.EdgeColor = 'none'; 
p14 = bar(4, prct_SilentCell); p14.FaceColor = colorMap(4, :); p14.EdgeColor = 'none'; 

title([groupNameLabelPool{i_group}, ' day: ', dayLabel{j_mouseDay}])
set(gca, 'FontSize', 15); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]); 
% p12.FaceColor = 'flat';p12.EdgeColor = 'none'; 
ylim([0 0.81]); yticks(0:0.2:0.8);; xlim([0 5])
xticks([1,2,3,4]); xticklabels({'Pre and Post', 'Pre only', 'Post only', 'Silent'})
ylabel('Fraction of recorded cells')
% p12.CData(1,:) = colorMap(5, :); p12.CData(2,:) = colorMap(7, :); p12.CData(3,:) = colorMap(3, :);
box off; pbaspect([1 1 1])
sgtitle(['mix-PC @ day: ', dayLabel{i_mouseDay}, ' to day: ', dayLabel{j_mouseDay}])
prct_PC_PrePost
prct_PC_PreOnly
prct_PC_PostOnly
prct_SilentCell

% fishPrint(h, 'landscape', 'normalized', [0 0.25 1 0.5], [DataFolder, '/PCTypeHistoryTrack/PCTypePieChart_historyTrack', '-N-Day_', dayLabel{i_mouseDay}, '-compare_day', dayLabel{j_mouseDay}])
saveas(h, [DataFolder, '/ExtendedData8_pcTypeBar_mix', '-',  groupNameLabelPool{i_group}, '-Day_', dayLabel{i_mouseDay}, '-Day_', dayLabel{j_mouseDay},'.fig']);

