function rateFractionChange = calculateRateFractionChange(rate_i, rate_j, rateChangeLapIdx)


meanRateToday =  (mean(rate_i(rateChangeLapIdx, :), 1, 'omitnan'))';
%             display([num2str(sum(meanRateToday<0)), ' pc low activity, rate Today'])
meanRateToday(meanRateToday<0) = 0;
meanRateTomo = (mean(rate_j(rateChangeLapIdx, :), 1, 'omitnan'))';
%             display([num2str(sum(meanRateTomo<0)), ' pc low activity, rate Tomo'])
meanRateTomo(meanRateTomo<0) = 0;

rateFractionChange = (meanRateTomo - meanRateToday) ./ (meanRateTomo + meanRateToday);
end