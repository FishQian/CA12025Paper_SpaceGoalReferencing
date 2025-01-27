function map = groupData_multiDay_CA1(meta_data, mouseGroupIdx, mouseDayIdx, Num_allMice, MiceDay, isRemap)
lapLimit = 100
map = struct

% cellNum_cumsum will be useful for calculating the global index of a cell within the entire group
cellNum = nan(length(mouseGroupIdx), length(mouseDayIdx));

for i = 1:length(mouseGroupIdx)
    i_mouse = mouseGroupIdx(i)
    for j = 1: length(mouseDayIdx)
        i_mouseDay = mouseDayIdx(j)
        if (meta_data{i_mouse, i_mouseDay}.isEmpty)
            
            cellNum(i, i_mouseDay) = 0;
        else
            cellNum(i, i_mouseDay) =  meta_data{i_mouse, i_mouseDay}.cellNum;
        end
    end
end
map(1).cellNum_cumsum = [zeros(1, size(cellNum, 2));cumsum(cellNum, 1)];
map(2).cellNum_cumsum = [zeros(1, size(cellNum, 2));cumsum(cellNum, 1)];


for i_map = 1:2
    % one mouse, one day, one number, i.e., cell number
    map(i_map).lapNum_allMice      = nan(Num_allMice, length(MiceDay{1})); % a vector to save lapNum for each animal and also a summed lapNum
    map(i_map).cellNum_allMice     = nan(Num_allMice, length(MiceDay{1})); % ROIs registered across multi-day share same cellNum across days
    map(i_map).pcNum_allMice       = nan(Num_allMice, length(MiceDay{1}));
    map(i_map).stablePCNum_allMice = nan(Num_allMice, length(MiceDay{1}));
    
    % one mouse, one day, one vector, i.e., pcIdx
    map(i_map).pcIdx_allMice       = cell(length(MiceDay{1}), 1);
    map(i_map).stablePCIdx_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).firstLapIdx_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).onsetLapIdx_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).onsetFieldReliability_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).peakPosition_allMice       = cell(length(MiceDay{1}), 1);
   
    
    % one mouse, one day, 
    map(i_map).avg_eachSpaDivFd_sm_allMice      = cell(length(MiceDay{1}));
    map(i_map).eachSpaDivFd_allMice             = cell(length(MiceDay{1}));
    map(i_map).eachSpaDivFd_sm_allMice          = cell(length(MiceDay{1}));
    map(i_map).eachSpaDivFdLarge_sm_allMice          = cell(length(MiceDay{1})); % removed not-larged spatial bin data
    map(i_map).eachSpaDiv_isLargeEvent_allMice          = cell(length(MiceDay{1})); % removed not-larged spatial bin data

    map(i_map).eachSpaDivLickCount_allMice      = cell(length(MiceDay{1}), 1);
    map(i_map).eachSpaDivSpeed_allMice          = cell(length(MiceDay{1}), 1);
    map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace          = cell(length(MiceDay{1}), 1);
    map(i_map).eachSpaDivLickProbability_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).eachLapPeakPosition_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).eachLapPeakPositionChange_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).eachLapPeakPosition_SigLapOnly_allMice = cell(length(MiceDay{1}), 1); % SigLapOnly - has mu+3*sigma at 90cm around peak
    map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice = cell(length(MiceDay{1}), 1);
    
    map(i_map).eachLapPeakAmplitude_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice = cell(length(MiceDay{1}), 1);
    
    map(i_map).eachLapSI_allMice      = cell(length(MiceDay{1}), 1); % Spatial information for each lap
    map(i_map).eachLapSI_SigLapOnly_allMice      = cell(length(MiceDay{1}), 1); % Spatial information for each lap, significant lap only
    map(i_map).eachLapSI_NotSigLapOnly_allMice      = cell(length(MiceDay{1}), 1); % Spatial information for each lap, significant lap only
    map(i_map).isSigLap_allMice       = cell(length(MiceDay{1}), 1); % Spatial information for each lap
    map(i_map).isLargeEventLap_allMice = cell(length(MiceDay{1}), 1); % is lap that includes at least 1 large event, max([1, prctile(Fd, 99)])
    map(i_map).eachCellSpaInf_allMice = cell(length(MiceDay{1}), 1);
    
    map(i_map).numLap2Add = zeros(Num_allMice, length(MiceDay{1})); % initial value 0
    map(i_map).numPcLap2Add = zeros(Num_allMice, length(MiceDay{1})); % initial value 0
    map(i_map).pcIdx = cell(Num_allMice,length(MiceDay{1}));
    map(i_map).pcIdx{1,1} = meta_data{1,1}.pcIdx;
    map(i_map).cellIdx = cell(Num_allMice, length(MiceDay{1}));
    map(i_map).cellIdx{1,1} = 1:meta_data{1,1}.cellNum;
    
    map(i_map).spatialXCorrLag_allMice = cell(length(MiceDay{1}), 1); % lapLimit by lapLimit
    map(i_map).spatialXCorrValue_allMice = cell(length(MiceDay{1}), 1);
    map(i_map).spatialXCorrLag_SigXCorrOnly_allMice = cell(length(MiceDay{1}), 1); % lapLimit by lapLimit
    map(i_map).spatialXCorrValue_SigXCorrOnly_allMice = cell(length(MiceDay{1}), 1);
end
% collect and centralize data in one place.
% mouseDayIdx
for i = 1:length(mouseDayIdx)
    i_mouseDay = mouseDayIdx(i)
    for i_map = 1:2 % array initialization
        map(i_map).pcIdx_allMice{i_mouseDay} = [];
        map(i_map).stablePCIdx_allMice{i_mouseDay} = [];
        map(i_map).firstLapIdx_allMice{i_mouseDay} = []; % 1 if no onset lap found, used for calculation convenience
        map(i_map).onsetLapIdx_allMice{i_mouseDay} = []; % nan if no onset lap found
        map(i_map).onsetFieldReliability_allMice{i_mouseDay}    = []; % nan if no onset lap found
        map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay}      = [];
        map(i_map).peakPosition_allMice{i_mouseDay}             = [];
        
        map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay, 1}      = [];
        map(i_map).eachSpaDivLickCount_allMice{i_mouseDay, 1}      = [];
        map(i_map).eachSpaDivSpeed_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1}          = [];
        map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1}          = [];
        
        map(i_map).eachLapPeakPosition_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay, 1}          = [];
        map(i_map).eachLapSI_allMice{i_mouseDay}             = [];
        map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay}             = [];
        map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay}             = [];
        map(i_map).isSigLap_allMice{i_mouseDay}             = [];
        map(i_map).isLargeEventLap_allMice{i_mouseDay}             = [];
        map(i_map).eachCellSpaInf_allMice{i_mouseDay, 1}             = [];
        
        map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1} = []; % lapLimit by lapLimit
        map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1} = [];
        map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1} = []; % lapLimit by lapLimit
        map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1} = [];
    end
    %     i_gap = 1
    for i = 1:length(mouseGroupIdx)
        i_mouse = mouseGroupIdx(i);
        i_mouseDay;
        if meta_data{i_mouse, i_mouseDay}.isEmpty
            % no actions required
            
            % assign some variables
             if i_mouseDay <= 3 % no remap
                 i_map = 1;
                 map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1}, nan(100, 100));
                 map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1}, nan(100, 100));
                 % sig xcorr only removes corr-coefficient < 0.1 comparisons
                 map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1}, nan(100, 100));
                 map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1}, nan(100, 100));
             else
                 for i_map = 1:2
                     map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1}, nan(100, 100));
                     map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1}, nan(100, 100));
                     % sig xcorr only removes corr-coefficient < 0.1 comparisons
                     map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1}, nan(100, 100));
                     map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1}, nan(100, 100));
                 end
                 
             end
        else
            % fixed reward, no reward shift
            if isRemap{i_mouse}{i_mouseDay} == false
                i_map = 1;
                map(i_map).lapNum_allMice(i_mouse, i_mouseDay)      = meta_data{i_mouse, i_mouseDay}.lapNum;
                map(i_map).cellNum_allMice(i_mouse, i_mouseDay)     = meta_data{i_mouse, i_mouseDay}.cellNum;
                map(i_map).pcNum_allMice(i_mouse, i_mouseDay)       = meta_data{i_mouse, i_mouseDay}.numPlaceCell;
                map(i_map).stablePCNum_allMice(i_mouse, i_mouseDay) = meta_data{i_mouse, i_mouseDay}.numStablePCell;
                
                map(i_map).pcIdx_allMice{i_mouseDay}       = [map(i_map).pcIdx_allMice{i_mouseDay};       meta_data{i_mouse, i_mouseDay}.pcIdx         + map(i_map).cellNum_cumsum(i, i_mouseDay)];
                map(i_map).stablePCIdx_allMice{i_mouseDay} = [map(i_map).stablePCIdx_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.pcIdxStable   + map(i_map).cellNum_cumsum(i, i_mouseDay)];
                map(i_map).firstLapIdx_allMice{i_mouseDay} = [map(i_map).firstLapIdx_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.firstLapIdx];
                map(i_map).onsetLapIdx_allMice{i_mouseDay} = [map(i_map).onsetLapIdx_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.onsetLapIdx];
                map(i_map).onsetFieldReliability_allMice{i_mouseDay} = [map(i_map).onsetFieldReliability_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.onsetFieldReliability];
                map(i_map).peakPosition_allMice{i_mouseDay} = [map(i_map).peakPosition_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition];
                map(i_map).eachSpaDivLickCount_allMice{i_mouseDay, 1} = [map(i_map).eachSpaDivLickCount_allMice{i_mouseDay} meta_data{i_mouse, i_mouseDay}.eachSpaDivLickSum_mat(1:meta_data{i_mouse, i_mouseDay}.lapLimit,:)']; 
                map(i_map).eachSpaDivSpeed_allMice{i_mouseDay, 1}     = [map(i_map).eachSpaDivSpeed_allMice{i_mouseDay}     meta_data{i_mouse, i_mouseDay}.eachSpaDivSpeed_mat(1:meta_data{i_mouse, i_mouseDay}.lapLimit,:)'];
                map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1}     = [map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay}     mean(meta_data{i_mouse, i_mouseDay}.eachSpaDivSpeed_mat(1:meta_data{i_mouse, i_mouseDay}.lapLimit,:)', 2, 'omitnan')];
                map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1} = [map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1} meta_data{i_mouse, i_mouseDay}.eachSpaDivLickProbability];
                map(i_map).eachCellSpaInf_allMice{i_mouseDay, 1} = [map(i_map).eachCellSpaInf_allMice{i_mouseDay, 1}; meta_data{i_mouse, i_mouseDay}.eachCellSpaInf'];
                
                map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay} = [map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay} ...
                    meta_data{i_mouse, i_mouseDay}.avg_eachSpaDivFd_sm];
                
                % spatial cross correlation matrix
                map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrLag);
                map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrValue);
                % sig xcorr only removes corr-coefficient < 0.1 comparisons
                map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrLag_SigXCorrOnly);
                map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrValue_SigXCorrOnly);
                
                % this dimension is designed for cell2mat dimension routine
                if meta_data{i_mouse, i_mouseDay}.lapLimit < lapLimit % dimension compensation required for lapNum
                    [sizeA, sizeB, sizeC] = size(meta_data{i_mouse, i_mouseDay}.eachSpaDivFd) %spaDivNum, lapNum, cellNum
                    X = cat(2, meta_data{i_mouse, i_mouseDay}.eachSpaDivFd,    nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                    X_sm = cat(2, meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm, nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                    X_smLarge = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFdLarge_sm, nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                    X_isLarge = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent, nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                    
                    Z = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    Z_Change = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    Z_SigLapOnly = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    Z_SigLapOnly_Change = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    
                    A = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension, each lap peak amplitude
                    A_SigLapOnly = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension, each lap peak amplitude, sig only
                    
                    SI = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    SI_Sig= cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    SI_NotSig = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_NotSigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                    SL = cat(1, meta_data{i_mouse, i_mouseDay}.isSigLap, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension. SL: sig lap
                    LE = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).isLargeEventLap, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension. LE: large event
                    
                    if isempty(map(i_map).eachSpaDivFd_allMice{i_mouseDay}) == false % not empty
                        map(i_map).eachSpaDivFd_allMice{i_mouseDay}    = cat(3, map(i_map).eachSpaDivFd_allMice{i_mouseDay}, X); % 3 is cellnum dimension
                        map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}, X_sm); % 3 is cellnum dimension
                        map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay}, X_smLarge); % 3 is cellnum dimension
                        map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay}, X_isLarge); % 3 is cellnum dimension
                        map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_allMice{i_mouseDay}, Z); % 2 is cellnum dimension
                        map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay}, Z_Change); % 2 is cellnum dimension
                        map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay}, Z_SigLapOnly); % 2 is cellnum dimension
                        map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay}, Z_SigLapOnly_Change); % 2 is cellnum dimension
                        
                        map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay}, A); % 2 is cellnum dimension
                        map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay}, A_SigLapOnly); % 2 is cellnum dimension
                        
                        map(i_map).eachLapSI_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_allMice{i_mouseDay}, SI); % 2 is cellnum dimension
                        map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_allMice{i_mouseDay}, SI_Sig); % 2 is cellnum dimension
                        map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_allMice{i_mouseDay}, SI_NotSig); % 2 is cellnum dimension
                        map(i_map).isSigLap_allMice{i_mouseDay} = cat(2, map(i_map).isSigLap_allMice{i_mouseDay}, SL); % 2 is cellnum dimension
                        map(i_map).isLargeEventLap_allMice{i_mouseDay} = cat(2, map(i_map).isLargeEventLap_allMice{i_mouseDay}, LE); % 2 is cellnum dimension
                    else % map(i_map).eachSpaDivFd_allMice{i_mouseDay} is empty
                        map(i_map).eachSpaDivFd_allMice{i_mouseDay}    = X;
                        map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = X_sm;
                        map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = X_smLarge;
                        map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = X_isLarge;
                        map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = Z;
                        map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = Z_Change;
                        map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = Z_SigLapOnly;
                        map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = Z_SigLapOnly_Change;
                        
                        map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = A;
                        map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = A_SigLapOnly;
                        
                        map(i_map).eachLapSI_allMice{i_mouseDay} = SI;
                        map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = SI_Sig;
                        map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = SI_NotSig;
                        map(i_map).isSigLap_allMice{i_mouseDay} = SL;
                        map(i_map).isLargeEventLap_allMice{i_mouseDay} = LE;
                    end
                else % enough laps for dimension matching across animals
                    % 
                    if isempty(map(i_map).eachSpaDivFd_allMice{i_mouseDay}) == false 
                        map(i_map).eachSpaDivFd_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFd_allMice{i_mouseDay},       meta_data{i_mouse, i_mouseDay}.eachSpaDivFd(:,1:meta_data{i_mouse, i_mouseDay}.lapLimit,    :)); % 3 is cellnum dimension
                        map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:,1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 3 is cellnum dimension
                        map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFdLarge_sm(:,1:meta_data{i_mouse, i_mouseDay}.lapLimit,:)); % 3 is cellnum dimension
                        map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent(:,1:meta_data{i_mouse, i_mouseDay}.lapLimit,:)); % 3 is cellnum dimension
                        map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        
                        map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        
                        map(i_map).eachLapSI_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_NotSigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).isSigLap_allMice{i_mouseDay} = cat(2, map(i_map).isSigLap_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.isSigLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        map(i_map).isLargeEventLap_allMice{i_mouseDay} = cat(2, map(i_map).isLargeEventLap_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).isLargeEventLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                    else % is empty for variable, no need for cat, just assign
                        map(i_map).eachSpaDivFd_allMice{i_mouseDay}    = meta_data{i_mouse, i_mouseDay}.eachSpaDivFd(:,    1:meta_data{i_mouse, i_mouseDay}.lapLimit,:);
                        map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.eachSpaDivFd_sm(:, 1:meta_data{i_mouse, i_mouseDay}.lapLimit,:);
                        map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFdLarge_sm(:, 1:meta_data{i_mouse, i_mouseDay}.lapLimit,:);
                        map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent(:, 1:meta_data{i_mouse, i_mouseDay}.lapLimit,:);
                        map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        
                        map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        
                        map(i_map).eachLapSI_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_NotSigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).isSigLap_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.isSigLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        map(i_map).isLargeEventLap_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).isLargeEventLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                    end
                end
                % reward shift, remap experiment
            elseif isRemap{i_mouse}{i_mouseDay} == true
                for i_map = 1:2
                    i_map;
                    
                    map(i_map).lapNum_allMice(i_mouse, i_mouseDay)     = meta_data{i_mouse, i_mouseDay}.lapNum;
                    map(i_map).cellNum_allMice(i_mouse, i_mouseDay)     = meta_data{i_mouse, i_mouseDay}.cellNum;
                    map(i_map).pcNum_allMice(i_mouse, i_mouseDay)       = meta_data{i_mouse, i_mouseDay}.map(i_map).numPlaceCell;   % save the map1 numPlaceCell       first
                    map(i_map).stablePCNum_allMice(i_mouse, i_mouseDay) = meta_data{i_mouse, i_mouseDay}.map(i_map).numStablePCell; % save the map1 numStablePlaceCell first
                    
                    map(i_map).pcIdx_allMice{i_mouseDay}       = [map(i_map).pcIdx_allMice{i_mouseDay};       map(i_map).cellNum_cumsum(i, i_mouseDay) + meta_data{i_mouse, i_mouseDay}.map(i_map).pcIdx];
                    map(i_map).stablePCIdx_allMice{i_mouseDay} = [map(i_map).stablePCIdx_allMice{i_mouseDay}; map(i_map).cellNum_cumsum(i, i_mouseDay) + meta_data{i_mouse, i_mouseDay}.map(i_map).pcIdxStable];
                    map(i_map).firstLapIdx_allMice{i_mouseDay} = [map(i_map).firstLapIdx_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapIdx];
                    map(i_map).onsetLapIdx_allMice{i_mouseDay} = [map(i_map).onsetLapIdx_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.map(i_map).onsetLapIdx];
                    map(i_map).peakPosition_allMice{i_mouseDay} = [map(i_map).peakPosition_allMice{i_mouseDay}; meta_data{i_mouse, i_mouseDay}.map(i_map).peakPosition];
                    map(i_map).eachSpaDivLickCount_allMice{i_mouseDay,1} = [map(i_map).eachSpaDivLickCount_allMice{i_mouseDay}   meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivLickSum(1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:)']; 
                    map(i_map).eachSpaDivSpeed_allMice{i_mouseDay,1}     = [map(i_map).eachSpaDivSpeed_allMice{i_mouseDay}       meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivSpeed(1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:)'];
                    map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay,1}     = [map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay}       mean(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivSpeed(1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:)', 2, 'omitnan')];
                    map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1} = [map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1} meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivLickProbability]
                    map(i_map).eachCellSpaInf_allMice{i_mouseDay, 1} = [map(i_map).eachCellSpaInf_allMice{i_mouseDay, 1}; meta_data{i_mouse, i_mouseDay}.map(i_map).eachCellSpaInf']
                    
                    
                    % spatial cross correlation matrix
                    map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrLag);
                    map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrValue);
                    % sig xcorr only removes corr-coefficient < 0.1 comparisons
                    map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrLag_SigXCorrOnly_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrLag_SigXCorrOnly);
                    map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1} = cat(3, map(i_map).spatialXCorrValue_SigXCorrOnly_allMice{i_mouseDay, 1}, meta_data{i_mouse, i_mouseDay}.map(i_map).spatialXCorrValue_SigXCorrOnly);
                    
                    % current version of onsetFieldReliability is not
                    % calculated corrected from the imported data. need to
                    % be re-calculated as below
                    cellNum = meta_data{i_mouse, i_mouseDay}.cellNum
                    meta_data{i_mouse, i_mouseDay}.map(i_map).onsetFieldReliability = nan(cellNum,1);
                    for i_cell = 1:cellNum
                        meta_data{i_mouse, i_mouseDay}.map(i_map).onsetFieldReliability(i_cell) = mean(meta_data{i_mouse, i_mouseDay}.map(i_map).isSigLap(meta_data{i_mouse, i_mouseDay}.map(i_map).firstLapIdx(i_cell):meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit, i_cell), 1, 'omitnan'); % onset lap to lapLimit
                    end
                    map(i_map).onsetFieldReliability_allMice{i_mouseDay} = [map(i_map).onsetFieldReliability_allMice{i_mouseDay}; (meta_data{i_mouse, i_mouseDay}.map(i_map).onsetFieldReliability)];
                    map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay} = [ map(i_map).avg_eachSpaDivFd_sm_allMice{i_mouseDay} ...
                        meta_data{i_mouse, i_mouseDay}.map(i_map).avg_eachSpaDivFd_sm ];
                    
                    if meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit < lapLimit
                        [sizeA, sizeB, sizeC] = size(meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd); %spaDivNum, lapNum, cellNum
                        X = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd,    nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                        X_sm = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm, nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                        X_smLarge = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFdLarge_sm, nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension
                        X_isLarge = cat(2, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent, nan(sizeA, lapLimit-sizeB, sizeC)); % 2 is lapnum dimension

                        Z = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        Z_Change = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        Z_SigLapOnly = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        Z_SigLapOnly_Change = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        
                        
                        A = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension, each lap peak amplitude
                        A_SigLapOnly = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension, each lap peak amplitude, sig only
                        
                        SI = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        SI_Sig = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_SigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        SI_NotSig = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_NotSigLapOnly, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension
                        SL = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).isSigLap, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension. SL: sig lap
                        LE = cat(1, meta_data{i_mouse, i_mouseDay}.map(i_map).isLargeEventLap, nan(lapLimit-sizeB, sizeC)); % 1 is lapNum dimension. LE: large event
                        if isempty(map(i_map).eachSpaDivFd_allMice{i_mouseDay}) == false
                            
                            map(i_map).eachSpaDivFd_allMice{i_mouseDay} =    cat(3, map(i_map).eachSpaDivFd_allMice{i_mouseDay}, X); % 3 is cellnum dimension
                            map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}, X_sm); % 3 is cellnum dimension
                            map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay}, X_smLarge); % 3 is cellnum dimension
                            map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay}, X_isLarge); % 3 is cellnum dimension
                            map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_allMice{i_mouseDay}, Z); % 2 is cellnum dimension
                            map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay}, Z_Change); % 2 is cellnum dimension
                            map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay}, Z_SigLapOnly); % 2 is cellnum dimension
                            map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay}, Z_SigLapOnly_Change); % 2 is cellnum dimension
                            
                            map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay}, A); % 2 is cellnum dimension
                            map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay}, A_SigLapOnly); % 2 is cellnum dimension
                            
                            map(i_map).eachLapSI_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_allMice{i_mouseDay}, SI); % 2 is cellnum dimension
                            map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay}, SI_Sig); % 2 is cellnum dimension
                            map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay}, SI_NotSig); % 2 is cellnum dimension
                            map(i_map).isSigLap_allMice{i_mouseDay} = cat(2, map(i_map).isSigLap_allMice{i_mouseDay}, SL); % 2 is cellnum dimension
                            map(i_map).isLargeEventLap_allMice{i_mouseDay} = cat(2, map(i_map).isLargeEventLap_allMice{i_mouseDay}, LE); % 2 is cellnum dimension
                        else
                            map(i_map).eachSpaDivFd_allMice{i_mouseDay}    = X;
                            map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = X_sm;
                            map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = X_smLarge;
                            map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = X_isLarge;
                            map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = Z;
                            map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = Z_Change;
                            map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = Z_SigLapOnly;
                            map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = Z_SigLapOnly_Change;
                            
                            map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = A;
                            map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = A_SigLapOnly;
                            
                            map(i_map).eachLapSI_allMice{i_mouseDay} = SI;
                            map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = SI_Sig;
                            map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = SI_NotSig;
                            map(i_map).isSigLap_allMice{i_mouseDay} = SL;
                            map(i_map).isLargeEventLap_allMice{i_mouseDay} = LE;
                        end
                    else % enough laps for dimension matching across animals, >= 100 laps
                        if isempty(map(i_map).eachSpaDivFd_allMice{i_mouseDay}) == false
                            map(i_map).eachSpaDivFd_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFd_allMice{i_mouseDay},       meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd(:,           1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit, :)); % 3 is cellnum dimension
                            map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,        1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit, :)); % 3 is cellnum dimension
                            map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFdLarge_sm(:,1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:)); % 3 is cellnum dimension
                            map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = cat(3, map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent(:,1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:)); % 3 is cellnum dimension
                            map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            
                            map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            
                            map(i_map).eachLapSI_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = cat(2, map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_NotSigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).isSigLap_allMice{i_mouseDay} = cat(2, map(i_map).isSigLap_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).isSigLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                            map(i_map).isLargeEventLap_allMice{i_mouseDay} = cat(2, map(i_map).isLargeEventLap_allMice{i_mouseDay}, meta_data{i_mouse, i_mouseDay}.map(i_map).isLargeEventLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :)); % 2 is cellnum dimension
                        else % what is this for?
                            map(i_map).eachSpaDivFd_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd(:,      1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:);
                            map(i_map).eachSpaDivFd_sm_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFd_sm(:,      1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:);
                            map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent(:, 1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:);
                            map(i_map).eachSpaDivFdLarge_sm_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDivFdLarge_sm(:, 1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:);
                            map(i_map).eachSpaDiv_isLargeEvent_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachSpaDiv_isLargeEvent(:, 1:meta_data{i_mouse, i_mouseDay}.map(i_map).lapLimit,:);
                            map(i_map).eachLapPeakPosition_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).eachLapPeakPositionChange_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).eachLapPeakPosition_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPosition_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).eachLapPeakPositionChange_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakPositionChange_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            
                            map(i_map).eachLapPeakAmplitude_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).eachLapPeakAmplitude_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            
                            map(i_map).eachLapSI_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).eachLapSI_SigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_SigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).eachLapSI_NotSigLapOnly_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapSI_NotSigLapOnly(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).isSigLap_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).isSigLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                            map(i_map).isLargeEventLap_allMice{i_mouseDay} = meta_data{i_mouse, i_mouseDay}.map(i_map).isLargeEventLap(1:meta_data{i_mouse, i_mouseDay}.lapLimit, :);
                        end
                    end
                    
                end
            end
        end
        
    end
end




% second group, isPC_i_andj, isPC_i_or_j, isPC_i_not_j
% meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}
for i_map = 1:2
    map(i_map).isPC_i_and_j = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).isPC_i_or_j = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).isPC_i_not_j = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).peakPositionChange_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).isSpaceAssociated_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).isRewardAssociated_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).is_neither_space_nor_reward_associated_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapPeakAmplitude_inField_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapPeakAmplitude_inField_shift_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    
    map(i_map).eachLapMeanAmplitude_inField_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapMeanAmplitude_inField_shift_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    
    % adv lick trials only and adv lick trial excluded
    map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapMeanAmplitude_withAdvLick_inField_shift_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    
    map(i_map).eachLapIsActive_inField_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    map(i_map).eachLapIsActive_inField_shift_allMice = cell(length(mouseDayIdx), length(mouseDayIdx), 2);
    
end

for i = 1:length(mouseDayIdx)
    i_mouseDay = mouseDayIdx(i)
    for j = 1:length(mouseDayIdx)
        j_mouseDay = mouseDayIdx(j);
        for i_map = 1:2 % array initialization
            for j_map = 1:2
                map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                
                map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                % only include adv lick trials vs excluding adv lick trials
                map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapMeanAmplitude_withAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                
                
                map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [];
                
            end
        end
    end
    
    for ii = 1:length(mouseGroupIdx)
        i_mouse = mouseGroupIdx(ii);
        i_mouseDay;
        if meta_data{i_mouse, i_mouseDay}.isEmpty
            % no actions required
        else
            if isRemap{i_mouse}{i_mouseDay} == false
                i_map = 1;
                for j = 1:length(mouseDayIdx)
                    j_mouseDay = mouseDayIdx(j);
                    if meta_data{i_mouse, j_mouseDay}.isEmpty
                        % no actions required
                    else
                        if isRemap{i_mouse}{j_mouseDay} == false
                            j_map = 1
                            map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}]);
                            map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map}]);
                            map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_not_j{j_mouseDay, j_map}]);
                            
                            map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).peakPositionChange{j_mouseDay, j_map}];
                            map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}];
                            map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}];
                            map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}];
                            
                            map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField{j_mouseDay, j_map}];
                            map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift{j_mouseDay, j_map}];
                            
                            map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}];
                            map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift{j_mouseDay, j_map}];
                            % adv lick trials only vs excluding add lick trials
                            map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                            map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                            map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                            map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                            
                            
                            map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField{j_mouseDay, j_map}];
                            map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift{j_mouseDay, j_map}];
                            
                            j_map = 2; % no actions required
                        elseif isRemap{i_mouse}{j_mouseDay}
                            for j_map = 1:2
                                map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}]);
                                map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map}]);
                                map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_not_j{j_mouseDay, j_map}]);
                                
                                map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).peakPositionChange{j_mouseDay, j_map}];
                                map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}];
                                map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}];
                                map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}];
                                
                                map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift{j_mouseDay, j_map}];
                                
                                map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift{j_mouseDay, j_map}];
                                % adv lick trials only vs excluding add lick trials
                                map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                                
                            
                                
                                map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift{j_mouseDay, j_map}];
                            end
                        end
                    end
                end
            elseif isRemap{i_mouse}{i_mouseDay}
                for i_map = 1:2
                    for j = 1:length(mouseDayIdx)
                        j_mouseDay = mouseDayIdx(j);
                        if meta_data{i_mouse, j_mouseDay}.isEmpty
                            % no actions required
                        else
                            if isRemap{i_mouse}{j_mouseDay} == false
                                j_map = 1;
                                map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}]);
                                map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map}]);
                                map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_not_j{j_mouseDay, j_map}]);
                                
                                map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).peakPositionChange{j_mouseDay, j_map}];
                                map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}];
                                map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}];
                                map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}];
                                
                                map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift{j_mouseDay, j_map}];
                                
                                map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift{j_mouseDay, j_map}];
                                
                                % adv lick trials only vs excluding add lick trials
                                map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                                
                                map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField{j_mouseDay, j_map}];
                                map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                    meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift{j_mouseDay, j_map}];
                                
                                j_map = 2; % no actions required
                            elseif isRemap{i_mouse}{j_mouseDay}
                                for j_map = 1:2
                                    map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_and_j{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_and_j{j_mouseDay, j_map}]);
                                    map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_or_j{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_or_j{j_mouseDay, j_map}]);
                                    map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map} = logical([map(i_map).isPC_i_not_j{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).isPC_i_not_j{j_mouseDay, j_map}]);
                                    
                                    map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).peakPositionChange_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).peakPositionChange{j_mouseDay, j_map}];
                                    map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isSpaceAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).isSpaceAssociated{j_mouseDay, j_map}];
                                    map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).isRewardAssociated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).isRewardAssociated{j_mouseDay, j_map}];
                                    map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).is_neither_space_nor_reward_associated_allMice{i_mouseDay, j_mouseDay, j_map}; ...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).is_neither_space_nor_reward_associated{j_mouseDay, j_map}];
                                    
                                    map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField{j_mouseDay, j_map}];
                                    map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapPeakAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapPeakAmplitude_inField_shift{j_mouseDay, j_map}];
                                    
                                    map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField{j_mouseDay, j_map}];
                                    map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_inField_shift{j_mouseDay, j_map}];
                                    
                                    % adv lick trials only vs excluding add lick trials
                                    map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                                    map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                                    map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withAdvLick_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withAdvLick_inField{j_mouseDay, j_map}];
                                    map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapMeanAmplitude_withOutAdvLick_inField_shift{j_mouseDay, j_map}];
                                    
                                    map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField{j_mouseDay, j_map}];
                                    map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map} = [map(i_map).eachLapIsActive_inField_shift_allMice{i_mouseDay, j_mouseDay, j_map},...
                                        meta_data{i_mouse, i_mouseDay}.map(i_map).eachLapIsActive_inField_shift{j_mouseDay, j_map}];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end
