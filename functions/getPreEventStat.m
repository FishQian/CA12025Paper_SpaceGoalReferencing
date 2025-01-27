function [preEvent_MeanOfPFWidth, preEvent_MeanOfSpeed, preEventPFCOM, preEvent_PFWidthofMean, preEvent_SpeedOfMean, preEvent_fieldFdSum] = ...
    getPreEventStat(Fd, speed, preEventLapIdx, signalThreshold, spaDivNum, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif)

% initialize variable output
preEvent_MeanOfPFWidth = nan;
preEvent_MeanOfSpeed = nan;
preEventPFCOM = nan;
preEvent_PFWidthofMean = nan;
preEvent_SpeedOfMean = nan;
preEvent_fieldFdSum = nan;

Fd_pre = Fd(:, preEventLapIdx);
speed_pre = speed(:, preEventLapIdx);

% 
X_pre_max = (max(Fd_pre, [], 1, 'omitnan'))';
nanUnreliablePreEventLap = nan(length(preEventLapIdx), 1);
% require at least detectable event for the entire lap to be considered at
% all. otherwise, remove the laps
isPreLapReliable = X_pre_max > signalThreshold;
nanUnreliablePreEventLap(isPreLapReliable) = true;

speedMean_pre = mean(speed_pre .* nanUnreliablePreEventLap', 2, 'omitnan');
X_pre_mean = mean(Fd_pre .* nanUnreliablePreEventLap', 2, 'omitnan');

[mx_pre, X_pre_centerBin] = max(X_pre_mean, [], 1, 'omitnan');

if ~isnan(mx_pre)
    X_pre_recenter = centerVector(X_pre_mean, X_pre_centerBin);
    % the postEventPFCOM calculated is relative to
    % spaDivNum/2
    speedMean_pre_recenter = centerVector(speedMean_pre, X_pre_centerBin);
    [preEvent_PFWidthofMean, preEventPFCOM_recenter, preEvent_SpeedOfMean, preEvent_fieldFdSum] = ...
        calculatePFWidth(X_pre_recenter, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, speedMean_pre_recenter);
    preEventPFCOM = recoverPFLocation(preEventPFCOM_recenter - spaDivNum/2, X_pre_centerBin, spaDivNum);
    PFW_pre = nan(size(Fd_pre,2),1);
    PFSpeed_pre = nan(size(Fd_pre,2),1);
    for i_lap = 1:size(Fd_pre,2)
        [mx2, X_pre_reC] = max(Fd_pre(:, i_lap), [], 1, 'omitnan');
        if ~isnan(mx2)
            F_reC = centerVector(Fd_pre(:, i_lap), X_pre_reC);
            speed_reC = centerVector(speed_pre(:, i_lap), X_pre_reC);
            [PFW_pre(i_lap), ~, PFSpeed_pre(i_lap)] = ...
                calculatePFWidth(F_reC, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, speed_reC);
        end
    end
    % mean of VaribleEachLap, remove unreliable lap
    % variable stats
    preEvent_MeanOfPFWidth = mean(PFW_pre .* nanUnreliablePreEventLap, 'omitnan');
    preEvent_MeanOfSpeed = mean(PFSpeed_pre .* nanUnreliablePreEventLap, 'omitnan');
    %
else
    
end

end