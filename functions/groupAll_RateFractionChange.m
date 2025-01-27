function y = groupAll_RateFractionChange(rateChangeData, positionData, rateChangeGroupIdx)
%% group Rate fraction Change data for each section place cells
%% rateData has the structure of cell number by 1


groupRateData = cell(5,1);
for i = 1:5
    groupRateData{i,1} = [];
end
for i_cell = 1:length(rateChangeData)
    i_position = positionData(i_cell);
    
    i_group = rateChangeGroupIdx(i_position);
    if ~isnan(i_group)
        groupRateData{i_group} = [groupRateData{i_group}; rateChangeData(i_cell)];
    end
end

y = groupRateData;
end