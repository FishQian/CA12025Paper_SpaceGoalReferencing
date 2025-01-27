function pcStats_acrossDay = calculatePC_TypeBias_AcrossDay(pcStatsAcrossDay, mouseGroupIdx, i_mouseDay, j_mouseDay)

pcStats_acrossDay = struct;

% 1-space, 2-reward, 3-mix, 4-typefree, 5-sum, 6-ratio, 7-ratio-sp-bias
Space_num = [pcStatsAcrossDay.spaceSpaceNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.spaceRewardNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.spaceMixNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.spaceTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx)];
Space_sum = sum(Space_num, 1, 'omitnan');
Space_Ratio = Space_num ./ Space_sum;
Space_Ratio_SP_bias = Space_Ratio(1, :) ./ (Space_Ratio(1, :) + Space_Ratio(2, :));

pcStats_acrossDay.spaceNum = Space_num;
pcStats_acrossDay.spaceNum_Info = {'1-space, 2-reward, 3-mix, 4-typefree'};
pcStats_acrossDay.spaceNum_sum = Space_sum;
pcStats_acrossDay.spaceRatio = Space_Ratio;
pcStats_acrossDay.spaceRatio_SP_bias = Space_Ratio_SP_bias;

Reward_num = [pcStatsAcrossDay.rewardSpaceNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.rewardRewardNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.rewardMixNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.rewardTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx)];
Reward_sum = sum(Reward_num, 1, 'omitnan');
Reward_Ratio = Reward_num ./ Reward_sum;
Reward_Ratio_SP_bias = Reward_Ratio(1, :) ./ (Reward_Ratio(1, :) + Reward_Ratio(2,:));

pcStats_acrossDay.rewardNum = Reward_num;
pcStats_acrossDay.rewardNum_Info = {'1-space, 2-reward, 3-mix, 4-typefree'};
pcStats_acrossDay.rewardNum_sum = Reward_sum;
pcStats_acrossDay.rewardRatio = Reward_Ratio;
pcStats_acrossDay.rewardRatio_SP_bias = Reward_Ratio_SP_bias;

Mix_num = [pcStatsAcrossDay.mixSpaceNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.mixRewardNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.mixMixNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx);...
    pcStatsAcrossDay.mixTypeFreeNum_allMice{i_mouseDay, j_mouseDay}(mouseGroupIdx)];
Mix_sum = sum(Mix_num, 1, 'omitnan');
Mix_Ratio = Mix_num ./ Mix_sum;
Mix_Ratio_SP_bias = Mix_Ratio(1,:) ./ (Mix_Ratio(1,:) + Mix_Ratio(2,:));

pcStats_acrossDay.mixNum = Mix_num;
pcStats_acrossDay.mixNum_Info = {'1-space, 2-reward, 3-mix, 4-typefree'};
pcStats_acrossDay.mixNum_sum = Mix_sum;
pcStats_acrossDay.mixRatio = Mix_Ratio;
pcStats_acrossDay.mixRatio_SP_bias = Mix_Ratio_SP_bias;

end