function groupStats = groupIsBothActive(meta_data, mouseGroupIdx, sectionWindowSize, lapNum)


if mod(lapNum, sectionWindowSize) == 0
    sectionNum = lapNum/sectionWindowSize;
else
    sectionNum = fix(lapNum/sectionWindowSize) +1;
end


groupStats= struct;
Num_allMice = size(mouseGroupIdx, 2);
Num_allMouseDay = size(meta_data,2);

% initialize variable
for i_mouseDay = 1:Num_allMouseDay
    for j_mouseDay = 1:Num_allMouseDay
        for i_map = 1:2
            for j_map = 1:2
                groupStats.group_eachLapIsBothActive_inField_allMice{i_mouseDay, j_mouseDay, i_map, j_map} = nan(sectionNum, Num_allMice);
%                 groupStats.group_eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, i_map, j_map}  = nan(sectionNum, Num_allMice);
                
                groupStats.group_eachLapIsBothActive_inField_isSpace_allMice{i_mouseDay, j_mouseDay, i_map, j_map}  = nan(sectionNum, Num_allMice);
%                 groupStats.group_eachLapIsActive_inField_shift_isSpace_allMice{i_mouseDay, j_mouseDay, i_map, j_map}  = nan(sectionNum, Num_allMice);
                
                groupStats.group_eachLapIsBothActive_inField_isReward_allMice{i_mouseDay, j_mouseDay, i_map, j_map}  = nan(sectionNum, Num_allMice);
%                 groupStats.group_eachLapIsActive_inField_shift_isReward_allMice{i_mouseDay, j_mouseDay, i_map, j_map}  = nan(sectionNum, Num_allMice);
            end
        end
    end
end

for i_mouseDay = 1:Num_allMouseDay
    for j_mouseDay = 1:Num_allMouseDay
        for i = 1:Num_allMice
            i_mouse = mouseGroupIdx(i)
            
            if ~meta_data{i_mouse, i_mouseDay}.isEmpty & ~meta_data{i_mouse, j_mouseDay}.isEmpty
                for i_map = 1:2
                    for j_map = 1:2
                        i_mouse
                        i_mouseDay
                        j_mouseDay
                        i_map
                        j_map
                        groupStats.group_eachLapIsBothActive_inField_allMice{i_mouseDay, j_mouseDay, i_map, j_map}(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField{j_mouseDay, j_map};
%                         groupStats.group_eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, i_map, j_map}(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift{j_mouseDay, j_map};
                        
                        groupStats.group_eachLapIsBothActive_inField_isSpace_allMice{i_mouseDay, j_mouseDay, i_map, j_map}(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isSpace{j_mouseDay, j_map};
%                         groupStats.group_eachLapIsActive_inField_shift_isSpace_allMice{i_mouseDay, j_mouseDay, i_map, j_map}(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift_isSpace{j_mouseDay, j_map};
                        
                        groupStats.group_eachLapIsBothActive_inField_isReward_allMice{i_mouseDay, j_mouseDay, i_map, j_map}(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isReward{j_mouseDay, j_map};
%                         groupStats.group_eachLapIsActive_inField_shift_isReward_allMice{i_mouseDay, j_mouseDay, i_map, j_map}(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift_isReward{j_mouseDay, j_map};
                    end
                end
            else
                
            end
        end
        
    end
end

end

