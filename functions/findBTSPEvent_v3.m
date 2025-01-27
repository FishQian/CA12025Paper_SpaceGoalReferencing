function  BTSP = findBTSPEvent_v3(eachSpaDivSpeed, eachSpaDivFd_mxsm, eachSpaDivFd_sm, peakPosition_map1_allCell, peakPosition_map2_allCell, peakPositionDif_allCell, numLapFirstReward, lapLimit_v3, signalThreshold, onsetReliability_map1, ...
    fillBinSize, fillBinLogic, sectionBinSize, map1_inFieldBinSize, ...
    fieldSpaBinSize, prePost_eventNum, prePost_plotLapNum, prePost_boostThreshold, preEventReliabilityThreshold, ...
    requirePreEventReliability, requireImmediatePreEventLapReliable, requireBoostReliability, postEventReliabilityThreshold, ...
    edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, ...
    topEvent_prctile, topEvent_AmplitudeMin, isPC, isSpacePC, isRewardPC, isMixPC,...
    isGoalZonePC, isPIZonePC, isSCZonePC, ...
    isRemap, PFCOMShift_binLimit)
%% new-v3

%{
1) separate event amplitude criterion for before and after reward switch
2) for remap, the last 5 laps, no BTSP, because no available 5 laps

%}


%% dumped-v3: (name v2 after double checking)
%{ 
the foundamental difference between v3 and v2
1) v3 takes the prePost_meanFd_inMap1Field vs
prePost_meanFd_outMap1Field time series to show how BTSP modulates
in-out-field (defined as map1-peakPosition +- 45cm) activity

%}


%% the foundamental difference between v2 and original version is 
%{ 
the foundamental difference between v2 and original version is 
1) v2 takes the entire lap data, limit is now 200
2) v2 also calculate the Post-Pre (if there is a pre)
3) v2 takes the entire 200 laps events as baseline to calculate the
threshold of 80 prctile, activities are generally weaker at the second 100
trials, therefore, the 200-lap-concatenated threshold is generally smaller
than the first-100-lap-concatenated thereshold, larger than the
second-100-lap-concatenated threshold. meaning less BTSP events might be
identified using 100 laps only. keep this in mind
%}
% [eachSpaDivFd_mxsm_clean, find_eventStartIdx, find_eventEndIdx,eventNum, eventPeakAmplitude, eventPeakLocation]
% sectionBinSize = 50; % every 25 laps as one section, combine the BTSP event number for per Cell and use it for statistical tests
numSection = lapLimit_v3/sectionBinSize;

BTSP = struct;
BTSP.matrix = [];
BTSP.perCell.matrix = [];

% side branch matrix for per cell data set
BTSP.perCell.columnID.eventNum = 1;
BTSP.perCell.columnID.topEventNum = BTSP.perCell.columnID.eventNum + 1;
BTSP.perCell.columnID.BTSPEventNum = BTSP.perCell.columnID.topEventNum +1;
BTSP.perCell.columnID.AbruptBTSPEventNum = BTSP.perCell.columnID.BTSPEventNum + 1;
BTSP.perCell.columnID.FirstBTSPEventNum = BTSP.perCell.columnID.AbruptBTSPEventNum +1;
BTSP.perCell.columnID.FirstAbruptBTSPEventNum = BTSP.perCell.columnID.FirstBTSPEventNum +1;

BTSP.perCell.columnID.numBTSPEvent_map1 = BTSP.perCell.columnID.FirstAbruptBTSPEventNum +1;
BTSP.perCell.columnID.numBTSPEvent_map2 = BTSP.perCell.columnID.numBTSPEvent_map1 +1;
BTSP.perCell.columnID.numAbruptBTSPEvent_map1 = BTSP.perCell.columnID.numBTSPEvent_map2 +1;
BTSP.perCell.columnID.numAbruptBTSPEvent_map2 = BTSP.perCell.columnID.numAbruptBTSPEvent_map1 +1;
BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_map1 = BTSP.perCell.columnID.numAbruptBTSPEvent_map2 + 1;
BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_map2 = BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_map1 + 1; 
BTSP.perCell.columnID.numAbruptBTSPEvent_PES_map1 = BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_map2 + 1; 
BTSP.perCell.columnID.numAbruptBTSPEvent_PES_map2 = BTSP.perCell.columnID.numAbruptBTSPEvent_PES_map1 + 1; 

BTSP.perCell.columnID.numBTSPEvent_perSection_Start = BTSP.perCell.columnID.numAbruptBTSPEvent_PES_map2 + 1; 
BTSP.perCell.columnID.numBTSPEvent_perSection_End = BTSP.perCell.columnID.numBTSPEvent_perSection_Start + (numSection-1); 

BTSP.perCell.columnID.numAbruptBTSPEvent_perSection_Start = BTSP.perCell.columnID.numBTSPEvent_perSection_End + 1; 
BTSP.perCell.columnID.numAbruptBTSPEvent_perSection_End = BTSP.perCell.columnID.numAbruptBTSPEvent_perSection_Start + (numSection-1); 

BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_perSection_Start =  BTSP.perCell.columnID.numAbruptBTSPEvent_perSection_End + 1;
BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_perSection_End =  BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_perSection_Start + (numSection-1);

BTSP.perCell.columnID.numAbruptBTSPEvent_PES_perSection_Start =  BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_perSection_End + 1;
BTSP.perCell.columnID.numAbruptBTSPEvent_PES_perSection_End =  BTSP.perCell.columnID.numAbruptBTSPEvent_PES_perSection_Start + (numSection-1);


BTSP.perCell.columnID.onsetReliabilityOfCell = BTSP.perCell.columnID.numAbruptBTSPEvent_PES_perSection_End + 1;
BTSP.perCell.columnID.isPC = BTSP.perCell.columnID.onsetReliabilityOfCell +1;
BTSP.perCell.columnID.isSpacePC = BTSP.perCell.columnID.isPC +1;
BTSP.perCell.columnID.isRewardPC = BTSP.perCell.columnID.isSpacePC +1;
BTSP.perCell.columnID.isMixPC = BTSP.perCell.columnID.isRewardPC +1;

BTSP.perCell.columnID.isGoalZonePC = BTSP.perCell.columnID.isMixPC +1;
BTSP.perCell.columnID.isPIZonePC = BTSP.perCell.columnID.isGoalZonePC +1;
BTSP.perCell.columnID.isSCZonePC = BTSP.perCell.columnID.isPIZonePC +1;

BTSP.perCell.columnID;

% main BTSP matrix
BTSP.columnID.cellID = 1;
BTSP.columnID.eventID = BTSP.columnID.cellID + 1;
BTSP.columnID.onsetReliabilityOfCell = BTSP.columnID.eventID + 1;
BTSP.columnID.find_eventStartIdx = BTSP.columnID.onsetReliabilityOfCell + 1;
BTSP.columnID.find_eventEndIdx = BTSP.columnID.find_eventStartIdx + 1;
BTSP.columnID.eventPeakAmplitude_mx = BTSP.columnID.find_eventEndIdx + 1;
BTSP.columnID.eventPeakAmplitude_sm = BTSP.columnID.eventPeakAmplitude_mx + 1;
BTSP.columnID.eventPeakLocation = BTSP.columnID.eventPeakAmplitude_sm + 1;

% peak position is less sensitive to (few but not all trials of) place field shift
BTSP.columnID.eventSpaDivIdx = BTSP.columnID.eventPeakLocation + 1 ;
BTSP.columnID.eventLapIdx = BTSP.columnID.eventSpaDivIdx + 1;
BTSP.columnID.eventLapIdx_align2RewardSwitch = BTSP.columnID.eventLapIdx + 1;
BTSP.columnID.postEventPeakLocation = BTSP.columnID.eventLapIdx_align2RewardSwitch +1;
BTSP.columnID.peakLocationShift = BTSP.columnID.postEventPeakLocation + 1;

% COM is more sensitive to (few but not all trials of) place field shift
BTSP.columnID.eventPFCOM = BTSP.columnID.peakLocationShift + 1;
BTSP.columnID.postEventPFCOM = BTSP.columnID.eventPFCOM + 1;
BTSP.columnID.PFCOMShift_Post2Induction = BTSP.columnID.postEventPFCOM + 1;
BTSP.columnID.PFCOMShift_Induction2Pre = BTSP.columnID.PFCOMShift_Post2Induction + 1;

BTSP.columnID.isFirstEvent = BTSP.columnID.PFCOMShift_Induction2Pre+1;
BTSP.columnID.isTopEvent = BTSP.columnID.isFirstEvent + 1;
BTSP.columnID.isFirstTopEvent = BTSP.columnID.isTopEvent +1;
BTSP.columnID.isEvent_boosting = BTSP.columnID.isFirstTopEvent + 1;
BTSP.columnID.isPostEventReliable = BTSP.columnID.isEvent_boosting + 1;
BTSP.columnID.isBTSPEvent = BTSP.columnID.isPostEventReliable + 1;
BTSP.columnID.isAbruptBTSPEvent = BTSP.columnID.isBTSPEvent + 1;
BTSP.columnID.isFirstBTSPEvent = BTSP.columnID.isAbruptBTSPEvent + 1;
BTSP.columnID.isFirstAbruptBTSPEvent = BTSP.columnID.isFirstBTSPEvent + 1;
BTSP.columnID.isFirstAbruptBTSPEvent_LSD = BTSP.columnID.isFirstAbruptBTSPEvent +1;
BTSP.columnID.isFirstAbruptBTSPEvent_PES = BTSP.columnID.isFirstAbruptBTSPEvent_LSD +1;

BTSP.columnID.isEvent_map1 = BTSP.columnID.isFirstAbruptBTSPEvent_PES + 1;
BTSP.columnID.isEvent_map2 = BTSP.columnID.isEvent_map1 + 1
BTSP.columnID.cellPeakPosition_map1 = BTSP.columnID.isEvent_map2 + 1;
BTSP.columnID.cellPeakPosition_map2 = BTSP.columnID.cellPeakPosition_map1 + 1;
BTSP.columnID.cellPeakPosition = BTSP.columnID.cellPeakPosition_map2 +1; 
BTSP.columnID.cellPeakPositionChange = BTSP.columnID.cellPeakPosition + 1;

BTSP.columnID.preEvent_Amplitude = BTSP.columnID.cellPeakPositionChange + 1;
BTSP.columnID.postEvent_Amplitude = BTSP.columnID.preEvent_Amplitude + 1;
BTSP.columnID.preEvent_Reliability = BTSP.columnID.postEvent_Amplitude + 1;
BTSP.columnID.postEvent_Reliability = BTSP.columnID.preEvent_Reliability + 1;
BTSP.columnID.event_PFWidth = BTSP.columnID.postEvent_Reliability + 1;
BTSP.columnID.event_fieldFdSum = BTSP.columnID.event_PFWidth +1;

BTSP.columnID.postEvent_PFWidthOfMean = BTSP.columnID.event_fieldFdSum + 1;
BTSP.columnID.postEvent_MeanOfPFWidth = BTSP.columnID.postEvent_PFWidthOfMean + 1;
BTSP.columnID.postEvent_fieldFdSum = BTSP.columnID.postEvent_MeanOfPFWidth + 1;
BTSP.columnID.postEvent_PFWidth_norm = BTSP.columnID.postEvent_fieldFdSum + 1;
BTSP.columnID.event_fieldRunSpeed = BTSP.columnID.postEvent_PFWidth_norm + 1;
BTSP.columnID.postEvent_SpeedOfMean = BTSP.columnID.event_fieldRunSpeed + 1;
BTSP.columnID.postEvent_MeanOfSpeed = BTSP.columnID.postEvent_SpeedOfMean + 1;

BTSP.columnID.prePostPeakAmplitude_Start = BTSP.columnID.postEvent_MeanOfSpeed + 1;
BTSP.columnID.prePostPeakAmplitude_End = BTSP.columnID.prePostPeakAmplitude_Start + 2*prePost_plotLapNum;

BTSP.columnID.prePostPFCorr_vsPre_Start = BTSP.columnID.prePostPeakAmplitude_End + 1;
BTSP.columnID.prePostPFCorr_vsPre_End = BTSP.columnID.prePostPFCorr_vsPre_Start + 2*prePost_eventNum;

BTSP.columnID.prePostPFCorr_vsPost_Start = BTSP.columnID.prePostPFCorr_vsPre_End + 1;
BTSP.columnID.prePostPFCorr_vsPost_End = BTSP.columnID.prePostPFCorr_vsPost_Start + 2*prePost_eventNum;

BTSP.columnID.prePostPFCorr_vsEvent_Start = BTSP.columnID.prePostPFCorr_vsPost_End + 1;
BTSP.columnID.prePostPFCorr_vsEvent_End = BTSP.columnID.prePostPFCorr_vsEvent_Start + 2*prePost_eventNum;

BTSP.columnID.prePost_meanFd_inMap1Field_Start = BTSP.columnID.prePostPFCorr_vsEvent_End +1;
BTSP.columnID.prePost_meanFd_inMap1Field_End = BTSP.columnID.prePost_meanFd_inMap1Field_Start + 2*prePost_eventNum;

BTSP.columnID.prePost_meanFd_outMap1Field_Start = BTSP.columnID.prePost_meanFd_inMap1Field_End +1;
BTSP.columnID.prePost_meanFd_outMap1Field_End = BTSP.columnID.prePost_meanFd_outMap1Field_Start + 2*prePost_eventNum;

BTSP.columnID.isPC = BTSP.columnID.prePost_meanFd_outMap1Field_End +1;
BTSP.columnID.isSpacePC = BTSP.columnID.isPC + 1;
BTSP.columnID.isRewardPC = BTSP.columnID.isSpacePC +1;
BTSP.columnID.isMixPC = BTSP.columnID.isRewardPC + 1;

BTSP.columnID.isGoalZonePC = BTSP.columnID.isMixPC +1
BTSP.columnID.isPIZonePC = BTSP.columnID.isGoalZonePC +1
BTSP.columnID.isSCZonePC = BTSP.columnID.isPIZonePC +1




BTSP.columnID;
% part 1
lapNum = min(lapLimit_v3, size(eachSpaDivFd_mxsm,2), 'omitnan');
spaDivNum = size(eachSpaDivFd_mxsm, 1);
cellNum = size(eachSpaDivFd_mxsm,3);
eachSpaDivFd_mxsm_clean = nan(spaDivNum, lapNum, cellNum);

% part 2
centerIdx = (spaDivNum/2 - fieldSpaBinSize) : (spaDivNum/2 + fieldSpaBinSize);
prePostEvent_minNum = prePost_eventNum;
fieldIdx = (spaDivNum/2-fieldSpaBinSize) : (spaDivNum/2+fieldSpaBinSize);

for i_cell = 1:cellNum
    
    %% part 1: high calcium event, top 20 prctile of the events is Sachin's protocol and will be my default mode
    a = squeeze(eachSpaDivFd_mxsm(:,1:lapNum, i_cell));
    a_sm = squeeze(eachSpaDivFd_sm(:,1:lapNum, i_cell));
    b = a(:);
    
    isBelowEventBin = fillmissing(b, 'nearest') < signalThreshold(i_cell);
    isBelowEventBin_filled = fillBin(isBelowEventBin, fillBinSize, fillBinLogic);
    
    % filled out some bin first then remove below threshold dF
    b_filled_clean =  a(:);
    b_filled_clean(isBelowEventBin_filled)=0;
    eachSpaDivFd_mxsm_clean(:,:,i_cell) = reshape(b_filled_clean, spaDivNum, lapNum);
    
    % find the start and end of each event
    eventEdge = diff([0; ~isBelowEventBin_filled(1:end-1); 0]); % because of the insertion of 0 at 2 ends, immediate-on event and no-ending events can both be found
    eventStartIdx = eventEdge == 1;
    eventEndIdx = eventEdge == -1;
    
    find_eventStartIdx = find(eventEdge == 1);
    find_eventEndIdx = find(eventEdge == -1);
    if sum(eventEndIdx) ~= sum(eventStartIdx) % one event (must at the edge
        warning('event start and end not matched')
    end
    eventNum = length(find_eventStartIdx);
    
    if eventNum>0 % exist event

        preEvent_Amplitude = nan(eventNum, 1);
        postEvent_Amplitude = nan(eventNum, 1);
        preEvent_Reliability = zeros(eventNum, 1);
        isImmediatePreEventLapReliable = zeros(eventNum, 1);
        postEvent_Reliability = nan(eventNum, 1);
        postEventPeakLocation = nan(eventNum, 1);
        isEvent_boostingReliability = true(eventNum, 1);
        
        cellPeakPosition_map1 = peakPosition_map1_allCell(i_cell) + zeros(eventNum, 1);
        cellPeakPosition_map2 = peakPosition_map2_allCell(i_cell) + zeros(eventNum, 1);
        % peak amplitude and peak location for each event
        cellPeakPositionChange = peakPositionDif_allCell(i_cell) + zeros(eventNum, 1);
        
        eventPeakAmplitude_mx = nan(eventNum, 1);
        eventPeakAmplitude_sm = nan(eventNum, 1);
        eventPeakLocation = nan(eventNum, 1);
        for i_event = 1:eventNum
            eventIdx = find_eventStartIdx(i_event):find_eventEndIdx(i_event);
            [eventPeakAmplitude_mx(i_event), i] = max(a(eventIdx), [], 'omitnan'); % i here is unused, 
            [eventPeakAmplitude_sm(i_event), ~] = max(a_sm(eventIdx), [], 'omitnan');
            if isnan(max(a(eventIdx), [], 'omitnan')) % identified event doesn't have signal, false positive because i.e., nan Fd_mxsm breaks the continuity
                i = nan;
            end
            eventPeakLocation(i_event) = find_eventStartIdx(i_event) + i - 1;
        end
        
        
        % part 2: 50% increase of mean of max in field.
        %{
        1) locate event position ( within the linearied vector), then the lap and spaBin
        2) get pre and post activity mean
        3) get post Center of Mass
        4) get the activity change
        %}
        
        
        [eventSpaDivIdx, eventLapIdx] = ind2sub([spaDivNum, lapNum],eventPeakLocation);
        postEvent_PFWidthofMean = nan(eventNum, 1);
        postEvent_MeanOfPFWidth = nan(eventNum, 1);
        event_PFWidth = nan(eventNum, 1);
        event_fieldRunSpeed = nan(eventNum, 1);
        event_fieldFdSum = nan(eventNum, 1);
        postEvent_fieldFdSum = nan(eventNum, 1);
        prePostPeakAmplitude = nan(eventNum, 2*prePost_plotLapNum + 1);
        prePostPFCorr_vsPost = nan(eventNum, 2*prePost_eventNum + 1);
        prePostPFCorr_vsPre = nan(eventNum, 2*prePost_eventNum + 1);
        prePostPFCorr_vsEvent = nan(eventNum, 2*prePost_eventNum + 1);
        prePost_meanFd_inMap1Field = nan(eventNum, 2*prePost_eventNum + 1);
        prePost_meanFd_outMap1Field = nan(eventNum, 2*prePost_eventNum + 1);
        postEvent_SpeedOfMean = nan(eventNum, 1);
        postEvent_MeanOfSpeed = nan(eventNum, 1);
        postEvent_PFWidth_norm = nan(eventNum, 1);
        eventPFCOM = nan(eventNum, 1);
        postEventPFCOM = nan(eventNum, 1);
        postEventPFCOM_recenter = nan(eventNum, 1);
        prePostFd = cell(eventNum, 1);
        
        % pre-evnt variable
        preEventPFCOM = nan(eventNum, 1);
        preEvent_MeanOfSpeed = nan(eventNum, 1);
        preEvent_MeanOfPFWidth = nan(eventNum, 1);
        
        
        Fd = squeeze(eachSpaDivFd_mxsm(:,1:lapNum,i_cell));
        Fd_sm = squeeze(eachSpaDivFd_sm(:,1:lapNum,i_cell));
        speed = eachSpaDivSpeed(:, 1:lapNum);
        Fd_clean = squeeze(eachSpaDivFd_mxsm_clean(:,1:lapNum,i_cell));
        for i_event = 1:eventNum

           
            % mxsm activities used to identify place field width
            
            Fd_recenter = centerFdMap(Fd, eventSpaDivIdx(i_event));
            speed_recenter = centerFdMap(speed, eventSpaDivIdx(i_event));
            
            %% PF width definition: (Christine's Nature paper) + Dombeck's PF definition
            % not considering at all, the pre-event PF width
            if eventLapIdx(i_event) == 1 % no pre-event lap
                % event lap
                X = Fd_recenter(:, eventLapIdx(i_event));
                speed_eventLap = speed_recenter(:, eventLapIdx(i_event));
                [event_PFWidth(i_event), eventPFCOM(i_event), event_fieldRunSpeed(i_event), event_fieldFdSum(i_event)] = ...
                    calculatePFWidth(X, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, speed_eventLap);
                % post event lap
                postEventLapIdx = (eventLapIdx(i_event)+1):min(lapNum, eventLapIdx(i_event)+5);
                [postEvent_MeanOfPFWidth(i_event), postEvent_MeanOfSpeed(i_event), postEventPFCOM(i_event), ...
                    postEvent_PFWidthofMean(i_event), postEvent_SpeedOfMean(i_event), postEvent_fieldFdSum(i_event)] ...
                    = getPreEventStat(Fd_recenter, speed_recenter, postEventLapIdx, signalThreshold(i_cell), ...
                                        spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif);
                
            elseif eventLapIdx(i_event) <= prePost_eventNum
                % event lap
                X = Fd_recenter(:, eventLapIdx(i_event));
                speed_eventLap = speed_recenter(:, eventLapIdx(i_event));
                [event_PFWidth(i_event), eventPFCOM(i_event), event_fieldRunSpeed(i_event), event_fieldFdSum(i_event)] = ...
                    calculatePFWidth(X, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, speed_eventLap);
                % pre event lap
                preEventLapIdx = 1:(eventLapIdx(i_event) - 1);
                [preEvent_MeanOfPFWidth(i_event), preEvent_MeanOfSpeed(i_event), preEventPFCOM(i_event), ~, ~, ~] = ...
                    getPreEventStat(Fd, speed, preEventLapIdx, signalThreshold(i_cell), ...
                                        spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif);
                % post event lap
                postEventLapIdx = (eventLapIdx(i_event)+1):min(lapNum, eventLapIdx(i_event)+5);
                [postEvent_MeanOfPFWidth(i_event), postEvent_MeanOfSpeed(i_event), postEventPFCOM(i_event), ...
                    postEvent_PFWidthofMean(i_event), postEvent_SpeedOfMean(i_event), postEvent_fieldFdSum(i_event)] ...
                    = getPreEventStat(Fd_recenter, speed_recenter, postEventLapIdx, signalThreshold(i_cell), ...
                    spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif);
            elseif eventLapIdx(i_event) >= lapNum-prePostEvent_minNum+1 % no post BTSP event lap. if 100 total laps, 5 post-event lap, minLap is 5, this means >= 95 laps
                % event lap
                X = Fd_recenter(:, eventLapIdx(i_event)); % event Fd_mxsm, centered around event peak location
                speed_eventLap = speed_recenter(:, eventLapIdx(i_event));
                [event_PFWidth(i_event), eventPFCOM(i_event), event_fieldRunSpeed(i_event), event_fieldFdSum(i_event)] = ...
                    calculatePFWidth(X, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, speed_eventLap);
               
                % pre event lap
                preEventLapIdx = (eventLapIdx(i_event) - 5):(eventLapIdx(i_event) - 1);
                [preEvent_MeanOfPFWidth(i_event), preEvent_MeanOfSpeed(i_event), preEventPFCOM(i_event), ~, ~, ~] = ...
                    getPreEventStat(Fd, speed, preEventLapIdx, signalThreshold(i_cell), ...
                                        spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif);
                
                
            else % have enough pre and post-event laps for calculating postEvent Stats
                % event lap
                X = Fd_recenter(:, eventLapIdx(i_event));
                speed_eventLap = speed_recenter(:, eventLapIdx(i_event));
                [event_PFWidth(i_event), eventPFCOM(i_event), event_fieldRunSpeed(i_event), event_fieldFdSum(i_event)] = ...
                    calculatePFWidth(X, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, speed_eventLap);
                % pre event lap
                preEventLapIdx = (eventLapIdx(i_event) - 5):(eventLapIdx(i_event) - 1);
                [preEvent_MeanOfPFWidth(i_event), preEvent_MeanOfSpeed(i_event), preEventPFCOM(i_event), ~, ~, ~] = ...
                    getPreEventStat(Fd, speed, preEventLapIdx, signalThreshold(i_cell), ...
                                        spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif);
                % post event lap
                postEventLapIdx = (eventLapIdx(i_event)+1):min(lapNum, eventLapIdx(i_event)+5);
                [postEvent_MeanOfPFWidth(i_event), postEvent_MeanOfSpeed(i_event), postEventPFCOM(i_event), ...
                    postEvent_PFWidthofMean(i_event), postEvent_SpeedOfMean(i_event), postEvent_fieldFdSum(i_event)] ...
                    = getPreEventStat(Fd_recenter, speed_recenter, postEventLapIdx, signalThreshold(i_cell), ...
                                        spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif);
            end
            
            %% extra criterion, only applies to post-event field identification
            %{
                    1) field width must be no longer than 90% of the
                    belt, means 45 spatial bins
                    2) in-field Fd_mxsm (mean across 5 laps) has at least
                    0.1
                    3) in-field dFF must be 3 times out-field dFF
            %}
            postEvent_PFWidth_norm(i_event) = postEvent_PFWidthofMean(i_event) / (postEvent_SpeedOfMean(i_event)/event_fieldRunSpeed(i_event));
            % clean Fd_mxsm used to identify BTSP-like events
            
            Fd_clean_recenter = centerFdMap(Fd_clean, eventSpaDivIdx(i_event));
            peak_inField_mx = (max(Fd_clean_recenter(fieldIdx, :), [], 1, 'omitnan'))';
            meanFd_inField = (mean(Fd_clean_recenter(fieldIdx, :), 1, 'omitnan'))';
% % % %             figure;
% % % %             subplot(1,2,1)
% % % %             imagesc(Fd_clean', [0 1]);
% % % %             title(['current event at: ', num2str(eventSpaDivIdx(i_event))])
% % % %             subplot(1,2,2)
% % % %             imagesc(Fd_clean_recenter', [0 1]);


            %%
            if eventLapIdx(i_event) == 1 % first lap has an event
                postEventLapIdx = eventLapIdx(i_event) + (1:5);
                preEvent_Amplitude(i_event) = 0;
                postEvent_Amplitude(i_event) = mean(meanFd_inField(postEventLapIdx), 'omitnan');
                
                preEvent_Reliability(i_event) = 0;
                isImmediatePreEventLapReliable(i_event) = 0;
                postEvent_Reliability(i_event) = mean(peak_inField_mx(postEventLapIdx) > signalThreshold(i_cell), 'omitnan');
                postEventMeanFd = mean(Fd_clean_recenter(spaDivNum/2-24:spaDivNum/2+24, postEventLapIdx), 2, 'omitnan');
                [~, postEventPeakLocation(i_event)] = max(postEventMeanFd,[], 'omitnan');
                if sum(postEventMeanFd, 'omitnan') == 0
                    postEventPeakLocation(i_event) = nan;
                end
                % last few laps not considered
            elseif eventLapIdx(i_event) >= lapNum-prePostEvent_minNum+1
                preEventLapIdx = eventLapIdx(i_event) + (-5:-1);
                preEvent_Amplitude(i_event) = mean(meanFd_inField(preEventLapIdx), 'omitnan');
                postEvent_Amplitude(i_event) = 0;
                preEvent_Reliability(i_event) = mean(peak_inField_mx(preEventLapIdx) > signalThreshold(i_cell), 'omitnan');
                isImmediatePreEventLapReliable(i_event) = mean(peak_inField_mx(eventLapIdx(i_event)-1) > signalThreshold(i_cell), 'omitnan');
                postEvent_Reliability(i_event) = 0;
                postEventPeakLocation(i_event) = nan;
            else
                preEventLapIdx = max(1, eventLapIdx(i_event)-5) : eventLapIdx(i_event)-1;
                postEventLapIdx = (eventLapIdx(i_event)+1) : min(eventLapIdx(i_event)+5, lapNum);

                preEvent_Amplitude(i_event) =  mean(meanFd_inField(preEventLapIdx), 'omitnan');
                postEvent_Amplitude(i_event) = mean(meanFd_inField(postEventLapIdx), 'omitnan');
                preEvent_Reliability(i_event) = mean(peak_inField_mx(preEventLapIdx) > signalThreshold(i_cell), 'omitnan');
                postEvent_Reliability(i_event) = mean(peak_inField_mx(postEventLapIdx) > signalThreshold(i_cell), 'omitnan');
                isImmediatePreEventLapReliable(i_event) = mean(peak_inField_mx(eventLapIdx(i_event)-1) > signalThreshold(i_cell), 'omitnan');
                postEventMeanFd = mean(Fd_clean_recenter(spaDivNum/2-24:spaDivNum/2+24, postEventLapIdx), 2, 'omitnan');
                
                [~, postEventPeakLocation(i_event)] = max(postEventMeanFd,[], 'omitnan');
                if sum(postEventMeanFd, 'omitnan') == 0
                    postEventPeakLocation(i_event) = nan;
                end
            end
            % get entire peak amplitude per lap aligned to event lap idx
            if eventLapIdx(i_event) <= prePost_plotLapNum
                comp = nan(1, prePost_plotLapNum+1-eventLapIdx(i_event));
                prePostPeakAmplitude(i_event, :) = [comp, (meanFd_inField(1:(eventLapIdx(i_event)+prePost_plotLapNum)))'];
            elseif eventLapIdx(i_event) >= (lapNum-prePost_plotLapNum+1)
                comp = nan(1, prePost_plotLapNum-lapNum+eventLapIdx(i_event));
                prePostPeakAmplitude(i_event, :) = [(meanFd_inField((eventLapIdx(i_event)-prePost_plotLapNum):end))', comp];
            else % no compensation required
                prePostPeakAmplitude(i_event, :) = (meanFd_inField((eventLapIdx(i_event)-prePost_plotLapNum):(eventLapIdx(i_event)+prePost_plotLapNum)))';
            end

            %% use peakPosition_map1 to define in-field and out-field spaDivIdx
            if peakPosition_map1_allCell(i_cell) == -5 % not a place cell
                prePost_meanFd_inMap1Field(i_event, :) = nan(prePost_eventNum*2+1, 1);
                prePost_meanFd_outMap1Field(i_event, :) = nan(prePost_eventNum*2+1, 1);
            else
                % recenter the Fd using peakPosition_map1 of each cell
                Fd_recenter_map1 = centerFdMap(Fd_sm, peakPosition_map1_allCell(i_cell)); % Fd_clean remove non-transient activitiy
                if peakPosition_map1_allCell(i_cell)<=25
                    peakPos_oppo = peakPosition_map1_allCell(i_cell) + 25;
                else
                    peakPos_oppo = peakPosition_map1_allCell(i_cell) + 25 - 50;
                end
                Fd_recenter_map1_oppo = centerFdMap(Fd_sm, peakPos_oppo); %
                % in-field out-field defined using map1-peakLocation, 6
                % spatial bins around it (45 cm)
                map1_inFieldIdx = 25-map1_inFieldBinSize:25+map1_inFieldBinSize;
                meanFd_map1_inField = abs((mean(Fd_recenter_map1(map1_inFieldIdx, :), 1, 'omitnan'))');
                meanFd_map1_outField = abs((mean(Fd_recenter_map1_oppo(map1_inFieldIdx, :), 1, 'omitnan'))');
                if eventLapIdx(i_event) <= prePost_eventNum
                    comp = nan(1, prePost_eventNum+1-eventLapIdx(i_event));
                    prePost_meanFd_inMap1Field(i_event, :) = [comp, (meanFd_map1_inField(1:(eventLapIdx(i_event)+prePost_eventNum)))'];
                    prePost_meanFd_outMap1Field(i_event, :) = [comp, (meanFd_map1_outField(1:(eventLapIdx(i_event)+prePost_eventNum)))'];
                elseif eventLapIdx(i_event) >= (lapNum-prePost_eventNum+1)
                    comp = nan(1, prePost_eventNum-lapNum+eventLapIdx(i_event));
                    prePost_meanFd_inMap1Field(i_event, :) = [(meanFd_map1_inField((eventLapIdx(i_event)-prePost_eventNum):end))', comp];
                    prePost_meanFd_outMap1Field(i_event, :) = [(meanFd_map1_outField((eventLapIdx(i_event)-prePost_eventNum):end))', comp];
                else % no compensation required
                    prePost_meanFd_inMap1Field(i_event, :) = (meanFd_map1_inField((eventLapIdx(i_event)-prePost_eventNum):(eventLapIdx(i_event)+prePost_eventNum)))';
                    prePost_meanFd_outMap1Field(i_event, :) = (meanFd_map1_outField((eventLapIdx(i_event)-prePost_eventNum):(eventLapIdx(i_event)+prePost_eventNum)))';
                end
            end
            
            %% place field correlation: against 1)postEventFd_mean, 2)eventLap, 3)preEventFd_mean
            % get the entire prePost_Fd matrix
            if eventLapIdx(i_event) <= prePost_eventNum
                comp = nan(spaDivNum, prePost_eventNum + 1-eventLapIdx(i_event));
                prePostFd{i_event} = [comp, (Fd(:, 1:(eventLapIdx(i_event)+prePost_eventNum)))];
            elseif eventLapIdx(i_event) >= (lapNum-prePost_eventNum+1)
                comp = nan(spaDivNum, prePost_eventNum + eventLapIdx(i_event) - lapNum);
                prePostFd{i_event} = [(Fd(:, (eventLapIdx(i_event)-prePost_eventNum):end)), comp];
            else % no compensation required
                prePostFd{i_event} = (Fd(:, (eventLapIdx(i_event)-prePost_eventNum):(eventLapIdx(i_event)+prePost_eventNum)));
            end
            
            preEventFdTmp = mean(prePostFd{i_event}(:, 1:prePost_eventNum), 2, 'omitnan');
            postEvenFdTmp = mean(prePostFd{i_event}(:, (prePost_eventNum+2):end), 2, 'omitnan');
            eventFdTmp = prePostFd{i_event}(:, prePost_eventNum+1);
            prePostPFCorr_vsPre(i_event, :) = (corr(prePostFd{i_event}, preEventFdTmp))';
            prePostPFCorr_vsPost(i_event, :) = (corr(prePostFd{i_event}, postEvenFdTmp))';
            prePostPFCorr_vsEvent(i_event, :) = (corr(prePostFd{i_event}, eventFdTmp))';
%             figure; 
%             subplot(1,2,1); 
%             imagesc(prePostFd{i_event}', [0 signalThreshold(i_cell)]); colormap jet;
%             y = recoverPFLocation(postEventPFCOM(i_event) - spaDivNum/2, eventSpaDivIdx(i_event), spaDivNum);
%             title(['pre-COM: ', num2str(preEventPFCOM(i_event), '%.2f'), ', post-COM: ', num2str(y, '%.2f')])
%             subplot(1,2,2); 
%             plot(preEventFdTmp, 'b'); hold on;
%             plot(postEvenFdtTmp, 'r'); hold on;
%             plot(eventFdTmp, 'k'); hold on;
%             xlim([0,2*prePost_eventNum+2]); 
%             close

%             tmp = 1;
            
        end
        postEventPeakLocation_abs = recoverPFLocation(postEventPeakLocation - spaDivNum/2, eventSpaDivIdx, spaDivNum);
        postEventPFCOM_abs = recoverPFLocation(postEventPFCOM - spaDivNum/2, eventSpaDivIdx, spaDivNum);
        eventPFCOM_abs = recoverPFLocation(eventPFCOM - spaDivNum/2, eventSpaDivIdx, spaDivNum);
        % force nan if no significant event was detected within the peak
        % range
        
        % preEvent_Reliability enforces within field significant event
        % detection, whereas preEventPFCOM calculates COM without any
        % spatial requirement for the significant event to be at. this is
        % necessary for calculating those that had a big shift of event-pre
        % PFCOM
% % %         if preEvent_Reliability == 0
% % %             preEventPFCOM = nan;
% % %         end
% % %         
% % %         if postEvent_Reliability == 0
% % %             postEventPFCOM_abs = nan;
% % %         end
        peakLocationShift = fieldPositionChange(spaDivNum, eventSpaDivIdx, postEventPeakLocation_abs);
        PFCOMShift_Post2Induction = fieldPositionChange(spaDivNum, eventPFCOM_abs, postEventPFCOM_abs);
        PFCOMShift_Induction2Pre = fieldPositionChange(spaDivNum, preEventPFCOM, eventPFCOM_abs);
        
         % part 0: enforce PF COM shift limit:
        isPFCOMShiftTooBig = abs(PFCOMShift_Post2Induction) > PFCOMShift_binLimit;
        
        % part 1: is top prctile event only
        %% v3 add-on, separate threshold for before and after reward switch
        if ~isRemap
            isTopEvent = (eventPeakAmplitude_mx > max(prctile(eventPeakAmplitude_mx, topEvent_prctile), topEvent_AmplitudeMin));
        elseif isRemap
            if eventNum>0
                isTopEvent = false(size(eventPeakAmplitude_mx));
                topPrct_amplitude_threshold = nan(size(eventPeakAmplitude_mx)); % separate threshold bef-after reward shift
                topPrct_amplitude_threshold(eventLapIdx <= numLapFirstReward) = max(prctile(eventPeakAmplitude_mx(eventLapIdx <= numLapFirstReward), topEvent_prctile), topEvent_AmplitudeMin);
                topPrct_amplitude_threshold(eventLapIdx > numLapFirstReward) = max(prctile(eventPeakAmplitude_mx(eventLapIdx > numLapFirstReward), topEvent_prctile), topEvent_AmplitudeMin);
                
                isBeforeRewardSwitchLap = eventLapIdx <= numLapFirstReward;
                isAfterRewardSwitchLap = eventLapIdx > numLapFirstReward;
                isTopEvent(isBeforeRewardSwitchLap) = (eventPeakAmplitude_mx(isBeforeRewardSwitchLap) > topPrct_amplitude_threshold(isBeforeRewardSwitchLap));
                isTopEvent(isAfterRewardSwitchLap) = (eventPeakAmplitude_mx(isAfterRewardSwitchLap) > topPrct_amplitude_threshold(isAfterRewardSwitchLap));
                
                %% validation purpose, check individual cells with
                % your approach
% % %                 figure;
% % %                 subplot(1,2,1)
% % %                 plot(eventLapIdx, eventPeakAmplitude_mx); hold on;
% % %                 plot(eventLapIdx, topPrct_amplitude_threshold); hold on;
% % %                 plot(eventLapIdx, isTopEvent); hold on;
% % %                 subplot(1,2,2)
% % %                 imagesc(a', [0 5]); colormap jet;
% % %                 axis square
            else % no event found, just regular calculation should work
                isTopEvent = (eventPeakAmplitude_mx > max(prctile(eventPeakAmplitude_mx, topEvent_prctile), topEvent_AmplitudeMin));
            end
        end
        
        %% if isRemap, 96-100 lap no BTSP
        
        if isRemap
            if eventNum > 0
                isDumpLap = (eventLapIdx <= numLapFirstReward) & (eventLapIdx >= numLapFirstReward-4);
                find_isDumpLap = find(isDumpLap == 1);
                if ~isempty(find_isDumpLap) % exist event between dump-lap-range
                    postEvent_Amplitude(find_isDumpLap) = 0;
                    postEvent_Reliability(find_isDumpLap) = 0;
                    postEventPeakLocation(find_isDumpLap) = nan;
                end
            end
            
        end
        
        
        
        % part 2: 50% boosting
        isEvent_boostingActivity = (postEvent_Amplitude > preEvent_Amplitude .* prePost_boostThreshold) & (postEvent_Amplitude > 0);

        % part 3: 4/5 reliability at minimum
        isPostEventReliable = postEvent_Reliability >= postEventReliabilityThreshold;
        isPreEventUnReliable = preEvent_Reliability <= preEventReliabilityThreshold;
        isPostEventPFExist = ~isnan(postEvent_PFWidthofMean); % post-event place field exist

        if requireBoostReliability
            isEvent_boostingReliability = postEvent_Reliability >= preEvent_Reliability;
        end
       
        %% BTSP Event: top event, boosting in-field activity, post-event reliable, postEventExistPF
        % two extra: requireImmediatePreEventLapReliable, requirePreEventReliability
        if requireImmediatePreEventLapReliable & requirePreEventReliability
            isBTSPEvent = isTopEvent & isEvent_boostingActivity & isPostEventReliable & isPostEventPFExist & ~isPFCOMShiftTooBig & ~isImmediatePreEventLapReliable & isPreEventUnReliable & isEvent_boostingReliability;
        elseif requireImmediatePreEventLapReliable & ~requirePreEventReliability
            isBTSPEvent = isTopEvent & isEvent_boostingActivity & isPostEventReliable & isPostEventPFExist & ~isPFCOMShiftTooBig & ~isImmediatePreEventLapReliable & isEvent_boostingReliability;
        elseif ~requireImmediatePreEventLapReliable & requirePreEventReliability
            isBTSPEvent = isTopEvent & isEvent_boostingActivity & isPostEventReliable & isPostEventPFExist & ~isPFCOMShiftTooBig & isPreEventUnReliable & isEvent_boostingReliability;
        elseif ~requireImmediatePreEventLapReliable & ~requirePreEventReliability
            isBTSPEvent = isTopEvent & isEvent_boostingActivity & isPostEventReliable & isPostEventPFExist & ~isPFCOMShiftTooBig & isEvent_boostingReliability;
        end
        
        % get isAbruptBTSPEvent
        % definition of abruptness: farther than 8 spatial bins, or no
        % pre-event at all.
        abruptBinSize = 12;
        isAbrupt = (abs(PFCOMShift_Induction2Pre) > abruptBinSize) | isnan(PFCOMShift_Induction2Pre);
        isAbrupt_largeSpaceDrift = (abs(PFCOMShift_Induction2Pre) > abruptBinSize);
        isAbrupt_preEventSilent = isnan(PFCOMShift_Induction2Pre);
        
        isAbruptBTSPEvent = isBTSPEvent & isAbrupt;
        isAbruptBTSPEvent_LSD = isBTSPEvent & isAbrupt_largeSpaceDrift; % LSD: large spatial drift event;
        isAbruptBTSPEvent_PES = isBTSPEvent & isAbrupt_preEventSilent; % PES: previous 5 trials silent;

        
        isEvent_PC = isPC(i_cell) * ones(eventNum, 1);
        isEvent_spacePC = isSpacePC(i_cell) * ones(eventNum, 1);
        isEvent_rewardPC = isRewardPC(i_cell) * ones(eventNum, 1);
        isEvent_mixPC = isMixPC(i_cell) * ones(eventNum, 1);
        isEvent_goalZonePC = isGoalZonePC(i_cell) * ones(eventNum, 1);
        isEvent_PIZonePC = isPIZonePC(i_cell) * ones(eventNum, 1);
        isEvent_SCZonePC = isSCZonePC(i_cell) * ones(eventNum, 1);
        
        
        %% if less than 100 laps, re-align the number
        eventLapIdx_align2Lap1 = eventLapIdx;
        eventLapIdx_align2RewardSwitch = eventLapIdx;
        if numLapFirstReward < 100
%             eventLapIdx
            d = 100 - numLapFirstReward;
            isMap2 =  eventLapIdx > numLapFirstReward;
            eventLapIdx_align2Lap1(isMap2) = eventLapIdx(isMap2) + d; % only shift the map2 lap index up
            eventLapIdx_align2RewardSwitch = eventLapIdx + d; % entire index vectore shift up
        end
        
        
        % identify first (abrupt) BTSP events out of each map
        % 1) preEventReliability must be 0 (abrupt)
        % 2) only first BTSP out of each map will fit 
        isEvent_map1 = eventLapIdx <= numLapFirstReward;
        isEvent_map2 = eventLapIdx > numLapFirstReward;
        isTopEvent_map1 = isTopEvent & isEvent_map1;
        isTopEvent_map2 = isTopEvent & isEvent_map2;
        isBTSPEvent_map1 = isBTSPEvent & isEvent_map1;
        isBTSPEvent_map2 = isBTSPEvent & isEvent_map2;
        
        % find first BTSP event for each map
        find_firstBTSPEvent_map1 = find(isBTSPEvent_map1==1, 1, 'first');
        find_firstBTSPEvent_map2 = find(isBTSPEvent_map2==1, 1, 'first');
        find_firstAbruptBTSPEvent_map1 = find((isBTSPEvent_map1 & isAbrupt)==1, 1, 'first');
        find_firstAbruptBTSPEvent_map2 = find((isBTSPEvent_map2 & isAbrupt)==1, 1, 'first');
        
        find_firstAbruptBTSPEvent_LSD_map1 = find((isBTSPEvent_map1 & isAbruptBTSPEvent_LSD)==1, 1, 'first');
        find_firstAbruptBTSPEvent_LSD_map2 = find((isBTSPEvent_map2 & isAbruptBTSPEvent_LSD)==1, 1, 'first');
        
        find_firstAbruptBTSPEvent_PES_map1 = find((isBTSPEvent_map1 & isAbruptBTSPEvent_PES)==1, 1, 'first');
        find_firstAbruptBTSPEvent_PES_map2 = find((isBTSPEvent_map2 & isAbruptBTSPEvent_PES)==1, 1, 'first');
        
        % first event and first top event as control
        find_firstEvent_map1 = find(isEvent_map1==1, 1, 'first');
        find_firstEvent_map2 = find(isEvent_map2==1, 1, 'first');
        find_firstTopEvent_map1 = find(isTopEvent_map1==1, 1, 'first');
        find_firstTopEvent_map2 = find(isTopEvent_map2==1, 1, 'first');
        
        isFirstBTSPEvent_map1 = false(size(isBTSPEvent));
        isFirstBTSPEvent_map2 = false(size(isBTSPEvent));
        isFirstAbruptBTSPEvent_map1 = false(size(isBTSPEvent));
        isFirstAbruptBTSPEvent_map2 = false(size(isBTSPEvent));
        isFirstAbruptBTSPEvent_LSD_map1 = false(size(isBTSPEvent));
        isFirstAbruptBTSPEvent_LSD_map2 = false(size(isBTSPEvent));
        isFirstAbruptBTSPEvent_PES_map1 = false(size(isBTSPEvent));
        isFirstAbruptBTSPEvent_PES_map2 = false(size(isBTSPEvent));
        
        isFirstEvent_map1 = false(size(isBTSPEvent));
        isFirstEvent_map2 = false(size(isBTSPEvent));
        isFirstTopEvent_map1 = false(size(isBTSPEvent));
        isFirstTopEvent_map2 = false(size(isBTSPEvent));
        
        % all first BTSP
        if ~isempty(find_firstBTSPEvent_map1) % exist first BTSP Event for map1
            isFirstBTSPEvent_map1(find_firstBTSPEvent_map1) = true;
        end
        if ~isempty(find_firstBTSPEvent_map2) % exist first BTSP Event for map2
            isFirstBTSPEvent_map2(find_firstBTSPEvent_map2) = true;
        end
        % first abrupt BTSP
        if ~isempty(find_firstAbruptBTSPEvent_map1) % exist first BTSP Event for map1
            isFirstAbruptBTSPEvent_map1(find_firstAbruptBTSPEvent_map1) = true;
        end
        if ~isempty(find_firstAbruptBTSPEvent_map2) % exist first BTSP Event for map2
            isFirstAbruptBTSPEvent_map2(find_firstAbruptBTSPEvent_map2) = true;
        end
        
        % first abrupt BTSP, LSD: Large spatial drift event
        if ~isempty(find_firstAbruptBTSPEvent_LSD_map1) % exist first BTSP Event for map1
            isFirstAbruptBTSPEvent_LSD_map1(find_firstAbruptBTSPEvent_LSD_map1) = true;
        end
        if ~isempty(find_firstAbruptBTSPEvent_LSD_map2) % exist first BTSP Event for map2
            isFirstAbruptBTSPEvent_LSD_map2(find_firstAbruptBTSPEvent_LSD_map2) = true;
        end
        
        % first abrupt BTSP, PES: Previous Event Silent
        if ~isempty(find_firstAbruptBTSPEvent_PES_map1) % exist first BTSP Event for map1
            isFirstAbruptBTSPEvent_PES_map1(find_firstAbruptBTSPEvent_PES_map1) = true;
        end
        if ~isempty(find_firstAbruptBTSPEvent_PES_map2) % exist first BTSP Event for map2
            isFirstAbruptBTSPEvent_PES_map2(find_firstAbruptBTSPEvent_PES_map2) = true;
        end
        
        % first event
        if ~isempty(find_firstEvent_map1) % exist first BTSP Event for map1
            isFirstEvent_map1(find_firstEvent_map1) = true;
        end
        if ~isempty(find_firstEvent_map2) % exist first BTSP Event for map2
            isFirstEvent_map2(find_firstEvent_map2) = true;
        end
        
        % first top event
         if ~isempty(find_firstTopEvent_map1) % exist first BTSP Event for map1
            isFirstTopEvent_map1(find_firstTopEvent_map1) = true;
        end
        if ~isempty(find_firstTopEvent_map2) % exist first BTSP Event for map2
            isFirstTopEvent_map2(find_firstTopEvent_map2) = true;
        end
        
        isFirstBTSPEvent = isFirstBTSPEvent_map1 | isFirstBTSPEvent_map2;
        isFirstAbruptBTSPEvent = isFirstAbruptBTSPEvent_map1 | isFirstAbruptBTSPEvent_map2;
        isFirstAbruptBTSPEvent_LSD = isFirstAbruptBTSPEvent_LSD_map1 | isFirstAbruptBTSPEvent_LSD_map2;
        isFirstAbruptBTSPEvent_PES = isFirstAbruptBTSPEvent_PES_map1 | isFirstAbruptBTSPEvent_PES_map2;
        
        isFirstEvent = isFirstEvent_map1 | isFirstEvent_map2;
        isFirstTopEvent = isFirstTopEvent_map1 | isFirstTopEvent_map2;

        
        % peakPosition of this cell for each map, does this correlate with
        % BTSP events
        cellPeakPosition_map1_tmp = cellPeakPosition_map1;
        cellPeakPosition_map1_tmp(isEvent_map2) = 0;
        cellPeakPosition_map2_tmp = cellPeakPosition_map2;
        cellPeakPosition_map2_tmp(isEvent_map1) = 0;
        cellPeakPosition = cellPeakPosition_map1_tmp + cellPeakPosition_map2_tmp;
        
        eventID = (1:eventNum)';
        event_CellID = ones(eventNum, 1) .* i_cell;
        cellOnsetReliability_map1 = ones(eventNum, 1) .* onsetReliability_map1(i_cell);
        BTSP_tmp = [event_CellID, eventID, cellOnsetReliability_map1, find_eventStartIdx, find_eventEndIdx, ...
            eventPeakAmplitude_mx, eventPeakAmplitude_sm, eventPeakLocation, eventSpaDivIdx, eventLapIdx_align2Lap1, eventLapIdx_align2RewardSwitch, postEventPeakLocation_abs, ...
            peakLocationShift, eventPFCOM_abs, postEventPFCOM_abs, PFCOMShift_Post2Induction, PFCOMShift_Induction2Pre,...
            isFirstEvent, isTopEvent, isFirstTopEvent, isEvent_boostingActivity, isPostEventReliable, isBTSPEvent, isAbruptBTSPEvent, isFirstBTSPEvent, isFirstAbruptBTSPEvent, isFirstAbruptBTSPEvent_LSD, isFirstAbruptBTSPEvent_PES, ...
            isEvent_map1, isEvent_map2, cellPeakPosition_map1, cellPeakPosition_map2, cellPeakPosition, cellPeakPositionChange, preEvent_Amplitude, postEvent_Amplitude, ...
            preEvent_Reliability, postEvent_Reliability, event_PFWidth, event_fieldFdSum, postEvent_PFWidthofMean, ...
            postEvent_MeanOfPFWidth, postEvent_fieldFdSum, postEvent_PFWidth_norm, event_fieldRunSpeed, postEvent_SpeedOfMean, ...
            postEvent_MeanOfSpeed, prePostPeakAmplitude, prePostPFCorr_vsPre, prePostPFCorr_vsPost, prePostPFCorr_vsEvent, prePost_meanFd_inMap1Field, prePost_meanFd_outMap1Field, ...
            isEvent_PC, isEvent_spacePC, isEvent_rewardPC, isEvent_mixPC,...
            isEvent_goalZonePC, isEvent_PIZonePC, isEvent_SCZonePC];
        BTSP.matrix = [BTSP.matrix; BTSP_tmp];
        
        % metric for per cell for quantification
        numBTSPEvent_map1 = sum(isBTSPEvent(isEvent_map1), 'omitnan');
        numBTSPEvent_map2 = sum(isBTSPEvent(isEvent_map2), 'omitnan');
        numAbruptBTSPEvent_map1 = sum(isAbruptBTSPEvent(isEvent_map1), 'omitnan');
        numAbruptBTSPEvent_map2 = sum(isAbruptBTSPEvent(isEvent_map2), 'omitnan');
        numAbruptBTSPEvent_LSD_map1 = sum(isAbruptBTSPEvent_LSD(isEvent_map1), 'omitnan');
        numAbruptBTSPEvent_LSD_map2 = sum(isAbruptBTSPEvent_LSD(isEvent_map2), 'omitnan');
        numAbruptBTSPEvent_PES_map1 = sum(isAbruptBTSPEvent_PES(isEvent_map1), 'omitnan');
        numAbruptBTSPEvent_PES_map2 = sum(isAbruptBTSPEvent_PES(isEvent_map2), 'omitnan');
        
        edges = 1:sectionBinSize:(lapLimit_v3+1);
        [numBTSPEvent_perSection, E] = histcounts(eventLapIdx(isBTSPEvent), edges);
        [numAbruptBTSPEvent_perSection, E] = histcounts(eventLapIdx(isAbruptBTSPEvent), edges);
        [numAbruptBTSPEvent_LSD_perSection, E] = histcounts(eventLapIdx(isAbruptBTSPEvent_LSD), edges);
        [numAbruptBTSPEvent_PES_perSection, E] = histcounts(eventLapIdx(isAbruptBTSPEvent_PES), edges);
        
        eventNumPerCell_tmp = [length(isTopEvent), sum(isTopEvent, 'omitnan'), sum(isBTSPEvent, 'omitnan'), sum(isAbruptBTSPEvent, 'omitnan'),sum(isFirstBTSPEvent, 'omitnan'), sum(isFirstAbruptBTSPEvent, 'omitnan'),...
             numBTSPEvent_map1, numBTSPEvent_map2, numAbruptBTSPEvent_map1, numAbruptBTSPEvent_map2, numAbruptBTSPEvent_LSD_map1, numAbruptBTSPEvent_LSD_map2, numAbruptBTSPEvent_PES_map1, numAbruptBTSPEvent_PES_map2,...
             numBTSPEvent_perSection, numAbruptBTSPEvent_perSection, numAbruptBTSPEvent_LSD_perSection, numAbruptBTSPEvent_PES_perSection,  ...
        onsetReliability_map1(i_cell), isPC(i_cell), isSpacePC(i_cell), isRewardPC(i_cell), isMixPC(i_cell), ...
            isGoalZonePC(i_cell), isPIZonePC(i_cell), isSCZonePC(i_cell)];
        BTSP.perCell.matrix = [BTSP.perCell.matrix; eventNumPerCell_tmp];
        
    elseif eventNum == 0
%         BTSP_tmp = [i_cell, nan, onsetReliability(i_cell), nan(1, BTSP.columnID.isMixPC-3)];
%         BTSP.matrix = [BTSP.matrix; BTSP_tmp];
        eventNumPerCell_tmp = [0, 0, 0, 0, 0, 0, ...
            0, 0, 0, 0, 0, 0, 0, 0, ...
            zeros(1, numSection), zeros(1, numSection), zeros(1, numSection), zeros(1, numSection), ...
            onsetReliability_map1(i_cell), isPC(i_cell), isSpacePC(i_cell), isRewardPC(i_cell), isMixPC(i_cell), isGoalZonePC(i_cell), isPIZonePC(i_cell), isSCZonePC(i_cell)];
        BTSP.perCell.matrix = [BTSP.perCell.matrix; eventNumPerCell_tmp];
    end
end


%% part 2: 50% increase of mean of max in field.
%{
1) locate event position ( within the linearied vector), then the lap and spaBin
2) get pre and post activity mean
3) get post Center of Mass
4) get the activity change
%}


