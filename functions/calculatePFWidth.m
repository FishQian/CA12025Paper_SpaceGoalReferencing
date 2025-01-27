function [PFWidth, PFCOM, varargout] = calculatePFWidth(X, edgeThreshold, fieldMaxRatio, InFieldFd_LowPoint, inOutFieldDif, varargin)
%% calculate Place Field Width, if it exists. besides, if output enforced, calculate in-field running speed and in-field dF summation

[peakAmplitude, peakLocation] = max(X, [], 'omitnan');
spaDivNum = length(X);
if ~isnan(peakAmplitude)
    fieldEdge = peakAmplitude * edgeThreshold;
    isField = X > fieldEdge;
    fieldStart = find(isField(1:peakLocation) == 0, 1, 'last');
    fieldEnd = find(isField(peakLocation+1:end) == 0, 1, 'first')+peakLocation;
    if isempty(fieldStart) && isempty(fieldEnd)
        PFWidth = nan;
    else
        PFIdx = (fieldStart:fieldEnd)';
        PFWidth = fieldEnd - fieldStart + 1;
        if ~isempty(fieldStart) && isempty(fieldEnd) % right side all above edgeThreshold
            % field end is at the left wing, search for field end
            fieldEnd_leftWing = find(isField(1:peakLocation) == 0, 1, 'first');
            PFIdx = ([1:fieldEnd_leftWing, fieldStart:spaDivNum])';
            PFWidth = (spaDivNum - fieldStart + 1) + fieldEnd_leftWing;
        elseif isempty(fieldStart) && ~isempty(fieldEnd) % left side all above edgeThreshold
            % field start is at the right wing, searh for new field start
            fieldStart_rightWing = find(isField(peakLocation+1:end) == 0, 1, 'last')+peakLocation;
            PFIdx = ([1:fieldEnd, fieldStart_rightWing:spaDivNum])';
            PFWidth = fieldEnd + (spaDivNum - fieldStart_rightWing + 1);
        end
        
        
        X_outField = X; X_outField(PFIdx) = [];
        X_inFieldMax = max(X(PFIdx), [], 'omitnan');
        X_inFieldMean = mean(X(PFIdx), 'omitnan');
        X_outFieldMean = mean(X_outField, 'omitnan');
        % extra criterion
        if PFWidth > fieldMaxRatio * spaDivNum % 1) field width must be no longer than 90% of the belt, means 45 spatial bins
            PFWidth = nan;
        elseif X_inFieldMax < InFieldFd_LowPoint % 2) in-field Fd_mxsm (mean across 5 laps) has at least 0.1
            PFWidth = nan;
        elseif ~(X_inFieldMean > (inOutFieldDif * X_outFieldMean)) % 3) in-field dFF must be 3 times out-field dFF
            PFWidth = nan;
        end
    end
else
    PFWidth = nan;
end

%% COM is more sensitive to few (but not all) trials of place field shift than Place field peak location
PFCOM = nan;
if ~isnan(PFWidth) % Exist PF
    X_noZero = X; X_noZero(X<0) = 0; % make dFF non zero, negative makes no sense
    X_noZero_inField = X_noZero(PFIdx);
    PFCOM = sum((X_noZero_inField .* PFIdx) ./ sum(X_noZero_inField, 'omitnan'), 'omitnan'); 
end


%% extra criterion, only applies to post-event field identification
%{
                
     1) field width must be no longer than 90% of the belt, means 45 spatial bins
     2) in-field Fd_mxsm (mean across 5 laps) has at least 0.1
     3) in-field dFF must be 3 times out-field dFF
                
%}



% if input speed, then output in-field speed for such trial
if nargin>5 && nargout>3
    % extra input is re-centered velocity
    speed = varargin{1};
    if ~isnan(peakAmplitude) && ~isnan(PFWidth)% the lap is not all nan, exist PF
        varargout{1} = mean(speed(PFIdx), 'omitnan');
        varargout{2} = sum(X(PFIdx), 'omitnan');
    else
        varargout{1} = nan;
        varargout{2} = nan;
    end
elseif nargin>5 && nargout>2
    % extra input is re-centered velocity
    speed = varargin{1};
    if ~isnan(peakAmplitude) && ~isnan(PFWidth)% the lap is not all nan, exist PF
        varargout{1} = mean(speed(PFIdx), 'omitnan');
    else
        varargout{1} = nan;
    end
end

end