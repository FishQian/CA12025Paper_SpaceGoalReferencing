function [inFieldIdx, inFieldIdx_shift] = peakLocation2_In_Out_FieldIdx(location, binThreshold, spaDivNum)
%% location is the field location
%% binThreshold spatial bin change criterion for defining similar field

location_shift = shiftFieldLocation(location, spaDivNum);


% in field indx
if location <= (spaDivNum - binThreshold) & (location >= binThreshold+1)
    inFieldIdx = (location - binThreshold) : (location + binThreshold);
elseif location <= binThreshold
    inFieldIdx = [(1:location+binThreshold), (spaDivNum+location-binThreshold:spaDivNum)];
elseif location > (spaDivNum - binThreshold)
    inFieldIdx = [(1:location + binThreshold -spaDivNum), (location-binThreshold:spaDivNum)];
    
end

% shifted field index
if location_shift <= (spaDivNum - binThreshold) & (location_shift >= binThreshold+1)
    inFieldIdx_shift = (location_shift - binThreshold) : (location_shift + binThreshold);
elseif location_shift <= binThreshold
    inFieldIdx_shift = [(1:location_shift+binThreshold), (spaDivNum+location_shift-binThreshold:spaDivNum)];
elseif location_shift > (spaDivNum - binThreshold)
    inFieldIdx_shift = [(1:location_shift + binThreshold -spaDivNum), (location_shift-binThreshold:spaDivNum)];
    
end

inFieldIdx = inFieldIdx';
inFieldIdx_shift = inFieldIdx_shift';

end


