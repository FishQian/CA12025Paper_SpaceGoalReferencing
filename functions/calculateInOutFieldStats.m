function meta_data = calculateInOutFieldStats(meta_data, isRemap, i_mouse, i_mouseDay, i_map, j_mouseDay, j_map, binThreshold,spaDivNum, sectionWindowSize)
% standard binThreshold is 4

% in field, defined as i_mouseDay, i_map field, project this as in-field to
% next condition

% actual peak amplitude is from j_mouseDay, j_map

n_cell = meta_data{i_mouse, i_mouseDay}.cellNum;
if isRemap{i_mouse}{j_mouseDay}
    n_lap = size(meta_data{i_mouse, j_mouseDay}.map(j_map).eachSpaDivFd, 2);
else
    n_lap = meta_data{i_mouse, j_mouseDay}.lapNum;
end
eachLapPeakAmplitude_inField = nan(n_lap, n_cell);
eachLapPeakAmplitude_inField_shift = nan(n_lap, n_cell);
eachLapMeanAmplitude_inField = nan(n_lap, n_cell);
eachLapMeanAmplitude_inField_shift = nan(n_lap, n_cell);
% adv lick trials only vs excluded
eachLapMeanAmplitude_withAdvLick_inField = nan(n_lap, n_cell);
eachLapMeanAmplitude_withAdvLick_inField_shift = nan(n_lap, n_cell);
eachLapMeanAmplitude_withOutAdvLick_inField = nan(n_lap, n_cell);
eachLapMeanAmplitude_withOutAdvLick_inField_shift = nan(n_lap, n_cell);



eachLapIsActive_inField = nan(n_lap, n_cell);
eachLapIsActive_inField_shift = nan(n_lap, n_cell);
inFieldIdx = nan(binThreshold*2+1, n_cell); % each column one cell
inFieldIdx_shift = nan(binThreshold*2+1, n_cell);
% X projects to Y
if isRemap{i_mouse}{j_mouseDay}
    Fd_map_Y = meta_data{i_mouse, j_mouseDay}.map(j_map).eachSpaDivFd;
    Fd_map_Y_withAdvLick = meta_data{i_mouse, j_mouseDay}.map(j_map).eachSpaDivFd_withAdvLick;
    Fd_map_Y_withOutAdvLick = meta_data{i_mouse, j_mouseDay}.map(j_map).eachSpaDivFd_withOutAdvLick;
else
    Fd_map_Y = meta_data{i_mouse, j_mouseDay}.eachSpaDivFd;
    Fd_map_Y_withAdvLick = meta_data{i_mouse, j_mouseDay}.map(j_map).eachSpaDivFd_withAdvLick;
    Fd_map_Y_withOutAdvLick = meta_data{i_mouse, j_mouseDay}.map(j_map).eachSpaDivFd_withOutAdvLick;
end
eventThreshold = meta_data{i_mouse, j_mouseDay}.signalThreshold_dFishQ;
for i_cell = 1:n_cell
%     i_cell
%     i_mouseDay
%     j_mouseDay
%     i_map
%     j_map
    if meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, i_map}(i_cell) % is a place cell
        location = meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition(i_cell);
        [inFieldIdx(:, i_cell), inFieldIdx_shift(:, i_cell)] = peakLocation2_In_Out_FieldIdx(location, binThreshold, spaDivNum);
        eachLapPeakAmplitude_inField(:, i_cell) = (max(squeeze(Fd_map_Y(inFieldIdx(:, i_cell), :, i_cell)), [], 1, 'omitnan'));
        eachLapPeakAmplitude_inField_shift(:, i_cell) = (max(squeeze(Fd_map_Y(inFieldIdx_shift(:, i_cell), :, i_cell)), [], 1, 'omitnan'));
        
        % in and out field dFoF, standard, withAdvLick, withOutAdvLick
        inField_dFoF = squeeze(Fd_map_Y(inFieldIdx(:, i_cell), :, i_cell)); inField_dFoF(inField_dFoF <= 0) = 0;
        inField_dFoF_withAdvLick = squeeze(Fd_map_Y_withAdvLick(inFieldIdx(:, i_cell), :, i_cell)); inField_dFoF_withAdvLick(inField_dFoF_withAdvLick <= 0) = 0;
        inField_dFoF_withOutAdvLick = squeeze(Fd_map_Y_withOutAdvLick(inFieldIdx(:, i_cell), :, i_cell)); inField_dFoF_withOutAdvLick(inField_dFoF_withOutAdvLick <= 0) = 0;
        
        eachLapMeanAmplitude_inField(:, i_cell) = (mean(inField_dFoF,  1, 'omitnan'));
        eachLapMeanAmplitude_withAdvLick_inField(:, i_cell) = (mean(inField_dFoF_withAdvLick,  1, 'omitnan'));
        eachLapMeanAmplitude_withOutAdvLick_inField(:, i_cell) = (mean(inField_dFoF_withOutAdvLick,  1, 'omitnan'));
        
        
        inField_shift_dFoF = squeeze(Fd_map_Y(inFieldIdx_shift(:, i_cell), :, i_cell));inField_shift_dFoF(inField_shift_dFoF <=0) = 0;
        inField_shift_dFoF_withAdvLick = squeeze(Fd_map_Y_withAdvLick(inFieldIdx_shift(:, i_cell), :, i_cell));inField_shift_dFoF_withAdvLick(inField_shift_dFoF_withAdvLick <=0) = 0;
        inField_shift_dFoF_withOutAdvLick = squeeze(Fd_map_Y_withOutAdvLick(inFieldIdx_shift(:, i_cell), :, i_cell));inField_shift_dFoF_withOutAdvLick(inField_shift_dFoF_withOutAdvLick <=0) = 0;
        
        
        eachLapMeanAmplitude_inField_shift(:, i_cell) = mean(inField_shift_dFoF, 1, 'omitnan');
        eachLapMeanAmplitude_withAdvLick_inField_shift(:, i_cell) = mean(inField_shift_dFoF_withAdvLick, 1, 'omitnan');
        eachLapMeanAmplitude_withOutAdvLick_inField_shift(:, i_cell) = mean(inField_shift_dFoF_withOutAdvLick, 1, 'omitnan');
        
        
        
        eachLapIsActive_inField(:, i_cell) = eachLapPeakAmplitude_inField(:, i_cell) > eventThreshold(i_cell);
        eachLapIsActive_inField_shift(:, i_cell) = eachLapPeakAmplitude_inField_shift(:, i_cell) > eventThreshold(i_cell);
        
    end
    
end

%% if n_lap >100, cut extra; if n_lap<100, add extra
if n_lap>100
    eachLapPeakAmplitude_inField = eachLapPeakAmplitude_inField(1:100, :);
    eachLapPeakAmplitude_inField_shift = eachLapPeakAmplitude_inField_shift(1:100, :);
    
    eachLapMeanAmplitude_inField = eachLapMeanAmplitude_inField(1:100, :);
    eachLapMeanAmplitude_inField_shift = eachLapMeanAmplitude_inField_shift(1:100, :);
    
    eachLapMeanAmplitude_withAdvLick_inField = eachLapMeanAmplitude_withAdvLick_inField(1:100, :);
    eachLapMeanAmplitude_withAdvLick_inField_shift = eachLapMeanAmplitude_withAdvLick_inField_shift(1:100, :);
    eachLapMeanAmplitude_withOutAdvLick_inField = eachLapMeanAmplitude_withOutAdvLick_inField(1:100, :);
    eachLapMeanAmplitude_withOutAdvLick_inField_shift = eachLapMeanAmplitude_withOutAdvLick_inField_shift(1:100, :);
    
    eachLapIsActive_inField = eachLapIsActive_inField(1:100, :);
    eachLapIsActive_inField_shift = eachLapIsActive_inField_shift(1:100, :);
elseif n_lap<100
    lap_gap = 100-n_lap;
    space_gap = nan(lap_gap, n_cell);
    eachLapPeakAmplitude_inField = [eachLapPeakAmplitude_inField; space_gap];
    eachLapPeakAmplitude_inField_shift = [eachLapPeakAmplitude_inField_shift;space_gap];
    eachLapMeanAmplitude_inField = [eachLapMeanAmplitude_inField; space_gap];
    eachLapMeanAmplitude_inField_shift = [eachLapMeanAmplitude_inField_shift;space_gap];
    eachLapMeanAmplitude_withAdvLick_inField = [eachLapMeanAmplitude_withAdvLick_inField; space_gap];
    eachLapMeanAmplitude_withAdvLick_inField_shift = [eachLapMeanAmplitude_withAdvLick_inField_shift;space_gap];
    eachLapMeanAmplitude_withOutAdvLick_inField = [eachLapMeanAmplitude_withOutAdvLick_inField; space_gap];
    eachLapMeanAmplitude_withOutAdvLick_inField_shift = [eachLapMeanAmplitude_withOutAdvLick_inField_shift;space_gap];
    
    
    eachLapIsActive_inField = [eachLapIsActive_inField;space_gap];
    eachLapIsActive_inField_shift = [eachLapIsActive_inField_shift;space_gap];
end

meta_data{i_mouse, i_mouseDay}.map(i_map).inFieldIdx{j_mouseDay, j_map} = inFieldIdx;
meta_data{i_mouse, i_mouseDay}.map(i_map).inFieldIdx_shift{j_mouseDay, j_map} = inFieldIdx_shift;

meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField{j_mouseDay, j_map} = eachLapPeakAmplitude_inField;
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift{j_mouseDay, j_map} = eachLapPeakAmplitude_inField_shift;
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map} = eachLapMeanAmplitude_inField;
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift{j_mouseDay, j_map} = eachLapMeanAmplitude_inField_shift;
% with adv lick
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map} = eachLapMeanAmplitude_withAdvLick_inField;
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField_shift{j_mouseDay, j_map} = eachLapMeanAmplitude_withAdvLick_inField_shift;
% without adv lick
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField{j_mouseDay, j_map} = eachLapMeanAmplitude_withOutAdvLick_inField;
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map} = eachLapMeanAmplitude_withOutAdvLick_inField_shift;

meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField{j_mouseDay, j_map} = eachLapIsActive_inField;
meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift{j_mouseDay, j_map} = eachLapIsActive_inField_shift;
eachLapIsBothActive_inField = eachLapIsActive_inField + (eachLapIsActive_inField_shift); % nan, 0, 1, 2
eachLapIsBothActive_inField(eachLapIsBothActive_inField == 1) = false;
eachLapIsBothActive_inField(eachLapIsBothActive_inField == 2) = true; %, nan, 0, 0, true

% group per section: mean from the section, then mean across each cell, one
% number one animal
if ~meta_data{i_mouse, i_mouseDay}.isEmpty & ~meta_data{i_mouse, j_mouseDay}.isEmpty
    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsBothActive_inField{j_mouseDay, j_map} = eachLapIsBothActive_inField;
    meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField{j_mouseDay, j_map} = mean(trialGroupMean(eachLapIsBothActive_inField, sectionWindowSize), 2, 'omitnan');
    meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isSpace{j_mouseDay, j_map} = mean(trialGroupMean(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsBothActive_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, 4}.map(1).isSpaceAssociated{4, 2})), sectionWindowSize), 2, 'omitnan');
    meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isReward{j_mouseDay, j_map} = mean(trialGroupMean(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsBothActive_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, 4}.map(1).isRewardAssociated{4, 2})), sectionWindowSize), 2, 'omitnan');
end

end