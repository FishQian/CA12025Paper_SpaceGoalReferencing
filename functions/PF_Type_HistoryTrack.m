function meta_data = PF_Type_HistoryTrack(meta_data, Num_allMice, isRemap, MiceDay)

% get idx, get number, get ratio
Num_miceDay = length(MiceDay{1})
for i_mouse = 1:Num_allMice
    
    for i_mouseDay = 1:Num_miceDay
        meta_data{i_mouse, i_mouseDay}.isSpaceSpaceIdx = cell(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isSpaceRewardIdx = cell(Num_miceDay,1);
        meta_data{i_mouse, i_mouseDay}.isSpaceMixIdx = cell(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeIdx = cell(Num_miceDay,1);
        
        meta_data{i_mouse, i_mouseDay}.isRewardSpaceIdx = cell(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isRewardRewardIdx = cell(Num_miceDay,1);
        meta_data{i_mouse, i_mouseDay}.isRewardMixIdx = cell(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeIdx = cell(Num_miceDay,1);
        
        meta_data{i_mouse, i_mouseDay}.isMixSpaceIdx = cell(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isMixRewardIdx = cell(Num_miceDay,1);
        meta_data{i_mouse, i_mouseDay}.isMixMixIdx = cell(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isMixTypeFreeIdx = cell(Num_miceDay,1);
        
        % number
        meta_data{i_mouse, i_mouseDay}.isSpaceSpaceNum = nan(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isSpaceRewardNum = nan(Num_miceDay,1);
        meta_data{i_mouse, i_mouseDay}.isSpaceMixNum = nan(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeNum = nan(Num_miceDay,1);
        
        meta_data{i_mouse, i_mouseDay}.isRewardSpaceNum = nan(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isRewardRewardNum = nan(Num_miceDay,1);
        meta_data{i_mouse, i_mouseDay}.isRewardMixNum = nan(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeNum = nan(Num_miceDay,1);
        
        meta_data{i_mouse, i_mouseDay}.isMixSpaceNum = nan(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isMixRewardNum = nan(Num_miceDay,1);
        meta_data{i_mouse, i_mouseDay}.isMixMixNum = nan(Num_miceDay,1); meta_data{i_mouse, i_mouseDay}.isMixTypeFreeNum = nan(Num_miceDay,1);
        
            
        for j_mouseDay = 1:Num_miceDay
            % initialize variables
            % index
            
            
            cellNum = meta_data{i_mouse, 4}.cellNum;
            nan_cellNum = nan(cellNum, 1);
            % initialize as nan
            meta_data{i_mouse, i_mouseDay}.isSpaceSpaceIdx{j_mouseDay} = nan_cellNum;   meta_data{i_mouse, i_mouseDay}.isSpaceRewardIdx{j_mouseDay} = nan_cellNum;
            meta_data{i_mouse, i_mouseDay}.isSpaceMixIdx{j_mouseDay} = nan_cellNum;     meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeIdx{j_mouseDay} = nan_cellNum;
            meta_data{i_mouse, i_mouseDay}.isRewardSpaceIdx{j_mouseDay} = nan_cellNum;  meta_data{i_mouse, i_mouseDay}.isRewardRewardIdx{j_mouseDay} = nan_cellNum;
            meta_data{i_mouse, i_mouseDay}.isRewardMixIdx{j_mouseDay} = nan_cellNum;    meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeIdx{j_mouseDay} = nan_cellNum;
            meta_data{i_mouse, i_mouseDay}.isMixSpaceIdx{j_mouseDay} = nan_cellNum;     meta_data{i_mouse, i_mouseDay}.isMixRewardIdx{j_mouseDay} = nan_cellNum;
            meta_data{i_mouse, i_mouseDay}.isMixMixIdx{j_mouseDay} = nan_cellNum;       meta_data{i_mouse, i_mouseDay}.isMixTypeFreeIdx{j_mouseDay} = nan_cellNum;
            
            % remap has to be yes for both conditions, no empty data set
            i_map = 1; j_map = 2;
            if meta_data{i_mouse, i_mouseDay}.isEmpty || meta_data{i_mouse, j_mouseDay}.isEmpty
                % one of the mouseDay has no data set, do nothing
                
            elseif isRemap{i_mouse}{i_mouseDay} & isRemap{i_mouse}{j_mouseDay}
                
                [isSpaceIdx_i, isRewardIdx_i, isMixIdx_i, isTypeFreeIdx_i] = get3Type_PC(meta_data, i_mouse, i_mouseDay, i_mouseDay, i_map, j_map);
                [isSpaceIdx_j, isRewardIdx_j, isMixIdx_j, isTypeFreeIdx_j] = get3Type_PC(meta_data, i_mouse, j_mouseDay, j_mouseDay, i_map, j_map);
% % %                 figure;
% % %                 subplot(1,2,1)
% % %                 imagesc([isSpaceIdx_i, isRewardIdx_i, isMixIdx_i, isTypeFreeIdx_i]);
% % %                 subplot(1,2,2)
% % %                 imagesc([isSpaceIdx_j, isRewardIdx_j, isMixIdx_j, isTypeFreeIdx_j]);
                meta_data{i_mouse, i_mouseDay}.isSpaceSpaceIdx{j_mouseDay} = isSpaceIdx_i & isSpaceIdx_j;
                meta_data{i_mouse, i_mouseDay}.isSpaceRewardIdx{j_mouseDay} = isSpaceIdx_i & isRewardIdx_j;
                meta_data{i_mouse, i_mouseDay}.isSpaceMixIdx{j_mouseDay} = isSpaceIdx_i & isMixIdx_j;
                meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeIdx{j_mouseDay} = isSpaceIdx_i & isTypeFreeIdx_j;
% % %                 figure;
% % %                 imagesc([meta_data{i_mouse, i_mouseDay}.isSpaceSpaceIdx{j_mouseDay}, ...
% % %                     meta_data{i_mouse, i_mouseDay}.isSpaceRewardIdx{j_mouseDay}, ...
% % %                     meta_data{i_mouse, i_mouseDay}.isSpaceMixIdx{j_mouseDay},...
% % %                     meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeIdx{j_mouseDay}])
                meta_data{i_mouse, i_mouseDay}.isRewardSpaceIdx{j_mouseDay} = isRewardIdx_i & isSpaceIdx_j;
                meta_data{i_mouse, i_mouseDay}.isRewardRewardIdx{j_mouseDay} = isRewardIdx_i & isRewardIdx_j;
                meta_data{i_mouse, i_mouseDay}.isRewardMixIdx{j_mouseDay} = isRewardIdx_i & isMixIdx_j;
                meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeIdx{j_mouseDay} = isRewardIdx_i & isTypeFreeIdx_j;
                
                meta_data{i_mouse, i_mouseDay}.isMixSpaceIdx{j_mouseDay} = isMixIdx_i & isSpaceIdx_j;
                meta_data{i_mouse, i_mouseDay}.isMixRewardIdx{j_mouseDay} = isMixIdx_i & isRewardIdx_j;
                meta_data{i_mouse, i_mouseDay}.isMixMixIdx{j_mouseDay} = isMixIdx_i & isMixIdx_j;
                meta_data{i_mouse, i_mouseDay}.isMixTypeFreeIdx{j_mouseDay} = isMixIdx_i & isTypeFreeIdx_j;
                
                meta_data{i_mouse, i_mouseDay}.isSpaceSpaceNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isSpaceSpaceIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isSpaceRewardNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isSpaceRewardIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isSpaceMixNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isSpaceMixIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isSpaceTypeFreeIdx{j_mouseDay}, 'omitnan');
                
                
                meta_data{i_mouse, i_mouseDay}.isRewardSpaceNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isRewardSpaceIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isRewardRewardNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isRewardRewardIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isRewardMixNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isRewardMixIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isRewardTypeFreeIdx{j_mouseDay}, 'omitnan');
                
                meta_data{i_mouse, i_mouseDay}.isMixSpaceNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isMixSpaceIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isMixRewardNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isMixRewardIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isMixMixNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isMixMixIdx{j_mouseDay}, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.isMixTypeFreeNum(j_mouseDay,1) = sum(meta_data{i_mouse, i_mouseDay}.isMixTypeFreeIdx{j_mouseDay}, 'omitnan');
                
                
            end
            
            
        end
        
        
    end
    
    
    
end























end