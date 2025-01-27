function y = groupAll_RateChange(rateChangeData, positionData, rateChangeGroupIdx, rateChangeLapIdx)
%% group Rate Change data and get the average out of lapIdx, and out of section place cells
%% rateData has the structure of lapnum by cell number


groupRateData = cell(5,1);
meanRateChangeData = mean(rateChangeData(rateChangeLapIdx, :), 1, 'omitnan');
for i = 1:5
    groupRateData{i,1} = [];
end
for i_cell = 1:size(rateChangeData,2)
    i_position = positionData(i_cell);
    
    i_group = rateChangeGroupIdx(i_position);
    if ~isnan(i_group)
        groupRateData{i_group} = [groupRateData{i_group}; meanRateChangeData(i_cell)];
    end
end


y = groupRateData;
end