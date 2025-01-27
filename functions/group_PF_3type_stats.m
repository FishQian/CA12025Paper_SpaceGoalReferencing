function pcStats = group_PF_3type_stats(data, mouseGroupIdx, i_mouseDay, j_mouseDay, i_map, j_map)


pcStats = struct;
Num_allMice = size(mouseGroupIdx, 1);
pcStats.spacePC_num_allMice = nan(Num_allMice, 1);
pcStats.rewardPC_num_allMice = nan(Num_allMice, 1);
pcStats.mixPC_num_allMice = nan(Num_allMice, 1);
pcStats.s_r_m_PC_num_allMice = nan(Num_allMice, 1);
pcStats.spacePC_ratio_allMice = nan(Num_allMice, 1);
pcStats.rewardPC_ratio_allMice = nan(Num_allMice, 1);
pcStats.mixPC_ratio_allMice = nan(Num_allMice, 1);

for i = 1:length(mouseGroupIdx)
    i_mouse = mouseGroupIdx(i)
    pcStats.spacePC_num_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map};
    pcStats.rewardPC_num_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map};
    pcStats.mixPC_num_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map};
    pcStats.s_r_m_PC_num_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
    
    pcStats.spacePC_ratio_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map};
    pcStats.rewardPC_ratio_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map};
    pcStats.mixPC_ratio_allMice(i, 1) = data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map};
    
end

end