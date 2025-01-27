function extendData2_pcTypeBar_v2(DataFolder, MAP, i_group, i_mouseDay, i_map, j_map, dayLabel, groupNameLabelPool)
%% bar plot and pie chart of all types of PC: both pre and post, pre only, post only, silent cells

% the new v2 only takes Pre&Post, Pre only, and Post only, without taking
% account of those completely silent for both conditions cells.

prct_PC_PrePost = mean(nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map}), 'omitnan');
prct_PC_PreOnly = mean(nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, i_mouseDay, j_map}), 'omitnan');
prct_PC_PostOnly = mean(nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{i_mouseDay, i_mouseDay, i_map}), 'omitnan');
% prct_SilentCell = mean(~nan2false(MAP{i_group}.map(i_map).isPC_i_or_j{i_mouseDay, i_mouseDay, j_map}), 'omitnan');


num_PC_PrePost = sum(nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map}), 'omitnan');
num_PC_PreOnly = sum(nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, i_mouseDay, j_map}), 'omitnan');
num_PC_PostOnly = sum(nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{i_mouseDay, i_mouseDay, i_map}), 'omitnan');
% num_SilentCell = sum(~nan2false(MAP{i_group}.map(i_map).isPC_i_or_j{i_mouseDay, i_mouseDay, j_map}), 'omitnan');

% rela_prct within PrePost, Pre and Post
rela_prct_PrePost = num_PC_PrePost / (num_PC_PrePost + num_PC_PreOnly + num_PC_PostOnly);
rela_prct_PreOnly = num_PC_PreOnly / (num_PC_PrePost + num_PC_PreOnly + num_PC_PostOnly);
rela_prct_PostOnly = num_PC_PostOnly / (num_PC_PrePost + num_PC_PreOnly + num_PC_PostOnly);

% nan free version for each category
% day i_mosueDay
prct_Allo = mean(nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}), 'omitnan'); % get nan free index for today
prct_Ego = mean(nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}), 'omitnan');  % get nan free index for today
prct_Mix = mean(nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}), 'omitnan'); % get nan free index for today

num_Allo = sum(nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}), 'omitnan'); % get nan free index for today
num_Ego = sum(nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}), 'omitnan');  % get nan free index for today
num_Mix = sum(nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}), 'omitnan'); % get nan free index for today

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
title([groupNameLabelPool{i_group}, ' - PC type, day: ', dayLabel{i_mouseDay}])

subplot(1,2,2);
p2 = bar(1, [rela_prct_Mix, rela_prct_Ego, rela_prct_Allo] .* rela_prct_PrePost, 'stack'); hold on;
p2(1).FaceColor = colorMap(9,:);p2(2).FaceColor = colorMap(1,:);p2(3).FaceColor = colorMap(2,:);
p2(1).EdgeColor = 'none'; p2(2).EdgeColor = 'none';p2(3).EdgeColor = 'none';
% p12 = bar([2,3,4], [prct_PC_PreOnly, prct_PC_PostOnly, prct_SilentCell])
p21 = bar(2.25, rela_prct_PreOnly); p21.FaceColor = colorMap(3, :); p21.EdgeColor = 'none'; 
p22 = bar(3.5, rela_prct_PostOnly); p22.FaceColor = colorMap(3, :); p22.EdgeColor = 'none';
% p23 = bar(4, prct_SilentCell); p23.FaceColor = colorMap(4, :); p23.EdgeColor = 'none';

title([groupNameLabelPool{i_group}, ' day: ', dayLabel{i_mouseDay}])
set(gca, 'FontSize', 15); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]); 
% p12.FaceColor = 'flat'; p12.EdgeColor = 'none'; 

ylim([0 0.81]); yticks([0 0.2 0.4 0.6 0.8]);; xlim([0 4.5])
xticks([1,2.25,3.5]); xticklabels({'Pre and Post', 'Pre only', 'Post only'})
ylabel('Fraction of recorded cells')
% p12.CData(1,:) = colorMap(5, :); 
% p12.CData(2,:) = colorMap(7, :); 
% p12.CData(3,:) = colorMap(3, :);
box off; pbaspect([1 1 1])

% prct_PC_PrePost
% prct_PC_PreOnly
% prct_PC_PostOnly
% prct_SilentCell

rela_prct_PrePost 
rela_prct_PreOnly
rela_prct_PostOnly


if i_group == 2
    ExtendedFig2d_pre_and_post = [rela_prct_Mix, rela_prct_Ego, rela_prct_Allo]' .* rela_prct_PrePost;
    ExtendedFig2d_pre_only = rela_prct_PreOnly;
    ExtendedFig2d_post_only = rela_prct_PostOnly;
elseif i_group ==3
    ExtendedFig2c_pre_and_post = [rela_prct_Mix, rela_prct_Ego, rela_prct_Allo]' .* rela_prct_PrePost;
    ExtendedFig2c_pre_only = rela_prct_PreOnly;
    ExtendedFig2c_post_only = rela_prct_PostOnly;
end

% fishPrint(h, 'landscape', 'normalized', [0 0.25 1 0.5], [DataFolder, '/PCTypeHistoryTrack/PCTypePieChart_historyTrack', '-N-Day_', dayLabel{i_mouseDay}, '-compare_day', dayLabel{j_mouseDay}])
saveas(h, [DataFolder, '/ExtendedData2_pcTypeBar', '-',  groupNameLabelPool{i_group}, '-Day_', dayLabel{i_mouseDay}, '.fig']);



