

function meta_data2 = calculate_PF_Stat(data, Num_allMice, isRemap, MiceDay)
% 3 types place cells, ratio for each single animal, and population
Num_miceDay = length(MiceDay{1})
for i_mouse = 1:Num_allMice
    for i_mouseDay = 1:Num_miceDay
        
        for i_map = 1:2 % initialize variable
            data{i_mouse, i_mouseDay}.map(i_map).spacePC_num = cell(6,2);
            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num = cell(6,2);
            data{i_mouse, i_mouseDay}.map(i_map).mixPC_num = cell(6,2);
            data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num = cell(6,2);
            data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio = cell(6,2);
            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio = cell(6,2);
            data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio = cell(6,2);
        end
        
        for i_map = 1:2
            for j_map = 1:2
                for j_mouseDay = 1:Num_miceDay
                    data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                    data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                    data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                    data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                    data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                    data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                    data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                end
            end
        end
        standardRemapMouseID = 13
        if isRemap{standardRemapMouseID}{i_mouseDay}
            for i_map = 1:2
                for j_mouseDay = 1:Num_miceDay
                    if isRemap{standardRemapMouseID}{j_mouseDay}
                        % initialize variable
                        for j_map = 1:2
                            if data{i_mouse, i_mouseDay}.isEmpty | data{i_mouse, j_mouseDay}.isEmpty
                                % empty if no recording data set
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                            else
                                % get the number of place cells for each type
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}, 'omitnan');
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}, 'omitnan');
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}, 'omitnan');
                                
                                data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}+...
                                    data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map}+...
                                    data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map};
                                % get the ratio of place cells for each type
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map}  = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}  / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map}    = data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map}    / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                            end
                        end
                        
                    else
                        for j_map = 1
                            if data{i_mouse, i_mouseDay}.isEmpty | data{i_mouse, j_mouseDay}.isEmpty
                                % empty if no recording data set
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                            else
                                % get the number of place cells for each type
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}, 'omitnan');
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}, 'omitnan');
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}, 'omitnan');
                                
                                data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}+...
                                    data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map}+...
                                    data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map};
                                % get the ratio of place cells for each type
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map}  = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}  / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map}    = data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map}    / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                            end
                        end
                        
                        for j_map = 2
                            data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                        end
                    end
                end
            end
            
        else % no remap for day i_mouseDay
            for i_map = 1
                for j_mouseDay = 1:Num_miceDay
                    if data{i_mouse, i_mouseDay}.isEmpty | data{i_mouse, j_mouseDay}.isEmpty
                        % empty if no recording data set
                        for j_map = 1:2
                            data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                            data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                        end
                    elseif isRemap{standardRemapMouseID}{j_mouseDay}
                        % initialize variable
                        for j_map = 1:2
                            % get the number of place cells for each type
                            data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}, 'omitnan');
                            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}, 'omitnan');
                            data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}, 'omitnan');
                            
                            data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}+...
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map}+...
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map};
                            % get the ratio of place cells for each type
                            data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map}  = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}  / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                            data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                            data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map}    = data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map}    / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                        end
                        
                    else
                        for j_map = 1
                            if data{i_mouse, i_mouseDay}.isEmpty | data{i_mouse, j_mouseDay}.isEmpty
                                % empty if no recording data set
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                            else
                                % get the number of place cells for each type
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}, 'omitnan');
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}, 'omitnan');
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = sum(data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}, 'omitnan');
                                
                                data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}+...
                                    data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map}+...
                                    data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map};
                                % get the ratio of place cells for each type
                                data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map}  = data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}  / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                                data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                                data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map}    = data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map}    / data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map};
                            end
                        end
                    end
                end
            end
            for i_map = 2
                for j_mouseDay = 1:Num_miceDay
                    % empty if no recording data set
                    for j_map = 1:2
                        data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map} = nan;
                        data{i_mouse, i_mouseDay}.map(i_map).rewardPC_num{j_mouseDay, j_map} = nan;
                        data{i_mouse, i_mouseDay}.map(i_map).mixPC_num{j_mouseDay, j_map} = nan;
                        data{i_mouse, i_mouseDay}.map(i_map).s_r_m_PC_num{j_mouseDay, j_map} = nan;
                        data{i_mouse, i_mouseDay}.map(i_map).spacePC_ratio{j_mouseDay, j_map} = nan;
                        data{i_mouse, i_mouseDay}.map(i_map).rewardPC_ratio{j_mouseDay, j_map} = nan;
                        data{i_mouse, i_mouseDay}.map(i_map).mixPC_ratio{j_mouseDay, j_map} = nan;
                    end
                end
            end
        end
    end
end
meta_data2 = data;
end


