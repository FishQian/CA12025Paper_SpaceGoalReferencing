function y = calculateSPBias(PF1, PF2, binThreshold, spaDivNum)
% input PF1,PF2, binThreshold, spaDivNum, output ratio of 3 types of place
% cells and the spBias = s/(s+p)

delta = abs(fieldPositionChange(spaDivNum, PF1, PF2));

spaceRatio = mean(delta<=binThreshold, 'omitnan');
rewardRatio = mean(delta>= spaDivNum/2 - binThreshold, 'omitnan');
mixRatio = 1 - spaceRatio - rewardRatio;
spBias = spaceRatio/(spaceRatio+rewardRatio);

y = [spaceRatio,rewardRatio, mixRatio, spBias];

