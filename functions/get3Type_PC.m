function [isSpaceIdx_i, isRewardIdx_i, isMixIdx_i, isTypeFreeIdx_i] = get3Type_PC(meta_data, i_mouse, i_mouseDay, j_mouseDay, i_map, j_map)

%% get logical structure, no nan for different place cell type
% 





isSpaceIdx_i = meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}; % nan for not i_and_j cells
isRewardIdx_i = meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map};
isMixIdx_i = meta_data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map};
isSpaceIdx_i(isnan(isSpaceIdx_i)) = false; isSpaceIdx_i = logical(isSpaceIdx_i);
isRewardIdx_i(isnan(isRewardIdx_i)) = false; isRewardIdx_i = logical(isRewardIdx_i);
isMixIdx_i(isnan(isMixIdx_i)) = false; isMixIdx_i = logical(isMixIdx_i);
isTypeFreeIdx_i = logical(1 - double(isSpaceIdx_i | isRewardIdx_i | isMixIdx_i));






end