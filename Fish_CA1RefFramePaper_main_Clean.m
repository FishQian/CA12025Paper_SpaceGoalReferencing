
clear
close all;
addpath(genpath('/Users/Fish/OneDrive - Baylor College of Medicine/MageeLab/MageeMatlab'))

% profile on;
set(0,'DefaultAxesColorOrder',cbrewer('qual','Dark2',8))
tic
fields = {'meta_data', 'MiceAll', 'MiceDay', 'isRemap', 'cellNum', 'cellNum_cumsum'}
% dataName = 'BinData_no_dFoF';
% dataName = 'BinData2';
dataName = 'BinData_withNext100lapDay3';
x = load(['/Volumes/FishSSD5/CA1/AnalyzedData_CA1_V01/CA1_paper/allMice/', dataName, '.mat']);
toc
% % lapNum_cat = load(['/Volumes/FishSSD5/CA1/AnalyzedData_CA1_V01/CA1_paper/allMice/', dataName, '.mat'], 'lapNum_concat')
% % binData re-collection
meta_data = x.meta_data;
% lapNum_cat = x.lapNum_concat;
isRemap = x.isRemap;
cellNum = x.cellNum;
cellNum_cumsum = x.cellNum_cumsum;
MiceAll = x.MiceAll;
MiceDay = x.MiceDay;
clear x
Num_allMice = length(MiceAll);

%% internally generated sequence, is there a third component other than SC and PI
% Prediction: separate the trials into 2 groups: anticipatory lick group vs no
% anticipatory licking trials. the cells with a field before reward zone
% might be modulated by this (anticipation of reward/attention/...)

for i_mouse = 1:17
    for i_mouseDay = 1:6
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty
            if isRemap{i_mouse}{i_mouseDay} % remapping day, day4-6
                for i_map = 1:2
                    X = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivLickSum';
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick = (max(X(4:13, :), [], 1, 'omitnan') >= 1);
                    
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd;
                    
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, nan2false(~meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick), :) = nan; % remove no-adv-lick lap
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick), :) = nan; % remove adv-lick lap
                end
            else % first 3 days
                for i_map = 1
                    X = meta_data{i_mouse, i_mouseDay}.eachSpaDivLickSum_mat';
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick = (max(X(4:13, :), [], 1, 'omitnan') >= 1);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick = meta_data{i_mouse, i_mouseDay}.eachSpaDivFd;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick = meta_data{i_mouse, i_mouseDay}.eachSpaDivFd;
                    
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, nan2false(~meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick), :) = nan;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick), :) = nan;
                end
                
                for i_map = 2
                    X = meta_data{i_mouse, i_mouseDay}.eachSpaDivLickSum_mat';
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick = (max(X(4:13, :), [], 1, 'omitnan') >= 1);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick = nan(size(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd));
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick = nan(size(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd));
                    
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, nan2false(~meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick), :) = nan;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick), :) = nan;
                end
            end
            
        end
    end
end

% % % % % check individual cells, with lick rate map, Fd_map,
% % % % % Fd_map_withAdvLick, Fd_map_withOutAdvLick
% % % % i_mouse = 5; i_mouseDay = 4; i_map = 1; j_map = 1;
% % % % i_cell = 88;
% % % % figure;
% % % % if isRemap{i_mouse}{i_mouseDay}
% % % %     h0=subplot(6,4,1:4:13); b0 = imagesc(((meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivLickSum)), [0 3]); colormap(h0, hot);
% % % %     h1=subplot(6,4,2:4:14); b1 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:, :, i_cell)))', [0 1]); colormap(h1, jet); set(b1, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:, :, i_cell)))'));
% % % %     h5 = subplot(6,4,22); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02]);
% % % % else
% % % %     h0=subplot(6,4,1:4:13); b0 = imagesc(((meta_data{i_mouse, i_mouseDay}.eachSpaDivLickSum_mat)), [0 3]); colormap(h0, hot);
% % % %     h1=subplot(6,4,2:4:14); b1 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, :, i_cell)))', [0 1]); colormap(h1, jet); set(b1, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, :, i_cell)))'));
% % % %     h5 = subplot(6,4,22); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02])
% % % % end
% % % % % withAdvLick all within map(i_map)
% % % % h2=subplot(6,4,3:4:15); b2 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, :, i_cell)))', [0 1]); colormap(h2, jet); set(b2, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, :, i_cell)))'));
% % % % h3=subplot(6,4,4:4:16); b3 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, :, i_cell)))', [0 1]); colormap(h3, jet); set(b3, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, :, i_cell)))'));
% % % % h6 = subplot(6,4,23); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02])
% % % % h7 = subplot(6,4,24); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02])
% % % % sgtitle(num2str(i_cell));

% calculate in-field related variables, require cross-day conditions
% eachLapPeakAmplitude_inField,eachLapPeakAmplitude_inField_shift
% eachLapActive_inField, eachLapActive_inField_shift


binThreshold  = 4 % spatial bin change criterion for defining similar field 
spaDivNum = 50
sectionWindowSize = 25; % group variable into one section
lapNum = 100
if mod(lapNum, sectionWindowSize) == 0
    sectionNum = lapNum/sectionWindowSize;
else
    sectionNum = fix(lapNum/sectionWindowSize) +1;
end

% initialize variable
for i_mouse = 1:Num_allMice
    for i_mouseDay = 1:6
        for i_map = 1:2
            meta_data{i_mouse, i_mouseDay}.map(i_map).inFieldIdx = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).inFieldIdx_shift = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift = cell(6,2);
            
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift = cell(6,2);
            % advLickTrial only vs excluded
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField_shift = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift = cell(6,2);
            
            
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift = cell(6,2);
            
            meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField = cell(6,2);
%             meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isSpace = cell(6,2);
%             meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift_isSpace = cell(6,2);
            meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isReward = cell(6,2);
%             meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift_isReward = cell(6,2);
            for j_mouseDay = 1:6
                for j_map = 1:2
                    if ~meta_data{i_mouse, i_mouseDay}.isEmpty & ~meta_data{i_mouse, j_mouseDay}.isEmpty
                        meta_data{i_mouse, i_mouseDay}.map(i_map).inFieldIdx{j_mouseDay, j_map} = nan(binThreshold*2+1, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).inFieldIdx_shift{j_mouseDay, j_map} = nan(binThreshold*2+1, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField_shift{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift{j_mouseDay, j_map} = nan(lapNum, meta_data{i_mouse, i_mouseDay}.cellNum);
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField{j_mouseDay, j_map} = nan(sectionNum, 1);
%                         meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift{j_mouseDay, j_map} = nan(sectionNum, 1);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isSpace{j_mouseDay, j_map} = nan(sectionNum, 1);
%                         meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift_isSpace{j_mouseDay, j_map} = nan(sectionNum, 1);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsBothActive_inField_isReward{j_mouseDay, j_map} = nan(sectionNum, 1);
%                         meta_data{i_mouse, i_mouseDay}.map(i_map).group_eachLapIsActive_inField_shift_isReward{j_mouseDay, j_map} = nan(sectionNum, 1);
                        
                    end
                    
                end
                
            end
        end
    end
end

for i_mouse = 1:Num_allMice
    for i_mouseDay = 1:6
       for j_mouseDay = 1:6
          
           if meta_data{i_mouse, i_mouseDay}.isEmpty | meta_data{i_mouse, j_mouseDay}.isEmpty % empty dataset for one condition

           else  % data set exists for day i and day j
               if isRemap{i_mouse}{i_mouseDay} & isRemap{i_mouse}{j_mouseDay}
                   for i_map = 1:2
                       for j_map = 1:2
                           meta_data = calculateInOutFieldStats(meta_data, isRemap, i_mouse, i_mouseDay, i_map, j_mouseDay, j_map, binThreshold, spaDivNum, sectionWindowSize);
                       end
                   end
               elseif isRemap{i_mouse}{i_mouseDay} & ~isRemap{i_mouse}{j_mouseDay}
                   j_map = 1;
                   for i_map = 1:2
                       meta_data = calculateInOutFieldStats(meta_data, isRemap, i_mouse, i_mouseDay, i_map, j_mouseDay, j_map, binThreshold,spaDivNum, sectionWindowSize);
                   end
               elseif ~isRemap{i_mouse}{i_mouseDay} & isRemap{i_mouse}{j_mouseDay}
                   i_map = 1;
                   for j_map = 1:2
                       meta_data = calculateInOutFieldStats(meta_data, isRemap, i_mouse, i_mouseDay, i_map, j_mouseDay, j_map, binThreshold,spaDivNum, sectionWindowSize);
                   end
               elseif ~isRemap{i_mouse}{i_mouseDay} & ~isRemap{i_mouse}{j_mouseDay}
                   i_map = 1; j_map = 1;
                   meta_data = calculateInOutFieldStats(meta_data, isRemap, i_mouse, i_mouseDay, i_map, j_mouseDay, j_map, binThreshold,spaDivNum, sectionWindowSize);

               end
           end
       end
    end
end

% % % % validate analysis
% % % i_mouse = 1; i_mouseDay = 4; i_map = 1; j_map = i_map; j_mouseDay = i_mouseDay;
% % % i_cell = 30;
% % % figure;
% % % if isRemap{i_mouse}{i_mouseDay}
% % %     h0=subplot(6,4,1:4:13); b0 = imagesc(((meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivLickSum)), [0 3]); colormap(h0, hot);
% % %     h1=subplot(6,4,2:4:14); b1 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:, :, i_cell)))', [0 1]); colormap(h1, jet); set(b1, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:, :, i_cell)))'));
% % %     h5 = subplot(6,4,22); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02]);
% % % else
% % %     h0=subplot(6,4,1:4:13); b0 = imagesc(((meta_data{i_mouse, i_mouseDay}.eachSpaDivLickSum_mat)), [0 3]); colormap(h0, hot);
% % %     h1=subplot(6,4,2:4:14); b1 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, :, i_cell)))', [0 1]); colormap(h1, jet); set(b1, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, :, i_cell)))'));
% % %     h5 = subplot(6,4,22); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02])
% % % end
% % % h2=subplot(6,4,3:4:15); b2 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, :, i_cell))), [0 1]); colormap(h2, jet); set(b2, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, :, i_cell)))));set(gca, 'YDir','normal')
% % % h3=subplot(6,4,4:4:16); b3 = imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, :, i_cell))), [0 1]); colormap(h3, jet); set(b3, 'AlphaData',~isnan((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, :, i_cell)))));set(gca, 'YDir','normal')
% % % h6 = subplot(6,4,19); plot(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}(:, i_cell), '-+'); ylim([-0.02 3.02])
% % % h7 = subplot(6,4,20); plot(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField{j_mouseDay, j_map}(:, i_cell), '-+'); ylim([-0.02 3.02])
% % % h8 = subplot(6,4,23); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withAdvLick(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02]);
% % % h9 = subplot(6,4,24); plot(mean((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_withOutAdvLick(:, :, i_cell))), 2, 'omitnan')); ylim([-0.02 3.02])
% % % sgtitle([MiceAll{i_mouse}, ', cell#', num2str(i_cell)]);
% % % 



DataFolder = '/Volumes/FishSSD5/CA1/AnalyzedData_CA1_V01/CA1_paper/allMice'
%  map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map},
%  map(i_map).peakPosition_allMice{i_mouseDay}
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
i_group = 1 % combined
map_allMice      = groupData_multiDay_CA1(meta_data, mouseGroupIdx{i_group}, mouseDayIdx{i_group}, Num_allMice, MiceDay, isRemap);
i_group = 2
map_novelBelt      = groupData_multiDay_CA1(meta_data, mouseGroupIdx{i_group}, mouseDayIdx{i_group}, Num_allMice, MiceDay, isRemap);

i_group = 3
map_familiarBelt      = groupData_multiDay_CA1(meta_data, mouseGroupIdx{i_group}, mouseDayIdx{i_group}, Num_allMice, MiceDay, isRemap);

i_group = 4
map_newExp      = groupData_multiDay_CA1(meta_data, mouseGroupIdx{i_group}, mouseDayIdx{i_group}, Num_allMice, MiceDay, isRemap);

i_group = 5 % take the first day A
map_allA = groupData_multiDay_CA1(meta_data, mouseGroupIdx{i_group}, mouseDayIdx{i_group}, Num_allMice, MiceDay, isRemap);

i_group = 6 % take the first day A
map_memoryB = groupData_multiDay_CA1(meta_data, mouseGroupIdx{i_group}, mouseDayIdx{i_group}, Num_allMice, MiceDay, isRemap);


X = {map_allMice, map_novelBelt, map_familiarBelt, map_newExp, map_allA, map_memoryB};
MAP = {};
for i_group = 1:6
    MAP{i_group}.map = X{i_group};
end
clear X
%% part 1. one analysis one animal, for statistical tests



%% part 2. analysis that focuses on group: map_allMice, map_familiarBelt, map_novelBelt, map_aABB

% representation visualization, odd vs even, first vs second 100 laps
% 1.1 day 1, 

%% same index as map1, plot ensemblem representation for map 2
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'}
mkdir([DataFolder, '/remap_representation_test_env']);
currPlaneIdx = '1st'
allMiceAddress = 'allMice'
% % % for i_mouseDay = 5
% % %     i_group = 2 % new experiment, familiar remap then novel belt rempa
% % %     plotGroupRemapRepresentation(allMiceAddress, [DataFolder, '/remap_representation_test_env'], map_novelBelt, i_mouseDay, groupNamePool{i_group}, groupNameLabelPool{i_group}, dayLabel{i_mouseDay});
% % %     i_group = 3
% % %     plotGroupRemapRepresentation(allMiceAddress, [DataFolder, '/remap_representation_test_env'], map_familiarBelt, i_mouseDay, groupNamePool{i_group}, groupNameLabelPool{i_group}, dayLabel{i_mouseDay});
% % %     i_group = 4
% % %     plotGroupRemapRepresentation(allMiceAddress, [DataFolder, '/remap_representation_test_env'], map_newExp, i_mouseDay, groupNamePool{i_group}, groupNameLabelPool{i_group}, dayLabel{i_mouseDay});
% % %     i_group = 5
% % %     plotGroupRemapRepresentation(allMiceAddress, [DataFolder, '/remap_representation_test_env'], map_allA, i_mouseDay, groupNamePool{i_group}, groupNameLabelPool{i_group}, dayLabel{i_mouseDay});
% % % end


%% calculate pc type number and ratio for each mouse and mouseDay
% meta_data{i_mouse, i_mouseDay}.map(i_map).spacePC_num{j_mouseDay, j_map}
meta_data = calculate_PF_Stat(meta_data, Num_allMice, isRemap, MiceDay);





%% calculate history of pc types across days
meta_data = PF_Type_HistoryTrack(meta_data, Num_allMice, isRemap, MiceDay);

groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
for i_group = 1:6
    MAP{i_group}.mapName = groupNameLabelPool{i_group};
    MAP{i_group}.pcStats = cell(6,6,2,2);
    MAP{i_group}.isPCType = cell(6,6,2,2);
    MAP{i_group}.groupIsBothActive = cell(6,6,2,2); % is both active in and out field, all pc, is-space, is-reward
    MAP{i_group}.pcStatsAcrossDay = struct;
    MAP{i_group}.pcStatsAcrossDay = group_PF_3type_stats_acrossDay(meta_data, mouseGroupIdx{i_group}, Num_allMice);
    MAP{i_group}.groupIsBothActive = groupIsBothActive(meta_data, mouseGroupIdx{i_group}, sectionWindowSize, lapNum);
    
    for i_mouseDay = 3:6
        for j_mouseDay= 3:6
            
            % pcStatsAcrossDay deals with one day at a time
             
            for i_map = 1:2
                for j_map = 1:2
                    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map} = group_PF_3type_stats(meta_data, mouseGroupIdx{i_group}, i_mouseDay, j_mouseDay, i_map, j_map);
                    % isPCType, isSpace = 1; isReward = 2; isMix = 3;
                    MAP{i_group}.isPCType{i_mouseDay, j_mouseDay, i_map, j_map} = MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map} + ...
                        2 *  MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map} + ...
                        3 *  MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map};
                end
            end
        end
    end
end
clear map_allMice map_familiarBelt map_novelBelt map_allA map_newExp map_memoryB

i_group = 1 % familiar belt
i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map=2;
MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}

figure; 
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17};
i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map=2;
stats = {MAP{1}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(mouseGroupIdx{2}), ...
    MAP{1}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(mouseGroupIdx{2}),... % MAP{1}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice(mouseGroupIdx{2}),...
    MAP{1}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(mouseGroupIdx{3}),...
    MAP{1}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(mouseGroupIdx{3}),... %     MAP{1}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice(mouseGroupIdx{3})

}

xTickLabel  = {'aBBB, SC, day 1', 'aBBB, PI, day 1', 'aAAA, SC, day 1', 'aAAA, PI, day 1'}
yLabel = 'place cell fraction'; yLimit = [0 1]
h = plotBar_meanSEM(stats, xTickLabel, yLabel, yLimit)
yticks([0  0.25  0.5 0.75 1]); set(gca,'TickDir','out'); xlim([0.5 4.5]); ylim([-0.0 1.02])


p = []
i_group = 1 % familiar belt
i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map=2;
[h, p(1)] = ttest2(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6),...
    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:17))
[h2, p(2)] = ttest2(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(1:6),...
    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(7:17))
[h3, p(3)] = ttest2(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice(1:6),...
    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice(7:17))

% Extended Data Fig. 4, fraction of mix vs allo, ego vs allo
fraction_allo = [MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6);
    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12)];
fraction_ego = [MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(1:6);
    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(7:12)];
fraction_mix = [MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice(1:6);
    MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice(7:12)];

% aBBB, day 1
SP_bias_1 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6) + MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(1:6));
% aA, aAAA, aABB, day 1
SP_bias_2 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:17) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:17) +MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(7:17));
SP_bias_2_1 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12) +MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(7:12));
SP_bias_2_2 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(13:17) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(13:17) +MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(13:17));


% aBBB, aAAA, aABB, day 2, bias factor
i_mouseDay = 5; j_mouseDay = 5;i_map = 1; j_map=2;
SP_bias_3 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6) + MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(1:6));
SP_bias_4 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12) + MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(7:12));
SP_bias_5 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(13:17) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(13:17) +  MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(13:17));

% aBBB, aAAA, aABB, day 3, bias factor
i_mouseDay = 6; j_mouseDay = 6;i_map = 1; j_map=2;
SP_bias_6 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(1:6) + MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(1:6));
SP_bias_7 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(7:12) + MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(7:12));
SP_bias_8 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(13:17) ./ ...
    (MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice(13:17) +  MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice(13:17));

SP_bias_aBBB = SP_bias_3 ./ SP_bias_1;
SP_bias_aAAA = SP_bias_4 ./ SP_bias_2_1;
SP_bias_aABB = SP_bias_5 ./ SP_bias_2_2;


[h4, p(4)] = ttest2(SP_bias_1, SP_bias_2)
[h5, p(5)] = ttest2(SP_bias_3, SP_bias_4); % p = 0.0127
[h6, p(6)] = ttest2(SP_bias_3, SP_bias_5) % p = 0.043
[h7, p(7)] = ttest2([SP_bias_4], [SP_bias_5]) % p = 0.10
[h8, p(8)] = ttest2(SP_bias_aAAA(2:6), SP_bias_aABB) % p = 0.0242, if remove aAAA 2.3077 data point, p=0.0008
[h9, p(9)] = ttest2(SP_bias_aAAA, SP_bias_aBBB) % p = 0.8275
[h10, p(10)] = ttest2(SP_bias_aBBB, SP_bias_aABB) % p = 0.0089
[h11, p(11)] = ttest2(SP_bias_2_1, SP_bias_4) % p = 0.7653
[h12, p(12)] = ttest2(SP_bias_6, SP_bias_7); % p = 0.0004
[h13, p(13)] = ttest2(SP_bias_6, SP_bias_8) % p = 0.395
[h14, p(14)] = ttest2(SP_bias_7, SP_bias_8) % p = 0.0047
[h15, p(15)] = ttest(SP_bias_3, SP_bias_1); % p = 0.6920, aBBB day +2 vs aBBB day +1
%% Extended Data Fig.8
[h16, p(16)] = ttest(SP_bias_4, SP_bias_2_1) % p = 0.4774, aAAA day +2 vs aAAA day +1
display('familiar day1, all/(allo+ego), SPBias')
mean(SP_bias_2_1), std(SP_bias_2_1)/sqrt(length(SP_bias_2_1))
display('familiar day2, all/(allo+ego), SPBias')
mean(SP_bias_4), std(SP_bias_4)/sqrt(length(SP_bias_4))

[h17, p(17)] = ttest(SP_bias_5, SP_bias_2_2) % p = 0.0013, aABB day+2 vs aABB day +1
display('familiar day1, all/(allo+ego), SPBias')
mean(SP_bias_2_2), std(SP_bias_2_2)/sqrt(length(SP_bias_2_2))
display('familiar day2, all/(allo+ego), SPBias')
mean(SP_bias_5), std(SP_bias_5)/sqrt(length(SP_bias_5))



[h12, p(12)] = ttest2(SP_bias_2_2, SP_bias_5) % p = 0.0004
% bias across conditions
stats2 = {SP_bias_1, SP_bias_2, SP_bias_2_1, SP_bias_2_2, SP_bias_3, SP_bias_4, SP_bias_5, SP_bias_6, SP_bias_7, SP_bias_8}; 
yLabel = 'S-P bias'; yLimit = [0 1]
xTickLabel = {'aB, day +1', 'aAA+aAB, day +1', 'aAA, day +1','aAB, day +1','aBB, day +2', 'aAA, day +2', 'aAB, day +2','aBB, day +3', 'aAA, day +3', 'aAB, day +3'}
h = plotBar_meanSEM(stats2, xTickLabel, yLabel, yLimit)


% bias change, day2/day1
stats3 = {SP_bias_1, SP_bias_3, SP_bias_2_1, SP_bias_4, SP_bias_2_2, SP_bias_5}
xTickLabel = {'aBBB, day +1', 'aBBB, day +2', 'aAAA, day +1', 'aAAA, day +2',  'aABB, day +1',  'aABB, day +2'};
ylabel('S-P bias across days'); yLimit = [0 1]
h = plotBar_meanSEM(stats3, xTickLabel, yLabel, yLimit)

% bias change, day 2 vs day 1, single group
stats3 = {SP_bias_2_2, SP_bias_5}
xTickLabel = {'aABB, day +1',  'aABB, day +2'};
ylabel('S-P bias across days'); yLimit = [0 1]
h = plotBar_meanSEM(stats3, xTickLabel, yLabel, yLimit)



%% bootstrapping analysis for pc type ratio

rng('default')  % For reproducibility
% MAP{i_group}.isPCType{i_mouseDay, j_mouseDay, i_map, j_map}
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
i_map = 1; j_map=2;
bootstat = {};
bootstat_10x = {};
% once the bootstrp n is large enough, adding more sampling times won't
% affect the bootstrp results.
for i_group = 2:4
    for i_mouseDay = 4:5
        j_mouseDay = i_mouseDay;
        x = MAP{i_group}.isPCType{i_mouseDay, j_mouseDay, i_map, j_map}; % row vector()
        bootstat{i_group, i_mouseDay} = bootstrp(10000,@countPC_SP_bias, x);
%         bootstat_10x{i_group, i_mouseDay} = bootstrp(10000,@countPC_SP_bias, [x, x, x, x, x, x, x, x, x, x]);
    end
end

figure; 
subplot(2,1,1)
for i_group = 2:4
    histogram(bootstat{i_group, 4}, 'Normalization', 'probability', 'BinWidth', 0.01); hold on;
end
% for i_group = 2:5
% histogram(bootstat_10x{i_group, 4}, 'Normalization', 'probability', 'BinWidth', 0.01); hold on; 
% end
legend({'aBBB-day1', 'aAAA-day1', 'aABB-day1', 'aAAA+aABB-day1'}); xlim([0 1])
xlabel('S-P bias'); ylabel('fraction'); ax = gca; ax.FontSize = 20; box off

subplot(2,1,2);
for i_group = 2:4
    histogram(bootstat{i_group, 5}, 'Normalization', 'probability', 'BinWidth', 0.01); hold on;
end
legend({'aBBB-day2', 'aAAA-day2', 'aABB-day2'}); xlabel('S-P bias'); ylabel('fraction'); ax = gca; ax.FontSize = 20;xlim([0 1]); box off;


%% calculate history of pc types across days
% MAP{i_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{i_mouseDay, j_mouseDay}
i_group = 1; i_mouseDay = 4; j_mouseDay = 5
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

for i_group = 2:4 % aAAA
     MAP{i_group}.pcTypeBias_acrossDay_allMice = cell(6,6)
    for i_mouseDay = 4:6
        for j_mouseDay = 4:6
            MAP{i_group}.pcTypeBias_acrossDay_allMice{i_mouseDay, j_mouseDay} = calculatePC_TypeBias_AcrossDay(MAP{1}.pcStatsAcrossDay, mouseGroupIdx{i_group}, i_mouseDay, j_mouseDay);
        end
    end
end

% % % % single day_i project to day_j, but be comprehensive
% % % i_mouseDay = 4; j_mouseDay = 5;
% % % i_group = 2; 
% % % plotPCType_acrossDay(MAP{i_group}.pcTypeBias_acrossDay_allMice{i_mouseDay, j_mouseDay}, groupNameLabelPool{i_group}, i_mouseDay, j_mouseDay, dayLabel);
% % % i_group = 3
% % % plotPCType_acrossDay(MAP{i_group}.pcTypeBias_acrossDay_allMice{i_mouseDay, j_mouseDay}, groupNameLabelPool{i_group}, i_mouseDay, j_mouseDay, dayLabel)
% % % i_group = 4
% % % plotPCType_acrossDay(MAP{i_group}.pcTypeBias_acrossDay_allMice{i_mouseDay, j_mouseDay}, groupNameLabelPool{i_group}, i_mouseDay, j_mouseDay, dayLabel)


% % % % pick the most critical analysis and present at same spot
% % % 
% % % plotPCType_acrossDay_cleanResult(MAP, groupNameLabelPool, dayLabel)
% % % 

%% ego cells on day 1, PF stability btw day 1 and day 2, both before reward switch.
%% response, rebuttal, review (nn, referee 1)

% % % colorM = cbrewer('qual', 'Set1', 9)
% % % x1 = (MAP{3}.map(1).peakPositionChange_allMice{3,4,1}(nan2false(MAP{3}.map(1).isSpaceAssociated_allMice{3,3,1}) & nan2false(MAP{3}.map(1).isSpaceAssociated_allMice{4,4,1})));
% % % x2 = (MAP{3}.map(1).peakPositionChange_allMice{4,5,1}(nan2false(MAP{3}.map(1).isRewardAssociated_allMice{4,4,2}) & nan2false(MAP{3}.map(1).isSpaceAssociated_allMice{5,5,1})));
% % % x3 = (MAP{2}.map(1).peakPositionChange_allMice{3,4,1}(nan2false(MAP{2}.map(1).isSpaceAssociated_allMice{3,3,1}) & nan2false(MAP{2}.map(1).isSpaceAssociated_allMice{4,4,1})));
% % % 
% % % [N1, E] = histcounts(x1, 'BinLimit', [-24 25], 'BinWidth', 1, 'Normalization', 'probability');
% % % [N2, E] = histcounts(x2, 'BinLimit', [-24 25], 'BinWidth', 1, 'Normalization', 'probability');
% % % [N3, E] = histcounts(x3, 'BinLimit', [-24 25], 'BinWidth', 1, 'Normalization', 'probability')
% % % 
% % % 
% % % [h,p] = kstest2(abs(x1), abs(x2))
% % % figure; 
% % % plot(E(1:end-1), N1, 'k', 'LineWidth', 1); hold on;
% % % plot(E(1:end-1), N2, 'Color', colorM(1,:), 'LineWidth', 1); 
% % % xticks([-25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25]); xticklabels({'-90', '-72', '-54', '-36', '-18', '0', '18', '36', '54', '72', '90'});
% % % xlim([-25.2 25.2]); ylim([-0.005 0.25]); axis square;
% % % title([outputPValue(p)]); 
% % % yticks(0:0.05:0.25); set(gca, 'FontSize', 15); box off
% % % legend('Day 0 to Day 1, F to F, all PCs', 'Day 1 to Day 2, F to F, goal PCs')
% % % 
% % % mean(x1 <= 4)
% % % sum(x1<=4)
% % % length(x1)
% % % mean(x1, 'omitnan')*3.6
% % % std(x1, 'omitnan')/sqrt(length(x1))*3.6
% % % 
% % % mean(x2 <= 4)
% % % sum(x2<=4)
% % % length(x2)
% % % mean(x2, 'omitnan')*3.6
% % % std(x2, 'omitnan')/sqrt(length(x2))*3.6
%% pie chart, single day for each group
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

%% Fig1e, Fig2d, pie charts
i_mouseDay = 4; j_mouseDay = i_mouseDay; i_map = 1; j_map = 2;
for i_group = 2:4
    pieChartSingleDay(DataFolder, MAP, i_group, i_mouseDay, j_mouseDay,i_map, j_map, dayLabel, groupNameLabelPool);
%     pieChartSingleDay_newPC(DataFolder, MAP, i_group, i_mouseDay, j_mouseDay,i_map, j_map, dayLabel, groupNameLabelPool);
end

% scatter plot for new pc

% % % i_map = 1; j_map = 2;i_mouseDay = 4; j_mouseDay = i_mouseDay; 
% % % i_group = 2;
% % % idx = MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, i_mouseDay-1, i_map}
% % % find_idx = find(idx==1);
% % % figure;
% % % for i = 1:length(find_idx)
% % %     i_cell = find_idx(i);
% % %     if MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map}(i_cell)
% % %         scatter(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay}(i_cell), MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay}(i_cell), 100, 'k', 'filled'); hold on;
% % %     else
% % %         scatter(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay}(i_cell), -3 +5*(rand(1)-0.5), 100, 'r', 'filled'); hold on;
% % %     end
% % % end
% % % 
% % % xticks([1 25 50]); ylim([-6 51]); xlim([-6 51]); yticks([-3 0 25 50]); box off;set(gca, 'TickDir','out'); xticklabels('');yticklabels('')


%% pie chart, tracking history pc type
% % % 
% % % mkdir([DataFolder, '/PCTypeHistoryTrack'])
% % % dayLabel = {'-3', '-2', '-1', '+1', '+2', '+3'}
% % % i_map = 1; j_map = 2
% % % for i_mouseDay = 4
% % %     for j_mouseDay = 5
% % %         pieChartPC_category_historyTracking(DataFolder, MAP{2}.map, MAP{3}.map, MAP{4}.map, i_mouseDay, i_map, j_map, j_mouseDay, dayLabel)
% % % %         pie_Bar_chart_PC_category_historyTracking(DataFolder, MAP{2}.map, MAP{3}.map, MAP{4}.map, i_mouseDay, i_map, j_map, j_mouseDay, dayLabel)
% % %         
% % %     end
% % % end


%% pie chart, combined with bar chart, tracking history pc type
mkdir([DataFolder, '/PCTypeHistoryTrack'])
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA'}
dayLabel = {'-3', '-2', '-1', '+1', '+2', '+3'}
i_map = 1; j_map = 2
% % % for i_mouseDay = 4
% % %     for j_mouseDay = 4
% % %         for i_group = 3
% % %             % with type free
% % %             pie_Bar_chart_PC_category_historyTracking(DataFolder, MAP, i_group, i_mouseDay, i_map, j_map, j_mouseDay, dayLabel, groupNameLabelPool)
% % %             % without type free
% % % %             pie_Bar_chart_PC_category_historyTracking_clean(DataFolder, MAP, i_group, i_mouseDay, i_map, j_map, j_mouseDay, dayLabel, groupNameLabelPool)
% % %         end
% % %     end
% % % end


i_mouseDay = 4; j_mouseDay = 5;
i_group = 3; j_group = 4; 
% Allo-Ego, Fraction of PCs
%% Fig. 3; Fig.3; Fig.3c; Fig.3d; Fig. 3c; Fig. 3d
%% Fig3c, Fig3d
pie_Bar_chart_PC_finalClean(DataFolder, MAP, i_group, i_mouseDay, i_map, j_map, j_mouseDay, dayLabel, groupNameLabelPool, j_group)

%% behavior analysis
%% Fig1b (group summary source data)
i_group = 3; i_mouseDay = 4
plotBehavior(MAP, i_group, i_mouseDay, dayLabel, groupNameLabelPool)

%% Fig2a, group summary
i_group = 2; i_mouseDay = 4
plotBehavior(MAP, i_group, i_mouseDay, dayLabel, groupNameLabelPool)

% % separate pre and post for talk presentation
% plotBehavior_v2(MAP, i_group, i_mouseDay, dayLabel, groupNameLabelPool)


%% compare behavior day -1, aBBB vs aAAA
% % % i_group = 3; j_group = 2;
% % % i_map = 1; i_mouseDay = 3
% % % % figure; plot(MAP{i_group}.map(i_map).eachSpaDivSpeed_allMice{3,1}*100, 'Color', [214,214,214]/255); 
% % % % hold on; plot(mean(MAP{i_group}.map(i_map).eachSpaDivSpeed_allMice{3,1}*100,2), 'LineWidth', 2, 'Color', 'k')
% % % % plot(MAP{j_group}.map(i_map).eachSpaDivSpeed_allMice{3,1}*100, 'Color', [245, 193, 193]/255); 
% % % % hold on; plot(mean(MAP{j_group}.map(i_map).eachSpaDivSpeed_allMice{3,1}*100,2), 'LineWidth', 2, 'Color', 'r')
% % % % 
% % % figure;
% % % stdshade(MAP{i_group}.map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay,1}', 0.25, 'k'); hold on;
% % % stdshade(MAP{j_group}.map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay,1}', 0.25, 'r');
% % % xline(14, '--k');
% % % xticks([1 25 50]); ylim([-0.02 0.52]); xlim([0 51]); yticks([0 0.125 0.25 0.375 0.5]); box off;set(gca, 'TickDir','out'); xticklabels('');yticklabels('')
% % % title([groupNameLabelPool{i_group}, ', day: ', dayLabel{i_mouseDay}, ' versus ', groupNameLabelPool{j_group}, ', day: ', dayLabel{i_mouseDay},])
% % % 
% % % figure;
% % % stdshade(MAP{i_group}.map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay,1}', 0.25, 'k'); hold on;
% % % stdshade(MAP{j_group}.map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay,1}', 0.25, 'r');
% % % xline(14, '--k');
% % % xticks([1 25 50]); ylim([-0.02 1.02]); xlim([0 51]); yticks([0  0.25 0.5 0.75 1]); box off;set(gca, 'TickDir','out'); xticklabels('');yticklabels('')
% % % title([groupNameLabelPool{i_group}, ', day: ', dayLabel{i_mouseDay}, ' versus ', groupNameLabelPool{j_group}, ', day: ', dayLabel{i_mouseDay},])


%% behavior quantification
% % % y1 = {}; y2 = {}; y1_insideRZ = {};y1_outsideRZ = {}; y2_insideRZ = {}; y2_outsideRZ = {};
% % % for i_group = 2:4
% % %     i_mouseDay = 4;
% % %     i_map = 1; j_map = 2;
% % %     y1{i_group} = MAP{i_group}.map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1};
% % %     y2{i_group} = MAP{i_group}.map(j_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1};
% % %     
% % %     idx1 = (5:17); idx2 = [1:4, 18:50];
% % %     idx3 = [30:42]; idx4 = [1:29, 43:50];
% % %     y1_insideRZ{i_group} = mean(y1{i_group}(idx1, :), 1, 'omitnan');
% % %     y1_outsideRZ{i_group} = mean(y1{i_group}(idx2, :), 1, 'omitnan');
% % %     y2_insideRZ{i_group} = mean(y2{i_group}(idx3, :), 1, 'omitnan');
% % %     y2_outsideRZ{i_group} = mean(y2{i_group}(idx4, :), 1, 'omitnan');
% % % end
% % % figure;
% % % i_group = 3
% % % scatter(ones(1,6), y1_insideRZ{i_group}./y1_outsideRZ{i_group}, 100, 'filled'); hold on;
% % % scatter(2*ones(1,6), y2_insideRZ{i_group}./y2_outsideRZ{i_group}, 100, 'filled');
% % % 
% % % i_group = 2
% % % scatter(3*ones(1,6), y1_insideRZ{i_group}./y1_outsideRZ{i_group}, 100, 'filled'); hold on;
% % % scatter(4*ones(1,6), y2_insideRZ{i_group}./y2_outsideRZ{i_group}, 100, 'filled');
% % % i_group = 4
% % % scatter(5*ones(1,5), y1_insideRZ{i_group}./y1_outsideRZ{i_group}, 100, 'filled'); hold on;
% % % scatter(6*ones(1,5), y2_insideRZ{i_group}./y2_outsideRZ{i_group}, 100, 'filled');
% % % 
% % % 
% % % xlim([0 7])
% % % ylim([0,1])
% % % 

%% bootstrapping acrossday pc type 
colorMap = cbrewer('qual','Dark2',8)
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17};
bootstat_acrossDay = {};
for i_group = 2:4
    i_group
    for i_mouseDay = 4:6
        i_mouseDay
        for j_mouseDay = 4:6
            x_space = MAP{i_group}.pcStatsAcrossDay.isSpace_SRMT_Idx_allMice{i_mouseDay, j_mouseDay}'; % row vector()
            x_reward = MAP{i_group}.pcStatsAcrossDay.isReward_SRMT_Idx_allMice{i_mouseDay, j_mouseDay}';
            x_mix = MAP{i_group}.pcStatsAcrossDay.isMix_SRMT_Idx_allMice{i_mouseDay, j_mouseDay}';
            
            bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay} = struct;
            bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.space =  bootstrp(10000,@countPC_SP_bias, x_space);
            bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.reward =  bootstrp(10000,@countPC_SP_bias, x_reward);
            bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.mix =  bootstrp(10000,@countPC_SP_bias, x_mix);
        end
    end
end

%% null hypothesis: place cells on day +2 will remap randomly
% bootstrap: take natural PC position from MAP=3, on day 1,
i_map = 1; j_map = 2; i_group = 3; i_mouseDay = 4;
PF_positionSeed = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map});
rng('default')  % For reproducibility
shuffleNum = 10000
binThreshold  = 4 % spatial bin change criterion for defining similar field 
spaDivNum = 50
SPBias_shuffle = nan(shuffleNum, 4);
for n = 1:shuffleNum
    randomPFLocation = randi([1, 50], length(PF_positionSeed), 1);
    SPBias_shuffle(n, :) = calculateSPBias(PF_positionSeed, randomPFLocation, binThreshold, spaDivNum);
end
% validation
%% ExtendedFig8a
figure;
subplot(2,1,1)
h = histogram(SPBias_shuffle(:, 4), 'Normalization', 'probability', 'BinWidth', 0.01); hold on; 
h.FaceColor = 'k';h.FaceAlpha = 0.4; h.EdgeColor = 'w'
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'out'); box off; ylim([0 0.12]); yticks([0 0.04 0.08 0.12])

xline(prctile(SPBias_shuffle(:, 4), 0.1), '--k');
xline(prctile(SPBias_shuffle(:, 4), 99.9), '--k');
i_group = 3; j_group = 4
x1 = sum(MAP{i_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{4, 5}, 'omitnan')/(sum(MAP{i_group}.pcStatsAcrossDay.spaceRewardNum_allMice{4, 5}, 'omitnan') + sum(MAP{i_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{4, 5}, 'omitnan'));
x2 = sum(MAP{j_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{4, 5}, 'omitnan')/(sum(MAP{j_group}.pcStatsAcrossDay.spaceRewardNum_allMice{4, 5}, 'omitnan') + sum(MAP{j_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{4, 5}, 'omitnan'));
xline(x1, 'b', 'LineWidth', 2)
xline(x2, 'r', 'LineWidth', 2)
xlim([0 1]);title(['space-SR', ', day', dayLabel{i_mouseDay}, ' to ', dayLabel{j_mouseDay}]); 
legend({'null', '', '', ...
    ['aAAA'],   ...
    ['aABB']}); legend('boxoff'); ylabel('fraction'); xlabel('S-R bias')

subplot(2,1,2)
h = histogram(SPBias_shuffle(:, 1), 'Normalization', 'probability', 'BinWidth', 0.01); hold on;
h.FaceColor = 'b';h.FaceAlpha = 0.4; h.EdgeColor = 'w'
h = histogram(SPBias_shuffle(:, 2), 'Normalization', 'probability', 'BinWidth', 0.01); hold on;
h.FaceColor = 'r';h.FaceAlpha = 0.4; h.EdgeColor = 'w'
h = histogram(SPBias_shuffle(:, 3), 'Normalization', 'probability', 'BinWidth', 0.01); hold on;
h.FaceColor = 'k';h.FaceAlpha = 0.4; h.EdgeColor = 'w';
legend('space', 'reward', 'mix'); title(['null distribution if random remapping', ', day', dayLabel{i_mouseDay}, ' to ', dayLabel{j_mouseDay}]); 
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'out'); box off;legend('boxoff'); xlim([0 1]);ylabel('fraction'); xlabel('S-R bias')

% plot pc type evolution simple plots
dayLabel = {'-3', '-2', '-1', '+1', '+2', '+3'}
mainLineWidth = 1;
minorLineWidth = 0.5
%% Fig3e
figure; 
i_mouseDay = 4; j_mouseDay = 5;
i_group = 3; 
h1 = histogram(bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.space,'BinLimit', [0 1], 'BinWidth', 0.02, 'Normalization', 'probability'); hold on
h1.FaceColor = 'b'; h1.FaceAlpha = 0.2; h1.EdgeColor = 'none'
xline(prctile(bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.space, 5),'--', 'Color', 'b', 'LineWidth', minorLineWidth)
j_group = 4;
ys = sum(MAP{j_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{4, 5}, 'omitnan')/(sum(MAP{j_group}.pcStatsAcrossDay.spaceRewardNum_allMice{4, 5}, 'omitnan') + sum(MAP{j_group}.pcStatsAcrossDay.spaceSpaceNum_allMice{4, 5}, 'omitnan'))
xline(ys, 'b', 'LineWidth', 2);
legend({['aAAA - bootstrap'],  '', ...
    ['aABB - real'],  '', '', });
xlim([0 1]); box off; legend('boxoff'); xticks(0:0.25:1)
xlabel('A-E bias'); ylabel('Fraction of PCs'); ylim([0 0.15]); yticks([0:0.05:0.15]); axis square
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'out'); box off; title(['allo-PC day 1, A-E bias, day', dayLabel{i_mouseDay}, ' to ', dayLabel{j_mouseDay}])
% Fig3e, source data
x_fig3e = bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.space;


%% Fig3f
figure; 
i_group = 3; 
h1 = histogram(bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.reward,'BinLimit', [0 1], 'BinWidth', 0.02, 'Normalization', 'probability'); hold on
h1.FaceColor = 'r'; h1.FaceAlpha = 0.2; h1.EdgeColor = 'none'
j_group = 4
yr = sum(MAP{j_group}.pcStatsAcrossDay.rewardSpaceNum_allMice{4, 5}, 'omitnan')/(sum(MAP{j_group}.pcStatsAcrossDay.rewardRewardNum_allMice{4, 5}, 'omitnan') + sum(MAP{j_group}.pcStatsAcrossDay.rewardSpaceNum_allMice{4, 5}, 'omitnan'))
xline(yr, 'r', 'LineWidth', 2); hold on;xticks(0:0.125:0.5)
xline(prctile(bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.reward, 5),'--', 'Color', 'r', 'LineWidth', minorLineWidth)
legend({['aAAA, bootstrap'], ...
    ['aABB, real']});
xlabel('A-E bias'); ylabel('Fraction of PCs'); ylim([0 0.3]); yticks([0:0.05:0.3]); axis square; xlim([0 0.5])
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'out'); box off; title(['ego-PC day 1, A-E bias, day', dayLabel{i_mouseDay}, ' to ', dayLabel{j_mouseDay}])
% Fig3f, source data
x_fig3f = bootstat_acrossDay{i_group, i_mouseDay, j_mouseDay}.reward;


%% the properties of the most stable place cells across days.
% focus on the a-a-a-A paradigm
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}



%% rate remapping analysis
% 1) a-B, rate remapping
% 2) a-B, the activity rate change can be predicted by the distribution of
% SC-PI cell ratio from aA day+1;
i_group = 2;
i_map = 1; i_mouseDay = 3; j_mouseDay = 4;
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17}; 
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA'}
dayLabel = {'-3', '-2', '-1', '+1', '+2', '+3'}


% get odd and even trial avg_eachSpaDiv_Fd_sm_allMice
for i_group = 2:4
    for i_map = 1:2
        for i_mouseDay = 1:6
                MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay} = nan(size(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}));
                MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay} = nan(size(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}));
                if ~size(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay},1) % no cells
                    
                else % cells exist
                    
                    
                    for i_cell = 1:MAP{i_group}.map(i_map).cellNum_cumsum(end, i_mouseDay)
                        onset = MAP{i_group}.map(i_map).onsetLapIdx_allMice{i_mouseDay}(i_cell);
                        if isnan(onset)
                            onset = MAP{i_group}.map(i_map).firstLapIdx_allMice{i_mouseDay}(i_cell) % trial 1 as onset
                        end
                        if ~(mod(onset, 2) == 0) % onset is odd
                            MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}(:, i_cell) = squeeze(mean(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}(:, onset:2:end, i_cell), 2, 'omitnan'));
                            MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}(:, i_cell) = squeeze(mean(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}(:, (onset+1):2:end, i_cell), 2, 'omitnan'));
                        else
                            MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}(:, i_cell) = squeeze(mean(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}(:, (onset+1):2:end, i_cell), 2, 'omitnan'));
                            MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}(:, i_cell) = squeeze(mean(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}(:, onset:2:end, i_cell), 2, 'omitnan'));
                            
                        end
                    end
                end
        end
    end
end


% % % % validate the odd and even trial data
% % % i_group = 3;
% % % i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map = 2;
% % % figure; 
% % % subplot(1,3,1); imagesc(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}', [0 1]); title('mean all trials')
% % % subplot(1,3,2); imagesc(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}', [0 1]); title('mean odd trials')
% % % subplot(1,3,3); imagesc(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}', [0 1]);title('mean even trials')
% % % 

%% representation from a to B, vs a to A
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17}; 
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'aaaB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA'}
dayLabel = {'-3', '-2', '-1', '+1', '+2', '+3'}


%% plot representatino of space vs pi place cellls
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

%% Fig1d; Fig2c
i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map = 2;
i_group = 2
idx = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
% rep =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, idx);
rep1 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}(:, idx);
rep2 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}(:, idx);
isNormalization = true
% plotSingleRepresentation(rep, isNormalization, 'aBBB, space PC', dayLabel{i_mouseDay})
plotSingleRepresentation_crossV(rep1, rep2, isNormalization, 'aBBB, space PC, even sort by odd lap', dayLabel{i_mouseDay})


idx = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
% rep =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, idx);
rep1 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}(:, idx);
rep2 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}(:, idx);
isNormalization = true
% plotSingleRepresentation(rep, isNormalization, 'aBBB, PI PC', dayLabel{i_mouseDay})
plotSingleRepresentation_crossV(rep1, rep2, isNormalization, 'aBBB, PI PC, even sort by odd lap', dayLabel{i_mouseDay})

i_group = 3
idx = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
rep =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, idx);
rep1 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}(:, idx);
rep2 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}(:, idx);
isNormalization = true
% plotSingleRepresentation(rep, isNormalization, 'aAAA, space PC', dayLabel{i_mouseDay})
plotSingleRepresentation_crossV(rep1, rep2, isNormalization, 'aAAA, space PC, even sort by odd lap', dayLabel{i_mouseDay})


idx = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
rep =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, idx);
rep1 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_odd_allMice{i_mouseDay}(:, idx);
rep2 =MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_even_allMice{i_mouseDay}(:, idx);
isNormalization = true
% plotSingleRepresentation(rep, isNormalization, 'aAAA, PI PC', dayLabel{i_mouseDay})

% plotSingleRepresentation(rep1, isNormalization, 'aAAA, PI PC', dayLabel{i_mouseDay})
plotSingleRepresentation_crossV(rep1, rep2, isNormalization, 'aAAA, PI PC, even sort by odd lap', dayLabel{i_mouseDay})

close all

% a-->B, rate change
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

i_map = 1;
aB_a1 = MAP{2}.map(i_map).eachLapMeanAmplitude_inField_allMice{3,3,1}(:, nan2false(MAP{2}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aB_B1_1 = MAP{2}.map(i_map).eachLapMeanAmplitude_inField_allMice{4,4,1}(:, nan2false(MAP{2}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aB_B1_2 = MAP{2}.map(i_map).eachLapMeanAmplitude_inField_allMice{4,4,2}(:, nan2false(MAP{2}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aB_rateChange_aB = mean(aB_B1_1(1:25, :), 1, 'omitnan') - mean(aB_a1(1:25, :), 1, 'omitnan');

aB_position_B1 = MAP{2}.map(i_map).peakPosition_allMice{4,1}(nan2false(MAP{2}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aB_position_a1 = MAP{2}.map(i_map).peakPosition_allMice{3,1}(nan2false(MAP{2}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aB_rateChange_aB_positionGrouped = cell(spaDivNum, 1);
for i_position = 1:spaDivNum
    aB_rateChange_aB_positionGrouped{i_position} = [];
    isPosition = aB_position_B1 == i_position;
    if ~isempty(aB_position_B1(isPosition))
        aB_rateChange_aB_positionGrouped{i_position} = aB_rateChange_aB(isPosition)';
    end
end

aA_a1 = MAP{3}.map(i_map).eachLapMeanAmplitude_inField_allMice{3,3,1}(:, nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aA_A1_1 = MAP{3}.map(i_map).eachLapMeanAmplitude_inField_allMice{4,4,1}(:, nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aA_A1_2 = MAP{3}.map(i_map).eachLapMeanAmplitude_inField_allMice{4,4,2}(:, nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aA_rateChange_aA = mean(aA_A1_1(1:25, :), 1, 'omitnan') - mean(aA_a1(1:25, :), 1, 'omitnan');
aA_position_A1 = MAP{3}.map(i_map).peakPosition_allMice{4,1}(nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aA_position_a1 = MAP{3}.map(i_map).peakPosition_allMice{3,1}(nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{3,4,1}));
aA_rateChange_aA_positionGrouped = cell(spaDivNum, 1);
for i_position = 1:spaDivNum
    aA_rateChange_aA_positionGrouped{i_position} = [];
    isPosition = aA_position_A1 == i_position;
    if ~isempty(aA_position_A1(isPosition))
        aA_rateChange_aA_positionGrouped{i_position} = aA_rateChange_aA(isPosition)';
    end
end
% delta rate change vs peak position
% % % figure; subplot(1,2,1)
% % % plotLine_meanSEM(aB_rateChange_aB_positionGrouped, 'k');
% % % yline(0, '--k')
% % % subplot(1,2,2);
% % % plotLine_meanSEM(aA_rateChange_aA_positionGrouped, 'r');
% % % yline(0, '--r')
% % % 
% % % figure
% % % subplot(1,3,1)
% % % scatter(aA_position_A1+0.2, aA_rateChange_aA, 100, 'k', 'filled');hold on
% % % scatter(aB_position_B1-0.2, aB_rateChange_aB, 100, 'r', 'filled');
% % % legend('aAAA', 'aBBB'); xlabel('peak position on day 1, belt A/B')
% % % subplot(1,3,2)
% % % scatter(aA_position_a1+0.2, aA_rateChange_aA, 100, 'k', 'filled');hold on
% % % scatter(aB_position_a1-0.2, aB_rateChange_aB, 100, 'r', 'filled');
% % % legend('aAAA', 'aBBB'); xlabel('peak position on day -1, belt a')
% % % subplot(1,3,3)
% % % scatter(aA_position_a1+0.2, mean(aA_a1, 1, 'omitnan'), 100, 'k', 'filled');hold on
% % % scatter(aB_position_a1-0.2, mean(aB_a1, 1, 'omitnan'), 100, 'r', 'filled');
% % % legend('aAAA', 'aBBB'); xlabel('peak position on day -1, belt a'); ylabel('activity rate')
% % % 

% from each single animal
rateChangeGroupIdx = nan(spaDivNum, 1); % used for group assignmen of each cell
rateChangeGroupIdx(14:23,1) = 1; % +- 4 spatial bins around PI peak dFoF
rateChangeGroupIdx(24:33,1) = 2;
rateChangeGroupIdx(34:43,1) = 3; %
rateChangeGroupIdx([1:3, 44:50],1) = 4;
rateChangeGroupIdx(4:13, 1) = 5


rateChangeLapIdx_pool = {1:25, 26:50, 51:75, 76:100, 1:100}
rateChangeLapIdx = 76:100;
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

rateFractionChangeStats = struct;
rateFractionChangeStats.allPC.rateChangeLapIdx = {};
rateFractionChangeStats.allPC.rateFractionChange = {};
rateFractionChangeStats.allPC.rateFractionChange_withAdvLick = {};
rateFractionChangeStats.allPC.rateFractionChange_withOutAdvLick = {};
% only include / exclude adv lick trials
rateFractionChangeStats.stablePC.rateChangeLapIdx = {};
rateFractionChangeStats.stablePC.rateFractionChange = {};
rateFractionChangeStats.stablePC.rateFractionChange_withAdvLick = {};
rateFractionChangeStats.stablePC.rateFractionChange_withOutAdvLick = {};


for i_rateLapGroup = 1:5
    rateChangeLapIdx = rateChangeLapIdx_pool{i_rateLapGroup}
    for i_group = 2:3
        MAP{i_group}.rateFractionChange_stablePC_groupAll = cell(6,1)
        MAP{i_group}.rateFractionChange_allPC_groupAll = cell(6,1)
        % only include / exclude adv lick trials
        MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll = cell(6,1)
        MAP{i_group}.rateFractionChange_withAdvLick_allPC_groupAll = cell(6,1)
        MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll = cell(6,1)
        MAP{i_group}.rateFractionChange_withOutAdvLick_allPC_groupAll = cell(6,1)
        
        % 
        for i = 1:length(mouseGroupIdx{i_group}) % aBBB and aAAA only
            i_mouse = mouseGroupIdx{i_group}(i);
            i_mouseDay = 3; j_mouseDay = 4;
            i_map = 1; j_map = 1;
            % absolute change
            
            % peak position is defined as day +1  peak from the first 100 laps
            positionData_stablePC = meta_data{i_mouse, j_mouseDay}.map(j_map).peakPosition(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}));
            positionData_allPC = meta_data{i_mouse, j_mouseDay}.map(j_map).peakPosition(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}));
            
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateChange{j_mouseDay, j_map} = ...
                meta_data{i_mouse, j_mouseDay}.map(j_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map} - meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{i_mouseDay, i_map};
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateChange_stablePC{j_mouseDay, j_map} = ...
                meta_data{i_mouse, i_mouseDay}.map(i_map).rateChange{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}));
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateChange_allPC{j_mouseDay, j_map} = ...
                meta_data{i_mouse, i_mouseDay}.map(i_map).rateChange{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}));
            
            % fraction change, calculate rate first for each day, then do the
            % fraction calculation
% % %             meanRateToday =  (mean(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{i_mouseDay, i_map}(rateChangeLapIdx, :), 1, 'omitnan'))';
% % % %             display([num2str(sum(meanRateToday<0)), ' pc low activity, rate Today'])
% % %             meanRateToday(meanRateToday<0) = 0;
% % %             meanRateTomo = (mean(meta_data{i_mouse, j_mouseDay}.map(j_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}(rateChangeLapIdx, :), 1, 'omitnan'))';
% % % %             display([num2str(sum(meanRateTomo<0)), ' pc low activity, rate Tomo'])
% % %             meanRateTomo(meanRateTomo<0) = 0;
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange{j_mouseDay, j_map} = calculateRateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{i_mouseDay, i_map}, meta_data{i_mouse, j_mouseDay}.map(j_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}, rateChangeLapIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC{j_mouseDay, j_map} = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange{j_mouseDay, j_map}(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}));
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC{j_mouseDay, j_map} = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange{j_mouseDay, j_map}(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}));
            % only include adv lick trials
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick{j_mouseDay, j_map} = calculateRateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{i_mouseDay, i_map}, meta_data{i_mouse, j_mouseDay}.map(j_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}, rateChangeLapIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC{j_mouseDay, j_map} = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick{j_mouseDay, j_map}(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}));
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC{j_mouseDay, j_map} = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick{j_mouseDay, j_map}(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}));
            % exclude adv lick trials
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick{j_mouseDay, j_map} = calculateRateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{i_mouseDay, i_map}, meta_data{i_mouse, j_mouseDay}.map(j_map).eachLapMeanAmplitude_withOutAdvLick_inField{j_mouseDay, j_map}, rateChangeLapIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC{j_mouseDay, j_map} = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick{j_mouseDay, j_map}(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}));
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC{j_mouseDay, j_map} = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick{j_mouseDay, j_map}(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}));
            
            
            
            % group mean, one zone one mean value out of all place cells
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC_groupMean{j_mouseDay, j_map} = groupMean_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC{j_mouseDay, j_map}, positionData_stablePC, rateChangeGroupIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC_groupMean{j_mouseDay, j_map} = groupMean_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC{j_mouseDay, j_map}, positionData_allPC, rateChangeGroupIdx);
            % only include adv lick trials
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC_groupMean{j_mouseDay, j_map} = groupMean_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC{j_mouseDay, j_map}, positionData_stablePC, rateChangeGroupIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC_groupMean{j_mouseDay, j_map} = groupMean_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC{j_mouseDay, j_map}, positionData_allPC, rateChangeGroupIdx);
            % exclude adv lick trials
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC_groupMean{j_mouseDay, j_map} = groupMean_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC{j_mouseDay, j_map}, positionData_stablePC, rateChangeGroupIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC_groupMean{j_mouseDay, j_map} = groupMean_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC{j_mouseDay, j_map}, positionData_allPC, rateChangeGroupIdx);
            
            % groupMean value into one structure
            MAP{i_group}.rateFractionChange_stablePC_groupMean(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC_groupMean{j_mouseDay, j_map};
            MAP{i_group}.rateFractionChange_allPC_groupMean(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC_groupMean{j_mouseDay, j_map};
           
            MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupMean(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC_groupMean{j_mouseDay, j_map};
            MAP{i_group}.rateFractionChange_withAdvLick_allPC_groupMean(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC_groupMean{j_mouseDay, j_map};
           
            MAP{i_group}.rateFractionChange_stablePC_withOutAdvLick_groupMean(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC_groupMean{j_mouseDay, j_map};
            MAP{i_group}.rateFractionChange_allPC_withOutAdvLick_groupMean(:, i) = meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC_groupMean{j_mouseDay, j_map};
           
            
            % group natual population, used to calculate group median and plot
            % the distribution of all rate differences
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC_groupAllData{j_mouseDay, j_map} = groupAll_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC{j_mouseDay, j_map}, positionData_stablePC, rateChangeGroupIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC_groupAllData{j_mouseDay, j_map} = groupAll_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC{j_mouseDay, j_map}, positionData_allPC, rateChangeGroupIdx);
            % only include adv lick trials
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC_groupAllData{j_mouseDay, j_map} = groupAll_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC{j_mouseDay, j_map}, positionData_stablePC, rateChangeGroupIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC_groupAllData{j_mouseDay, j_map} = groupAll_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC{j_mouseDay, j_map}, positionData_allPC, rateChangeGroupIdx);
            % exclude adv lick trials
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC_groupAllData{j_mouseDay, j_map} = groupAll_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC{j_mouseDay, j_map}, positionData_stablePC, rateChangeGroupIdx);
            meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC_groupAllData{j_mouseDay, j_map} = groupAll_RateFractionChange(meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC{j_mouseDay, j_map}, positionData_allPC, rateChangeGroupIdx);
            
            
            
            for i_zone = 1:5
                % stable PC across day -1 to day +1, isPC_i_or_j, day-1 vs day+1 map1 only
                MAP{i_group}.rateFractionChange_stablePC_groupAll{i_zone, 1} = [MAP{i_group}.rateFractionChange_stablePC_groupAll{i_zone, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_stablePC_groupAll{6, 1} = [MAP{i_group}.rateFractionChange_stablePC_groupAll{6, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_allPC_groupAll{i_zone, 1} = [MAP{i_group}.rateFractionChange_stablePC_groupAll{i_zone, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_allPC_groupAll{6, 1} = [MAP{i_group}.rateFractionChange_allPC_groupAll{6, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_allPC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                % only include adv lick trials
                MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll{i_zone, 1} = [MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll{i_zone, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll{6, 1} = [MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll{6, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_withAdvLick_allPC_groupAll{i_zone, 1} = [MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll{i_zone, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_withAdvLick_allPC_groupAll{6, 1} = [MAP{i_group}.rateFractionChange_withAdvLick_allPC_groupAll{6, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withAdvLick_allPC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                % exclude adv lick trials
                MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll{i_zone, 1} = [MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll{i_zone, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll{6, 1} = [MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll{6, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_withOutAdvLick_allPC_groupAll{i_zone, 1} = [MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll{i_zone, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_stablePC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                MAP{i_group}.rateFractionChange_withOutAdvLick_allPC_groupAll{6, 1} = [MAP{i_group}.rateFractionChange_withOutAdvLick_allPC_groupAll{6, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).rateFractionChange_withOutAdvLick_allPC_groupAllData{j_mouseDay, j_map}{i_zone, 1}];
                
            end
        end
        rateFractionChangeStats.allPC.rateChangeLapIdx{i_rateLapGroup,i_group} = rateChangeLapIdx;
        rateFractionChangeStats.allPC.rateFractionChange{i_rateLapGroup,i_group} = MAP{i_group}.rateFractionChange_allPC_groupAll{6, 1};
        % only include adv lick trials vs exclude adv lick trials
        rateFractionChangeStats.allPC.rateFractionChange_withAdvLick{i_rateLapGroup,i_group} = MAP{i_group}.rateFractionChange_withAdvLick_allPC_groupAll{6, 1};
        rateFractionChangeStats.allPC.rateFractionChange_withOutAdvLick{i_rateLapGroup,i_group} = MAP{i_group}.rateFractionChange_withOutAdvLick_allPC_groupAll{6, 1};
        
        rateFractionChangeStats.stablePC.rateChangeLapIdx{i_rateLapGroup,i_group} = rateChangeLapIdx;
        rateFractionChangeStats.stablePC.rateFractionChange{i_rateLapGroup,i_group} = MAP{i_group}.rateFractionChange_stablePC_groupAll{6, 1};
        % only include adv lick trials vs exclude adv lick trials
        rateFractionChangeStats.stablePC.rateFractionChange_withAdvLick{i_rateLapGroup,i_group} = MAP{i_group}.rateFractionChange_withAdvLick_stablePC_groupAll{6, 1};
        rateFractionChangeStats.stablePC.rateFractionChange_withOutAdvLick{i_rateLapGroup,i_group} = MAP{i_group}.rateFractionChange_withOutAdvLick_stablePC_groupAll{6, 1};
        
        
        
        
    end
    
end




%% group mean Amplitude, standard, adv lick trials only, and without adv lick trials
advLickFractionThreshold = 0.2;
for i_rateLapGroup = 5
    rateChangeLapIdx = rateChangeLapIdx_pool{i_rateLapGroup}
    for i_group = 2:3
        MAP{i_group}.meanAmplitude_inField_stablePC_groupAll = cell(6,6,6);
        MAP{i_group}.meanAmplitude_inField_allPC_groupAll = cell(6,6,6);
        % only include / exclude adv lick trials
        MAP{i_group}.meanAmplitude_withAdvLick_inField_stablePC_groupAll = cell(6,6,6);
        MAP{i_group}.meanAmplitude_withAdvLick_inField_allPC_groupAll = cell(6,6,6);
        MAP{i_group}.meanAmplitude_withOutAdvLick_inField_stablePC_groupAll = cell(6,6,6);
        MAP{i_group}.meanAmplitude_withOutAdvLick_inField_allPC_groupAll = cell(6,6,6);
        
        
        for i = 1:length(mouseGroupIdx{i_group}) % aBBB and aAAA only
            i_mouse = mouseGroupIdx{i_group}(i);
            for i_mouseDay = 1:6
                for j_mouseDay = 1:6
                    i_map = 1; j_map = 1;
                    % absolute change
                    if ~meta_data{i_mouse, i_mouseDay}.isEmpty & ~meta_data{i_mouse, j_mouseDay}.isEmpty
                        % peak position is defined as day +1  peak from the first 100 laps
                        positionData_stablePC = meta_data{i_mouse, j_mouseDay}.map(j_map).peakPosition(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}));
                        positionData_allPC = meta_data{i_mouse, j_mouseDay}.map(j_map).peakPosition(nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}));
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_inField_stablePC_zoned{j_mouseDay, j_map} = groupAll_RateChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map})), positionData_stablePC, rateChangeGroupIdx, rateChangeLapIdx);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_inField_allPC_zoned{j_mouseDay, j_map} = groupAll_RateChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map})), positionData_allPC, rateChangeGroupIdx, rateChangeLapIdx);
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withAdvLick_inField_stablePC_zoned{j_mouseDay, j_map} = groupAll_RateChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map})), positionData_stablePC, rateChangeGroupIdx, rateChangeLapIdx);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withAdvLick_inField_allPC_zoned{j_mouseDay, j_map} = groupAll_RateChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map})), positionData_allPC, rateChangeGroupIdx, rateChangeLapIdx);
                        
                        meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withOutAdvLick_inField_stablePC_zoned{j_mouseDay, j_map} = groupAll_RateChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map})), positionData_stablePC, rateChangeGroupIdx, rateChangeLapIdx);
                        meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withOutAdvLick_inField_allPC_zoned{j_mouseDay, j_map} = groupAll_RateChange(meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField{j_mouseDay, j_map}(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map})), positionData_allPC, rateChangeGroupIdx, rateChangeLapIdx);
                        
                        for i_zone = 1:5
                            % stable PC across day -1 to day +1, isPC_i_or_j, day-1 vs day+1 map1 only
                            MAP{i_group}.meanAmplitude_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone} = [MAP{i_group}.meanAmplitude_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                            MAP{i_group}.meanAmplitude_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, 6} = [MAP{i_group}.meanAmplitude_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, 6}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                            MAP{i_group}.meanAmplitude_inField_allPC_groupAll{i_mouseDay, j_mouseDay, i_zone} = [MAP{i_group}.meanAmplitude_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                            MAP{i_group}.meanAmplitude_inField_allPC_groupAll{i_mouseDay, j_mouseDay, 6} = [MAP{i_group}.meanAmplitude_inField_allPC_groupAll{i_mouseDay, j_mouseDay, 6}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_inField_allPC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                            % only include adv lick trials
                            if mean(meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick, 'omitnan') >= advLickFractionThreshold & mean(meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick, 'omitnan') <= 1-advLickFractionThreshold 
                                MAP{i_group}.meanAmplitude_withAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone} = [MAP{i_group}.meanAmplitude_withAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withAdvLick_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                MAP{i_group}.meanAmplitude_withAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, 6} = [MAP{i_group}.meanAmplitude_withAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, 6}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withAdvLick_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                MAP{i_group}.meanAmplitude_withAdvLick_inField_allPC_groupAll{i_mouseDay, j_mouseDay, i_zone} = [MAP{i_group}.meanAmplitude_withAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withAdvLick_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                MAP{i_group}.meanAmplitude_withAdvLick_inField_allPC_groupAll{i_mouseDay, j_mouseDay, 6} = [MAP{i_group}.meanAmplitude_withAdvLick_inField_allPC_groupAll{i_mouseDay, j_mouseDay, 6}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withAdvLick_inField_allPC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                % exclude adv lick trials
                                MAP{i_group}.meanAmplitude_withOutAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay,i_zone} = [MAP{i_group}.meanAmplitude_withOutAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withOutAdvLick_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                MAP{i_group}.meanAmplitude_withOutAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, 6} = [MAP{i_group}.meanAmplitude_withOutAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, 6}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withOutAdvLick_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                MAP{i_group}.meanAmplitude_withOutAdvLick_inField_allPC_groupAll{i_mouseDay, j_mouseDay, i_zone} = [MAP{i_group}.meanAmplitude_withOutAdvLick_inField_stablePC_groupAll{i_mouseDay, j_mouseDay, i_zone}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withOutAdvLick_inField_stablePC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                                MAP{i_group}.meanAmplitude_withOutAdvLick_inField_allPC_groupAll{i_mouseDay, j_mouseDay, 6} = [MAP{i_group}.meanAmplitude_withOutAdvLick_inField_allPC_groupAll{i_mouseDay, j_mouseDay, 6}; meta_data{i_mouse, i_mouseDay}.map(i_map).meanAmplitude_withOutAdvLick_inField_allPC_zoned{j_mouseDay, j_map}{i_zone, 1}];
                            else
                                display(['mouse#', num2str(i_mouse), ', ', MiceAll{i_mouse}, ', day:', dayLabel{i_mouseDay}, ', adv lick fraction is ', num2str(mean(meta_data{i_mouse, i_mouseDay}.map(i_map).isAdvLick, 'omitnan')), ', removed from analysis'])
                            end
                        end
                    end
                end
            end
            
        end
    end
    
end


%% plot all mice, rate differences within zone for adv lick trials vs no-adv-lick-trials
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}


%% which mouse has the most increased activities rate in pre-reward zone
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

% % % i_mouseDay = 3; j_mouseDay = 4; i_map = 1; j_map = 1;i_zone = 1
% % % figure;
colorMap = {};
colorMap{2} = cbrewer('seq', 'YlOrRd', 11);
colorMap{3} = cbrewer('seq', 'YlGnBu', 11)
colorGroup = cbrewer('qual','Dark2',8);

% analyze reliability and spatial information differences between day -1
% and day +1
i_mouseDay = 3; j_mouseDay = 4; i_map = 1; j_map = 1;
for i_group =2:3
    MAP{i_group}.map(1).eachCellSpaInf_allPC_allMice = {};
    MAP{i_group}.map(1).eachCellSpaInf_stablePC_allMice ={};
    for i_mouseDay = 3:4
        MAP{i_group}.map(1).eachCellSI_v2_allMice{i_mouseDay,1} = nan(size(MAP{i_group}.map(1).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}, 2),1);
        MAP{i_group}.map(1).eachCellSelectivity_allMice{i_mouseDay,1} = nan(size(MAP{i_group}.map(1).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}, 2),1);
        for i_cell = 1:size(MAP{i_group}.map(1).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}, 2)
            a = MAP{i_group}.map(1).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, i_cell);
            a(a<0) = 0;
            MAP{i_group}.map(1).eachCellSI_v2_allMice{i_mouseDay,1}(i_cell) = mean(a .* log2(a ./mean(a, 'omitnan')), 'omitnan');
            MAP{i_group}.map(1).eachCellSelectivity_allMice{i_mouseDay,1}(i_cell) = (max(a, [], 'omitnan') - min(a, [], 'omitnan')) / mean(a, 'omitnan');
        end
        
        MAP{i_group}.map(1).eachCellSpaInf_allPC_allMice{i_mouseDay,1} = MAP{i_group}.map(1).eachCellSI_v2_allMice{i_mouseDay,1}(nan2false(MAP{i_group}.map(1).isPC_i_and_j{3,4,1}));
        MAP{i_group}.map(1).eachCellSpaInf_stablePC_allMice{i_mouseDay,1} = MAP{i_group}.map(1).eachCellSI_v2_allMice{i_mouseDay,1}(nan2false(MAP{i_group}.map(1).isSpaceAssociated_allMice{3,4,1}));
    end
end





%% selectivity
% for PI cells, spatial information correlate with distance after reward

PI_SI_allMice = MAP{3}.map(1).eachCellSI_v2_allMice{i_mouseDay,1}(nan2false(MAP{3}.map(1).isRewardAssociated_allMice{4,4,2}));
PI_Selectivity_allMice = MAP{3}.map(1).eachCellSelectivity_allMice{i_mouseDay,1}(nan2false(MAP{3}.map(1).isRewardAssociated_allMice{4,4,2}));
PI_peakPosition_allMice = MAP{3}.map(1).peakPosition_allMice{i_mouseDay,1}(nan2false(MAP{3}.map(1).isRewardAssociated_allMice{4,4,2}));
for i_cell = 1:length(PI_SI_allMice)
    if PI_peakPosition_allMice(i_cell)<=15
        PI_peakPosition_allMice(i_cell) = PI_peakPosition_allMice(i_cell)+50 - 15;
    else
        PI_peakPosition_allMice(i_cell) = PI_peakPosition_allMice(i_cell)-15;
    end
    
end


PI_SI_allMice_binGroup = nan(50,1);

for i_cell = 1:length(PI_SI_allMice)
    PI_SI_allMice_binGroup(PI_peakPosition_allMice(i_cell)) =  sum([PI_SI_allMice_binGroup(PI_peakPosition_allMice(i_cell)),PI_SI_allMice(i_cell)], 'omitnan')
end

%% Reliability
% firstLapFieldReliabiliity_allMice: reliability starts count from lap 1
% not the onset reliability
for i_group = 2:3
    MAP{i_group}.map(1).firstLapFieldReliability_allMice = cell(6,1);
    for i_mouseDay = 3:4
        i_map = 1;
        MAP{i_group}.map(1).firstLapFieldReliability_allMice{i_mouseDay, 1} = nan(size(MAP{i_group}.map(1).onsetFieldReliability_allMice{i_mouseDay, 1}));
        for i_cell = 1:length(MAP{i_group}.map(1).onsetFieldReliability_allMice{i_mouseDay, 1})
            MAP{i_group}.map(1).firstLapFieldReliability_allMice{i_mouseDay, 1}(i_cell) = mean(MAP{i_group}.map(1).isSigLap_allMice{i_mouseDay,1}(:, i_cell), 1, 'omitnan');
        end
    end
end


%% Gothard, McNaughton, 1996
%% 1) reward referenced version avg_eachSpaDivFd_sm in reference to reward location
%% 2) shifted version, everything shift 25 spatial bin
% correlation matrix, spatial population vector 
for i_mouse = 1:17
    for i_mouseDay = 4:6
        
            if ~meta_data{i_mouse, i_mouseDay}.isEmpty
                
                % first map, refrence to reward at 50, bin 14
                i_map = 1;
                X = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd;
                meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_ref2Reward = nan(size(meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm));
                lapNum_thisMouse = size(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd, 2);
                for i_cell = 1:meta_data{i_mouse, i_mouseDay}.cellNum
                    X_cell = squeeze(X(:, :, i_cell));
                    X_cell_vector = X_cell(:);
                    X_cell_vector_shift = [X_cell_vector(14:end); nan(13,1)];
                    X_cell_shift = reshape(X_cell_vector_shift, size(X_cell));
                    
                    lapIdx = meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapIdx(i_cell):lapNum_thisMouse;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_ref2Reward(:, i_cell) = mean(X_cell_shift(:, lapIdx), 2, 'omitnan');
                end
                
                % second map, refrence to reward at 140, bin 39
                  i_map =2;
                X = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd;
                meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_ref2Reward = nan(size(meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm));
                lapNum_thisMouse = size(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd, 2);
                for i_cell = 1:meta_data{i_mouse, i_mouseDay}.cellNum
                    X_cell = squeeze(X(:, :, i_cell));
                    X_cell_vector = X_cell(:);
                    X_cell_vector_shift = [X_cell_vector(39:end); nan(38,1)];
                    X_cell_shift = reshape(X_cell_vector_shift, size(X_cell));
                    
                    lapIdx = meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapIdx(i_cell):lapNum_thisMouse;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_ref2Reward(:, i_cell) = mean(X_cell_shift(:, lapIdx), 2, 'omitnan');
                end
                
                
                % both map, shift 90cm, 25 bins
                for i_map = 1:2
                X = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd;
                meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_shift90 = nan(size(meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm));
                lapNum_thisMouse = size(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd, 2);
                for i_cell = 1:meta_data{i_mouse, i_mouseDay}.cellNum
                    X_cell = squeeze(X(:, :, i_cell));
                    X_cell_vector = X_cell(:);
                    X_cell_vector_shift = [X_cell_vector(39:end); nan(38,1)];
                    X_cell_shift = reshape(X_cell_vector_shift, size(X_cell));
                    
                    lapIdx = meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapIdx(i_cell):lapNum_thisMouse;
                    meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_shift90(:, i_cell) = mean(X_cell_shift(:, lapIdx), 2, 'omitnan');
                end
                end
                
                
                
                
            end
        
    
    
    end
end

% create shifted avg_eachSpaDivFd_sm and shifted eachSpaDivFd_sm for MAP
for i_group = 2:4
    for i_mouseDay = 4:6
        % both map, shift 90cm, 25 bins, for average activity
        for i_map = 1:2
            X = MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1};
            MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_shift90_allMice{i_mouseDay,1} = nan(size(MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay,1}));
            MAP{i_group}.map(i_map).eachSpaDivFd_sm_shift90_allMice{i_mouseDay,1} = nan(size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}));

            lapNum_thisMap = size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 2);
            for i_cell = 1:size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 3)
                X_cell = squeeze(X(:, :, i_cell));
                X_cell_vector = X_cell(:);
                X_cell_vector_shift = [nan(25,1); X_cell_vector(1:end-25)];
                X_cell_shift = reshape(X_cell_vector_shift, size(X_cell));
                lapIdx = MAP{i_group}.map(i_map).firstLapIdx_allMice{i_mouseDay,1}(i_cell):lapNum_thisMap;
                                
                MAP{i_group}.map(i_map).eachSpaDivFd_sm_shift90_allMice{i_mouseDay,1}(:,:, i_cell) = X_cell_shift;
                MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_shift90_allMice{i_mouseDay,1}(:, i_cell) = mean(X_cell_shift(:, lapIdx), 2, 'omitnan');
            end
        end
                
    end
end




binThreshold = 0; % criterion for in-field, +- 4 is default, if 0, meaning no expansion of field, but only take the diagonal value out
spaDivNum= 50;
for i_mouse = 1:17
    for i_mouseDay = 1:6
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty
            if isRemap{i_mouse}{i_mouseDay}
                for i_map = 1:2
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_rewared = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC  = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC  = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC  = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC  = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward = cell(6,2);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward = cell(6,2);
                
                    for j_mouseDay = 1:6
                        if ~meta_data{i_mouse, j_mouseDay}.isEmpty
                            if isRemap{i_mouse}{j_mouseDay}
                                for j_map = 1:2
                                    
                                    map1 = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm; % reference to reward
                                    map1_odd = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_odd; % odd even for cross-validation
                                    map1_even = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_even;
                                    map2 = meta_data{i_mouse, j_mouseDay}.map(j_map).avg_eachSpaDivFd_sm; % reference to new reward locationeta_data{i_mouse, i_mouseDay}.map(i_map).spaPopVecCorr{j_mouseDay, j_map} = spa
                                    idx_allPC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map};
                                    idx_space = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map});
                                    idx_reward = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map});
                                    % correlation matrix for spatial population
                                    % vector: first page is self
                                    % cross-validation, second page is across
                                    % condition
                                    [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}] = ...
                                        spaPopVecCorr(map1, map1_odd, map1_even, idx_allPC, map2, idx_allPC);
                                    [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}] = ...
                                        spaPopVecCorr(map1, map1_odd, map1_even, idx_space, map2, idx_space);
                                    [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}] = ...
                                        spaPopVecCorr(map1, map1_odd, map1_even, idx_reward, map2, idx_reward);
                                    %% statistial analysis, get the median x, bins around the in-field vs out-field areas and do ranksum/kstest2
                                    
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                    for i = 1:2
                                        for i_spaDiv = 1:spaDivNum
                                            [inFieldIdx, inFieldIdx_shift] = peakLocation2_In_Out_FieldIdx(i_spaDiv, binThreshold, spaDivNum);
                                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}(i_spaDiv, i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                        end
                                    end
                                    
                                end
                            else
                                j_map = 1;
                                map1 = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm; % reference to reward
                                map1_odd = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_odd; % odd even for cross-validation
                                map1_even = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_even;
                                map2 = meta_data{i_mouse, j_mouseDay}.avg_eachSpaDivFd_sm; % reference to new reward locationeta_data{i_mouse, i_mouseDay}.map(i_map).spaPopVecCorr{j_mouseDay, j_map} = spa
                                idx_allPC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map};
                                idx_space = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map});
                                idx_reward = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map});
                                % correlation matrix for spatial population
                                % vector: first page is self
                                % cross-validation, second page is across
                                % condition
                                [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}] = ...
                                    spaPopVecCorr(map1, map1_odd, map1_even, idx_allPC, map2, idx_allPC);
                                [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}] = ...
                                    spaPopVecCorr(map1, map1_odd, map1_even, idx_space, map2, idx_space);
                                [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}] = ...
                                    spaPopVecCorr(map1, map1_odd, map1_even, idx_reward, map2, idx_reward);
                                %% statistial analysis, get the median x, bins around the in-field vs out-field areas and do ranksum/kstest2
                                
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                for i = 1:2
                                    for i_spaDiv = 1:spaDivNum
                                        [inFieldIdx, inFieldIdx_shift] = peakLocation2_In_Out_FieldIdx(i_spaDiv, binThreshold, spaDivNum);
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}(i_spaDiv, i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                    end
                                end
                            end
                            
                        end
                    end
                end
            else
                i_map = 1;
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_rewared = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC  = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC  = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC  = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC  = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward = cell(6,2);
                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward = cell(6,2);
                
                for j_mouseDay = 1:6
                    if ~meta_data{i_mouse, j_mouseDay}.isEmpty
                        if isRemap{i_mouse}{j_mouseDay}
                            for j_map = 1:2
                                map1 = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm; % reference to reward
                                map1_odd = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_odd; % odd even for cross-validation
                                map1_even = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_even;
                                map2 = meta_data{i_mouse, j_mouseDay}.map(j_map).avg_eachSpaDivFd_sm; % reference to new reward locationeta_data{i_mouse, i_mouseDay}.map(i_map).spaPopVecCorr{j_mouseDay, j_map} = spa
                                idx_allPC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map};
                                idx_space = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map});
                                idx_reward = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map});
                                % correlation matrix for spatial population
                                % vector: first page is self
                                % cross-validation, second page is across
                                % condition
                                % first column: odd vs even, second column:
                                % map1 vs map2
                                [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}] = ...
                                    spaPopVecCorr(map1, map1_odd, map1_even, idx_allPC, map2, idx_allPC);
                                [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}] = ...
                                    spaPopVecCorr(map1, map1_odd, map1_even, idx_space, map2, idx_space);
                                [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}] = ...
                                    spaPopVecCorr(map1, map1_odd, map1_even, idx_reward, map2, idx_reward);
                                %% statistial analysis, get the median x, bins around the in-field vs out-field areas and do ranksum/kstest2
                                
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                                for i = 1:2
                                    for i_spaDiv = 1:spaDivNum
                                        [inFieldIdx, inFieldIdx_shift] = peakLocation2_In_Out_FieldIdx(i_spaDiv, binThreshold, spaDivNum);
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}(i_spaDiv, i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                    end
                                end
                                
                            end
                            
                        else
                            j_map = 1;
                            map1 = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm; % reference to reward
                            map1_odd = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_odd; % odd even for cross-validation
                            map1_even = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_even;
                            map2 = meta_data{i_mouse, j_mouseDay}.avg_eachSpaDivFd_sm; % reference to new reward locationeta_data{i_mouse, i_mouseDay}.map(i_map).spaPopVecCorr{j_mouseDay, j_map} = spa
                            idx_allPC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map};
                            idx_space = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map});
                            idx_reward = nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map});
                            % correlation matrix for spatial population
                            % vector: first page is self
                            % cross-validation, second page is across
                            % condition
                            [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}] = ...
                                spaPopVecCorr(map1, map1_odd, map1_even, idx_allPC, map2, idx_allPC);
                            [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}] = ...
                                spaPopVecCorr(map1, map1_odd, map1_even, idx_space, map2, idx_space);
                            [meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}] = ...
                                spaPopVecCorr(map1, map1_odd, map1_even, idx_reward, map2, idx_reward);
                            %% statistial analysis, get the median x, bins around the in-field vs out-field areas and do ranksum/kstest2
                            
                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map} = nan(spaDivNum,2);
                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map} =  nan(spaDivNum,2);
                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                            meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map} =  nan(spaDivNum,2);
                            for i = 1:2
                                for i_spaDiv = 1:spaDivNum
                                    [inFieldIdx, inFieldIdx_shift] = peakLocation2_In_Out_FieldIdx(i_spaDiv, binThreshold, spaDivNum);
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}(i_spaDiv, i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_space{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx, i), 2, 'omitnan');
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}(i_spaDiv,i) = median(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_reward{j_mouseDay, j_map}(i_spaDiv, inFieldIdx_shift, i), 2, 'omitnan');
                                end
                            end
                            
                        end
                        
                        
                    end
                    
                end
            end
        end
    end
end


% concatenate in-field median value of correlation into one array for
% quantification
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
for i_group = 2:4
    i_map = 1;
    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice = cell(6,6,2); MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice = cell(6,6,2);
    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice = cell(6,6,2); MAP{i_group}.map(i_map).space_corrM_outFieldMedian_space_allMice = cell(6,6,2);
    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice = cell(6,6,2); MAP{i_group}.map(i_map).reward_corrM_outFieldMedian_reward_allMice = cell(6,6,2);
    
    for i_mouseDay = 1:6
        if isRemap{1}{i_mouseDay}
            for i_map = 1:2
                for j_mouseDay = 1:6
                    
                    if isRemap{1}{j_mouseDay}
                        for j_map = 1:2
                            MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                            MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                            MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                            MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                            MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                            MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                            for i = 1:length(mouseGroupIdx{i_group}) % each day, concatenate result
                                i_mouse = mouseGroupIdx{i_group}(i);
                                if ~meta_data{i_mouse, i_mouseDay}.isEmpty % not empty dataset
                                    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                        [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}];
                                    MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                        [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}];
                                    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                        [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}];
                                    MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                        [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}];
                                    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                        [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}];
                                    MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                        [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}];
                                end
                            end
                            
                            
                        end
                    else
                        j_map = 1;
                        MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        for i = 1:length(mouseGroupIdx{i_group}) % each day, concatenate result
                            i_mouse = mouseGroupIdx{i_group}(i);
                            if ~meta_data{i_mouse, i_mouseDay}.isEmpty % not empty dataset
                                MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}];
                            end
                        end
                        
                        
                    end
                end
            end
        else
            i_map = 1;
            for j_mouseDay = 1:6
                if isRemap{1}{j_mouseDay}
                    for j_map = 1:2
                        MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                        for i = 1:length(mouseGroupIdx{i_group}) % each day, concatenate result
                            i_mouse = mouseGroupIdx{i_group}(i);
                            if ~meta_data{i_mouse, i_mouseDay}.isEmpty % not empty dataset
                                MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}];
                                MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                    [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}];
                            end
                        end
                        
                        
                    end
                else
                    j_map = 1;
                    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                    MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                    MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                    MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                    MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                    for i = 1:length(mouseGroupIdx{i_group}) % each day, concatenate result
                        i_mouse = mouseGroupIdx{i_group}(i);
                        if ~meta_data{i_mouse, i_mouseDay}.isEmpty % not empty dataset
                            MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_allPC{j_mouseDay, j_map}];
                            MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}= ...
                                [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_allPC{j_mouseDay, j_map}];
                            MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_space{j_mouseDay, j_map}];
                            MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_space_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_space{j_mouseDay, j_map}];
                            MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                [MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_inFieldMedian_reward{j_mouseDay, j_map}];
                            MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map} = ...
                                [MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_reward_allMice{i_mouseDay, j_mouseDay, j_map}; meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_outFieldMedian_reward{j_mouseDay, j_map}];
                        end
                    end
                    
                end
            end
        end
    end
end


% in-field - out-field
% population vector analysis
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
i_map = 1;
i_mouseDay = 4; j_mouseDay = 4; j_map = 2;
colorM = {'', 'r', 'k', 'b'}
figure;
for i_group = 2:3
    
    a = MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}(:,2)
    b = MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}(:,2);
    
    delta = reshape(b - a, 50, length(mouseGroupIdx{i_group}));
    
    stdshade(delta', 0.25, colorM{i_group}); hold on;
end
box off; set(gca, 'FontSize', 15); set(gca, 'TickDir', 'out'); xlim([-0.5 50.5])
axis square
xticks([0 12.5 25 37.5 50]); xticklabels({'0', '45', '90', '135', '180'}); ylim([-1, 1])
legend('', groupNamePool{2}, '', groupNamePool{3}); legend('boxoff');
xlabel('position (cm)'); ylabel('correlation difference (in-field - out-field)')


%% population vector similarity; PV similarity

% Allo-similarity vs Ego-similarity
% statistical tests
%% Fig2i, i_group = 2
%% Fig1k, i_group = 3
for i_group = 2:3
    figure;
    i_map = 1;
    i_mouseDay = 4; j_mouseDay = 4; j_map = 2;
    x1 = MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}(:,1);
    x2 = MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}(:,1);
    
    y1 = MAP{i_group}.map(i_map).spaPV_corrM_inFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}(:,2);
    y2 = MAP{i_group}.map(i_map).spaPV_corrM_outFieldMedian_allPC_allMice{i_mouseDay, j_mouseDay, j_map}(:,2);
    
    n1=length(x1)/spaDivNum;
    x1_reshape = reshape(x1, spaDivNum, n1);
    x1_reshapeMean = mean(x1_reshape, 1, 'omitnan');
    
    n2=length(x2)/spaDivNum;
    x2_reshape = reshape(x2, spaDivNum, n2);
    x2_reshapeMean = mean(x2_reshape, 1, 'omitnan');
    
    m1=length(y1)/spaDivNum;
    y1_reshape = reshape(y1, spaDivNum, m1);
    y1_reshapeMean = mean(y1_reshape, 1, 'omitnan');
    
    m2=length(y2)/spaDivNum;
    y2_reshape = reshape(y2, spaDivNum, m2);
    y2_reshapeMean = mean(y2_reshape, 1, 'omitnan');
    
    
    [N_1, edges_1] = histcounts(x1, 'BinLimit', [-0.5 1], 'BinWidth', 0.02, 'Normalization', 'cdf'); hold on;
    [N_2, edges_2] = histcounts(x2, 'BinLimit', [-0.5 1], 'BinWidth', 0.02, 'Normalization', 'cdf'); hold on;
    
    [N_3, edges_3] = histcounts(y1, 'BinLimit', [-0.5 1], 'BinWidth', 0.02, 'Normalization', 'cdf'); hold on;
    [N_4, edges_4] = histcounts(y2, 'BinLimit', [-0.5 1], 'BinWidth', 0.02, 'Normalization', 'cdf'); hold on; close
    
    % % % figure;
    % % % plot(edges_1(2:end), N_1, 'k'); hold on;
    % % % plot(edges_2(2:end), N_2, '--k'); hold on;
    % % % plot(edges_3(2:end), N_3, 'r'); hold on;
    % % % plot(edges_4(2:end), N_4, '--r'); hold on;
    % % %
    % % % xticks([-0.5 0 0.5 1.0]);
    % % % box off; set(gca, 'FontSize', 15); yticks([0 0.25 0.5 0.75 1.0]);set(gca,'TickDir','out');
    % % % ax = gca; ax.XAxis.FontWeight = 'bold'; ax.YAxis.FontWeight = 'bold'
    % % % xlim([-0.52 1.02]);
    % % % ylim([-0.02 1.02])
    
    % notBoxPlot
    % % % figure;
    % % % h = notBoxPlot(x1_reshapeMean, 1, 'style', 'line')
    % % % h2 = notBoxPlot(x2_reshapeMean, 2, 'style', 'line')
    % % % h3 = notBoxPlot(y1_reshapeMean, 3, 'style', 'line')
    % % % h4 = notBoxPlot(y2_reshapeMean, 4, 'style', 'line')
    
    colorG = cbrewer('seq', 'Greys', 9);
    greyLevel = 5;
    colorM = cbrewer('qual', 'Set1', 9)
    
    %%
    figure;
    jitter = 0.5
    i1 = 4;
    n1 = length(x1_reshapeMean)
    % h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
    er = errorbar(i1-0.5, mean(x1_reshapeMean), std(x1_reshapeMean)/sqrt(n1), 'o', 'LineWidth', 0.25, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;
    
    i2 = 5;
    n2 = length(x2_reshapeMean)
    % h2 = bar(i, mean(y2)); h2.FaceColor = 'r', h2.FaceAlpha=0.2; h2.EdgeColor = 'w'; hold on;
    er = errorbar(i2+0.5, mean(x2_reshapeMean), std(x2_reshapeMean)/sqrt(n2), 'o', 'LineWidth', 0.25, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;
    
    
    
    % statistical test, mean, sem
    [h1,p1] = ttest(x1_reshapeMean, x2_reshapeMean)
    display('pre-odd, PV similarity')
    mean(x1_reshapeMean), std(x1_reshapeMean)/sqrt(n1)
    display('pre-even, PV similarity')
    mean(x2_reshapeMean), std(x2_reshapeMean)/sqrt(n2)
    
    a = [(i1+jitter*(rand(n1,1)-0.5)), i2+jitter*(rand(n2,1)-0.5)]
    b = [x1_reshapeMean', x2_reshapeMean']
    plot(a',b','-o', 'MarkerSize',10, 'LineWidth', 0.3, 'Color', colorG(greyLevel,:))
    
    i3 = 1;
    n3 = length(y1_reshapeMean)
    % h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
    er = errorbar(i3-0.5, mean(y1_reshapeMean), std(y1_reshapeMean)/sqrt(n3), 'o', 'LineWidth', 0.25, 'MarkerSize',5, 'Color', colorM(2,:), 'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor',colorM(2,:)); hold on;
    
    i4 = 2;
    n4 = length(y2_reshapeMean)
    % h2 = bar(i, mean(y2)); h2.FaceColor = 'r', h2.FaceAlpha=0.2; h2.EdgeColor = 'w'; hold on;
    er = errorbar(i4+0.5, mean(y2_reshapeMean), std(y2_reshapeMean)/sqrt(n4), 'o', 'LineWidth', 0.25, 'MarkerSize',5, 'Color', colorM(1,:), 'MarkerEdgeColor', colorM(1,:),'MarkerFaceColor',colorM(1,:)); hold on;
    
    % source data for Fig1k and Fig2i
    if i_group == 3
        x_Fig1k_odd_vs_even_diag = x1_reshapeMean;
        x_Fig1k_odd_vs_even_offdiag = x2_reshapeMean;
        x_Fig1k_Pre_vs_Post_diag = y1_reshapeMean;
        x_Fig1k_Pre_vs_Post_offdiag = y2_reshapeMean;
    elseif i_group == 2
        x_Fig2i_odd_vs_even_diag = x1_reshapeMean;
        x_Fig2i_odd_vs_even_offdiag = x2_reshapeMean;
        x_Fig2i_Pre_vs_Post_diag = y1_reshapeMean;
        x_Fig2i_Pre_vs_Post_offdiag = y2_reshapeMean;
    end
    
    
    a = [(i3+jitter*(rand(n3,1)-0.5)), i4+jitter*(rand(n4,1)-0.5)]
    b = [y1_reshapeMean', y2_reshapeMean']
    plot(a',b','-ko', 'MarkerSize',10, 'LineWidth', 0.3, 'Color', colorG(greyLevel,:))
    
    xlim([0 6]); ylim([-0.3 1]); pbaspect([1 0.5 1]);
    set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
    xticks(''); yticks(-0.25:0.25:1);
    ylabel('PV similarity');
    % statistical test, mean, sem
    [h2,p2] = ttest(y1_reshapeMean, y2_reshapeMean)
    display('pre , PV similarity')
    mean(y1_reshapeMean), std(y1_reshapeMean)/sqrt(n3)
    display('post, PV similarity')
    mean(y2_reshapeMean), std(y2_reshapeMean)/sqrt(n4)
end

% correlation matrix, each animal, map1 vs map2
% Population vector correlation analysis
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
for i_mouse = 1:12 % all novel belt mice and familiar mice
    i_map = 1; j_map = 2;
    i_mouseDay = 4
    if ~meta_data{i_mouse, i_mouseDay}.isEmpty
        figure;
        subplot(1,2,1);
        imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{i_mouseDay, j_map}(:,:,1)))', [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15,'TickDir','out', 'TickLength', [0.025; 0.025]); axis square;
        subplot(1,2,2);
        imagesc((squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{i_mouseDay, j_map}(:,:,2)))', [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15,'TickDir','out', 'TickLength', [0.025; 0.025]);axis square;
        sgtitle([MiceAll{i_mouse}, ', day:',  dayLabel{i_mouseDay}], 'FontSize', 15)
    end
end

%% Fig1i, Fig1j, mouse KQ145 (i_mouse = 10)
for i_mouse = 10
    i_map = 1; j_map = 2;
    i_mouseDay = 4
    if ~meta_data{i_mouse, i_mouseDay}.isEmpty
        figure;
        subplot(1,2,1);
        x_Fig1j = (squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{i_mouseDay, j_map}(:,:,1)))';
        imagesc(x_Fig1j, [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15,'TickDir','out', 'TickLength', [0.025; 0.025]); axis square;
        subplot(1,2,2);
        x_Fig1i = (squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{i_mouseDay, j_map}(:,:,2)))';
        imagesc(x_Fig1i, [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15,'TickDir','out', 'TickLength', [0.025; 0.025]);axis square;
        sgtitle([MiceAll{i_mouse}, ', day:',  dayLabel{i_mouseDay}], 'FontSize', 15)
    end
end


%% Fig2g, Fig2h, mouse KQ141 (i_mouse = 2)
for i_mouse = 2
    i_map = 1; j_map = 2;
    i_mouseDay = 4
    if ~meta_data{i_mouse, i_mouseDay}.isEmpty
        figure;
        subplot(1,2,1);
        x_Fig2g = (squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{i_mouseDay, j_map}(:,:,1)))';
        imagesc(x_Fig2g, [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15,'TickDir','out', 'TickLength', [0.025; 0.025]); axis square;
        subplot(1,2,2);
        x_Fig2h = (squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{i_mouseDay, j_map}(:,:,2)))';
        imagesc(x_Fig2h, [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15,'TickDir','out', 'TickLength', [0.025; 0.025]);axis square;
        sgtitle([MiceAll{i_mouse}, ', day:',  dayLabel{i_mouseDay}], 'FontSize', 15)
    end
end






%% cross day: day-1 vs day 1

for i_mouse = 1:12 % all novel and familiar mice
    i_map = 1; j_map = 1;
    i_mouseDay = 3; j_mouseDay = 4
    if ~meta_data{i_mouse, i_mouseDay}.isEmpty
        figure;
        subplot(1,2,1);
        y1 = squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(:,:,1));
        imagesc(y1', [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15);set(gca,'TickDir','out'); ax = gca; ax.XAxis.FontWeight = 'bold'; ax.YAxis.FontWeight = 'bold'
        ax.XAxis.LineWidth = 1; ax.YAxis.LineWidth = 1; axis square;
        subplot(1,2,2);
        y2 = squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).spaPV_corrM_allPC{j_mouseDay, j_map}(:,:,2));
        imagesc(y2', [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
        plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
        xticks([1 25 50]); xticklabels({'0', '90', '180'}); yticks([1 25 50]); yticklabels({'0', '90', '180'}); box off; 
        set(gca, 'FontSize', 15);set(gca,'TickDir','out'); ax = gca; 
        ax.XAxis.LineWidth = 1; ax.YAxis.LineWidth = 1;axis square;
        sgtitle([MiceAll{i_mouse}, ', day:',  dayLabel{i_mouseDay}], 'FontSize', 15)
    end
end


%% correlation matrix for spatial and pi place cells


%% all Mice average
for i_mouseDay = 4:6
i_group = 3;
j_mouseDay = i_mouseDay;
i_map = 1; j_map = 2;

spaMap1 = MAP{3}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1};
spaMap2 = MAP{3}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1};
spaMap1_space = spaMap1(:, nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}));
spaMap1_reward = spaMap1(:, nan2false(MAP{3}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}));
spaMap2_space = spaMap2(:, nan2false(MAP{3}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}));
spaMap2_reward = spaMap2(:, nan2false(MAP{3}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}));



x1 = corr(spaMap1_space', spaMap1_space');
x2 = corr(spaMap2_space', spaMap1_space');

y1 = corr(spaMap1_reward', spaMap1_reward');
y2 = corr(spaMap2_reward', spaMap1_reward');

figure;
subplot(2,2,1);
imagesc(x1, [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
xticks([14 39]); xticklabels({'50cm', '140cm'});yticks([14 39]); yticklabels({'50cm', '140cm'}); set(gca, 'FontSize', 15); axis square;
subplot(2,2,2);
imagesc(x2', [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
xticks([14 39]); xticklabels({'50cm', '140cm'});yticks([14 39]); yticklabels({'50cm', '140cm'}); set(gca, 'FontSize', 15);axis square;
subplot(2,2,3);
imagesc(y1, [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
xticks([14 39]); xticklabels({'50cm', '140cm'});yticks([14 39]); yticklabels({'50cm', '140cm'}); set(gca, 'FontSize', 15);axis square;
subplot(2,2,4);

imagesc(y2', [0 1]);set(gca, 'YDir','normal'); colormap jet; hold on;
plot(1:50, 1:50, 'k', 'LineWidth', 1); hold on; plot(1:25, (26:50), 'w', 'LineWidth', 1); plot((26:50), 1:25, 'w', 'LineWidth', 1);
xticks([14 39]); xticklabels({'50cm', '140cm'});yticks([14 39]); yticklabels({'50cm', '140cm'}); set(gca, 'FontSize', 15);axis square;

sgtitle([groupNameLabelPool{i_group}, ', day:',  dayLabel{i_mouseDay}], 'FontSize', 15)


end


%% Gothard, McNaughton, 1996


%% example of Allo-centric and Ego-centric place cells, single neuron representation and average trace
%% example cell: 2 Ego-PC from novel environment KQ141, Roi5; KQ146, Roi#18
%% example cell: 1 allo, 1 ego-PC from familiar environment: KQ144, Roi#29; KQ142, Roi#130
%% example cell: 3 mix-PC from familiar env: KQ140, #38; KQ163, #162; KQ163, #174
%% example cell: 3 mix-PC from novel env: KQ139, #199; KQ146, #42; KQ173, #312; Extended Data Fig.4 Fig. 4
% example cell: ego-PC with BTSP: KQ142, #192, KQ140, #24; KQ163, #156; KQ142, #154
% example cell: allo-PC with BTSP: KQ142, #119; KQ144, #29

%% Fig5f, Space PC example. i_mouse = 9 (KQ144), i_cell = 140
i_mouse = 9; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 140

Fig5f_space_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
Fig5f_space_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';
figure;
b1 = imagesc(Fig5f_space_Pre , [0 3]); colormap(flipud(gray(256)));
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); 
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(Fig5f_space_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(Fig5f_space_Post, [0 3]); colormap(flipud(gray(256)));
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); 
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(Fig5f_space_Post));pbaspect([0.5,1,1])

figure;
yi = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan');
yj = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan');
plot(yi/max(yi,[],'omitnan'), 'k'); hold on;
plot(yj/max(yj,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])
Fig5f_space_Pre_mean = yi';
Fig5f_space_Post_mean = yj';

% example cell: ego-PC with BTSP: KQ142, #192, KQ140, #24; KQ163, #156; KQ142, #154
%% Fig5f, Goal PC example. i_mouse = 8 (KQ142), i_cell = 192
i_mouse = 8; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 192

Fig5f_goal_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
Fig5f_goal_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';
figure;
b1 = imagesc(Fig5f_goal_Pre , [0 3]); colormap(flipud(gray(256)));
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); 
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(Fig5f_goal_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(Fig5f_goal_Post, [0 3]); colormap(flipud(gray(256)));
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); 
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(Fig5f_goal_Post));pbaspect([0.5,1,1])

figure;
yi = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan');
yj = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan');
plot(yi/max(yi,[],'omitnan'), 'k'); hold on;
plot(yj/max(yj,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])
Fig5f_goal_Pre_mean = yi';
Fig5f_goal_Post_mean = yj';



%% single cell example, allo and egocentric place cells, jet colormap
%% Familiar environment: allo, KQ163, ROI#115; ego, KQ142, ROI#130
%% Fig1c: Fam env: Space PC: i_mouse=10 (KQ145),i_cell=71
%% Fig1c: Fam env: Goal PC: i_mouse=8 (KQ142),i_cell=130
i_mouse = 10; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 71

x_Fig1c_spacePC_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
x_Fig1c_spacePC_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(x_Fig1c_spacePC_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig1c_spacePC_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(x_Fig1c_spacePC_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig1c_spacePC_Post)); pbaspect([0.5,1,1])

figure;
y_Fig1c_spacePC_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
y_Fig1c_spacePC_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(y_Fig1c_spacePC_Pre_mean/max(y_Fig1c_spacePC_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(y_Fig1c_spacePC_Post_mean/max(y_Fig1c_spacePC_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])

%% Fig1c: Fam env: Goal PC: i_mouse=8 (KQ142),i_cell=130
i_mouse = 8; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 130

x_Fig1c_goalPC_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
x_Fig1c_goalPC_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(x_Fig1c_goalPC_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig1c_goalPC_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(x_Fig1c_goalPC_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig1c_goalPC_Post)); pbaspect([0.5,1,1])

figure;
y_Fig1c_goalPC_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
y_Fig1c_goalPC_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(y_Fig1c_goalPC_Pre_mean/max(y_Fig1c_goalPC_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(y_Fig1c_goalPC_Post_mean/max(y_Fig1c_goalPC_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])

%% example cell: 2 Ego-PC from novel environment KQ141, Roi5; KQ146, Roi#18
%% Fig2b, Goal PC, Left
i_mouse = 2; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 5

x_Fig2b_left_goalPC_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
x_Fig2b_left_goalPC_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(x_Fig2b_left_goalPC_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig2b_left_goalPC_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(x_Fig2b_left_goalPC_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig2b_left_goalPC_Post)); pbaspect([0.5,1,1])

figure;
y_Fig2b_left_goalPC_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
y_Fig2b_left_goalPC_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(y_Fig2b_left_goalPC_Pre_mean/max(y_Fig2b_left_goalPC_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(y_Fig2b_left_goalPC_Post_mean/max(y_Fig2b_left_goalPC_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])


%% Fig2b, Goal PC, Right
i_mouse = 3; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 18

x_Fig2b_right_goalPC_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
x_Fig2b_right_goalPC_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(x_Fig2b_right_goalPC_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig2b_right_goalPC_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(x_Fig2b_right_goalPC_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(x_Fig2b_right_goalPC_Post)); pbaspect([0.5,1,1])

figure;
y_Fig2b_right_goalPC_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
y_Fig2b_right_goalPC_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(y_Fig2b_right_goalPC_Pre_mean/max(y_Fig2b_right_goalPC_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(y_Fig2b_right_goalPC_Post_mean/max(y_Fig2b_right_goalPC_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])

%% example cell: 3 mix-PC from familiar env: KQ140, #38; KQ163, #162; KQ163, #174
%% Extended Fig3a, Left, KQ140, #38;
i_mouse = 7; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 38

ExtendedFig3a_interPC_left_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
ExtendedFig3a_interPC_left_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(ExtendedFig3a_interPC_left_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3a_interPC_left_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(ExtendedFig3a_interPC_left_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3a_interPC_left_Post)); pbaspect([0.5,1,1])

figure;
ExtendedFig3a_interPC_left_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
ExtendedFig3a_interPC_left_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(ExtendedFig3a_interPC_left_Pre_mean/max(ExtendedFig3a_interPC_left_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(ExtendedFig3a_interPC_left_Post_mean/max(ExtendedFig3a_interPC_left_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])

ExtendedFig3a_interPC_left_summary = [ExtendedFig3a_interPC_left_Pre; nan(2,50); ExtendedFig3a_interPC_left_Pre_mean; nan(2,50); ...
    ExtendedFig3a_interPC_left_Post; nan(2,50); ExtendedFig3a_interPC_left_Post_mean]

%% Extended Fig3a, middle, KQ163, #162;
i_mouse = 12; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 162

ExtendedFig3a_interPC_middle_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
ExtendedFig3a_interPC_middle_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(ExtendedFig3a_interPC_middle_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3a_interPC_middle_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(ExtendedFig3a_interPC_middle_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15); xlim([0.5 50.5]);
set(b1, 'AlphaData',~isnan(ExtendedFig3a_interPC_middle_Post)); pbaspect([0.5,1,1])

figure;
ExtendedFig3a_interPC_middle_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
ExtendedFig3a_interPC_middle_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(ExtendedFig3a_interPC_middle_Pre_mean/max(ExtendedFig3a_interPC_middle_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(ExtendedFig3a_interPC_middle_Post_mean/max(ExtendedFig3a_interPC_middle_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])

ExtendedFig3a_interPC_middle_summary = [ExtendedFig3a_interPC_middle_Pre; nan(2,50); ExtendedFig3a_interPC_middle_Pre_mean; nan(2,50); ...
    ExtendedFig3a_interPC_middle_Post; nan(2,50); ExtendedFig3a_interPC_middle_Post_mean]


%% Extended Fig3a, middle, KQ163, #174;
i_mouse = 12; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 174

ExtendedFig3a_interPC_right_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
ExtendedFig3a_interPC_right_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(ExtendedFig3a_interPC_right_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3a_interPC_right_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(ExtendedFig3a_interPC_right_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15); xlim([0.5 50.5]);
set(b1, 'AlphaData',~isnan(ExtendedFig3a_interPC_right_Post)); pbaspect([0.5,1,1])

figure;
ExtendedFig3a_interPC_right_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
ExtendedFig3a_interPC_right_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(ExtendedFig3a_interPC_right_Pre_mean/max(ExtendedFig3a_interPC_right_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(ExtendedFig3a_interPC_right_Post_mean/max(ExtendedFig3a_interPC_right_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca;xlim([0.5 50.5])

ExtendedFig3a_interPC_right_summary = [ExtendedFig3a_interPC_right_Pre; nan(2,50); ExtendedFig3a_interPC_right_Pre_mean; nan(2,50); ...
    ExtendedFig3a_interPC_right_Post; nan(2,50); ExtendedFig3a_interPC_right_Post_mean]


%% example cell: 3 mix-PC from novel env: KQ139, #199; KQ146, #42; KQ173, #312; Extended Data Fig.4 Fig. 4
%% Extended Fig3c, left, KQ139, #199
i_mouse = 1; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 199

ExtendedFig3c_interPC_left_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
ExtendedFig3c_interPC_left_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(ExtendedFig3c_interPC_left_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3c_interPC_left_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(ExtendedFig3c_interPC_left_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3c_interPC_left_Post)); pbaspect([0.5,1,1])

figure;
ExtendedFig3c_interPC_left_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
ExtendedFig3c_interPC_left_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(ExtendedFig3c_interPC_left_Pre_mean/max(ExtendedFig3c_interPC_left_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(ExtendedFig3c_interPC_left_Post_mean/max(ExtendedFig3c_interPC_left_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca; xlim([0.5 50.5])

ExtendedFig3c_interPC_left_summary = [ExtendedFig3c_interPC_left_Pre; nan(2,50); ExtendedFig3c_interPC_left_Pre_mean; nan(2,50); ...
    ExtendedFig3c_interPC_left_Post; nan(2,50); ExtendedFig3c_interPC_left_Post_mean]


%% Extended Fig3c, left,  KQ146, #42;
i_mouse = 3; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 42

ExtendedFig3c_interPC_middle_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
ExtendedFig3c_interPC_middle_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(ExtendedFig3c_interPC_middle_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3c_interPC_middle_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(ExtendedFig3c_interPC_middle_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3c_interPC_middle_Post)); pbaspect([0.5,1,1])

figure;
ExtendedFig3c_interPC_middle_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
ExtendedFig3c_interPC_middle_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(ExtendedFig3c_interPC_middle_Pre_mean/max(ExtendedFig3c_interPC_middle_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(ExtendedFig3c_interPC_middle_Post_mean/max(ExtendedFig3c_interPC_middle_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca; xlim([0.5 50.5])

ExtendedFig3c_interPC_middle_summary = [ExtendedFig3c_interPC_middle_Pre; nan(2,50); ExtendedFig3c_interPC_middle_Pre_mean; nan(2,50); ...
    ExtendedFig3c_interPC_middle_Post; nan(2,50); ExtendedFig3c_interPC_middle_Post_mean]



%% Extended Fig3c, left, KQ173, #312
i_mouse = 5; i_mouseDay = 4; i_map = 1; j_map = 2; i_cell = 312

ExtendedFig3c_interPC_right_Pre = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)';
ExtendedFig3c_interPC_right_Post = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)';

figure;
b1 = imagesc(ExtendedFig3c_interPC_right_Pre, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca; set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3c_interPC_right_Pre));
pbaspect([0.5,1,1])
            
figure;
b1 = imagesc(ExtendedFig3c_interPC_right_Post, [0 3]); colormap jet;
xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 50 100])
box off; 
set(gca, 'FontSize', 7); set(gca,'TickDir','out'); 
ax = gca;set(gca, 'FontSize', 15);xlim([0.5 50.5])
set(b1, 'AlphaData',~isnan(ExtendedFig3c_interPC_right_Post)); pbaspect([0.5,1,1])

figure;
ExtendedFig3c_interPC_right_Pre_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
ExtendedFig3c_interPC_right_Post_mean = mean(squeeze(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm(:,:,i_cell)), 2, 'omitnan')';
plot(ExtendedFig3c_interPC_right_Pre_mean/max(ExtendedFig3c_interPC_right_Pre_mean,[],'omitnan'), 'k'); hold on;
plot(ExtendedFig3c_interPC_right_Post_mean/max(ExtendedFig3c_interPC_right_Post_mean,[],'omitnan'), 'r'); hold on;
set(gca, 'FontSize', 7); ylim([-0.05 1.05]); xticks([1 12 25 37 50]); xticklabels({'0', '', '90', '', '180'}); box off;  set(gca, 'FontSize', 15);
yticks(0:0.25:1); set(gca,'TickDir','out'); ax = gca; xlim([0.5 50.5])

ExtendedFig3c_interPC_right_summary = [ExtendedFig3c_interPC_right_Pre; nan(2,50); ExtendedFig3c_interPC_right_Pre_mean; nan(2,50); ...
    ExtendedFig3c_interPC_right_Post; nan(2,50); ExtendedFig3c_interPC_right_Post_mean]


%% place field correlation
% initialize variables
for i_group = 2:4
    for i_map = 1:2
        % all trials, initialize
        MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_sm_allMice = {};
        MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_sm_allMice = {};
        % shift version
        MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_shift90_sm_allMice = {};
        MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_shift90_sm_allMice = {};
        
    end
end
% field correlation, top and bottom template comes from the mean activity from first and second maps; smoothed
% version use averaged field (5/10 laps) to be correlated with the same template

smoothWindow = 10; % set 1 no smoothing
isStandardTemplate = false % true, use avg from each map for template; if false: take only last 10/20,... trials mean
templateTrialNum = 25; % if isStandardTemplate is true; last 10 trials as template

for i_group = 2:4
    for i_mouseDay = 4:6
        for i_map = 1:2
            MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_sm_allMice{i_mouseDay, 1} = nan(size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 2), size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 3));
            MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_sm_allMice{i_mouseDay, 1} = nan(size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 2), size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 3));
            % shift version
            MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_shif90t_sm_allMice{i_mouseDay, 1} = nan(size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 2), size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_shift90_allMice{i_mouseDay,1}, 3));
            MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_shift90_sm_allMice{i_mouseDay, 1} = nan(size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 2), size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_shift90_allMice{i_mouseDay,1}, 3));
            if isStandardTemplate
                for i_cell = 1:size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 3)
                    % every trial included
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), MAP{i_group}.map(1).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, i_cell)); % use mean of first map, top
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), MAP{i_group}.map(2).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, i_cell)); % use mean of second map, bottom
                    
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_shift90_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), MAP{i_group}.map(1).avg_eachSpaDivFd_sm_shift90_allMice{i_mouseDay, 1}(:, i_cell)); % use mean of first map, top
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_shift90_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), MAP{i_group}.map(2).avg_eachSpaDivFd_sm_shift90_allMice{i_mouseDay, 1}(:, i_cell)); % use mean of second map, bottom
                    
                end
                
                
            else
                 for i_cell = 1:size(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}, 3)
                    % every trial included
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), mean(squeeze(MAP{i_group}.map(1).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, end-templateTrialNum+1:end, i_cell)), 2, 'omitnan')); % use mean of first map, top
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), mean(squeeze(MAP{i_group}.map(1).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, end-templateTrialNum+1:end, i_cell)), 2, 'omitnan')); % use mean of second map, bottom
                    
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_top_shift90_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), mean(squeeze(MAP{i_group}.map(1).eachSpaDivFd_sm_shift90_allMice{i_mouseDay, 1}(:, end-templateTrialNum+1:end, i_cell)), 2, 'omitnan')); % use mean of first map, top
                    MAP{i_group}.map(i_map).eachSpaDivFd_fieldCorr_btm_shift90_sm_allMice{i_mouseDay, 1}(:, i_cell) = ...
                        corr(smoothdata(squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay,1}(:,:,i_cell)), 2, 'movmean', smoothWindow, 'omitnan'), mean(squeeze(MAP{i_group}.map(1).eachSpaDivFd_sm_shift90_allMice{i_mouseDay, 1}(:, end-templateTrialNum+1:end, i_cell)), 2, 'omitnan')); % use mean of second map, bottom
                    
                end
                
            end
        end
        
    end
end

%% Place field correlation; PF correlation; gradual vs abrupt remapping
% % % i_mouseDay = 4; i_map = 1; j_map = 2; j_mouseDay = 4;
% % % i_group = 2; j_group = 3
% % % plotPFCorrelation(MAP, i_group, j_group, i_map, j_map, i_mouseDay, j_mouseDay, groupNameLabelPool, dayLabel)



%% cumulative distribution of place field position change across map1 vs map2 for different groups
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
% % % 
i_mouseDay = 4; i_map = 1; j_map = 2; j_mouseDay = 4;
% % % 
% % % 
% % % [N1, E1] = histcounts(abs(MAP{2}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(MAP{2}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}))), 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'cdf')
% % % [N2, E2] = histcounts(abs(MAP{3}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(MAP{3}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}))), 'BinLimit', [0 25], 'BinWidth', 1, 'Normalization', 'cdf')
% % % 
% % % figure;
% % % plot(E1(2:end), N1, 'r'); hold on;
% % % plot(E2(2:end), N2, 'k'); hold on;
% % % 
% % % xticks([1 12.5 25]); xticklabels({'0', '45', '90'}); box off; set(gca, 'FontSize', 15); 
% % % yticks([0  0.25  0.5 0.75 1]); set(gca,'TickDir','out'); xlim([-0 25]); ylim([-0.02 1.02])

% probability distribution
%% Fig2e
i_mouseDay = 4; i_map = 1; j_map = 2; j_mouseDay = 4;
x_Fig2e_sourcedata_novel = abs(MAP{2}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(MAP{2}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map})));
x_Fig2e_sourcedata_familiar = abs(MAP{3}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(MAP{3}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map})));

[N1, E1] = histcounts(x_Fig2e_sourcedata_novel, 'BinLimit', [0 25], 'BinWidth', 2, 'Normalization', 'probability')
[N2, E2] = histcounts(x_Fig2e_sourcedata_familiar, 'BinLimit', [0 25], 'BinWidth', 2, 'Normalization', 'probability')

x_Fig2e_plotbindata_novelbelt = N1;
x_Fig2e_plotbindata_familiarbelt = N2
figure;
plot(E1(2:end), N1, 'r'); hold on;
plot(E2(2:end), N2, 'k'); hold on;

xticks([2 13.5 25]); xticklabels({'0', '45', '90'}); box off; set(gca, 'FontSize', 15); 
yticks([0 0.1 0.2 0.3]); set(gca,'TickDir','out'); xlim([1 26]); ylim([-0.01 0.31])
axis square

% statistical test
[h, p] = kstest2(x_Fig2e_sourcedata_novel,x_Fig2e_sourcedata_familiar)

%% Fig1f
% uniformity of the distribution: for aAAA place field position change; 
i_mouseDay = 4; i_map = 1; j_map = 2; j_mouseDay = 4;
i_group = 3;
idx = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
x = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx);
y1 = abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(idx));
binSize = 2; edges = 0:binSize:26
[N1, E1] = histcounts(y1, edges, 'Normalization', 'probability')

n = sum(idx)
rng('default')
shuffleNum = 1000
N_shuffle = nan(length(N1), shuffleNum);
p_shuffle = nan(shuffleNum, 1)
for i_shuffle = 1:shuffleNum
    x_rand = randi(spaDivNum, n, 1);
    y_shuffle = abs(fieldPositionChange(spaDivNum, x, x_rand));
    [N_shuffle(:, i_shuffle), E2] = histcounts(y_shuffle, edges, 'Normalization', 'probability');
    [h1, p_shuffle(i_shuffle)] = kstest2(y1, y_shuffle);
end

%% Fig1f
% plot real data versus confidence interval
colorM = cbrewer('qual', 'Set1', 9)

figure;
x_Fig1f_measured_familiar = N1;
x_Fig1f_shuffleMean = mean(N_shuffle, 2, 'omitnan')';
x_Fig1f_shuffle_95prct = prctile(N_shuffle, 95, 2)';
x_Fig1f_shuffle_5prct = prctile(N_shuffle, 5, 2)';

plot(E1(2:end), N1, 'k'); hold on;
plot(E2(2:end), mean(N_shuffle, 2, 'omitnan'),  'Color', colorM(3,:)); hold on;
plot(E2(2:end), prctile(N_shuffle, 95, 2), '--', 'Color', colorM(3,:)); hold on;
plot(E2(2:end), prctile(N_shuffle, 5, 2), '--', 'Color', colorM(3,:)); hold on;
pbaspect([1 1 1]);set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([2 13 25]); xticklabels({'0', '45', '90'}); yticks(0:0.05:0.2); ylim([0 0.2]); xlim([1 26])
title(['confidence interval:', num2str(mean(p_shuffle<0.05))])
xlabel('delta place field position (cm)'); ylabel('Fraction of PCs')


%% found the a to B group has a positive shift tendency for peak position change, find out where their field locations are
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

%% fraction of stable PC from day 3 to day 4 (d-1 to d1), one number per animal
for i_mouse = 1:17
    i_mouseDay = 3; j_mouseDay = 4; i_map = 1; j_map = 1;
    if ~meta_data{i_mouse, i_mouseDay}.isEmpty & ~meta_data{i_mouse, j_mouseDay}.isEmpty
        n = sum(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}, 'omitnan');
        N = sum(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}, 'omitnan');
        meta_data{i_mouse, i_mouseDay}.stablePCFraction = n/N;
    end
end

% group together the fraction of stable PC, day-1 to +1
for i_group = 2:3
    MAP{i_group}.stablePCFraction = [];
    for i_mouse = mouseGroupIdx{i_group}
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty & ~meta_data{i_mouse, j_mouseDay}.isEmpty
            MAP{i_group}.stablePCFraction = [MAP{i_group}.stablePCFraction; meta_data{i_mouse, i_mouseDay}.stablePCFraction];
        end
    end
end



%% population vector similarity

groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

i_mouseDay = 3; j_mouseDay = 4; i_map = 1;
similarity = {};
similarity_shuffle = {};
for i_group = 2:3
    similarity{i_group,1} = [];
    i = 1
    for i_mouse = mouseGroupIdx{i_group}
        % i_mouseDay
        % once liearized, the sequence of activities doesn't matter, so
        % no matter you lienarize by population vector or by field mean,
        % you get exactly the same number out
        representation1 = (meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_all(:));  % from lap 1 to lapLimit
        representation1_odd = transposeLinearize(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_odd);
        representation1_even = transposeLinearize(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_even);
        representation1_firstHalfSession = transposeLinearize(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_firstHalfSession);
        representation1_secondHalfSession = transposeLinearize(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_secondHalfSession);
        
        % shuffle repersentation 1 by 100 times.
        representation1_shuffle = {}
        shuffleNum = 100
        G_shuffle = nan(shuffleNum, 1);
        for i_shuffle  = 1:shuffleNum
            shuffleIdx = randperm(size(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_all, 2));
            representation1_shuffle{i_shuffle} = meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_all(:, shuffleIdx);
            GG = corrcoef(representation1, representation1_shuffle{i_shuffle}(:));
            G_shuffle(i_shuffle) = GG(2,1);
        end
        
        % j_mouseDay
        representation2 = (meta_data{i_mouse, j_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_all(:));
        representation2_odd = transposeLinearize(meta_data{i_mouse, j_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_odd);
        representation2_even = transposeLinearize(meta_data{i_mouse, j_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_even);
        representation2_firstHalfSession = transposeLinearize(meta_data{i_mouse, j_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_firstHalfSession);
        representation2_secondHalfSession = transposeLinearize(meta_data{i_mouse, j_mouseDay}.map(i_map).avg_eachSpaDivFd_sm_secondHalfSession);
        
        G = corrcoef(representation1, representation2);
        G1_oddEven = corrcoef(representation1_odd, representation1_even);
        G2_oddEven = corrcoef(representation2_odd, representation2_even);
        G1_firstSecond = corrcoef(representation1_firstHalfSession, representation1_secondHalfSession);
        G2_firstSecond = corrcoef(representation2_firstHalfSession, representation2_secondHalfSession);
        
        
        similarity{i_group,1}(i,1) = G1_oddEven(2,1);
        similarity{i_group,1}(i,2) = G2_oddEven(2,1);
        similarity{i_group,1}(i,3) = G1_firstSecond(2,1);
        similarity{i_group,1}(i,4) = G2_firstSecond(2,1);
        similarity{i_group,1}(i,5) = G(2,1);
        similarity_shuffle{i_group, 1}(:, i) = G_shuffle;
        i=i+1
    end
end




%% BTSP analysis: implementation of Sachin's approaches: identify putative BTSP events
%{ 
   ------ 1) high calcium event: 20% of all events to be qualified as
   induction event (my addition: event peak amplitude must be at least 1)
   ------ 2) 50% increase of mean of max in field ( -30 to +30cm, 8 spatial bins)
   ------ 3) 4/5 next 5 laps (I'll still use Christine's 2/5 criterion


%}
% % % % validation, eachSpaDivFd_mxsm is good for doing this analysis
% % % i_mouse = 5; i_mouseDay = 4;
% % % i_map = 1;
% % % for i_cell = 78
% % %     a = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd(:,:, i_cell);
% % %     a_mxsm = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_mxsm(:,:, i_cell);
% % %     b = a(:); b_mxsm = a_mxsm(:);
% % %     b(b < meta_data{i_mouse, i_mouseDay}.signalThreshold_dFishQ(i_cell)) = 0;
% % %     b_mxsm(b_mxsm < meta_data{i_mouse, i_mouseDay}.signalThreshold_dFishQ(i_cell)) = 0;
% % %     figure;
% % %     subplot(2,1,1); plot(a(:), 'k'); hold on; plot(b, 'r');
% % %     subplot(2,1,2); plot(a_mxsm(:), 'k'); hold on; plot(b_mxsm, 'r');
% % % end
% % % 
% % % figure;
% % % i_cell = 56
% % % a_mxsm = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_mxsm(:,:, i_cell);
% % % b_mxsm = a_mxsm(:); b_mxsm_clean = a_mxsm(:); 
% % % b_mxsm_clean(b_mxsm < meta_data{i_mouse, i_mouseDay}.signalThreshold_dFishQ(i_cell)) = 0;
% % % figure; plot(a_mxsm(:), 'k'); hold on; 
% % % plot(b_mxsm_clean, 'r');
% % % 
% % % isEventBin = b_mxsm < meta_data{i_mouse, i_mouseDay}.signalThreshold_dFishQ(i_cell);
% % % isEventBin_filled = fillBin(isEventBin, 2, false)
% % % 
% % % b_mxsm_filled =  a_mxsm(:); 
% % % b_mxsm_filled(isEventBin_filled)=0;
% % % 
% % % % find the start and end of each event
% % % eventEdge = diff([0; ~isEventBin_filled(1:end-1); 0]); % because of the insertion of 0 at 2 ends, immediate-on event and no-ending events can both be found
% % % eventStartIdx = eventEdge == 1;
% % % eventEndIdx = eventEdge == -1;
% % % 
% % % find_eventStartIdx = find(eventEdge == 1);
% % % find_eventEndIdx = find(eventEdge == -1);
% % % if sum(eventEndIdx) ~= sum(eventStartIdx) % one event (must at the edge
% % %     warning('event start and end not matched')
% % % end


%% get firstLapFieldReliability
%% get isRewardPredZone, isPIZone, isSCZone
% where highest fraction of place cells reside
goalZoneIdx = 7:15
PIZoneIdx = 16:24
SCZoneIdx = 34:42

for i_mouse = 1:17
    for i_mouseDay = 1:6
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty % exist data set
            if isRemap{i_mouse}{i_mouseDay}
                for i_map = 1:2
                    cellNum = meta_data{i_mouse, i_mouseDay}.cellNum;
                    lapX = min(100, meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit);
                    meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapFieldReliability = nan(size(meta_data{i_mouse, i_mouseDay}.map(i_map).onsetFieldReliability));
                    for i_cell = 1:cellNum
                        meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapFieldReliability(i_cell,1) = mean(meta_data{i_mouse, i_mouseDay}.map(i_map).isSigLap(1:lapX, i_cell), 'omitnan');
                        
                    end
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isGoalZonePC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, j_map} & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition <= goalZoneIdx(end)) & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition >= goalZoneIdx(1));
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPIZonePC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, j_map} & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition <= PIZoneIdx(end)) & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition >= PIZoneIdx(1));
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isSCZonePC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, j_map} & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition <= SCZoneIdx(end)) & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition >= SCZoneIdx(1));

                end
            else
                i_map = 1
                cellNum = meta_data{i_mouse, i_mouseDay}.cellNum;
                lapX = min(100, size(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd,2));
                meta_data{i_mouse, i_mouseDay}.firstLapFieldReliability = nan(size(meta_data{i_mouse, i_mouseDay}.onsetFieldReliability));
                for i_cell = 1:cellNum
                    meta_data{i_mouse, i_mouseDay}.firstLapFieldReliability(i_cell,1)  = mean(meta_data{i_mouse, i_mouseDay}.isSigLap(1:lapX, i_cell), 'omitnan');
                    
                end
                meta_data{i_mouse, i_mouseDay}.map(i_map).isGoalZonePC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, i_map} & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition <= goalZoneIdx(end)) & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition >= goalZoneIdx(1));
                meta_data{i_mouse, i_mouseDay}.map(i_map).isPIZonePC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, i_map} & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition <= PIZoneIdx(end)) & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition >= PIZoneIdx(1));
                meta_data{i_mouse, i_mouseDay}.map(i_map).isSCZonePC = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, i_map} & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition <= SCZoneIdx(end)) & (meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition >= SCZoneIdx(1));

            end
        end
    end
end

%% find BTSP events
fillBinSize = 2; % 1 or 2
fillBinLogic = false; % false or true
lapLimit = 100;

prePost_eventNum = 5 % 5 or 10, analysis purpose
prePost_plotLapNum = 10; % plotting purpose
prePost_boostThreshold = 2 
preEventReliabilityThreshold = 0.4 % pre events have to not higher than 0.2
requirePreEventReliability = false
requireImmediatePreEventLapReliable = false
requireBoostReliability = true
%% alternatively, set immediatePreEventReliability as must be false.
postEventReliabilityThreshold = 0.8 % post-event has to be higher than 0.4
edgeThreshold = 0.35 % above which of peak identified as PF
fieldSpaBinSize = 8 % 8 spatial bin is too stringent, go with 12, mouse#7, cell#2
topEvent_prctile = 90
topEvent_AmplitudeMin = 2; % dFF must be above this threshold, change from 1 to 2 as the mean is well above 3 for 80/90 percential
%% extra criterion for PF: inspired by Dombeck's Nature paper methods
fieldMaxRatio = 0.9 % field has to be smaller than 90% of the entire track, meaning 162cm
InFieldFd_LowPoint = 0.2 % in-field max has to be larger than this very low threshold, this makes sense for across-trial averaged Fd since there might be one trial with event out of N trials
inOutFieldDif = 2 % in-filed mean must be at least 2 times of out-field mean

%% this code takes ~3 min to run
%% v3 of find_BTSP % 1106-2023, before SfN
%% v3 is the version for CA1 paper, 2024

% findBTSPEvent_v3, consider all 200 laps for day -1
lapLimit_v3 = 200;
sectionBinSize = 20; % quantify number of BTSP from each section
map1_inFieldBinSize = 6 % 45cm zone
PFCOMShift_binLimit = 12; % if postPFCOM-eventPFCOM is too large
tic
parfor i_mouse = 1:17 %Num_allMice
    tic
    for i_mouseDay = 3:6
%         display(['Mouse#: ', num2str(i_mouse), ', day#: ', num2str(i_mouseDay)]);
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty % not empty data set
            meta_data{i_mouse, i_mouseDay}.map(1).BTSP_v3 = struct; meta_data{i_mouse, i_mouseDay}.map(2).BTSP_v3 = struct;
            if ~isRemap{i_mouse}{i_mouseDay} & i_mouseDay == 3
                i_map = 1;
                % identify top prctile event
                nanPC = nan(meta_data{i_mouse, i_mouseDay}.cellNum,1); nanSpacePC = nanPC; nanRewardPC = nanPC; nanMixPC = nanPC;
                isPC_tmp = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC & meta_data{i_mouse, i_mouseDay}.isPC_next100lap
                numLapFirstReward = 100 % if 100, won't affect anything thing
                [mx, meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap] = max(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_next100lap, [], 1, 'omitnan');
                meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap = meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap';
                isSMPC_next100lap = false(meta_data{i_mouse, i_mouseDay}.cellNum,1);
                isSMPC_next100lap(meta_data{i_mouse, i_mouseDay}.pcIdx_next100lap) = true;
                meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap(~isSMPC_next100lap) = -5;
                peakPosition_map1 = meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition;
                peakPosition_map2 = meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap;
                peakPositionDif = fieldPositionChange(spaDivNum, peakPosition_map2, peakPosition_map1);
                
                % version 2 findBTSPEvent_v2, lapLimit_v2 = 200
                meta_data{i_mouse, i_mouseDay}.map(i_map).BTSP_v3...
                    = findBTSPEvent_v3(meta_data{i_mouse, i_mouseDay}.eachSpaDivSpeed_mat', meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_mxsm, meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm, peakPosition_map1, peakPosition_map2, peakPositionDif, numLapFirstReward, lapLimit_v3, ...
                    meta_data{i_mouse, i_mouseDay}.signalThreshold_dFishQ, meta_data{i_mouse, i_mouseDay}.firstLapFieldReliability, fillBinSize, fillBinLogic, sectionBinSize, map1_inFieldBinSize, ...
                    fieldSpaBinSize, prePost_eventNum, prePost_plotLapNum, prePost_boostThreshold, preEventReliabilityThreshold, ...
                    requirePreEventReliability, requireImmediatePreEventLapReliable, requireBoostReliability, postEventReliabilityThreshold, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, topEvent_prctile, topEvent_AmplitudeMin, ...
                    isPC_tmp, nanSpacePC, nanRewardPC, nanMixPC,...
                    nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isGoalZonePC), nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPIZonePC), nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSCZonePC),...
                    isRemap{i_mouse}{i_mouseDay}, PFCOMShift_binLimit);
                
            else
                i_map = 1; j_map = 2;

                eachSpaDivSpeed_tmp = [meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivSpeed', meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivSpeed'];
                eachSpaDivFd_mxsm_tmp = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_mxsm, meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_mxsm);
                eachSpaDivFd_sm_tmp = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm, meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivFd_sm);
                numLapFirstReward = size(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_mxsm,2);
                peakPosition_map1 = meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition;
                peakPosition_map2 = meta_data{i_mouse, i_mouseDay}.map(j_map).peakPosition;
                peakPositionDif = meta_data{i_mouse, i_mouseDay}.map(i_map).peakPositionChange{i_mouseDay, j_map};
                meta_data{i_mouse, i_mouseDay}.map(i_map).BTSP_v3...
                    = findBTSPEvent_v3(eachSpaDivSpeed_tmp, eachSpaDivFd_mxsm_tmp, eachSpaDivFd_sm_tmp, peakPosition_map1, peakPosition_map2, peakPositionDif, numLapFirstReward, lapLimit_v3, ...
                    meta_data{i_mouse, i_mouseDay}.signalThreshold_dFishQ, meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapFieldReliability, fillBinSize, fillBinLogic, sectionBinSize, map1_inFieldBinSize, ...
                    fieldSpaBinSize, prePost_eventNum, prePost_plotLapNum, prePost_boostThreshold, preEventReliabilityThreshold, ...
                    requirePreEventReliability, requireImmediatePreEventLapReliable, requireBoostReliability, postEventReliabilityThreshold, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, topEvent_prctile, topEvent_AmplitudeMin, ...
                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, j_map}, nan2false(meta_data{i_mouse, i_mouseDay}.map(1).isSpaceAssociated{i_mouseDay, 2}),...
                    nan2false(meta_data{i_mouse, i_mouseDay}.map(1).isRewardAssociated{i_mouseDay, 2}), nan2false(meta_data{i_mouse, i_mouseDay}.map(1).is_neither_space_nor_reward_associated{i_mouseDay, 2}),...
                    nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isGoalZonePC), nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isPIZonePC), nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSCZonePC),...
                    isRemap{i_mouse}{i_mouseDay}, PFCOMShift_binLimit);
                
              
            end
        end
        
    end
    toc
end
toc


% group single animal data, v3
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

for i_group = 1:5
    MAP{i_group}.map(1).BTSP_v3 = cell(6,1);
    MAP{i_group}.map(2).BTSP_v3 = cell(6,1);
    for i_mouseDay = 3:6
        i_map = 1
        MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay} = struct;
        MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.matrix = [];
        MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.columnID = meta_data{7, i_mouseDay}.map(1).BTSP_v3.columnID;
        MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.perCell.matrix = [];
        MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.perCell.columnID = meta_data{7, i_mouseDay}.map(1).BTSP_v3.perCell.columnID;
        for i = 1:length(mouseGroupIdx{i_group})
            i_mouse = mouseGroupIdx{i_group}(i);
            if ~meta_data{i_mouse, i_mouseDay}.isEmpty
                % transform the animal-local cell ID into global cell ID
                x = meta_data{i_mouse, i_mouseDay}.map(i_map).BTSP_v3.matrix;
                x(:, meta_data{i_mouse, i_mouseDay}.map(i_map).BTSP_v3.columnID.cellID) = x(:, meta_data{i_mouse, i_mouseDay}.map(i_map).BTSP_v3.columnID.cellID) + MAP{i_group}.map(i_map).cellNum_cumsum(i, i_mouseDay);
                MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.matrix = [MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.matrix; x];
                MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.perCell.matrix = [MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay}.perCell.matrix; meta_data{i_mouse, i_mouseDay}.map(i_map).BTSP_v3.perCell.matrix];
            end
        end
        
    end
end

groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

% key stats across MAP, v3

i_mouseDay = 4; 
i_map = 1; 
i_group = 3
BTSPv3 = MAP{i_group}.map(i_map).BTSP_v3{i_mouseDay};
if i_mouseDay >=4
% % %     %% Fig.4; Fig. 4 and Extended Data for BTSP
%     plotBTSP_Fig4(BTSPv3, i_mouseDay, i_group, i_map,  groupNameLabelPool, dayLabel, prePost_plotLapNum, prePost_eventNum, topEvent_prctile, fieldSpaBinSize)
    %% basically a clean version of plotBTSP_Fig4, for keeping track of source data, 01-13-2025 for final submission
    % well, it's actually the code for Fig 5...
    plotBTSP_Fig4_sourceData(BTSPv3, i_mouseDay, i_group, i_map,  groupNameLabelPool, dayLabel, prePost_plotLapNum, prePost_eventNum, topEvent_prctile, fieldSpaBinSize)
end

% calculate speed Corr trial-to-trial for each individual animal
i_map = 1; j_map = 2;
templateIdx = 76:100
for i_mouseDay = 4:6
    for i_mouse = 1:Num_allMice
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty
            [sizeA, sizeB] = size(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivSpeed)
            if sizeA < 100
                a1 = [meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivSpeed; nan(100-sizeA, sizeB)];
            else
                a1 = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivSpeed
            end
            [sizeC, sizeD] = size(meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivSpeed)
            if sizeC < 100
                a2 = [meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivSpeed; nan(100-sizeC, sizeD)];
            else
                a2 = meta_data{i_mouse, i_mouseDay}.map(j_map).eachSpaDivSpeed;
            end
            
            
            x = [a1', a2'];
            x_template = mean(x(:, templateIdx), 2, 'omitnan');
            meta_data{i_mouse, i_mouseDay}.speedCorr = corr(x_template, x);
        end
    end
end

% combine speed Corr to one MAP
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
for i_group = 2:3
    MAP{i_group}.speedCorr = {};
    for i_mouseDay = 4:5
        MAP{i_group}.speedCorr{i_mouseDay} = [];     

        for i_mouse = mouseGroupIdx{i_group}
            if ~meta_data{i_mouse, i_mouseDay}.isEmpty
                MAP{i_group}.speedCorr{i_mouseDay} = [MAP{i_group}.speedCorr{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.speedCorr]
            end
        end
    end
end


i_group = 2; j_group = 3;
i_mouseDay = 4
plotSpeedCorr(MAP, i_group, j_group, i_mouseDay, dayLabel, groupNameLabelPool)




%% representation of place cells diappeared / newly acquired after reward switch
i_group = 3
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 4;

x1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map})
x2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, MAP{i_group}.map(j_map).isPC_i_not_j{i_mouseDay, j_mouseDay, i_map})

figure;
subplot(1,2,1)
[ii, mx] = max(x1, [], 1, 'omitnan');
[mx_sort, iii] = sort(mx)
imagesc(x1(:, iii)', [0 1]); colormap jet;
title('PC@map1, disappearred@map2'); 
set(gca, 'FontSize',12, 'TickDir', 'out'); xticks([1 12.5 25 37.5 50]); yticks([1, size(x1,2)]); xticklabels({'0', '45', '90', '135', '180'})
subplot(1,2,2)
[ii, mx] = max(x2, [], 1, 'omitnan');
[mx_sort, iii] = sort(mx)
imagesc(x2(:, iii)', [0 1]); colormap jet;
title('not PC@map1, appeared@map2');
set(gca, 'FontSize',12, 'TickDir', 'out'); xticks([1 12.5 25 37.5 50]); yticks([1, size(x2,2)]); xticklabels({'0', '45', '90', '135', '180'})
sgtitle(groupNameLabelPool{i_group})

%% uniformly disappeared? uniformly appeared? uniformity test

i_group = 2
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 4;
idx_disappearPC = nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, i_mouseDay, j_map}); 
idx_newPC = nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{i_mouseDay, i_mouseDay, i_map});
% observed data
x_disappearPC = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_disappearPC);
x_newPC = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_newPC);
% synthetic data

% disappear PC simulation
n = sum(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, i_map}, 'omitnan');
n_disappear = sum(idx_disappearPC);
ratio_disappear = n_disappear/n; % use this diappear ratio to generate a if-random-disappear data set for comparison
rng('default')
i_d = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, i_map});
find_i = find(i_d==1);
for i_find = 1:length(find_i)
    if rand > ratio_disappear
        i_d(i_find) = false;
    end
end
y_disappearPC = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(i_d);

% new PC simulation
n = sum(MAP{i_group}.map(j_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map}, 'omitnan');
n_new = sum(idx_newPC);
ratio_new = n_new/n; % use this new ratio to generate a if-random-appear data set for comparison
rng('default')
i_n = nan2false(MAP{i_group}.map(j_map).isPC_i_and_j{i_mouseDay, i_mouseDay, j_map});
find_i = find(i_n==1);
for i_find = 1:length(find_i)
    if rand > ratio_new
        i_n(i_find) = false;
    end
end
y_newPC = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(i_n);




%% look at group 4, space vs PI cells
i_group = 2;
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 4;

x1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}))
x2 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}))
x3 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}(:, nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map}))

figure;
subplot(1,3,1)
[ii, mx] = max(x1, [], 1, 'omitnan');
[mx_sort, iii] = sort(mx)
imagesc(x1(:, iii)', [0 1]); colormap jet;
title('PC @map1, disappearred @map2')
subplot(1,3,2)
[ii, mx] = max(x2, [], 1, 'omitnan');
[mx_sort, iii] = sort(mx)
imagesc(x2(:, iii)', [0 1]); colormap jet;
title('not PC @map1, appeared @map2')
subplot(1,3,3)
[ii, mx] = max(x3, [], 1, 'omitnan');
[mx_sort, iii] = sort(mx)
imagesc(x3(:, iii)', [0 1]); colormap jet;
title('not PC @map1, appeared @map2')
sgtitle(groupNameLabelPool{i_group})

figure;
plot(mean(x1, 2, 'omitnan'), 'b'); hold on;
plot(mean(x2, 2, 'omitnan'), 'r'); hold on;
plot(mean(x3, 2, 'omitnan'), 'k'); hold on;


%% does mean activity of space and reward referenced pc anti-correlate with each other?
i_group = 3;
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 4;
for i_mouse = 7:17
    x1 = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}))
    x2 = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm(:, nan2false(meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}))
    meta_data{i_mouse, i_mouseDay}.spaceCorrReward = corr(mean(x1, 2, 'omitnan'), mean(x2, 2, 'omitnan'))
   
end

i_mouseDay = 4
for i_group = 3:5
    MAP{i_group}.spaceCorrReward = []
    for i_mouse = mouseGroupIdx{i_group}
        if ~meta_data{i_mouse, i_mouseDay}.isEmpty
            MAP{i_group}.spaceCorrReward = [MAP{i_group}.spaceCorrReward; meta_data{i_mouse, i_mouseDay}.spaceCorrReward]
        end
    end
end


%% find the best representation figure

for i_mouse = 1:6
    figure;
    h1 = subplot(1,2,1)
    imagesc(100*meta_data{i_mouse,4}.eachSpaDivSpeed_mat, [0 50]); colormap jet; colorbar
    h2 = subplot(1,2,2)
    imagesc(meta_data{i_mouse,4}.eachSpaDivLickSum_mat, [0 3]); colormap(h2, hot); colorbar
end

%% best running representative, aAAA: i_mouse = 7; aBBB: i_mouse = 3
%% Fig1b, example velocity and licking profile, KQ146
i_mouse = 7
figure;
h1 = subplot(1,2,1)
imagesc(100*meta_data{i_mouse,4}.map(1).eachSpaDivSpeed, [0 50]); colormap jet; colorbar; box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)
h2 = subplot(1,2,2)
imagesc(meta_data{i_mouse,4}.map(1).eachSpaDivLickSum, [0 3]); colormap(h2, hot); colorbar; box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)

figure;
h1 = subplot(1,2,1)
imagesc(100*meta_data{i_mouse,4}.map(2).eachSpaDivSpeed, [0 50]); colormap jet; colorbar;box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)
h2 = subplot(1,2,2)
imagesc(meta_data{i_mouse,4}.map(2).eachSpaDivLickSum, [0 3]); colormap(h2, hot); colorbar;box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)

Fig1b_speed_Pre = 100*meta_data{i_mouse,4}.map(1).eachSpaDivSpeed;
Fig1b_speed_Post = 100*meta_data{i_mouse,4}.map(2).eachSpaDivSpeed;
Fig1b_lickprob_Pre = meta_data{i_mouse,4}.map(1).eachSpaDivLickSum;
Fig1b_lickprob_Post = meta_data{i_mouse,4}.map(2).eachSpaDivLickSum;

%% Fig2a, example velocity and licking profile, KQ146
i_mouse = 3
figure;
h1 = subplot(1,2,1)
imagesc(100*meta_data{i_mouse,4}.map(1).eachSpaDivSpeed, [0 50]); colormap jet; colorbar; box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)
h2 = subplot(1,2,2)
imagesc(meta_data{i_mouse,4}.map(1).eachSpaDivLickSum, [0 3]); colormap(h2, hot); colorbar; box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)

figure;
h1 = subplot(1,2,1)
imagesc(100*meta_data{i_mouse,4}.map(2).eachSpaDivSpeed, [0 50]); colormap jet; colorbar;box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)
h2 = subplot(1,2,2)
imagesc(meta_data{i_mouse,4}.map(2).eachSpaDivLickSum, [0 3]); colormap(h2, hot); colorbar;box off;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1 50 100]); set(gca, 'FontSize', 12)

Fig2a_speed_Pre = 100*meta_data{i_mouse,4}.map(1).eachSpaDivSpeed;
Fig2a_speed_Post = 100*meta_data{i_mouse,4}.map(2).eachSpaDivSpeed;
Fig2a_lickprob_Pre = meta_data{i_mouse,4}.map(1).eachSpaDivLickSum;
Fig2a_lickprob_Post = meta_data{i_mouse,4}.map(2).eachSpaDivLickSum;


%% test statistical significance for each spatial bin the portion of spatial-cue PCs and reward-distance PCs
numDivision = 25; % division the entire track into this amount of spatial bins
i_group = 4
i_mouseDay = 4
j_mouseDay = i_mouseDay;
i_map = 1;
j_map = 2
y1 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay}(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
y2 = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay}(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
n = length(y1);
rng('default');
% each column is shuffled space PC ratio from this division bin
shuffleNum = 200
shuffleSpacePCRatioEachDiv = nan(shuffleNum, numDivision);

for i_shuffle = 1:shuffleNum
    idx_rand = randi(spaDivNum, n, 1);
    shuffleSpacePCRatioEachDiv(i_shuffle, :) = calculateDivSCRatio(y1, idx_rand, numDivision, binThreshold, spaDivNum);
end


divisionSpacePCRatio = calculateDivPCRatio(y1, MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}), numDivision, spaDivNum);
divisionRewardPCRatio = calculateDivPCRatio(y1, MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}), numDivision, spaDivNum);

PCRatioEachDivprct_95 = prctile(shuffleSpacePCRatioEachDiv, 95, 1)
PCRatioEachDivprct_5 = prctile(shuffleSpacePCRatioEachDiv, 5, 1)

figure;
plot(divisionSpacePCRatio, '-ob'); hold on;
plot(divisionRewardPCRatio, '-or');
plot(PCRatioEachDivprct_95)
plot(PCRatioEachDivprct_5)
% xticks([0 25 50]); xticklabels({'0', '90', '180'});
set(gca, 'TickDir', 'out');
box off; set(gca, 'FontSize', 12)
xticks([3, 7, 11, 15, 19, 23]+1)

% 
% plot(PCRatioEachDivprct_95, '-*k'); hold on;
% plot(PCRatioEachDivprct_5, '-*k')





%% activity vs position vs velocity (separate matlab.m

%% show representation across conditions

%% Fig2c, Extended Fig3d
i_mouseDay = 4; j_mouseDay = i_mouseDay; i_map = 1; j_map = 2;
i_group = 2

idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});

%% Fig2c, Space Map, in Pre and Post, novel env
idx = idx1; 
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
Fig2c_spaceMap_Pre = map1_norm(:, ii)';
Fig2c_spaceMap_Post = map2_norm(:, ii)';

%% Fig2c, Goal PC map in Pre and Post, novel env
idx = idx2; 
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
Fig2c_goalMap_Pre = map1_norm(:, ii)';
Fig2c_goalMap_Post = map2_norm(:, ii)';

%% Extended Fig3d, Inter PC map in Pre and Post, novel env
idx = idx3; 
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
ExtendedFig3d_interMap_Pre = map1_norm(:, ii)';
ExtendedFig3d_interMap_Post = map2_norm(:, ii)';


%% Fig1d, Extended Fig3b
i_mouseDay = 4; j_mouseDay = i_mouseDay; i_map = 1; j_map = 2;
i_group = 3

idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});

%% Fig1d, Space Map, in Pre and Post, novel env
idx = idx1; 
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
Fig1d_spaceMap_Pre = map1_norm(:, ii)';
Fig1d_spaceMap_Post = map2_norm(:, ii)';

%% Fig2c, Goal PC map in Pre and Post, novel env
idx = idx2; 
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
Fig1d_goalMap_Pre = map1_norm(:, ii)';
Fig1d_goalMap_Post = map2_norm(:, ii)';

%% Extended Fig3b, Inter PC map in Pre and Post, novel env
idx = idx3; 
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
ExtendedFig3b_interMap_Pre = map1_norm(:, ii)';
ExtendedFig3b_interMap_Post = map2_norm(:, ii)';


%% what is the fraction of place cells remain stable across day, but shift from allocentric to egocentric PC
% allo-ego transformation, Fig 3, Allo-Ego Transformation
i_mouseDay = 4; j_mouseDay = 5;
i_map = 1; j_map = 2;
i_group = 3
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map}); % day 1, allo
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map}); % day 1, ego

idx3 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{j_mouseDay, j_mouseDay, j_map}); % day 2, allo
idx4 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{j_mouseDay, j_mouseDay, j_map}); % day 2, ego

idx5 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, i_map}); % maintained stable PF day 1 vs day 2, first 100 laps
idx6 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{j_mouseDay, j_mouseDay, j_map}); % day 2, dual-track PCs

idx_aa = idx1 & idx3; % allo day 1, allo day 2
idx_aas = idx1 & idx3 & idx5; % allo day 1, allo day 2, and maintained stable PF across two days

idx_ae = idx1 & idx4; % allo day 1, ego day 2
idx_aes = idx1 & idx4 & idx5; % allo day 1, ego day 2, and maintained stable PF across two days

idx_ee = idx2 & idx4 ; % ego day 1,  ego day 2,
idx_ees = idx2 & idx4 & idx5; % ego day 1, ego day 2, stable across day

idx = idx_ae
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map3 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:, idx);
map4 = MAP{i_group}.map(j_map).avg_eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:, idx);

[mx1, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[mx3, i3] = max(map3, [], 1, 'omitnan');
[mx4, i4] = max(map4, [], 1, 'omitnan');

[i_sort, ii] = sort(i);
map1_norm = map1 ./ mx1; map2_norm = map2 ./ mx2; map3_norm = map3 ./ mx3; map4_norm = map4 ./ mx4;

figure;
subplot(2,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 12.5 25 37.550]); xticklabels({'0', '', '90','',  '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(2,2,3)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 12.5 25 37.550]); xticklabels({'0', '', '90','',  '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])
subplot(2,2,2)
imagesc(map3_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 12.5 25 37.550]); xticklabels({'0', '', '90','',  '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map3_norm,2)])
subplot(2,2,4)
imagesc(map4_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 12.5 25 37.550]); xticklabels({'0', '', '90','',  '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map4_norm,2)]);
sgtitle(groupNameLabelPool{i_group})
% allo-ego transformation, Allo-Ego transformation
d = MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, i_map}(idx)
figure;
edges = 0:1:25
[n1, e1] = histcounts(abs(d), edges, 'Normalization', 'probability')
plot(e1(2:end), n1, 'k');ylim([-0.01, 0.25]); xlim([0 26])
title([groupNameLabelPool{i_group}, ', ', num2str(mean(abs(d)<=4 | abs(d)>=20), '%.3f')]); box off; axis square



% single cell example
% allo-PC keeps allo. cell #310, aAAA
% allo-PC becomes ego. cell #427, aABB
find_allo2egoCellIdx = find(idx_aa ==1);
map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx_aa);
[mx, i] = max(map1, [], 1, 'omitnan');
[i_sort, ii] = sort(i);
for i_c = 21:28 %length(find_allo2egoCellIdx)
    i_cell = find_allo2egoCellIdx(ii(i_c))
    lapLimit = 1:100
    m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
    m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
    n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
    n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
    figure; colorlimit = 1;
    subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
    subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
    subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
    subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
    sgtitle([ 'cell# ',num2str(i_cell)]);
    figure;
    subplot(1,2,1); plot(mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'), 'k'); hold on; plot(mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'), 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
    subplot(1,2,2); plot(mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'), 'k'); hold on; plot(mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'), 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
end
% all allo2ego cells, simple visualization
for i_c = 1:length(find_allo2egoCellIdx)
    i_cell = find_allo2egoCellIdx(ii(i_c))
    lapIdx = 1:70 % only show the first 70, 
    m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,lapIdx, i_cell)); m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,lapIdx, i_cell));
    n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapIdx, i_cell)); n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapIdx, i_cell));
    N = [m1, m2, n1, n2];
    figure;
    b1=imagesc(N, [0 1]); colormap jet;  set(b1, 'AlphaData', ~isnan(N));
    xticks([1 101 201 301 400]); xticklabels({'1', '', '2', '', '400'}); yticks([1 13 25 37 50]); yticklabels({'0', '', '90', '', '180'}); ylabel('Position (cm)'); xlabel('Trials');
    sgtitle([ 'cell# ',num2str(i_cell)]); box off; set(gca, 'TickDir', 'out')
    pbaspect([1, 0.4, 1])
end


% allo-PC keeps allo. cell #310, aAAA
% allo-PC becomes ego. cell #427, aABB
%% Fig3b, cell #310, aAAA
i_mouseDay = 4; j_mouseDay = 5
i_cell = 310; i_group = 3;
lapLimit = 1:80
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);
figure;
subplot(1,2,1); 
plot(mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'), 'k'); hold on; 
plot(mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'), 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'), 'k'); hold on; 
plot(mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'), 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

Fig3b_fam_day1_Pre = m1';
Fig3b_fam_day1_Post = m2';
Fig3b_fam_day2_Pre = n1';
Fig3b_fam_day2_Post = n2';
Fig3b_fam_day1_Pre_mean_norm = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
Fig3b_fam_day1_Post_mean_norm = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
Fig3b_fam_day2_Pre_mean_norm = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
Fig3b_fam_day2_Post_mean_norm = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

% allo-PC becomes ego. cell #427, aABB
%% Fig3a, cell #427, aABB
i_mouseDay = 4; j_mouseDay = 5
i_cell = 427; i_group = 4;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);
figure;
subplot(1,2,1); 
plot(mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'), 'k'); hold on; 
plot(mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'), 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'), 'k'); hold on; 
plot(mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'), 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

Fig3a_novel_day1_Pre = m1';
Fig3a_novel_day1_Post = m2';
Fig3a_novel_day2_Pre = n1';
Fig3a_novel_day2_Post = n2';
Fig3a_novel_day1_Pre_mean_norm = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
Fig3a_novel_day1_Post_mean_norm = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
Fig3a_novel_day2_Pre_mean_norm = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
Fig3a_novel_day2_Post_mean_norm = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';


%% Extended Fig9a, Goal PC stays Goal PC, aABB
%% cell 478, cell 1210, cell 1086
%% Extended Fig9a, left, cell 478, aABB
i_mouseDay = 4; j_mouseDay = 5
i_cell = 478; i_group = 4;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);

m1_mean = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
m2_mean = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
n1_mean = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
n2_mean = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

figure;
subplot(1,2,1); 
plot(m1_mean, 'k'); hold on; 
plot(m2_mean, 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(n1_mean, 'k'); hold on; 
plot(n2_mean, 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

x1 = [m1'; nan(2,50); m1_mean; nan(2,50); n1'; nan(2,50); n1_mean];
x2 = [m2'; nan(2,50); m2_mean; nan(2,50); n2'; nan(2,50); n2_mean];
ExtendedFig9a_left = [x1, nan(size(x1,1),2), x2];

%% Extended Fig9a, middle, cell 1210, aABB
i_mouseDay = 4; j_mouseDay = 5
i_cell = 1210; i_group = 4;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);

m1_mean = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
m2_mean = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
n1_mean = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
n2_mean = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

figure;
subplot(1,2,1); 
plot(m1_mean, 'k'); hold on; 
plot(m2_mean, 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(n1_mean, 'k'); hold on; 
plot(n2_mean, 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

x1 = [m1'; nan(2,50); m1_mean; nan(2,50); n1'; nan(2,50); n1_mean];
x2 = [m2'; nan(2,50); m2_mean; nan(2,50); n2'; nan(2,50); n2_mean];
ExtendedFig9a_middle = [x1, nan(size(x1,1),2), x2];

%% Extended Fig9a, right, cell 1086, aABB
i_mouseDay = 4; j_mouseDay = 5
i_cell = 1086; i_group = 4;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);

m1_mean = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
m2_mean = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
n1_mean = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
n2_mean = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

figure;
subplot(1,2,1); 
plot(m1_mean, 'k'); hold on; 
plot(m2_mean, 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(n1_mean, 'k'); hold on; 
plot(n2_mean, 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

x1 = [m1'; nan(2,50); m1_mean; nan(2,50); n1'; nan(2,50); n1_mean];
x2 = [m2'; nan(2,50); m2_mean; nan(2,50); n2'; nan(2,50); n2_mean];
ExtendedFig9a_right = [x1, nan(size(x1,1),2), x2];


%% Extended Fig9b, left, cell53, aAAA
i_mouseDay = 4; j_mouseDay = 5
i_cell = 53; i_group = 3;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);

m1_mean = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
m2_mean = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
n1_mean = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
n2_mean = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

figure;
subplot(1,2,1); 
plot(m1_mean, 'k'); hold on; 
plot(m2_mean, 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(n1_mean, 'k'); hold on; 
plot(n2_mean, 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

x1 = [m1'; nan(2,50); m1_mean; nan(2,50); n1'; nan(2,50); n1_mean];
x2 = [m2'; nan(2,50); m2_mean; nan(2,50); n2'; nan(2,50); n2_mean];
ExtendedFig9b_left = [x1, nan(size(x1,1),2), x2];


%% Extended Fig9b, middle, cell 617, aAAA
i_mouseDay = 4; j_mouseDay = 5
i_cell = 617; i_group = 3;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);

m1_mean = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
m2_mean = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
n1_mean = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
n2_mean = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

figure;
subplot(1,2,1); 
plot(m1_mean, 'k'); hold on; 
plot(m2_mean, 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(n1_mean, 'k'); hold on; 
plot(n2_mean, 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

x1 = [m1'; nan(2,50); m1_mean; nan(2,50); n1'; nan(2,50); n1_mean];
x2 = [m2'; nan(2,50); m2_mean; nan(2,50); n2'; nan(2,50); n2_mean];
ExtendedFig9b_middle = [x1, nan(size(x1,1),2), x2];

%% Extended Fig9b, right, cell 907, aAAA
i_mouseDay = 4; j_mouseDay = 5
i_cell = 907; i_group = 3;
lapLimit = 1:100
m1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
m2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:,:, i_cell));
n1 = squeeze(MAP{i_group}.map(i_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,:, i_cell));
n2 = squeeze(MAP{i_group}.map(j_map).eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:,lapLimit, i_cell));
figure; colorlimit = 1;
subplot(2,2,1); b1 = imagesc(m1', [0 colorlimit]); set(b1, 'AlphaData', ~isnan(m1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,3); b2 = imagesc(m2', [0 colorlimit]); set(b2, 'AlphaData', ~isnan(m2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,2); b3 = imagesc(n1', [0 colorlimit]); set(b3, 'AlphaData', ~isnan(n1')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
subplot(2,2,4); b4 = imagesc(n2', [0 colorlimit]); set(b4, 'AlphaData', ~isnan(n2')); colormap jet; xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'}); yticks([1 20 40 60 80 100]); xlabel('Position (cm)'); ylabel('Trials'); set(gca, 'TickDir', 'out'); box off;
sgtitle([ 'cell# ',num2str(i_cell)]);

m1_mean = (mean(m1, 2, 'omitnan')./ max(mean(m1, 2, 'omitnan'), [], 'omitnan'))';
m2_mean = (mean(m2, 2, 'omitnan')./ max(mean(m2, 2, 'omitnan'), [], 'omitnan'))';
n1_mean = (mean(n1, 2, 'omitnan')./ max(mean(n1, 2, 'omitnan'), [], 'omitnan'))';
n2_mean = (mean(n2, 2, 'omitnan')./ max(mean(n2, 2, 'omitnan'), [], 'omitnan'))';

figure;
subplot(1,2,1); 
plot(m1_mean, 'k'); hold on; 
plot(m2_mean, 'r'); hold on; ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;
subplot(1,2,2); 
plot(n1_mean, 'k'); hold on; 
plot(n2_mean, 'r'); hold on;ylim([-0.1 1.1]);xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});yticks([0 0.25 0.5 0.75 1]);xlabel('Position (cm)'); ylabel('norm dF/F'); set(gca, 'TickDir', 'out'); box off;

x1 = [m1'; nan(2,50); m1_mean; nan(2,50); n1'; nan(2,50); n1_mean];
x2 = [m2'; nan(2,50); m2_mean; nan(2,50); n2'; nan(2,50); n2_mean];
ExtendedFig9b_right = [x1, nan(size(x1,1),2), x2];

%% show representation - clean, Jeff wants self ranked representation, no cross validation
% place cell representation
i_mouseDay = 4; j_mouseDay = 5;
i_map = 1; j_map = 2;
i_group = 4

idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, i_map}); % allocentric
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, i_map}); % egocentri
idx3 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, i_map}); % all PCs with fields on both maps
idx4 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, i_map}); % mixed-PCs
idx = idx3;

% modulate spatial bin creterion
% % % idx = nan2false(abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map})>=9 & abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map})<=16);
% % % idx = nan2false(abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map})<=8)

map1 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay, 1}(:, idx);
map2 = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{j_mouseDay, 1}(:, idx);
[mx, i] = max(map1, [], 1, 'omitnan');
[mx2, i2] = max(map2, [], 1, 'omitnan');
[i_sort, ii] = sort(i);

map1_norm = map1 ./ mx;
map2_norm = map2 ./ mx2;
figure;
subplot(1,2,1)
imagesc(map1_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map1_norm,2)])
subplot(1,2,2)
imagesc(map2_norm(:, ii)', [0 1]); colormap jet; box off
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); yticks([1, size(map2_norm,2)])


%% spatial distribution of each type of place cells
% place field distribution, first 100 laps

i_mouseDay = 4; j_mouseDay = 4;
i_map = 1; j_map = 2;
i_group = 3
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
idx = idx3;

% first 100 laps
y1 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx1);
y2 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx2);
i_group = 2;
idx3 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
y3 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx3);

figure;
h1 = histogram(y1, 'Normalization', 'count'); hold on;
h2 = histogram(y2, 'Normalization', 'count'); hold on;
% h3 = histogram(y3, 'Normalization', 'probability'); hold on;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out');
box off; legend('Allocentric PCs', 'Egocentric PCs'); legend('boxoff')
h1.FaceColor = 'k'; h1.FaceAlpha = 0.5; h1.EdgeColor = 'k'; h1.EdgeAlpha = 0.3;
h2.FaceColor = 'r'; h2.FaceAlpha = 0.5; h2.EdgeColor = 'r'; h2.EdgeAlpha = 0.3;
% h3.FaceColor = 'b'; h3.EdgeColor = 'w'; h3.FaceAlpha = 0.5;
set(gca, 'FontSize', 24);
pbaspect([1 0.618 1])
% ylim([0 0.2]); yticks([0 0.05 0.1 0.15 0.2]);



figure;
h1 = histogram(y1, 'Normalization', 'count'); hold on;
h2 = histogram(y2, 'Normalization', 'count'); hold on;
h3 = histogram(y3, 'Normalization', 'count'); hold on;
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out');
box off; legend('space-cue PCs, familiar env A', 'reward-distance PCs,  familiar env A', 'reward-distance PCs, novel env B'); legend('boxoff')
h1.FaceColor = 'k'; h1.EdgeColor = 'w'; h1.FaceAlpha = 0.5
h2.FaceColor = 'r'; h2.EdgeColor = 'w'; h2.FaceAlpha = 0.5;
h3.FaceColor = 'b'; h3.EdgeColor = 'w'; h3.FaceAlpha = 0.5;
set(gca, 'FontSize', 24); 
% ylim([0 0.2]); yticks([0 0.05 0.1 0.15 0.2]);


%% allo+ego PCs vs mix PC
% place field distribution/spatial distribution
i_mouseDay = 4; j_mouseDay = 4;
i_map = 1; j_map = 2;
i_group = 2
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});
idx4 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
idx = idx1;

y1 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx1|idx2); % ego+allo
y2 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx3); % mix
[k1, p1] = kstest2(y1, y2)

figure; 
h1 = histogram(y1, 'Normalization', 'probability', 'BinWidth', 2); hold on;
h2 = histogram(y2, 'Normalization', 'probability', 'BinWidth', 2); hold on;
% h3 = histogram(y3, 'Normalization', 'probability'); hold on;
xticks([1 13 25 37 50]); xticklabels({'0', '', '90', '', '180'});set(gca, 'TickDir', 'out');
box off; legend('A+E PCs', 'Mix PCs'); legend('boxoff')
h1.FaceColor = 'k'; h1.FaceAlpha = 0.5; h1.EdgeColor = 'w'; h1.EdgeAlpha = 0.3;
h2.FaceColor = 'r'; h2.FaceAlpha = 0.5; h2.EdgeColor = 'w'; h2.EdgeAlpha = 0.3;
% h3.FaceColor = 'b'; h3.EdgeColor = 'w'; h3.FaceAlpha = 0.5;
title([groupNameLabelPool{i_group}, ', ', outputPValue(p1), ', day: ', dayLabel{i_mouseDay}]); ylim([0 0.15]); yticks(0:0.03:0.15)
set(gca, 'FontSize', 15);
% ylim([0 0.2]); yticks([0 0.05 0.1 0.15 0.2]);





%% relative fraction of allo+ego vs mix
% spatial distribution of place field (no confidence interval)
% Fig.1h; Fig. 1h
%% Fig2f, Fig2c, Extended Fig3d
i_mouseDay = 4; j_mouseDay = i_mouseDay
i_map = 1; j_map = 2;
i_group = 2
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});
idx4 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});

ya_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx1); % allo
ye_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx2); % ego
ym_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx3); % mix
y0_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx4); % all PC, dual-track

ya_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx1); % allo
ye_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx2); % ego
ym_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx3); % mix
y0_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx4); % all PC, dual-track


edges = 1:2:51
[na_pre, Ea] = histcounts(ya_pre,edges); [ne_pre, Ee] = histcounts(ye_pre,edges);
[nm_pre, Em] = histcounts(ym_pre,edges); [n0_pre, E0] = histcounts(y0_pre,edges); 

[na_post, Ea] = histcounts(ya_post,edges); [ne_post, Ee] = histcounts(ye_post,edges);
[nm_post, Em] = histcounts(ym_post,edges); [n0_post, E0] = histcounts(y0_post,edges); 


% plot the relative fraction of PC versus the position, pre
[k1, p2] = kstest2(ya_pre, ye_pre)
figure;
stairs((na_pre./n0_pre), 'b'); hold on; % allo
stairs((ne_pre./n0_pre), 'r'); hold on; % ego
yline(0.18, '--k'); 
title([groupNameLabelPool{i_group}, ', ', outputPValue(p2), ', day: ', dayLabel{i_mouseDay}]); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-0.02 1.02]); xlim([-0.5 25.5]); yticks(0:0.25:1); xticks([1 7 13 19 25]); xticklabels({'0', '','90','', '180'})
ylabel('Proportion of PCs')
legend('Allo', 'Ego'); legend('boxoff')

Fig2f_Space = (na_pre./n0_pre);
Fig2f_Goal = (ne_pre./n0_pre);
Fig2f_binValue = edges(1:end-1)


% plot the PC number, Allo, pre vs post;
% Fig. 1h, Fig.1h
colorM = cbrewer('qual', 'Set1', 9);
figure;
plot(Ea(1:end-1), na_pre, 'Color', 'k'); hold on; % allo, pre
plot(Ea(1:end-1), na_post, 'Color', 'r'); hold on; % allo, post
title([groupNameLabelPool{i_group},  ', day: ', dayLabel{i_mouseDay}, 'allo pre vs post']); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-1 40]); xlim([-0.5 50.5]); yticks(0:10:40); xticks([1 13 25 38 50]); xticklabels({'0', '','90','', '180'})
ylabel('PC number')
legend('Allo-Pre', 'Allo-Post'); legend('boxoff')

Fig2c_PCcount_space_pre = na_pre;
Fig2c_PCcount_space_post = na_post;
Fig2c_PCcount_space_binValue = Ea(1:end-1)
Fig2c_PCcount_space_summary = [Fig2c_PCcount_space_pre; nan(2, size(ne_pre, 2)); Fig2c_PCcount_space_post; nan(2, size(ne_pre, 2)); Fig2c_PCcount_space_binValue]


%% Extended Data Fig.4; Extended Data Fig. 4; Extended Data 4;
colorM = cbrewer('qual', 'Set1', 9);
figure;
plot(Em(1:end-1), nm_pre, 'Color', 'k'); hold on; % allo, pre
plot(Em(1:end-1), nm_post, 'Color', 'r'); hold on; % allo, post
title([groupNameLabelPool{i_group},  ', day: ', dayLabel{i_mouseDay}, ', Mix pre vs post']); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-1 40]); xlim([-0.5 50.5]); yticks(0:10:40); xticks([1 13 25 38 50]); xticklabels({'0', '','90','', '180'})
ylabel('PC number')
legend('Mix-Pre', 'Mix-Post'); legend('boxoff')

ExtendedFig3d_PCcount_inter_pre = nm_pre;
ExtendedFig3d_PCcount_inter_post = nm_post;
ExtendedFig3d_PCcount_inter_binValue = Em(1:end-1)
ExtendedFig3d_PCcount_inter_summary = [ExtendedFig3d_PCcount_inter_pre; nan(2, size(ne_pre, 2)); ExtendedFig3d_PCcount_inter_post; nan(2, size(ne_pre, 2)); ExtendedFig3d_PCcount_inter_binValue]


% plot the PC number, Ego, pre vs post;
colorM = cbrewer('qual', 'Set1', 9);
figure;
plot(Ee(1:end-1), ne_pre, 'Color', 'k'); hold on; % allo, pre
plot(Ee(1:end-1), ne_post, 'Color', 'r'); hold on; % allo, post
title([groupNameLabelPool{i_group},  ', day: ', dayLabel{i_mouseDay}, 'Ego, pre vs post']); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-1 40]); xlim([-0.5 50.5]); yticks(0:10:40); xticks([1 13 25 38 50]); xticklabels({'0', '','90','', '180'})
ylabel('PC number')
legend('Ego-Pre', 'Ego-Post'); legend('boxoff')
Fig2c_PCcount_goal_pre = ne_pre;
Fig2c_PCcount_goal_post = ne_post;
Fig2c_PCcount_goal_binValue = Ee(1:end-1)
Fig2c_PCcount_goal_summary = [Fig2c_PCcount_goal_pre; nan(2, size(ne_pre, 2)); Fig2c_PCcount_goal_post; nan(2, size(ne_pre, 2)); Fig2c_PCcount_goal_binValue]


%% Fig1d, Fig1g, Extended Fig3b
i_mouseDay = 4; j_mouseDay = i_mouseDay
i_map = 1; j_map = 2;
i_group = 3
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});
idx4 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});

ya_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx1); % allo
ye_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx2); % ego
ym_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx3); % mix
y0_pre = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx4); % all PC, dual-track

ya_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx1); % allo
ye_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx2); % ego
ym_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx3); % mix
y0_post = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx4); % all PC, dual-track


edges = 1:2:51
[na_pre, Ea] = histcounts(ya_pre,edges); [ne_pre, Ee] = histcounts(ye_pre,edges);
[nm_pre, Em] = histcounts(ym_pre,edges); [n0_pre, E0] = histcounts(y0_pre,edges); 

[na_post, Ea] = histcounts(ya_post,edges); [ne_post, Ee] = histcounts(ye_post,edges);
[nm_post, Em] = histcounts(ym_post,edges); [n0_post, E0] = histcounts(y0_post,edges); 


% plot the relative fraction of PC versus the position, pre
[k1, p2] = kstest2(ya_pre, ye_pre)
figure;
stairs((na_pre./n0_pre), 'b'); hold on; % allo
stairs((ne_pre./n0_pre), 'r'); hold on; % ego
yline(0.18, '--k'); 
title([groupNameLabelPool{i_group}, ', ', outputPValue(p2), ', day: ', dayLabel{i_mouseDay}]); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-0.02 1.02]); xlim([-0.5 25.5]); yticks(0:0.25:1); xticks([1 7 13 19 25]); xticklabels({'0', '','90','', '180'})
ylabel('Proportion of PCs')
legend('Allo', 'Ego'); legend('boxoff')

Fig1g_Space = (na_pre./n0_pre);
Fig1g_Goal = (ne_pre./n0_pre);
Fig1g_binValue = edges(1:end-1);
Fig1g_summary = [Fig1g_Space; nan(2, size(Fig1g_Space,2)); Fig1g_Goal; nan(2, size(Fig1g_Space,2)); Fig1g_binValue]


% plot the PC number, Allo, pre vs post;
% Fig. 1h, Fig.1h
colorM = cbrewer('qual', 'Set1', 9);
figure;
plot(Ea(1:end-1), na_pre, 'Color', 'k'); hold on; % allo, pre
plot(Ea(1:end-1), na_post, 'Color', 'r'); hold on; % allo, post
title([groupNameLabelPool{i_group},  ', day: ', dayLabel{i_mouseDay}, 'allo pre vs post']); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-1 40]); xlim([-0.5 50.5]); yticks(0:10:40); xticks([1 13 25 38 50]); xticklabels({'0', '','90','', '180'})
ylabel('PC number')
legend('Allo-Pre', 'Allo-Post'); legend('boxoff')

Fig1d_PCcount_space_pre = na_pre;
Fig1d_PCcount_space_post = na_post;
Fig1d_PCcount_space_binValue = Ea(1:end-1)
Fig1d_PCcount_space_summary = [Fig1d_PCcount_space_pre; nan(2, size(ne_pre, 2)); Fig1d_PCcount_space_post; nan(2, size(ne_pre, 2)); Fig1d_PCcount_space_binValue]


%% Extended Data Fig.4; Extended Data Fig. 4; Extended Data 4;
colorM = cbrewer('qual', 'Set1', 9);
figure;
plot(Em(1:end-1), nm_pre, 'Color', 'k'); hold on; % allo, pre
plot(Em(1:end-1), nm_post, 'Color', 'r'); hold on; % allo, post
title([groupNameLabelPool{i_group},  ', day: ', dayLabel{i_mouseDay}, ', Mix pre vs post']); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-1 40]); xlim([-0.5 50.5]); yticks(0:10:40); xticks([1 13 25 38 50]); xticklabels({'0', '','90','', '180'})
ylabel('PC number')
legend('Mix-Pre', 'Mix-Post'); legend('boxoff')

ExtendedFig3b_PCcount_inter_pre = nm_pre;
ExtendedFig3b_PCcount_inter_post = nm_post;
ExtendedFig3b_PCcount_inter_binValue = Em(1:end-1)
ExtendedFig3b_PCcount_inter_summary = [ExtendedFig3b_PCcount_inter_pre; nan(2, size(ne_pre, 2)); ExtendedFig3b_PCcount_inter_post; nan(2, size(ne_pre, 2)); ExtendedFig3b_PCcount_inter_binValue]


% plot the PC number, Ego, pre vs post;
colorM = cbrewer('qual', 'Set1', 9);
figure;
plot(Ee(1:end-1), ne_pre, 'Color', 'k'); hold on; % allo, pre
plot(Ee(1:end-1), ne_post, 'Color', 'r'); hold on; % allo, post
title([groupNameLabelPool{i_group},  ', day: ', dayLabel{i_mouseDay}, 'Ego, pre vs post']); 
axis square; set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; 
ylim([-1 40]); xlim([-0.5 50.5]); yticks(0:10:40); xticks([1 13 25 38 50]); xticklabels({'0', '','90','', '180'})
ylabel('PC number')
legend('Ego-Pre', 'Ego-Post'); legend('boxoff')

Fig1d_PCcount_goal_pre = ne_pre;
Fig1d_PCcount_goal_post = ne_post;
Fig1d_PCcount_goal_binValue = Ee(1:end-1)
Fig1d_PCcount_goal_summary = [Fig1d_PCcount_goal_pre; nan(2, size(ne_pre, 2)); Fig1d_PCcount_goal_post; nan(2, size(ne_pre, 2)); Fig1d_PCcount_goal_binValue]


%% spatial distribution of place field (adding confidence interval)
% test: compared to random remap model, allo+ego vs random; mix vs random
% first allo+ego vs random
% for efficiency: keep only the dual-track PC peak position vector,
% transfer the global isAllo isEgo index into local index
%% Fig1h
i_mouseDay = 4; j_mouseDay = i_mouseDay
i_map = 1; j_map = 2;
i_group = 3
% global index, applied to all Cell
idx0 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});
% global to local index
y0 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx0); % allo+ego
isAllo_local = idx1(idx0);
isEgo_local = idx2(idx0);
isAOE_local = isAllo_local | isEgo_local;
isMix_local = idx3(idx0);
% get data place field
y0_Allo_data = y0(isAllo_local);
y0_Ego_data = y0(isEgo_local);
y0_AOE_data = y0(isAOE_local);
y0_Mix_data = y0(isMix_local);
% get place field count for different types
binSize = 2
edges = 1:binSize:51; % binning rule
[N0, E] = histcounts(y0,edges);
[N0_Allo_data, E] = histcounts(y0_Allo_data,edges);
[N0_Ego_data, E] = histcounts(y0_Ego_data,edges);
[N0_AOE_data, E] = histcounts(y0_AOE_data,edges);
[N0_Mix_data, E] = histcounts(y0_Mix_data,edges);
% calculate ratio of PC within each local bins
R0_Allo_data = N0_Allo_data ./ N0;
R0_Ego_data = N0_Ego_data ./ N0;
R0_AOE_data = N0_AOE_data ./ N0;
R0_Mix_data = N0_Mix_data ./ N0;
% shuffle to get confidence interval
shuffleNum = 10000;
n = length(y0);
spaDivNum = 50;
threshold = 4; % spatial bins, used to define allo and ego
R0_Allo_rand = nan(length(N0), shuffleNum);
R0_Ego_rand = nan(length(N0), shuffleNum);
R0_AOE_rand = nan(length(N0), shuffleNum);
R0_Mix_rand = nan(length(N0), shuffleNum);

rng('default')
for i_shuffle = 1:shuffleNum
   y_rand = randi(spaDivNum, n, 1);
   y_delta = abs(fieldPositionChange(spaDivNum, y0, y_rand));
   
   isAlloIdx = (y_delta <= threshold);
   isEgoIdx = (y_delta >= (spaDivNum/2-threshold));
   isAOEIdx = (y_delta <= threshold) | (y_delta >= (spaDivNum/2-threshold));
   
   y0_Allo_rand = y0(isAlloIdx);
   y0_Ego_rand = y0(isEgoIdx);
   y0_AOE_rand = y0(isAOEIdx);
   y0_Mix_rand = y0(~isAOEIdx);
   
   [N0_Allo_rand, E] = histcounts(y0_Allo_rand,edges);
   [N0_Ego_rand, E] = histcounts(y0_Ego_rand,edges);
   [N0_AOE_rand, E] = histcounts(y0_AOE_rand,edges);
   [N0_Mix_rand, E] = histcounts(y0_Mix_rand,edges);
   
   R0_Allo_rand(:, i_shuffle) = N0_Allo_rand./N0;
   R0_Ego_rand(:, i_shuffle) = N0_Ego_rand./N0;
   R0_AOE_rand(:, i_shuffle) = N0_AOE_rand./N0;
   R0_Mix_rand(:, i_shuffle) = N0_Mix_rand./N0;
end



%% plot A-E Bias, Allo-Ego bias versus location
% entire environment
% % % figure;
% % % y = R0_Allo_data % ./ (R0_Allo_data + R0_Ego_data)
% % % plot(y, 'k'); hold on; % ego+allo
% % % 
% % % % focus on two zones with same cues uniforming covering each zone
% % % colorMap = cbrewer('qual', 'Set1', 9)
% % % idx = 22:39
% % % figure;subplot(1,2,1)
% % % scatter(idx, y(idx), 'filled', 'MarkerEdgeColor','w', 'MarkerFaceColor', colorMap(2,:)); hold on;
% % % mdl = fitlm(idx, y(idx))
% % % plot(idx, idx .* mdl.Coefficients.Estimate(2) + mdl.Coefficients.Estimate(1), 'k')
% % % axis square;set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; xticks()
% % % xlim([1 50])
% % % 
% % % idx = 5:22
% % % subplot(1,2,2)
% % % scatter(idx, y(idx), 'filled', 'MarkerEdgeColor','w', 'MarkerFaceColor', colorMap(1,:)); hold on;
% % % mdl = fitlm(idx, y(idx))
% % % plot(idx, idx .* mdl.Coefficients.Estimate(2) + mdl.Coefficients.Estimate(1), 'k')
% % % axis square
% % % xlim([1 50])

% % % % same result, on the same plot
% % % colorMap = cbrewer('qual', 'Set1', 9)
% % % idx = 22:39 % cue 2
% % % figure;
% % % scatter(idx, y(idx), 200, 'filled', 'MarkerEdgeColor','w', 'MarkerFaceColor', colorMap(2,:)); hold on;
% % % mdl1 = fitlm(idx, y(idx))
% % % plot(idx, idx .* mdl1.Coefficients.Estimate(2) + mdl1.Coefficients.Estimate(1), 'k')
% % % xlim([1 50])
% % % 
% % % idx = 5:22 % cue 1
% % % scatter(idx, y(idx), 200, 'filled', 'MarkerEdgeColor','w', 'MarkerFaceColor', colorMap(1,:)); hold on;
% % % mdl2 = fitlm(idx, y(idx))
% % % plot(idx, idx .* mdl2.Coefficients.Estimate(2) + mdl2.Coefficients.Estimate(1), 'k')
% % % axis square;set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; yticks(0:0.25:1)
% % % xlim([-1 52]); xticks([1 25 50]); xticklabels({'0', '90', '180'});
% % % xlabel('Position (cm)'); ylabel('Fraction of Allo PCs'); ylim([-0.04 1.04])
% % % title([groupNameLabelPool{i_group}, ', day:', dayLabel{i_mouseDay}])
% % % 

% correlation for 15-50-1-14 (episodic, between reward site experience)
colorMap = cbrewer('qual', 'Set1', 9)
%% Fig1h
y = R0_Ego_data ./ (R0_Allo_data + R0_Ego_data)
totalNumPC_binned = (R0_Allo_data + R0_Ego_data);
weights = totalNumPC_binned ./ sum(totalNumPC_binned, 'omitnan');
if binSize == 2
    binS = 7
elseif binSize == 5
    binS = 4
elseif binSize == 1
    binS = 15
end
y_realign = [y(binS+1:end), y(1:binS)]; % reference to reward location
weights_realign = [weights(binS+1:end), weights(1:binS)]; 
figure;
idx = 1:50/binSize % entire r
scatter(idx, y_realign(idx), 500, 'filled', 'MarkerEdgeColor','w', 'MarkerFaceColor', colorMap(1,:)); hold on;
mdl3 = fitlm(idx, y_realign(idx), 'Weights', weights_realign)
plot(idx, idx .* mdl3.Coefficients.Estimate(2) + mdl3.Coefficients.Estimate(1), 'k')
axis square;set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; yticks(0:0.25:1)
xlim([0 26]); xticks([1 13 25]); xticklabels({'0', '90', '180'});
xlabel('Position after reward (cm)'); ylabel('Ego/(Ego+Allo)'); ylim([-0.04 1.04])
title([groupNameLabelPool{i_group}, ', day:', dayLabel{i_mouseDay}])

Fig1h_ratio = y_realign(idx);
Fig1h_binValue = idx;
Fig1h_weights = weights_realign;
Fig1h_summary = [Fig1h_ratio; Fig1h_binValue; Fig1h_weights]


% PF distribution, day -1, compare aAAA vs aBBB
i_group = 3; j_group = 2;
i_map = 1; i_mouseDay = 3
figure;
h1 = histogram(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, i_map})), 'BinLimit', [1 50], 'BinWidth', 1, 'Normalization', 'probability','DisplayStyle','stairs'); hold on;
h2 = histogram(MAP{j_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, i_map})), 'BinLimit', [1 50], 'BinWidth', 1, 'Normalization', 'probability','DisplayStyle','stairs'); hold on;
h1.EdgeColor = 'k'; h1.EdgeAlpha = 1;
h2.EdgeColor = 'r'; h2.EdgeAlpha = 1;
xline(14.1, '--b')
xticks([1 25 50]); xticklabels({'0', '90', '180'});set(gca, 'TickDir', 'out'); box off;yticks([0:0.02:1]);
[h, p] = kstest2(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, i_map})), ...
    MAP{j_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{i_mouseDay, i_mouseDay, i_map})))

%% reliability, selectivity, onset speed, space vs goal vs intermediate PCs
%% Extended Data
% reliability comparison, day+1, aAAA: space vs reward PCs
% familiar belt
%% Extended Fig2g; Extended Fig2h
for i_group = 2:3
    i_map = 1; j_map = 2;
    i_mouseDay = 4
    
    x0 = MAP{i_group}.map(i_map).firstLapFieldReliability_allMice{i_mouseDay,1};
    idx1 = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, i_mouseDay, j_map});
    idx2 = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, i_mouseDay, j_map});
    idx3 = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, i_mouseDay, j_map});
    x1 = x0(idx1); x2 = x0(idx2); x3 = x0(idx3);
    
    [~, p1] = ttest2(x1, x2)
    [~, p1] = ttest2(x1, x3)
    [~, p1] = ttest2(x2, x3)
    
    mean(x1)
    std(x1)/sqrt(length(x1))
    mean(x2)
    std(x2)/sqrt(length(x2))
    mean(x3)
    std(x3)/sqrt(length(x3))
    
    %% aAAA
    figure;
    % space-referenced PCs
    markersize = 10;
    i = 1;
    n = length(x1)
    er = errorbar(i-jitter/0.618, mean(x1), std(x1)/sqrt(n), 'o', 'LineWidth', 1, 'CapSize', markersize, 'MarkerSize', markersize, 'Color', colorM(2, :), 'MarkerEdgeColor', colorM(2, :),'MarkerFaceColor', colorM(2, :)); hold on;
    scatter((i+0.25*(rand(n,1)-0.5)), x1, 300, 'filled', 'MarkerFaceColor', colorM(2, :),  'MarkerEdgeColor', colorM(2, :), 'MarkerFaceAlpha', 0.5); hold on;
    
    % goal-referenced PCs
    i = 3;
    n = length(x2)
    er = errorbar(i-jitter/0.618, mean(x2), std(x2)/sqrt(n), 'o', 'LineWidth', 1, 'CapSize', markersize, 'MarkerSize',  markersize, 'Color', colorM(1, :), 'MarkerEdgeColor', colorM(1, :),'MarkerFaceColor', colorM(1, :)); hold on;
    scatter((i+jitter*(rand(n,1)-0.5)), x2, 300, 'filled','MarkerFaceColor', colorM(1, :), 'MarkerEdgeColor', colorM(1, :), 'MarkerFaceAlpha', 0.5); hold on
    
    % intermediate PCs
    i = 5;
    n = length(x3)
    er = errorbar(i-jitter/0.618, mean(x3), std(x3)/sqrt(n), 'o', 'LineWidth', 1, 'CapSize', markersize, 'MarkerSize', markersize, 'Color', colorM(9, :), 'MarkerEdgeColor', colorM(9, :),'MarkerFaceColor', colorM(9, :)); hold on;
    h = scatter((i+jitter*(rand(n,1)-0.5)), x3, 300, 'filled', 'MarkerFaceColor', colorM(9, :), 'MarkerEdgeColor', colorM(9, :), 'MarkerFaceAlpha', 0.5); hold on
    
    xlim([-0.5 5.7]); ylim([0 1.01]); pbaspect([0.618 1 1]);
    set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
    xticks([(2 - jitter/0.618), (6 - jitter/0.618), (10 - jitter/0.618)]/2);
    xticklabels({'Space', 'Goal', 'Inter'})
    yticks(0:0.25:1);
    ylabel('PF Reliability')
    title(groupNameLabelPool{i_group})
    
    if i_group == 2
        ExtendedFig2g_novel_spacePC = x1;
        ExtendedFig2g_novel_goalPC = x2;
        ExtendedFig2g_novel_interPC = x3;
    elseif i_group == 3
        ExtendedFig2g_familiar_spacePC = x1;
        ExtendedFig2g_familiar_goalPC = x2;
        ExtendedFig2g_familiar_interPC = x3;
    end
    
    
    
    % figure;
    % n1 = length(y1); a1 = 1+0.1*(rand(n1,1)-0.5); scatter(a1, y1); xlim([0 4]); hold on;
    % n2 = length(y2); a2 = 2+0.1*(rand(n2,1)-0.5);scatter(a2, y2); xlim([0 4])
    
    
    % onset lap comparison, day+1, aAAA: space vs reward PCs
% % %     figure;
% % %     x0 = MAP{i_group}.map(i_map).onsetLapIdx_allMice{i_mouseDay,1};
% % %     x1 = x0(idx1); x2 = x0(idx2); x3 = x0(idx3);
% % %     [N1, E] = histcounts(x1, 'BinLimit', [0 100], 'BinWidth', 1, 'Normalization', 'cdf'); hold on;
% % %     [N2, E] = histcounts(x2, 'BinLimit', [0 100], 'BinWidth', 1, 'Normalization', 'cdf'); hold on;
% % %     [N3, E] = histcounts(x3, 'BinLimit', [0 100], 'BinWidth', 1, 'Normalization', 'cdf'); hold on;
% % %     stairs(E(2:end), N1, 'b'); hold on; stairs(E(2:end), N2, 'r'); hold on;stairs(E(2:end), N3, 'k'); hold on;
% % %     xticks([1 25 50 75 100]); set(gca, 'TickDir', 'out'); box off;
% % %     yticks(0:0.25:1); ylim([0 1]);
% % %     pbaspect([1 1 1]); % make the plot square
% % %     [h, p] = kstest2(x1, x2)
% % %     [h, p] = kstest2(x1, x3)
% % %     [h, p] = kstest2(x2, x3)
% % %     
    
    % selectivity comparison, day 1, aAAA, spave vs reward pc
    s0 = MAP{i_group}.map(i_map).eachCellSpaInf_allMice{i_mouseDay,1};
    s1 = s0(idx1); s2 = s0(idx2); s3 = s0(idx3);
    
    [~, p1] = ttest2(s1, s2)
    [~, p2] = ttest2(s1, s3)
    [~, p3] = ttest2(s2, s3)
    
    mean(s1)
    std(s1)/sqrt(length(s1))
    mean(s2)
    std(s2)/sqrt(length(s2))
    mean(s3)
    std(s3)/sqrt(length(s3))
    %% aAAA
    figure;
    % space-referenced PCs
    markersize = 10;
    i = 1;
    n = length(s1)
    er = errorbar(i-jitter/0.618, mean(s1), std(s1)/sqrt(n), 'o', 'LineWidth', 1, 'CapSize', markersize, 'MarkerSize', markersize, 'Color', colorM(2, :), 'MarkerEdgeColor', colorM(2, :),'MarkerFaceColor', colorM(2, :)); hold on;
    scatter((i+0.25*(rand(n,1)-0.5)), s1, 300, 'filled', 'MarkerFaceColor', colorM(2, :),  'MarkerEdgeColor', colorM(2, :), 'MarkerFaceAlpha', 0.5); hold on;
    
    % goal-referenced PCs
    i = 3;
    n = length(s2)
    er = errorbar(i-jitter/0.618, mean(s2), std(s2)/sqrt(n), 'o', 'LineWidth', 1, 'CapSize', markersize, 'MarkerSize',  markersize, 'Color', colorM(1, :), 'MarkerEdgeColor', colorM(1, :),'MarkerFaceColor', colorM(1, :)); hold on;
    scatter((i+jitter*(rand(n,1)-0.5)), s2, 300, 'filled','MarkerFaceColor', colorM(1, :), 'MarkerEdgeColor', colorM(1, :), 'MarkerFaceAlpha', 0.5); hold on
    
    % intermediate PCs
    i = 5;
    n = length(s3)
    er = errorbar(i-jitter/0.618, mean(s3), std(s3)/sqrt(n), 'o', 'LineWidth', 1, 'CapSize', markersize, 'MarkerSize', markersize, 'Color', colorM(9, :), 'MarkerEdgeColor', colorM(9, :),'MarkerFaceColor', colorM(9, :)); hold on;
    h = scatter((i+jitter*(rand(n,1)-0.5)), s3, 300, 'filled', 'MarkerFaceColor', colorM(9, :), 'MarkerEdgeColor', colorM(9, :), 'MarkerFaceAlpha', 0.5); hold on
    
    xlim([-0.5 5.7]); ylim([-0.05 1.51]); pbaspect([0.618 1 1]);
    set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
    xticks([(2 - jitter/0.618), (6 - jitter/0.618), (10 - jitter/0.618)]/2);
    xticklabels({'Space', 'Goal', 'Inter'})
    yticks(0:0.25:1.5);
    ylabel('Spatial information')
    title(groupNameLabelPool{i_group})
    
    
    if i_group == 2
        ExtendedFig2h_novel_spacePC = s1;
        ExtendedFig2h_novel_goalPC = s2;
        ExtendedFig2h_novel_interPC = s3;
    elseif i_group == 3
        ExtendedFig2h_familiar_spacePC = s1;
        ExtendedFig2h_familiar_goalPC = s2;
        ExtendedFig2h_familiar_interPC = s3;
    end
    
end

% fraction of PCs comparison


% % % % slowing correlation index
% % % figure;
% % % for i_trial = 200:220
% % %     plot(MAP{3}.map(1).eachSpaDivSpeed_allMice{4,1}(:, i_trial) + i_trial*0.3, 'k'); hold on
% % % end


% % % %% HartigansDipTest, binormality test
% % % i_group = 2
% % % i_map = 1; j_map = 2;
% % % i_mouseDay = 4; j_mouseDay = 4;
% % % idx = MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map};
% % % figure; histogram((abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(idx)))))
% % % [dip, p_value, xlow,xup] = HartigansDipSignifTest((abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(idx)))), 10000);
% % % p_value



%% fraction of recorded cells are PC
% Fraction, 
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
i_mouseDay = 4; j_mouseDay = 4;
x = {}
y = {}
for i_group = 2:3
    i_map = 1; j_map = 2;
    x{i_group} = nan(length(mouseGroupIdx{i_group}), 1);
    y{i_group} = nan(length(mouseGroupIdx{i_group}), 1);
    for i = 1:length(mouseGroupIdx{i_group})
        i_mouse = mouseGroupIdx{i_group}(i);
        if i_mouseDay <= 3
            %         x(i) = meta_data{i_mouse, i_mouseDay}.numPlaceCell;
            x{i_group}(i) = meta_data{i_mouse, i_mouseDay}.numStablePCell;
            y{i_group}(i) = meta_data{i_mouse, i_mouseDay}.cellNum;
        else
            %         x(i) = meta_data{i_mouse, i_mouseDay}.map(i_map).numPlaceCell;
            x{i_group}(i) = meta_data{i_mouse, i_mouseDay}.map(i_map).numStablePCell;
            y{i_group}(i) = meta_data{i_mouse, i_mouseDay}.cellNum;
        end
    end
    
    mean(x{i_group})
    std(x{i_group})/sqrt(length(x{i_group}))
    
    mean(x{i_group} ./ y{i_group})
    std(x{i_group} ./ y{i_group})/ sqrt(length(x{i_group}))
end
i_group = 2; j_group = 3
[h,p] = ttest2(x{i_group} ./ y{i_group}, x{j_group} ./ y{j_group})

%% scatter plot of allo-vs-ego pc for aA(aAAA+aABB), day 1
% fraction of allocentric PCs anti-correlates with egocentric PCs
% Competitive, competitive
%% Extended Fig3g
i_mouseDay = 4; j_mouseDay = 4;
i_map = 1; j_map = 2;
figure;
idx = [2 3];
colorMap = cbrewer('qual', 'Set1', 9);
colorMapIdx = [1 2 4]
x = [];
y = [];
for i = 1:length(idx)
    i_group = idx(i)
    scatter(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice,...
        MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice, ...
        500, 'filled', 'MarkerEdgeColor', 'w', 'MarkerFaceColor', colorMap(colorMapIdx(i), :)); 
    hold on;
    x = [x; MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice];
    y = [y; MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice];
end
xlim([0 0.8]); ylim([0 0.8]);
xticks(0:0.2:0.8); 
yticks(0:0.2:0.8); 
pbaspect([1 1 1]); set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xlabel('Fraction of allo-PCs')
ylabel('Fraction of ego-PCs');
title('Competitive formation of allo-vs-ego PC')
mdl = fitlm(x,y)
a0 = mdl.Coefficients.Estimate(2);
c = mdl.Coefficients.Estimate(1);
y_fit = a0 .* x + c;
plot(x, y_fit, 'k')

ExtendedFig3g_spaceFraction = x;
ExtendedFig3g_goalFraction = y;
ExtendedFig3g_summary = [x,y]


% only familiar belt
%% Extended Fig3e
figure;
idx = [3];
colorMap = cbrewer('qual', 'Set1', 9);
colorMapIdx = [2]
x = [];
y = [];
for i = 1:length(idx)
    i_group = idx(i)
    scatter(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice,...
        MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice, ...
        500, 'filled', 'MarkerEdgeColor', 'w', 'MarkerFaceColor', colorMap(colorMapIdx(i), :)); 
    hold on;
    x = [x; MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice];
    y = [y; MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice];
end
xlim([0 0.8]); ylim([0 0.8]);
xticks(0:0.2:0.8); 
yticks(0:0.2:0.8); 
pbaspect([1 1 1]); set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xlabel('Fraction of allo-PCs')
ylabel('Fraction of ego-PCs');
title('Competitive formation of allo-vs-ego PC')
mdl = fitlm(x,y)
a0 = mdl.Coefficients.Estimate(2);
c = mdl.Coefficients.Estimate(1);
y_fit = a0 .* x + c;
plot(x, y_fit, 'k')

ExtendedFig3e_spaceFraction = x;
ExtendedFig3e_goalFraction = y;
ExtendedFig3e_summary = [x,y]

%% mix PC from familiar vs novel environment
%% Extended Data Fig3f
i_mouseDay = 4; j_mouseDay = 4;
i_map = 1; j_map = 2;
x1 = MAP{3}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice;
x2 = MAP{2}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice;

colorM = cbrewer('qual', 'Set1', 9)
jitter = 0.5
figure;
% familiar environment
i = 1;
n = length(x1)
% h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
er = errorbar(i-jitter/0.618, mean(x1), std(x1)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 10, 'Color', 'k', 'MarkerEdgeColor', 'k','MarkerFaceColor', 'k'); hold on;
scatter((i+0.25*(rand(n,1)-0.5)), x1, 300, 'filled', 'MarkerFaceColor', colorM(9, :), 'MarkerFaceAlpha', 0.75, 'MarkerEdgeColor', colorM(9, :)); hold on;
% novel environment
i = 2.5;
n = length(x2)
er = errorbar(i+jitter/0.618, mean(x2), std(x2)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 10, 'Color', 'k', 'MarkerEdgeColor', 'k','MarkerFaceColor', 'k'); hold on;
scatter((i+jitter*(rand(n,1)-0.5)), x2, 300, 'filled','MarkerFaceColor', colorM(9, :), 'MarkerFaceAlpha', 0.75,'MarkerEdgeColor', colorM(9, :)); hold on



xlim([-0.5 4.25]); ylim([0 0.8]); pbaspect([1 1 1]);
set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([(2 - jitter/0.618), (5 + jitter/0.618)]/2) 
xticklabels({'Familiar', 'Novel'})
yticks(0:0.2:0.8);
ylabel('Fraction of PCs')
title('aAAA')
[h,p1] = ttest(x1, x2)
title(outputPValue(p1))

ExtendedFig3f_interFraction_familiar = x1;
ExtendedFig3f_interFraction_novel = x2;
ExtendedFig3f_summary = [x1, x2]




% allo+ego a constant?
%% no need for a fit here
figure;
idx = [2 3];
colorMap = cbrewer('qual', 'Set1', 9);
colorMapIdx = [1 2 4]
x = [];
y = [];
for i = 1:length(idx)
    i_group = idx(i)
    scatter(MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice,...
        MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice, ...
        500, 'filled', 'MarkerEdgeColor', 'w', 'MarkerFaceColor', colorMap(colorMapIdx(i), :)); 
    hold on;
    x = [x; MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice];
    y = [y; MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice];
 
end
xlim([0 0.8]); ylim([0 0.8]);
xticks(0:0.2:0.8); 
yticks(0:0.2:0.8); 
xlabel('Fraction of allo-PCs')
ylabel('Fraction of mix-PCs');
title('Relationship between allo and mix-PC')
pbaspect([1 1 1]);set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
mdl = fitlm(x,y)
a0 = mdl.Coefficients.Estimate(2);
c = mdl.Coefficients.Estimate(1);
y_fit = a0 .* x + c;
plot(x, y_fit, 'k')
% mdl = fitlm(x(7:end),y(7:end))
% a0 = mdl.Coefficients.Estimate(2);
% c = mdl.Coefficients.Estimate(1);
% y_fit = a0 .* x(7:end) + c;
% plot(x(7:end), y_fit, 'k')


% mean and std of these numbers
i_group = 3 % aAAA
i_mouseDay = 4; j_mouseDay = 4;
i_map = 1; j_map = 2;

x1 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice
x2 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice
x3 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice
mean(x1)
std(x1)/sqrt(length(x1))
mean(x2)
std(x2)/sqrt(length(x2))
mean(x3)
std(x3)/sqrt(length(x3))

i_group = 2 % aBBB
i_mouseDay = 4; j_mouseDay = 4;
i_map = 1; j_map = 2;

y1 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.spacePC_ratio_allMice;
y2 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice;
y3 = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.mixPC_ratio_allMice;
mean(y1)
std(y1)/sqrt(length(y1))
mean(y2)
std(y2)/sqrt(length(y2))
mean(y3)
std(y3)/sqrt(length(y3))


%% plot the data points from individual mice
%% Extended Fig2f
colorM = cbrewer('qual', 'Set1', 9)
jitter = 0.5

%% aAAA, Extended Fig2f, familiar

figure;
% space-referenced PCs
i = 1;
n = length(x1)
% h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
er = errorbar(i-jitter/0.618, mean(x1), std(x1)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 10, 'Color', colorM(2, :), 'MarkerEdgeColor', colorM(2, :),'MarkerFaceColor', colorM(2, :)); hold on;
scatter((i+0.25*(rand(n,1)-0.5)), x1, 300, 'filled', 'MarkerFaceColor', colorM(2, :), 'MarkerFaceAlpha', 0.75, 'MarkerEdgeColor', colorM(2, :)); hold on;

% goal-referenced PCs
i = 2.5;
n = length(x2)
er = errorbar(i-jitter/0.618, mean(x2), std(x2)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 10, 'Color', colorM(1, :), 'MarkerEdgeColor', colorM(1, :),'MarkerFaceColor', colorM(1, :)); hold on;
scatter((i+jitter*(rand(n,1)-0.5)), x2, 300, 'filled','MarkerFaceColor', colorM(1, :), 'MarkerFaceAlpha', 0.75,'MarkerEdgeColor', colorM(1, :)); hold on

% intermediate PCs
i = 4;
n = length(x3)
er = errorbar(i-jitter/0.618, mean(x3), std(x3)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 10, 'Color', colorM(9, :), 'MarkerEdgeColor', colorM(9, :),'MarkerFaceColor', colorM(9, :)); hold on;
scatter((i+jitter*(rand(n,1)-0.5)), x3, 300, 'filled', 'MarkerFaceColor', colorM(9, :), 'MarkerFaceAlpha', 0.75,'MarkerEdgeColor', colorM(9, :)); hold on


xlim([-0.25 4.75]); ylim([0 0.8]); pbaspect([0.5 1 1]);
set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([(2 - jitter/0.618), (5 - jitter/0.618), (8 - jitter/0.618)]/2); 
xticklabels({'Space', 'Goal', 'Inter'})
yticks(0:0.2:0.8);
ylabel('Fraction of PCs')
title('aAAA')
[h,p1] = ttest(x1, x2)

ExtendedFig2f_familiar_spacePC = x1;
ExtendedFig2f_familiar_goalPC = x2;
ExtendedFig2f_familiar_interPC = x3;
ExtendedFig2f_familiar_summary = [x1,x2,x3]

%% aBBB, Extended Fig2f, novel

% space-referenced PCs
figure;
i = 1;
n = length(y1)
% h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
er = errorbar(i-jitter/0.618, mean(y1), std(y1)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 5, 'Color', colorM(2, :), 'MarkerEdgeColor', colorM(2, :),'MarkerFaceColor', colorM(2, :)); hold on;
scatter((i+0.25*(rand(n,1)-0.5)), y1, 300, 'filled', 'MarkerFaceColor', colorM(2, :),  'MarkerFaceAlpha', 0.75,'MarkerEdgeColor', colorM(2, :)); hold on;

% goal-referenced PCs
i = 2.5;
n = length(y2)
er = errorbar(i-jitter/0.618, mean(y2), std(y2)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize', 5, 'Color', colorM(1, :), 'MarkerEdgeColor', colorM(1, :),'MarkerFaceColor', colorM(1, :)); hold on;
scatter((i+jitter*(rand(n,1)-0.5)), y2, 300, 'filled','MarkerFaceColor', colorM(1, :), 'MarkerFaceAlpha', 0.75,'MarkerEdgeColor', colorM(1, :)); hold on

% intermediate PCs
i = 4;
n = length(y3)
er = errorbar(i-jitter/0.618, mean(y3), std(y3)/sqrt(n), 'o', 'LineWidth', 1, 'MarkerSize',5, 'Color', colorM(9, :), 'MarkerEdgeColor', colorM(9, :),'MarkerFaceColor', colorM(9, :)); hold on;
scatter((i+jitter*(rand(n,1)-0.5)), y3, 300, 'filled', 'MarkerFaceColor', colorM(9, :), 'MarkerFaceAlpha', 0.75, 'MarkerEdgeColor', colorM(9, :)); hold on


xlim([-0.25 4.75]); ylim([0 0.8]); pbaspect([0.5 1 1]);
set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([(2 - jitter/0.618), (5 - jitter/0.618), (8 - jitter/0.618)]/2); 
xticklabels({'Space', 'Goal', 'Inter'})
yticks(0:0.2:0.8);
ylabel('Fraction of PCs')
title('aBBB')
[h,p2] = ttest(y1, y2)

ExtendedFig2f_novel_spacePC = y1;
ExtendedFig2f_novel_goalPC = y2;
ExtendedFig2f_novel_interPC = y3;
ExtendedFig2f_novel_summary = [y1,y2,y3]

%% number of place cells, day 0
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

i_mouseDay = 3;
i_map = 1; j_map = 2;
x = {}
for i_group = 2:3
    n = length(mouseGroupIdx{i_group});
    x{i_group,1} = nan(n,1)
    for i = 1:n
        i_mouse = mouseGroupIdx{i_group}(i)
        x{i_group,1}(i) = sum(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, i_map});
    end
    mean(x{i_group,1})
    std(x{i_group,1})/(n-1)
end


%% A-E bias, allo-ego ratio, day 1, aAAA versus aBBB
i_group = 3; 
y1 = MAP{i_group}.pcStats{4,4,1,2}.spacePC_num_allMice ./ (MAP{i_group}.pcStats{4,4,1,2}.spacePC_num_allMice + MAP{i_group}.pcStats{4,4,1,2}.rewardPC_num_allMice)
% y1 = MAP{i_group}.pcStats{4,4,1,2}.spacePC_ratio_allMice

i_group = 2; 
y2 = MAP{i_group}.pcStats{4,4,1,2}.spacePC_num_allMice ./ (MAP{i_group}.pcStats{4,4,1,2}.spacePC_num_allMice + MAP{i_group}.pcStats{4,4,1,2}.rewardPC_num_allMice)
% y2 = MAP{i_group}.pcStats{4,4,1,2}.spacePC_ratio_allMice

[h0,p1] = ttest2(y1,y2)
figure;
i = 1;
n = length(y1)
% h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
er = errorbar(i-0.5, mean(y1), std(y1)/sqrt(n), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;
scatter((i+0.1*(rand(n,1)-0.5)), y1, 200,  'MarkerFaceColor', 'w',  'MarkerEdgeColor', 'k'); hold on;

i = 2;
n = length(y2)
er = errorbar(i+0.5, mean(y2), std(y2)/sqrt(n), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'r', 'MarkerEdgeColor','r','MarkerFaceColor','r'); hold on;
scatter((i+0.2*(rand(n,1)-0.5)), y2, 200, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r'); hold on

xlim([0 3]); ylim([0 1]); pbaspect([0.5 1 1]);
set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks(''); yticks(0:0.25:1);
ylabel('A-E bias');
title(outputPValue(p1))

%% A-E bias, allo-ego ratio, day 1 versus day 2 aAAA versus aABB
%% Extended Fig8b
i_group = 3; 
i_mouseDay = 4
x1 = MAP{i_group}.pcStats{i_mouseDay,i_mouseDay,1,2}.spacePC_num_allMice ./ (MAP{i_group}.pcStats{i_mouseDay,i_mouseDay,1,2}.spacePC_num_allMice + MAP{i_group}.pcStats{i_mouseDay,i_mouseDay,1,2}.rewardPC_num_allMice)
j_mouseDay = 5
x2 = MAP{i_group}.pcStats{j_mouseDay,j_mouseDay,1,2}.spacePC_num_allMice ./ (MAP{i_group}.pcStats{j_mouseDay,j_mouseDay,1,2}.spacePC_num_allMice + MAP{i_group}.pcStats{j_mouseDay,j_mouseDay,1,2}.rewardPC_num_allMice)

i_group = 4; 
i_mouseDay = 4
y1 = MAP{i_group}.pcStats{i_mouseDay,i_mouseDay,1,2}.spacePC_num_allMice ./ (MAP{i_group}.pcStats{i_mouseDay,i_mouseDay,1,2}.spacePC_num_allMice + MAP{i_group}.pcStats{i_mouseDay,i_mouseDay,1,2}.rewardPC_num_allMice)
j_mouseDay = 5
y2 = MAP{i_group}.pcStats{j_mouseDay,j_mouseDay,1,2}.spacePC_num_allMice ./ (MAP{i_group}.pcStats{j_mouseDay,j_mouseDay,1,2}.spacePC_num_allMice + MAP{i_group}.pcStats{j_mouseDay,j_mouseDay,1,2}.rewardPC_num_allMice)

[h0,p1] = ttest(x1,x2) % paried t test within the same animal
figure;
i1 = 1;
n = length(x1)
% h1 = bar(i, mean(y1)); h1.FaceColor = 'k', h1.FaceAlpha=0.2; h1.EdgeColor = 'w'; hold on;
er = errorbar(i1-0.5, mean(x1), std(x1)/sqrt(n), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;

i2 = 2;
n = length(x2)
% h2 = bar(i, mean(y2)); h2.FaceColor = 'r', h2.FaceAlpha=0.2; h2.EdgeColor = 'w'; hold on;
er = errorbar(i2+0.5, mean(x2), std(x2)/sqrt(n), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;

a1 = [(i1+0.1*(rand(n,1)-0.5)), (i2+0.2*(rand(n,1)-0.5))]
plot(a1', [x1, x2]', '-ok', 'MarkerSize',15)

xlim([0 3]); ylim([0 1]); pbaspect([0.618 1 1]);
set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks(''); yticks(0:0.25:1);
ylabel('A-E bias');
title([outputPValue(p1)])
mean(x1)
std(x1)/sqrt(length(x1))
mean(x2)
std(x2)/sqrt(length(x2))
%% Extended Fig8b, left,
ExtendedFig8b_left_day1 = x1;
ExtendedFig8b_left_day2 = x2;
ExtendedFig8b_left_summary = [x1,x2]


%% Extended Fig8b, right, familiar to novel
figure;
i3 = 1;
n = length(y1)
er = errorbar(i3-0.5, mean(y1), std(y1)/sqrt(n), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;

i4 = 2;
n = length(y2)
er = errorbar(i4+0.5, mean(y2), std(y2)/sqrt(n), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'k', 'MarkerEdgeColor','k','MarkerFaceColor','k'); hold on;
a2 = [(i3+0.1*(rand(n,1)-0.5)), (i4+0.2*(rand(n,1)-0.5))]
plot(a2', [y1, y2]', '-ok', 'MarkerSize',15)

[h0,p2] = ttest(y1,y2) % paried t test within the same animal

xlim([0 3]); ylim([0 1]); pbaspect([0.618 1 1]);
set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks(''); yticks(0:0.25:1);
ylabel('A-E bias');
title([outputPValue(p2)])

mean(y1)
std(y1)/sqrt(length(y1))
mean(y2)
std(y2)/sqrt(length(y2))
% Extended Fig8b, right
ExtendedFig8b_right_day1 = y1;
ExtendedFig8b_right_day2 = y2;
ExtendedFig8b_right_summary = [y1, y2]



% number of place cells, number of PCs


i_mouseDay = 4; j_mouseDay = i_mouseDay;
i_map = 1; j_map = i_map;

i_group = 3

pcnum = nan(length(mouseGroupIdx{i_group}), 1)
n = length(mouseGroupIdx{i_group});
for i = 1:n
   i_mouse = mouseGroupIdx{i_group}(i);
   pcnum(i) = sum(meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}, 'omitnan')
end

mean(pcnum)
std(pcnum)/sqrt(n)

%% Extended Data 1, Fig.1
%% spatial distribution of PC, day 1
i_mouseDay = 4; j_mouseDay = i_mouseDay;
i_map = 1; j_map = 1;
for i_group = 2:3
    
    idx = MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map};
    % map
    map = MAP{i_group}.map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay,1}(:, idx);
    [map_mx, i_mx] = max(map, [], 1, 'omitnan');
    [~, ii_mx] = sort(i_mx)
    map_norm = map ./ map_mx;
    figure;
    imagesc((map_norm(:, ii_mx))', [0 1]); colormap jet;
    xticks([1 13 25 37 50]); xticklabels({'0', '45', '90', '135', '180'}); pbaspect([0.618 1 1]); set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
    xlabel('Position (cm)'); ylabel('Place cell index'); title('representation')
    % peak position distribution
    map_peak = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(idx);
    
    figure;
    h=histogram(map_peak, 'Normalization', 'probability', 'BinWidth', 1);
    h.EdgeAlpha = 0;colorM = cbrewer('seq', 'Greys', 9); h.FaceColor = colorM(6,:);
    xticks([1 13 25 37 49]); xticklabels({'0', '45', '90', '135', '180'});xlim([0.5 50]); pbaspect([1 0.618 1]); set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
    xlabel('Position (cm)'); ylabel('Fraction of PCs'); yticks(0:0.02:0.1); ylim([0 0.1]); xline(14.5, '--k');
    
    if i_group == 2
        ExtendedFig1b_heatmap = (map_norm(:, ii_mx))';
        ExtendedFig1b_histogram = map_peak;
        
    elseif i_group ==3
        ExtendedFig1a_heatmap = (map_norm(:, ii_mx))';
        ExtendedFig1a_histogram = map_peak;
        
    end
end
% cumulative distribution of peak position, ks test
%% Extended Fig1c
i_mouseDay = 4; j_mouseDay = i_mouseDay;
i_map = 1; j_map = 1;
i_group = 3; j_group = 2
map_peak_i = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
map_peak_j = MAP{j_group}.map(i_map).peakPosition_allMice{i_mouseDay,1}(MAP{j_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
[h,p] = kstest2(map_peak_i, map_peak_j);
edges = 1:1:51
[ni,ei] = histcounts(map_peak_i, edges, 'Normalization', 'cdf');
[nj,ej] = histcounts(map_peak_j, edges, 'Normalization', 'cdf');
figure;
plot(ei(1:end-1), ni, 'k'); hold on;
plot(ej(1:end-1), nj, 'r');
xticks([1 13 25 37 50]); xticklabels({'0', '45', '90', '135', '180'}); xlim([0 51])
xlabel('Position (cm)'); ylabel('Cumu. frac. of PCs'); yticks(0:0.25:1); ylim([-0.01 1.01]); xline(14.5, '--k');
set(gca, 'TickDir', 'out', 'FontSize', 15); box off; pbaspect([1 1 1])
ExtendedFig1c = [ni', nj', ei(1:end-1)']

%% Extended Fig2a, Extended Fig2b
%% scatter plot of place cell locations, all PC, place cell remapping
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 4;
alpha = 0.5; markersize = 200
for i_group = 2:3
    figure;
    % mix PC
    idx_mix = nan2false(MAP{i_group}.map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map});
    s1 = scatter(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_mix), ...
        MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_mix), markersize, 'k', 'filled'); hold on;
    s1.MarkerFaceAlpha = alpha
    % space PC
    idx_space = nan2false(MAP{i_group}.map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map});
    s2 = scatter(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_space), ...
        MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_space), markersize, 'b', 'filled'); hold on;
    s2.MarkerFaceAlpha = alpha
    % goal PC
    idx_reward = nan2false(MAP{i_group}.map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map})
    s3 = scatter(MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_reward), ...
        MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_reward), markersize, 'r', 'filled'); hold on;
    s3.MarkerFaceAlpha = alpha
    % map 1 only PC
    N = 10;colorM = cbrewer('qual', 'Set1', 9)
    idx_map1_only = nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map});
    peakMap1 = MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_map1_only);
    peakMap2_rand = (rand(length(peakMap1),1)*N)-1.5*N;
    s4 = scatter(peakMap1, peakMap2_rand, markersize, colorM(3,:), 'filled'); hold on;
    s4.MarkerFaceAlpha = alpha
    % map 2 only PC
    N = 10;colorM = cbrewer('qual', 'Set1', 9)
    idx_map2_only = nan2false(MAP{i_group}.map(j_map).isPC_i_not_j{i_mouseDay, j_mouseDay, i_map});
    peakMap2 = MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_map2_only);
    peakMap1_rand = (rand(length(peakMap2),1)*N)-1.5*N;
    s5 = scatter(peakMap1_rand, peakMap2, markersize, colorM(3,:), 'filled'); hold on;
    s5.MarkerFaceAlpha = alpha
    
    xticks([-N 1 25 50]); xlim([-1.5*N-2, 52]); xticklabels({'Silent', '0', '90', '180'}); box off; set(gca, 'FontSize', 15);
    yticks([-N 1 25 50]); ylim([-1.5*N-2, 52]); yticklabels({'Silent', '0', '90', '180'}); set(gca,'TickDir','out'); axis square;
    xlabel('Place field position (cm), map1'); ylabel('Place field position (cm), map2');
    % Extended Fig2a, Extended Fig2b
    if i_group == 2
        ExtendedFig2b_mix = [MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_mix),...
            MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_mix)];
        ExtendedFig2b_space = [MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_space), ...
            MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_space)];
        ExtendedFig2b_goal = [MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_reward), ...
            MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_reward)];
        ExtendedFig2b_map1_only = [peakMap1, peakMap2_rand];
        ExtendedFig2b_map2_only = [peakMap1_rand, peakMap2];
    elseif i_group == 3
        ExtendedFig2a_mix = [MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_mix),...
            MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_mix)];
        ExtendedFig2a_space = [MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_space), ...
            MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_space)];
        ExtendedFig2a_goal = [MAP{i_group}.map(i_map).peakPosition_allMice{i_mouseDay, 1}(idx_reward), ...
            MAP{i_group}.map(j_map).peakPosition_allMice{i_mouseDay, 1}(idx_reward)];
        ExtendedFig2a_map1_only = [peakMap1, peakMap2_rand];
        ExtendedFig2a_map2_only = [peakMap1_rand, peakMap2];
        
    end
end


% PC type bars for all types
i_map = 1; j_map = 2
i_mouseDay = 4;
%% Extended Fig2c, Extended Fig2d, source data inside the plotting function.
for i_group = 2:3
    % v2, excluded the completely silent cells for calculating fraction, simplification purpose
    extendData2_pcTypeBar_v2(DataFolder, MAP, i_group, i_mouseDay, i_map, j_map, dayLabel, groupNameLabelPool)
end

%% Extended Fig7b, Extended Fig7d, aAAA
%% Extended Fig7a, Extended Fig7c, aABB
% Where do allo/ego-PCs go to on day 2
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 5;
for i_group = 3:4
    extendData8_pcTypeBar(DataFolder, MAP, i_group, i_mouseDay, j_mouseDay, i_map, j_map, dayLabel, groupNameLabelPool)
end


%% Extended Fig2e
%% distribution of place field shift for day -1, first vs next 100 laps
x = nan(1,2);
peakPositionChange_day3_allMice = [];
i_mouseDay = 3;
for i_mouse = 1:17
    if ~meta_data{i_mouse, i_mouseDay}.isEmpty
        i_map = 1;
        % identify top prctile event
        isPC_tmp = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC & meta_data{i_mouse, i_mouseDay}.isPC_next100lap
        numLapFirstReward = 100 % if 100, won't affect anything thing
        [mx, meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap] = max(meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm_next100lap, [], 1, 'omitnan');
        meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap = meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap';
        isSMPC_next100lap = false(meta_data{i_mouse, i_mouseDay}.cellNum,1);
        isSMPC_next100lap(meta_data{i_mouse, i_mouseDay}.pcIdx_next100lap) = true;
        meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap(~isSMPC_next100lap) = -5;
        isPCBothMap = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, i_map} & isSMPC_next100lap;
        peakPosition_map1 = meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition(isPCBothMap);
        peakPosition_map2 = meta_data{i_mouse, i_mouseDay}.peakPosition_next100lap(isPCBothMap);
        peakPositionDif = fieldPositionChange(spaDivNum, peakPosition_map2, peakPosition_map1);
        x = [x; [peakPosition_map1, peakPosition_map2]];
        peakPositionChange_day3_allMice = [peakPositionChange_day3_allMice; peakPositionDif]
    end
end
figure; 
h = histogram(abs(peakPositionChange_day3_allMice), 'Normalization', 'pdf')
xticks([0 12.5 25]); xticklabels({'0', '45', '90'}); xlabel('PF change (cm)'); ylabel('Fraction of PC');
yline(1/26, '--r', 'chance level');set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
h.EdgeColor = 'none'; h.LineWidth = 0.25; h.FaceColor = 'k'; h.FaceAlpha = 0.6

ExtendedFig2e = abs(peakPositionChange_day3_allMice);



%% Extended Fig1d, Extended Fig1e
% spatial information

i_group = 3; j_group = 2;
i_map = 1; j_map = 2; i_mouseDay = 4; j_mouseDay = 4;
idx_i = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}) | nan2false(MAP{i_group}.map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map});
idx_j = nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{j_mouseDay, i_mouseDay, j_map}) | nan2false(MAP{j_group}.map(i_map).isPC_i_not_j{j_mouseDay, i_mouseDay, j_map});

SI_i = MAP{i_group}.map(i_map).eachCellSpaInf_allMice{i_mouseDay,1}(idx_i, 1);
SI_j = MAP{j_group}.map(i_map).eachCellSpaInf_allMice{i_mouseDay,1}(idx_j, 1);

mean(SI_i)
std(SI_i) / sqrt(length(SI_i))

mean(SI_j)
std(SI_j) / sqrt(length(SI_j))


si_mx = max([max(SI_i), max(SI_j)])
binEdges = 0:0.05:si_mx*1.1
[ni,ei] = histcounts(SI_i, binEdges, 'Normalization', 'cdf')
[nj,ej] = histcounts(SI_j, binEdges, 'Normalization', 'cdf')

figure;
plot(ei(2:end), ni, 'k'); hold on;
plot(ej(2:end), nj, 'r'); hold on;

xticks(0:0.35:1.4); xlim([-0.05, 1.45]); yticks(0:0.2:1); ylim([0 1.05]); 
pbaspect([1 1 1]); set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xlabel('Spatial information'); ylabel('Cumu. frac. PCs');
[h,p] = ttest2(SI_i, SI_j)
display('familiar belt, day 1, Pre')
mean(SI_i), std(SI_i)/sqrt(length(SI_i))
display('novel belt, day 1, Pre')
mean(SI_j), std(SI_j)/sqrt(length(SI_j))

ExtendedFig1d = [ei(2:end);ni; nj]'

%% Extended Fig1e
% reliability
reliability_i = MAP{i_group}.map(i_map).firstLapFieldReliability_allMice{i_mouseDay,1}(idx_i, 1);
reliability_j = MAP{j_group}.map(i_map).firstLapFieldReliability_allMice{i_mouseDay,1}(idx_j, 1);
binEdges = 0:0.05:1
[ni,ei] = histcounts(reliability_i, binEdges, 'Normalization', 'cdf')
[nj,ej] = histcounts(reliability_j, binEdges, 'Normalization', 'cdf')
figure;
plot(ei(2:end), ni, 'k'); hold on;
plot(ej(2:end), nj, 'r'); hold on;
xticks(0:0.2:1); xlim([-0.05, 1.05]); yticks(0:0.2:1); ylim([-0.02 1.02]); 
pbaspect([1 1 1]); set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xlabel('Reliabilty'); ylabel('Cumu. frac. PCs');
[h,p] = ttest2(reliability_i, reliability_j)
display('familiar belt, day 1, Pre')
mean(reliability_i), std(reliability_i)/sqrt(length(reliability_i))
display('novel belt, day 1, Pre')
mean(reliability_j), std(reliability_j)/sqrt(length(reliability_j))
ExtendedFig1e = [ei(2:end); ni; nj]'




%% Extended Fig6, Control Experiments.
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}

meta_data_ctrl = load(['/Volumes/FishSSD5/CA1/AnalyzedData', '_CA1_V01/', 'CA1_paper/allControlMice', '/BinData_controlData_withBehavior.mat'])


i_map = 1; j_map = 2;

pcRemap_withCtrl = struct;
% aAAA_day2
i_mouseDay = 5; j_mouseDay = 5;
i_group = 3; 
idx1 = nan2false(MAP{i_group}.map(i_map).isPC_i_and_j{i_mouseDay+1, j_mouseDay+1, j_map});
pcRemap_withCtrl.aAAA_day2 = abs(MAP{i_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(idx1));
% aBBB_day1
i_mouseDay = 4; j_mouseDay = 4;
j_group = 2;
idx2 = nan2false(MAP{j_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
pcRemap_withCtrl.aBBB_day1 = abs(MAP{j_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(idx2));
% aABB, day 1
k_group = 4; % aABB
i_mouseDay = 4; j_mouseDay = 4;
idx3 = nan2false(MAP{k_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
pcRemap_withCtrl.aABB_day1 = abs(MAP{k_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(idx3));
% aABB, day 2
k_group = 4; % aABB
i_mouseDay = 5; j_mouseDay = 5;
idx4 = nan2false(MAP{k_group}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map});
pcRemap_withCtrl.aABB_day2 = abs(MAP{k_group}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(idx4));

% control data.
pcRemap_withCtrl.bBA_day1 = abs(meta_data_ctrl.peakPositionChange1);
pcRemap_withCtrl.bBA_day2 = abs(meta_data_ctrl.peakPositionChange2);
pcRemap_withCtrl.abB_day1 = abs(meta_data_ctrl.peakPositionChange3);


[~,p1] = kstest2(pcRemap_withCtrl.abB_day1, pcRemap_withCtrl.aBBB_day1)
[~,p2] = kstest2(pcRemap_withCtrl.bBA_day2, pcRemap_withCtrl.aAAA_day2)
[~,p3] = kstest2(pcRemap_withCtrl.aABB_day1, pcRemap_withCtrl.aABB_day2)
[~,p4] = kstest2(pcRemap_withCtrl.bBA_day1, pcRemap_withCtrl.bBA_day2)


pcRemap_yaxis = struct
edges = 0:26
[pcRemap_yaxis.aAAA_day2, E] = histcounts(removeNan(pcRemap_withCtrl.aAAA_day2), edges, 'Normalization', 'cdf'); % aAAA, day 1
[pcRemap_yaxis.aBBB_day1, E] = histcounts(removeNan(pcRemap_withCtrl.aBBB_day1), edges, 'Normalization', 'cdf'); % aAAA, day 1
[pcRemap_yaxis.aABB_day1, E] = histcounts(removeNan(pcRemap_withCtrl.aABB_day1), edges, 'Normalization', 'cdf'); % aAAA, day 1
[pcRemap_yaxis.aABB_day2, E] = histcounts(removeNan(pcRemap_withCtrl.aABB_day2), edges, 'Normalization', 'cdf'); % aAAA, day 1
[pcRemap_yaxis.bBA_day1, E] = histcounts(removeNan(pcRemap_withCtrl.bBA_day1), edges, 'Normalization', 'cdf'); % aAAA, day 1
[pcRemap_yaxis.bBA_day2, E] = histcounts(removeNan(pcRemap_withCtrl.bBA_day2), edges, 'Normalization', 'cdf'); % aAAA, day 1
[pcRemap_yaxis.abB_day1, E] = histcounts(removeNan(pcRemap_withCtrl.abB_day1), edges, 'Normalization', 'cdf'); % aAAA, day 1
pcRemap_yaxis

colorM = cbrewer('qual', 'Set1', 9)
figure;
subplot(1,4,1)
plot(E(2:end), pcRemap_yaxis.aBBB_day1, 'Color',colorM(1,:)); hold on; pbaspect([0.5,1,1]) % aBBB_day1
plot(E(2:end), pcRemap_yaxis.abB_day1, '--', 'Color', colorM(2,:)); hold on; % abB_day1
xlim([0.75 26.25]); ylim([0 1]);  set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([1 7 13 19 26]); xticklabels({'0', '', '45', '', '90'}); yticks(0:0.25:1); ylabel('Fraction of PCs'); xlabel('Delta PF (cm)')
title(outputPValue(p1)); axis square

% ExtendedFig6b_binValue = E(2:end);
% ExtendedFig6b_abB = pcRemap_yaxis.abB_day1;
% ExtendedFig6b_aB = pcRemap_yaxis.aBBB_day1;
%% Extended Fig6b
ExtendedFig6b_summary = [E(2:end)-1; pcRemap_yaxis.abB_day1; pcRemap_yaxis.aBBB_day1]

subplot(1,4,2)
plot(E(2:end), pcRemap_yaxis.bBA_day2, 'Color', colorM(1,:)); hold on; % bBA_day2
plot(E(2:end), pcRemap_yaxis.aAAA_day2, 'Color', colorM(2,:)); hold on; pbaspect([0.5,1,1]) % aAAA_day2
xlim([0.75 26.25]); ylim([0 1]);  set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([1 7 13 19 26]); xticklabels({'0', '', '45', '', '90'}); yticks(0:0.25:1); ylabel('Fraction of PCs');title(outputPValue(p2)); xlabel('Delta PF (cm)')
axis square
%% Extended Fig6c
ExtendedFig6c_summary = [E(2:end)-1; pcRemap_yaxis.aAAA_day2; pcRemap_yaxis.bBA_day2]


subplot(1,4,3)
plot(E(2:end), pcRemap_yaxis.aABB_day1,  'Color', colorM(2,:)); hold on; % aBBB, day 2
plot(E(2:end), pcRemap_yaxis.aABB_day2, 'Color', colorM(1,:)); hold on;pbaspect([0.5,1,1]);
xlim([0.75 26.25]);ylim([0 1]);  set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([1 7 13 19 26]); xticklabels({'0', '', '45', '', '90'}); yticks(0:0.25:1); ylabel('Fraction of PCs');title(outputPValue(p3)); xlabel('Delta PF (cm)')
axis square
%% Extended Fig6d
ExtendedFig6d_summary = [E(2:end)-1; pcRemap_yaxis.aABB_day1; pcRemap_yaxis.aABB_day2]

subplot(1,4,4)
plot(E(2:end), pcRemap_yaxis.bBA_day1,  'Color', colorM(2,:)); hold on; % aBBB, day 2
plot(E(2:end), pcRemap_yaxis.bBA_day2, 'Color', colorM(1,:)); hold on;pbaspect([0.5,1,1]);
xlim([0.75 26.25]);ylim([0 1]);  set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
xticks([1 7 13 19 26]); xticklabels({'0', '', '45', '', '90'}); yticks(0:0.25:1); ylabel('Fraction of PCs');title(outputPValue(p3)); xlabel('Delta PF (cm)')
axis square
%% Extended Fig6e
ExtendedFig6e_summary = [E(2:end)-1; pcRemap_yaxis.bBA_day1; pcRemap_yaxis.bBA_day2]


% fed time_v2023 data and compare time vs space
groupNamePool = {'allGroupCombine', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
groupNameLabelPool = {'allGroup', 'aBBB', 'aAAA', 'aABB', 'aA', 'memoryB'}
dayLabel = {'-3', '-2', '-1', '1', '2', '3'};
mouseGroupIdx = {1:17, 1:6, 7:12, 13:17, 7:17, [1:4,6]}
mouseDayIdx = {1:6, 1:6, 1:6, 1:6, 1:6, 1:6}
timeData = load('/Volumes/FishSSD5/CA1/AnalyzedData_CA1_V2024_time_v2/CA1_paper/allMice/time_vs_distance/BinData_v2.mat') % v2 used find2End_v5, 0325-2024
timeMAP = groupTimeData(timeData)
i_slow = 1;
i_fast = 3;
%% Extended Fig4a, Extended Fig4b, Extended Fig4c
plotTimeMap_v1_cleanForPaper(timeMAP, MAP{3}.map(1).isRewardAssociated_allMice{4,4,2}, groupNamePool, 3, 'Ego-PCs', i_slow, i_fast);


%% Extended Data Fig6
% whole-cell intracellular PF position change
wholeCell_PFPos_pre = [37   110    50    69    57    39   127   155    34    33    39    56    55    57   164    58    70    45    55   141    76    48   130   145    95    65];
wholeCell_PFPos_post = [73   130    59    84   155    55    74    97    36    73   126    67   146   104   163    49    76   120   148   138   155   127   128   160    74    87];
spaDivNum = 50; % number of spatial bins
locationSize = 184; % cm
wholeCell_PFPos_pre_spaDiv = transformLocation2Bin(wholeCell_PFPos_pre, spaDivNum, locationSize)
wholeCell_PFPos_post_spaDiv = transformLocation2Bin(wholeCell_PFPos_post, spaDivNum, locationSize)
wholeCell_filedPostiionChange_abs = abs(fieldPositionChange(spaDivNum, wholeCell_PFPos_pre_spaDiv, wholeCell_PFPos_post_spaDiv));

i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map = 2;
% make whole-cell data binned 
x = abs(MAP{3}.map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}(nan2false(MAP{3}.map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map})));
% ks test
[h,p] = kstest2(x, wholeCell_filedPostiionChange_abs)
% [p,h] = ranksum(x, wholeCell_filedPostiionChange_abs)

[N1, E1] = histcounts(x, 'BinLimit', [0 25], 'BinWidth', 2, 'Normalization', 'probability')
[N2, E2] = histcounts(wholeCell_filedPostiionChange_abs, 'BinLimit', [0 25], 'BinWidth', 2, 'Normalization', 'probability')

colorM = cbrewer('qual', 'Set1', 9)
figure;
E1(end) = 26 % make it symmetric
plot(E1(2:end), N1, 'k'); hold on;
plot(E1(2:end), N2, 'Color', colorM(3, :))
axis square
xticks([2 14 26]); xticklabels({'0', '45', '90'}); box off; set(gca, 'FontSize', 15); 
yticks([0  0.05  0.1 0.15 0.2]); set(gca,'TickDir','out'); xlim([1 27]); ylim([-0.01 0.21])
xlabel('delta PF Position (cm)'); ylabel('Fraction of PCs')
title(['p value is ', num2str(p, '%.2f') ', ks-test']); 
legend('imaging', 'whole-cell');legend('boxoff')



%% control data, number of days of training with fixed reward
familiarTrainTotalLapNum = [841; 711; 646; 790; 615; 595]
extensiveTrainTotalLapNum = [800; 800; 728; 725]

[h,p] = ttest2(extensiveTrainTotalLapNum, familiarTrainTotalLapNum)

mean(familiarTrainTotalLapNum)
std(familiarTrainTotalLapNum)/sqrt(length(familiarTrainTotalLapNum))

mean(extensiveTrainTotalLapNum)
std(extensiveTrainTotalLapNum)/sqrt(length(extensiveTrainTotalLapNum))


%% control data, 
%{
1. correlation of running profile versus mean velocity
2. mean velocity each trials and the progression over trial
%}


%% number of days training

%{
%% number of days of training
1) Familiar env, number of fixed reward training days: [5,5,7,6,4,5]
2) abB group: [4,4,4,4], SD is 0
%% number of laps of training
1) familiar: [841, 711, 646, 790, 615, 595]
2) abB: [800, 800, 728, 725]
%}
lapMeanStart = 75
% progress of velocity, versus the second half of the velocity
eachSpaDivSpeed_controlMice = []
eachSpaDivSpeed_mean_controlMice = []
eachSpaDivSpeed_corrMean_controlMice = [] 
for i = 1:4
    x = meta_data_ctrl.eachSpaDivSpeed{i}(1:100, :)';
    eachSpaDivSpeed_controlMice = cat(3, eachSpaDivSpeed_controlMice, smoothdata(x, 2, 'movmean', 1, 'omitnan'));
    eachSpaDivSpeed_mean_controlMice = [eachSpaDivSpeed_mean_controlMice, mean(x(:, lapMeanStart:100), 2, 'omitnan')];
    eachSpaDivSpeed_corrMean_controlMice = [eachSpaDivSpeed_corrMean_controlMice, corr(eachSpaDivSpeed_controlMice(:,:,i), eachSpaDivSpeed_mean_controlMice(:, i))];
end

% progress of running, corr vs mean running profile, familiar belt

eachSpaDivSpeed_corrMean_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivSpeed_allMice{4};
    for i = 1:6
        idx = 1+100*(i-1) : (100*i);
        x_i = x(:, idx);
        x_mean = mean(x_i(:, lapMeanStart:end), 2, 'omitnan'); % second half of session
        eachSpaDivSpeed_corrMean_familiarMice = [eachSpaDivSpeed_corrMean_familiarMice, corr(x_i, x_mean)];
    end
end

% progress of running, corr vs mean running profile, novel belt
eachSpaDivSpeed_corrMean_novelMice = []
for i_group = 2
    x = MAP{i_group}.map(1).eachSpaDivSpeed_allMice{4};
    for i = 1:6
        idx = 1+100*(i-1) : (100*i);
        x_i = x(:, idx);
        x_mean = mean(x_i(:, lapMeanStart:end), 2, 'omitnan'); % second half of session
        eachSpaDivSpeed_corrMean_novelMice = [eachSpaDivSpeed_corrMean_novelMice, corr(x_i, x_mean)];
    end
end

figure;
stdshade(smoothdata(eachSpaDivSpeed_corrMean_controlMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.6000    0.6000    0.6000]); hold on;
stdshade(smoothdata(eachSpaDivSpeed_corrMean_familiarMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.2157    0.4941    0.7216]); hold on;
stdshade(smoothdata(eachSpaDivSpeed_corrMean_novelMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.8941    0.1020    0.1098]); hold on;
legend('control', '', 'familiar', '', 'novel'); axis square;
xlim([-0.1, 100.1]); ylim([-0.01 1.01]); box off; set(gca, 'TickDir', 'out')

idx1 = [1:100, 1:100, 1:100, 1:100]';
idx2 = [1:100, 1:100, 1:100, 1:100, 1:100, 1:100]';
a = eachSpaDivSpeed_corrMean_controlMice(:);
b = eachSpaDivSpeed_corrMean_controlMice(:);
c = eachSpaDivSpeed_corrMean_controlMice(:);
% mdl_speed_control = fit(idx1, smoothdata(a, 1, 'movmean', 5, 'omitnan'), "log10")
% mdl_speed_familiar = fit(idx2, smoothdata(b, 1, 'movmean', 5, 'omitnan'), 'log')
% mdl_speed_novel = fit(idx2, smoothdata(c, 1, 'movmean', 5, 'omitnan'), 'log')
% curveFitter(idx1, smoothdata(eachSpaDivSpeed_corrMean_controlMice(:), 1, 'movmean', 5, 'omitnan'))

%% across-session average, running profile reliability
idx = 1:10
eachSpaDivSpeed_corrMean_sessionMean_controlMice = mean(eachSpaDivSpeed_corrMean_controlMice(idx, :), 1, 'omitnan');
eachSpaDivSpeed_corrMean_sessionMean_familiarMice = mean(eachSpaDivSpeed_corrMean_familiarMice(idx, :), 1, 'omitnan');
eachSpaDivSpeed_corrMean_sessionMean_novelMice = mean(eachSpaDivSpeed_corrMean_novelMice(idx, :), 1, 'omitnan');
[h1, p1] = ttest2(eachSpaDivSpeed_corrMean_sessionMean_controlMice, eachSpaDivSpeed_corrMean_sessionMean_familiarMice)
[h2, p2] = ttest2(eachSpaDivSpeed_corrMean_sessionMean_controlMice, eachSpaDivSpeed_corrMean_sessionMean_novelMice)
[h3, p3] = ttest2(eachSpaDivSpeed_corrMean_sessionMean_familiarMice, eachSpaDivSpeed_corrMean_sessionMean_novelMice)



% progress of lick selectivity, outside versus total
outSideRewardZoneIdx = [1:9, 25:50]
insideRewardZoneIdx = [10:24]
eachLapLickSelectivity_controlMice = []
% control group of animal
for i = 1:4
    x = meta_data_ctrl.eachSpaDivLickSum{i}(1:100, :)';
    outsideLickCount = sum(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideLickCount = sum(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    totalLickCount = sum(x, 1, 'omitnan')';
    eachLapLickSelectivity_controlMice = [eachLapLickSelectivity_controlMice, insideLickCount./totalLickCount];
end


% familiar group
eachLapLickSelectivity_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivLickCount_allMice{4};
    outsideLickCount = sum(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideLickCount = sum(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    totalLickCount = sum(x, 1, 'omitnan')';
    tmp = insideLickCount./totalLickCount;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachLapLickSelectivity_familiarMice = [eachLapLickSelectivity_familiarMice, tmp(idx)];
    end
    
end

% novel group
eachLapLickSelectivity_novelMice = []
for i_group = 2
    x = MAP{i_group}.map(1).eachSpaDivLickCount_allMice{4};
    outsideLickCount = sum(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideLickCount = sum(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    totalLickCount = sum(x, 1, 'omitnan')';
    tmp = insideLickCount./totalLickCount;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachLapLickSelectivity_novelMice = [eachLapLickSelectivity_novelMice, tmp(idx)];
    end
    
end

sectionSize = 10
eachLapLickSelectivity_perSection_controlMice = nan(100/sectionSize, size(eachLapLickSelectivity_controlMice, 2));
eachLapLickSelectivity_perSection_familiarMice = nan(100/sectionSize, size(eachLapLickSelectivity_familiarMice, 2));
eachLapLickSelectivity_perSection_novelMice = nan(100/sectionSize, size(eachLapLickSelectivity_novelMice, 2));

for i_section = 1:(100/sectionSize)
    idx = 1+sectionSize*(i_section-1) : sectionSize*i_section
    for i_mouse = 1:size(eachLapLickSelectivity_controlMice, 2)
        eachLapLickSelectivity_perSection_controlMice(i_section, i_mouse) = mean(eachLapLickSelectivity_controlMice(idx, i_mouse), 'omitnan');
    end
    for i_mouse = 1:size(eachLapLickSelectivity_familiarMice, 2)
        eachLapLickSelectivity_perSection_familiarMice(i_section, i_mouse) = mean(eachLapLickSelectivity_familiarMice(idx, i_mouse), 'omitnan');
    end
    for i_mouse = 1:size(eachLapLickSelectivity_novelMice, 2)
        eachLapLickSelectivity_perSection_novelMice(i_section, i_mouse) = mean(eachLapLickSelectivity_novelMice(idx, i_mouse), 'omitnan');
    end
end



figure;
stdshade(smoothdata(eachLapLickSelectivity_controlMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.6000    0.6000    0.6000]); hold on;
stdshade(smoothdata(eachLapLickSelectivity_familiarMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.2157    0.4941    0.7216]); hold on;
stdshade(smoothdata(eachLapLickSelectivity_novelMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.8941    0.1020    0.1098]); hold on;
legend('control', '', 'familiar', '', 'novel'); axis square;
xlim([-0.1, 100.1]); ylim([-0.01 1.01]); box off; set(gca, 'TickDir', 'out')

figure;
stdshade(smoothdata(eachLapLickSelectivity_perSection_controlMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.6000    0.6000    0.6000]); hold on;
stdshade(smoothdata(eachLapLickSelectivity_perSection_familiarMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.2157    0.4941    0.7216]); hold on;
stdshade(smoothdata(eachLapLickSelectivity_perSection_novelMice, 1, 'movmean', 1, 'omitnan')', 0.5, [0.8941    0.1020    0.1098]); hold on;
legend('control', '', 'familiar', '', 'novel')
axis square; box off;
xlim([1-0.2, 100/sectionSize+0.2]);
ylim([0 1]); xticks(1:10)
set(gca, 'FontSize', 15)


idx = 1
mean(eachLapLickSelectivity_perSection_controlMice(idx,:))
std(eachLapLickSelectivity_perSection_controlMice(idx,:))/sqrt(length(eachLapLickSelectivity_perSection_controlMice(idx,:)))
mean(eachLapLickSelectivity_perSection_familiarMice(idx,:))
std(eachLapLickSelectivity_perSection_familiarMice(idx,:))/sqrt(length(eachLapLickSelectivity_perSection_familiarMice(idx,:)))
mean(eachLapLickSelectivity_perSection_novelMice(idx,:))
std(eachLapLickSelectivity_perSection_novelMice(idx,:))/sqrt(length(eachLapLickSelectivity_perSection_novelMice(idx,:)))

[h1, p1] = ttest2(eachLapLickSelectivity_perSection_controlMice(idx,:), eachLapLickSelectivity_perSection_familiarMice(idx,:))
[h1, p2] = ttest2(eachLapLickSelectivity_perSection_controlMice(idx,:), eachLapLickSelectivity_perSection_novelMice(idx,:))
[h1, p3] = ttest2(eachLapLickSelectivity_perSection_familiarMice(idx,:), eachLapLickSelectivity_perSection_novelMice(idx,:))





%% Response to reviewer's comments/ rebuttal/ response/Rebuttal

% familiar group, anticipatory licking probability, one mouse, one data
% point, corr with goal-ref PCs
advRewardZoneIdx = [10:14]
eachMouseAdvLickProbability_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivLickCount_allMice{4};
    
    eachLapIsAdvLick = mean(x(advRewardZoneIdx, :), 1, 'omitnan')' > 0;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       thisMouseAdvLickProbability = mean(eachLapIsAdvLick(idx), 'omitnan');
       eachMouseAdvLickProbability_familiarMice = [eachMouseAdvLickProbability_familiarMice, thisMouseAdvLickProbability];
    end
    
end
eachMouseAdvLickProbability_familiarMice



% familiar group, licking selectivity, one mouse one data point
insideRewardZoneIdx = [10:24]
eachMouseLickSelectivity_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivLickCount_allMice{4};
    outsideLickCount = sum(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideLickCount = sum(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    totalLickCount = sum(x, 1, 'omitnan')';
    tmp = insideLickCount./totalLickCount;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachMouseLickSelectivity_familiarMice = [eachMouseLickSelectivity_familiarMice, mean(tmp(idx), 'omitnan')];
    end
    
end
eachMouseLickSelectivity_familiarMice


% familiar group, adv slow down, one mouse one data point

advRunZoneIdx = [4, 14]
eachMouseAdvSlowRate_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivSpeed_allMice{4};
    speed_late = sum(x(advRunZoneIdx(2), :), 1, 'omitnan')';
    speed_early = sum(x(advRunZoneIdx(1), :), 1, 'omitnan')';
    speedChange = speed_late ./ speed_early;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachMouseAdvSlowRate_familiarMice = [eachMouseAdvSlowRate_familiarMice, mean(speedChange(idx), 'omitnan')];
    end
    
end
eachMouseAdvSlowRate_familiarMice

% familiar group, slow down selectivity, one mouse one data point
outSideRewardZoneIdx = [1:9, 25:50]
insideRewardZoneIdx = [10:24]
eachMouseSpeedSelectivity_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivSpeed_allMice{4};
    outsideSpeed = mean(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideSpeed  = mean(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    tmp = insideSpeed ./ outsideSpeed;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachMouseSpeedSelectivity_familiarMice = [eachMouseSpeedSelectivity_familiarMice, mean(tmp(idx), 'omitnan')];
    end
end
eachMouseSpeedSelectivity_familiarMice


%% Rebuttal, rebuttal, response, Response, Review, review
% corr different behavioral performance to goal-ref PCs fraction
i_group = 3;
i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map = 2;
x1 = eachMouseAdvLickProbability_familiarMice;
y = MAP{i_group}.pcStats{i_mouseDay, j_mouseDay, i_map, j_map}.rewardPC_ratio_allMice;
mdl1 = fitlm(x1, y)

x2 = eachMouseLickSelectivity_familiarMice
mdl2 = fitlm(x2, y)

x3 = eachMouseAdvSlowRate_familiarMice
mdl3 = fitlm(x3, y)


figure;
subplot(1,3,1)
scatter(x1, y, 300, 'k', 'filled'); hold on;
% plot(x1, x1 .* mdl1.Coefficients.Estimate(2) + mdl1.Coefficients.Estimate(1), 'k');
xlim([0, 1]); ylim([0, 0.601]); pbaspect([0.618 1 1]); xticks(0:0.1:1); yticks(0:0.15:0.6); set(gca, 'FontSize', 15); xlabel('Prob. of anticipatory lick'); ylabel('Fraction of goal-ref PCs')

subplot(1,3,2)
scatter(x2, y, 300, 'k', 'filled'); hold on;
% plot(x2, x2 .* mdl2.Coefficients.Estimate(2) + mdl2.Coefficients.Estimate(1), 'k')
xlim([0 1]); ylim([0 0.601]); pbaspect([0.618 1 1]); xticks(0:0.1:1); yticks(0:0.15:0.6); set(gca, 'FontSize', 15); xlabel('Licking selectivity'); ylabel('Fraction of goal-ref PCs')
subplot(1,3,3)
scatter(x3, y, 300, 'k', 'filled'); hold on;
% plot(x3, x3 .* mdl3.Coefficients.Estimate(2) + mdl3.Coefficients.Estimate(1), 'k')
xlim([0 0.8]); ylim([0 0.601]); pbaspect([0.618 1 1]); xticks(0:0.2:0.8); yticks(0:0.15:0.6); set(gca, 'FontSize', 15); xlabel('Anticipatory slow down rate'); ylabel('Fraction of goal-ref PCs')



%% licking selectivity correlates with goal-refereced PC number across trials

% familiar group
eachLapLickSelectivity_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivLickCount_allMice{4};
    outsideLickCount = sum(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideLickCount = sum(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    totalLickCount = sum(x, 1, 'omitnan')';
    tmp = insideLickCount./totalLickCount;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachLapLickSelectivity_familiarMice = [eachLapLickSelectivity_familiarMice, tmp(idx)];
    end
end

eachLapOnsetGoalPC_cumFraction = []
eachLapActiveGoalPC_cumFraction = []
eachLapGoalPC_PVCorr = nan(100, 6);
i_mouseDay = 4; j_mouseDay = 4; i_map = 1; j_map = 2;
for i_group = 3
    
    for i = 1:6
        
        i_mouse = mouseGroupIdx{i_group}(i)
        isShiftPF = abs(meta_data{i_mouse, i_mouseDay}.map(i_map).peakPositionChange{i_mouseDay, j_map}) >= 21;
        isPC_i_and_j = meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{i_mouseDay, j_map};
        idx = isShiftPF & isPC_i_and_j;
        sum(idx)
        x = meta_data{i_mouse, i_mouseDay}.map(i_map).isSigLap(1:100, idx);
        y = meta_data{i_mouse, i_mouseDay}.map(i_map).onsetLapIdx(idx); y(isnan(y)) = [];
        x_cum = sum(x, 2, 'omitnan') / sum(idx);
        y_cum = histcounts(y,'BinLimit', [0 100], 'BinWidth', 1, 'Normalization', 'cdf')';
        eachLapOnsetGoalPC_cumFraction = [eachLapOnsetGoalPC_cumFraction, y_cum];
        eachLapActiveGoalPC_cumFraction = [eachLapActiveGoalPC_cumFraction, x_cum];
        
        % PV corr
        template = meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm(:, idx);
        for i_lap = 1:100
            thisLapFd = squeeze(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd(:, i_lap, idx));
            eachLapGoalPC_PVCorr(i_lap, i) = corr(thisLapFd(:), template(:));
            
        end
    end
end

% familiar group, adv slow down, one mouse one data point

advRunZoneIdx = [4, 14]
eachLapAdvSlowRate_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivSpeed_allMice{4};
    speed_late = sum(x(advRunZoneIdx(2), :), 1, 'omitnan')';
    speed_early = sum(x(advRunZoneIdx(1), :), 1, 'omitnan')';
    speedChange = speed_late ./ speed_early;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachLapAdvSlowRate_familiarMice = [eachLapAdvSlowRate_familiarMice, speedChange(idx)];
    end
    
end
eachLapAdvSlowRate_familiarMice

% familiar group, speed selectivity, each lap
outSideRewardZoneIdx = [1:9, 25:50]
insideRewardZoneIdx = [10:24]
eachLapSpeedSelectivity_familiarMice = []
for i_group = 3
    x = MAP{i_group}.map(1).eachSpaDivSpeed_allMice{4};
    outsideSpeed = mean(x(outSideRewardZoneIdx, :), 1, 'omitnan')';
    insideSpeed  = mean(x(insideRewardZoneIdx, :), 1, 'omitnan')';
    tmp = insideSpeed ./ outsideSpeed;
    for i = 1:6
       idx = 1+100*(i-1):100*i;
       eachLapSpeedSelectivity_familiarMice = [eachLapSpeedSelectivity_familiarMice, tmp(idx)];
    end
end
eachLapSpeedSelectivity_familiarMice




figure;
% stdshade(eachLapOnsetGoalPC_cumFraction', 0.5, 'r'); hold on
yyaxis left; 
stdshade(eachLapLickSelectivity_familiarMice', 0.5, 'k'); hold on; ylim([0 1.01]);yticks(0:0.25:1); ylabel('Licking selectivity')
% stdshade(eachLapActiveGoalPC_cumFraction', 0.5, 'b'); hold on
yyaxis right
stdshade(eachLapGoalPC_PVCorr', 0.5, 'r'); hold on; ylim([0 1]);yticks(0:0.25:1); ylabel('PV Correlation (r) of Goal PCs')
box off
xlim([0.5 100.5]); xticks([1, 25, 50, 75, 100])
axis square; set(gca, 'FontSize', 15)
M = corr(eachLapLickSelectivity_familiarMice, eachLapGoalPC_PVCorr, 'Rows', 'complete')
eachMouseLickSel_corr_GoalPV = diag(M)
mean(eachMouseLickSel_corr_GoalPV)


figure;
yyaxis left
% stdshade(eachLapOnsetGoalPC_cumFraction', 0.5, 'r'); hold on
stdshade(eachLapAdvSlowRate_familiarMice', 0.5, 'k'); hold on; ylim([0 1.261]);yticks(0:0.25:1.25); ylabel('Anticipatory slow rate')
% stdshade(eachLapActiveGoalPC_cumFraction', 0.5, 'b'); hold on
yyaxis right
stdshade(eachLapGoalPC_PVCorr', 0.5, 'r'); hold on; ylim([0 1.01]);yticks(0:0.25:1); ylabel('PV Correlation (r) of Goal PCs')
box off

xlim([0.5 100.5]);  xticks([1, 25, 50, 75, 100]);

axis square; set(gca, 'FontSize', 15)

M = corr(eachLapAdvSlowRate_familiarMice, eachLapGoalPC_PVCorr, 'Rows', 'complete')
eachMouseAdvSlowRate_corr_GoalPV = diag(M)
mean(eachMouseAdvSlowRate_corr_GoalPV)
































