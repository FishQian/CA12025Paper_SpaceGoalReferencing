function deltaFieldPosition = fieldPositionChange(spaDivNum, peakPosition_1, peakPosition_2)
%% the change is -25 is categorized as +25, range: -24-->0-->+25 only
% peakPositino1 and peakPosition2 should come with the same dimension
deltaFieldPosition = nan(length(peakPosition_1),1);
for i_cell = 1:length(peakPosition_1)
    
    if (peakPosition_1(i_cell) == -5) || (peakPosition_2(i_cell) == -5) % doesn't have a peak position: not smPC
        deltaFieldPosition(i_cell) = nan;
    elseif ~isnan(peakPosition_1(i_cell))
        delta = peakPosition_2(i_cell) - peakPosition_1(i_cell);
        if delta <= -(spaDivNum/2) % peakPositin2 smaller than peakPosition1
            
            deltaFieldPosition(i_cell) = delta + spaDivNum;
            
        elseif delta > (spaDivNum/2)
            
            deltaFieldPosition(i_cell) = delta - spaDivNum;
        else
            deltaFieldPosition(i_cell) = delta;
            
        end
        
    elseif isnan(peakPosition_1(i_cell))
        deltaFieldPosition(i_cell) = nan;
%         display('i-th element nan')
    end
    
end
end
