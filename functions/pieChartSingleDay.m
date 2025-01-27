function pieChartSingleDay(DataFolder, MAP, i_group, i_mouseDay, j_mouseDay,i_map, j_map, dayLabel, groupNameLabelPool)



% number of all pc from each type
SC = sum(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_num_allMice, 'omitnan');
PI = sum(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_num_allMice, 'omitnan');
MIX = sum(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_num_allMice, 'omitnan');


SC_ratio = SC / (SC+PI+MIX);
PI_ratio = PI / (SC+PI+MIX);
MIX_ratio = MIX / (SC+PI+MIX);

colorMap = cbrewer('qual', 'Set1', 9)
h = figure;
p1 = pie([SC_ratio, PI_ratio, MIX_ratio], '%.1f%%');
legend({'SC', 'PD', 'MIX'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'FontSize', 10); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
p1(2).FontSize = 10; p1(4).FontSize = 10; p1(6).FontSize = 10
p1(1).FaceColor = colorMap(2, :); p1(3).FaceColor = colorMap(1, :);p1(5).FaceColor = colorMap(9, :);
title([groupNameLabelPool{i_group}, ', day: ', dayLabel{i_mouseDay}])

% figure source data 
x = [SC; PI; MIX]
y = [SC_ratio; PI_ratio; MIX_ratio]

disp('Pie Chart is beautiful')


end