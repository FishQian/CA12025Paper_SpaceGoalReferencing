function divisionPCRatio = calculateDivPCRatio(PF1, isPCType, numDiv, spaDivNum)

divisionPCRatio = nan(1, numDiv);
for i_div = 1:numDiv % each division generates one ratio
    % spadividx for each division
    divIdx = (1 + (i_div - 1)*(spaDivNum/numDiv)) : i_div*(spaDivNum/numDiv);
    divIdxBegin = divIdx(1);
    divIdxEnd = divIdx(end);
    
    
    % for each division, locate which neuron has a field within this division
    neuronDivIdx = PF1<=divIdxEnd & PF1>=divIdxBegin; % locate neurons belong to this division from PF1
    
    isPCType_div = isPCType(neuronDivIdx); % pf change within this division
    
    divisionPCRatio(i_div) = mean(isPCType_div);
    % 
    
    
end

end