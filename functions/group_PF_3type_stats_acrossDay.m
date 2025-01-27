function pcStats_acrossDay = group_PF_3type_stats_acrossDay(meta_data, mouseGroupIdx, Num_allMice)


pcStats_acrossDay = struct;
Num_allMice = size(mouseGroupIdx, 1);
Num_allMouseDay = size(meta_data,2);
% initialize variable
for i_mouseDay = 1:Num_allMouseDay
    for j_mouseDay = 1:Num_allMouseDay
        pcStats_acrossDay.spaceSpaceNum_allMice{i_mouseDay, j_mouseDay} = nan(1, Num_allMice);
        pcStats_acrossDay.spaceRewardNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.spaceMixNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.spaceTypeNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        
        pcStats_acrossDay.rewardSpaceNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.rewardRewardNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.rewardMixNnum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.rewardTypeNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        
        pcStats_acrossDay.mixSpaceNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.mixRewardNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.mixMixNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
        pcStats_acrossDay.mixTypeNum_allMice{i_mouseDay, j_mouseDay}  = nan(1, Num_allMice);
    end
end


for i_mouseDay = 4:Num_allMouseDay
    for j_mouseDay = 4:Num_allMouseDay
        
        pcStats_acrossDay.isSpace_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [];
        pcStats_acrossDay.isReward_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [];
        pcStats_acrossDay.isMix_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [];
%         pcStats_acrossDay.isTypeFree_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [];
        
        i = 1
        i_mouse = mouseGroupIdx(i)
        pcStats_acrossDay.isSpace_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 1);
        pcStats_acrossDay.isReward_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 2);
        pcStats_acrossDay.isMix_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 3);
%         pcStats_acrossDay.isTypeFree_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 4);
        
        
        
        pcStats_acrossDay.spaceSpaceNum_allMice{i_mouseDay, j_mouseDay}(i) = meta_data{i_mouse, i_mouseDay}.isSpaceSpaceNum(j_mouseDay);
        pcStats_acrossDay.spaceRewardNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isSpaceRewardNum(j_mouseDay);
        pcStats_acrossDay.spaceMixNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isSpaceMixNum(j_mouseDay);
        pcStats_acrossDay.spaceTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeNum(j_mouseDay);
        
        pcStats_acrossDay.rewardSpaceNum_allMice{i_mouseDay, j_mouseDay}(i) = meta_data{i_mouse, i_mouseDay}.isRewardSpaceNum(j_mouseDay);
        pcStats_acrossDay.rewardRewardNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isRewardRewardNum(j_mouseDay);
        pcStats_acrossDay.rewardMixNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isRewardMixNum(j_mouseDay);
        pcStats_acrossDay.rewardTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeNum(j_mouseDay);
        
        pcStats_acrossDay.mixSpaceNum_allMice{i_mouseDay, j_mouseDay}(i) = meta_data{i_mouse, i_mouseDay}.isMixSpaceNum(j_mouseDay);
        pcStats_acrossDay.mixRewardNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isMixRewardNum(j_mouseDay);
        pcStats_acrossDay.mixMixNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isMixMixNum(j_mouseDay);
        pcStats_acrossDay.mixTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isMixTypeFreeNum(j_mouseDay);
        
        for i = 2:length(mouseGroupIdx)
            i_mouse = mouseGroupIdx(i)
            pcStats_acrossDay.isSpace_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [pcStats_acrossDay.isSpace_SRMT_Idx_allMice{i_mouseDay, j_mouseDay}; 
                count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 1)];
            pcStats_acrossDay.isReward_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [pcStats_acrossDay.isReward_SRMT_Idx_allMice{i_mouseDay, j_mouseDay};
                count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 2)];
            pcStats_acrossDay.isMix_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [pcStats_acrossDay.isMix_SRMT_Idx_allMice{i_mouseDay, j_mouseDay};
                count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 3)];
%             pcStats_acrossDay.isTypeFree_SRMT_Idx_allMice{i_mouseDay, j_mouseDay} = [pcStats_acrossDay.isTypeFree_SRMT_Idx_allMice{i_mouseDay, j_mouseDay};
%                 count4Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, 4)];
%             
%             
%             
            pcStats_acrossDay.spaceSpaceNum_allMice{i_mouseDay, j_mouseDay}(i) = meta_data{i_mouse, i_mouseDay}.isSpaceSpaceNum(j_mouseDay);
            pcStats_acrossDay.spaceRewardNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isSpaceRewardNum(j_mouseDay);
            pcStats_acrossDay.spaceMixNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isSpaceMixNum(j_mouseDay);
            pcStats_acrossDay.spaceTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeNum(j_mouseDay);
            
            pcStats_acrossDay.rewardSpaceNum_allMice{i_mouseDay, j_mouseDay}(i) = meta_data{i_mouse, i_mouseDay}.isRewardSpaceNum(j_mouseDay);
            pcStats_acrossDay.rewardRewardNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isRewardRewardNum(j_mouseDay);
            pcStats_acrossDay.rewardMixNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isRewardMixNum(j_mouseDay);
            pcStats_acrossDay.rewardTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeNum(j_mouseDay);
            
            pcStats_acrossDay.mixSpaceNum_allMice{i_mouseDay, j_mouseDay}(i) = meta_data{i_mouse, i_mouseDay}.isMixSpaceNum(j_mouseDay);
            pcStats_acrossDay.mixRewardNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isMixRewardNum(j_mouseDay);
            pcStats_acrossDay.mixMixNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isMixMixNum(j_mouseDay);
            pcStats_acrossDay.mixTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(i)  = meta_data{i_mouse, i_mouseDay}.isMixTypeFreeNum(j_mouseDay);
            
            
        end
        
    end
    
end

end