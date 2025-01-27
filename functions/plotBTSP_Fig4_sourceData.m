function plotBTSP_Fig4(BTSPv2, i_mouseDay, i_group, i_map,  ...
    groupNameLabelPool, dayLabel, prePost_plotLapNum, prePost_eventNum, topEvent_prctile, fieldSpaBinSize)

BTSP = BTSPv2;
prePostPeakAmplitude = BTSP.matrix(:, BTSP.columnID.prePostPeakAmplitude_Start:BTSP.columnID.prePostPeakAmplitude_End);
prePostPFCorr_vsPre = BTSP.matrix(:, BTSP.columnID.prePostPFCorr_vsPre_Start:BTSP.columnID.prePostPFCorr_vsPre_End);
prePostPFCorr_vsPost = BTSP.matrix(:, BTSP.columnID.prePostPFCorr_vsPost_Start:BTSP.columnID.prePostPFCorr_vsPost_End);
prePostPFCorr_vsEvent = BTSP.matrix(:, BTSP.columnID.prePostPFCorr_vsEvent_Start:BTSP.columnID.prePostPFCorr_vsEvent_End);

prePost_meanFd_inMap1Field = BTSP.matrix(:, BTSP.columnID.prePost_meanFd_inMap1Field_Start:BTSP.columnID.prePost_meanFd_inMap1Field_End);
prePost_meanFd_outMap1Field = BTSP.matrix(:, BTSP.columnID.prePost_meanFd_outMap1Field_Start:BTSP.columnID.prePost_meanFd_outMap1Field_End);

PFCOMShift_Induction2Pre = BTSP.matrix(:, BTSP.columnID.PFCOMShift_Induction2Pre);
PFCOMShift_Post2Induction = BTSP.matrix(:, BTSP.columnID.PFCOMShift_Post2Induction);
%% postEvent_MeanOfPFWidth = BTSP.matrix(:, BTSP.columnID.postEvent_MeanOfPFWidth) * 3.6;
%% postEvent_PFWidth = BTSP.matrix(:, BTSP.columnID.postEvent_PFWidthOfMean) * 3.6;
postEvent_MeanOfPFWidth = BTSP.matrix(:, BTSP.columnID.postEvent_MeanOfPFWidth) * 3.6;
eventPeakAmplitude_mx  = BTSP.matrix(:, BTSP.columnID.eventPeakAmplitude_mx);

eventPeakAmplitude_sm  = BTSP.matrix(:, BTSP.columnID.eventPeakAmplitude_sm);
velocity  = BTSP.matrix(:, BTSP.columnID.event_fieldRunSpeed) * 100;
eventPFWidth  = BTSP.matrix(:, BTSP.columnID.event_PFWidth) * 3.6;
postEvent_SpeedOfMean  = BTSP.matrix(:, BTSP.columnID.postEvent_SpeedOfMean) * 100;
postEvent_MeanOfSpeed  = BTSP.matrix(:, BTSP.columnID.postEvent_MeanOfSpeed) * 100;
event_fieldFdSum  = BTSP.matrix(:, BTSP.columnID.event_fieldFdSum);
event_fieldRunSpeed  = BTSP.matrix(:, BTSP.columnID.event_fieldRunSpeed);

postEvent_fieldFdSum  = BTSP.matrix(:, BTSP.columnID.postEvent_fieldFdSum);
postEventPFCOM = BTSP.matrix(:, BTSP.columnID.postEventPFCOM);
postEvent_PFWidthOfMean =  BTSP.matrix(:, BTSP.columnID.postEvent_PFWidthOfMean);
eventLapIdx  = BTSP.matrix(:, BTSP.columnID.eventLapIdx);
eventLapIdx_align2RewardSwitch  = BTSP.matrix(:, BTSP.columnID.eventLapIdx_align2RewardSwitch);
eventPFCOM = BTSP.matrix(:, BTSP.columnID.eventPFCOM);
cellPeakPosition = BTSP.matrix(:, BTSP.columnID.cellPeakPosition);
cellPeakPosition_map1 = BTSP.matrix(:, BTSP.columnID.cellPeakPosition_map1);
cellPeakPosition_map2 = BTSP.matrix(:, BTSP.columnID.cellPeakPosition_map2);
event_cellID = BTSP.matrix(:, BTSP.columnID.cellID);
% BTSP.columnID.

isTopEvent  = logical(BTSP.matrix(:, BTSP.columnID.isTopEvent));
isBTSPEvent  = logical(BTSP.matrix(:, BTSP.columnID.isBTSPEvent));
isAbruptBTSPEvent = logical(BTSP.matrix(:, BTSP.columnID.isAbruptBTSPEvent));
% isAbruptBTSPEvent_LSD = logical(BTSP.matrix(:, BTSP.columnID.isAbruptBTSPEvent));
isFirstTopEvent = logical(BTSP.matrix(:, BTSP.columnID.isFirstTopEvent));
isFirstBTSPEvent = logical(BTSP.matrix(:, BTSP.columnID.isFirstBTSPEvent));
isFirstAbruptBTSPEvent = logical(BTSP.matrix(:, BTSP.columnID.isFirstAbruptBTSPEvent));
isSpacePC  = logical(BTSP.matrix(:, BTSP.columnID.isSpacePC));
isRewardPC  = logical(BTSP.matrix(:, BTSP.columnID.isRewardPC));
isMixPC  = logical(BTSP.matrix(:, BTSP.columnID.isMixPC));
isPC = logical(BTSP.matrix(:, BTSP.columnID.isPC));
isEvent_map1 = logical(BTSP.matrix(:, BTSP.columnID.isEvent_map1));
isEvent_map2 = logical(BTSP.matrix(:, BTSP.columnID.isEvent_map2));


perCell_isPC = logical(BTSP.perCell.matrix(:, BTSP.perCell.columnID.isPC));
perCell_isSpacePC = logical(BTSP.perCell.matrix(:, BTSP.perCell.columnID.isSpacePC));
perCell_isRewardPC = logical(BTSP.perCell.matrix(:, BTSP.perCell.columnID.isRewardPC));
perCell_isMixPC = logical(BTSP.perCell.matrix(:, BTSP.perCell.columnID.isMixPC));
perCell_numBTSPEvent_map1 = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numBTSPEvent_map1));
perCell_numBTSPEvent_map2 = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numBTSPEvent_map2));
perCell_numAbruptBTSPEvent_map1 = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numAbruptBTSPEvent_map1));
perCell_numAbruptBTSPEvent_map2 = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numAbruptBTSPEvent_map2));

perCell_numBTSPEvent_perSection = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numBTSPEvent_perSection_Start:BTSP.perCell.columnID.numBTSPEvent_perSection_End));
perCell_numAbruptBTSPEvent_perSection = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numAbruptBTSPEvent_perSection_Start:BTSP.perCell.columnID.numAbruptBTSPEvent_perSection_End));
perCell_numAbruptBTSPEvent_LSD_perSection = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_perSection_Start:BTSP.perCell.columnID.numAbruptBTSPEvent_LSD_perSection_End));
perCell_numAbruptBTSPEvent_PES_perSection = (BTSP.perCell.matrix(:, BTSP.perCell.columnID.numAbruptBTSPEvent_PES_perSection_Start:BTSP.perCell.columnID.numAbruptBTSPEvent_PES_perSection_End));


%% print every allo-ego-mix PC with BTSP events
DataFolder = '/Volumes/FishSSD5/CA1/AnalyzedData_CA1_V01/CA1_paper/allMice'


figure; colorM = cbrewer('qual', 'Set1', 9);sectionNum = 10
subplot(1,sectionNum+1,1)
lapLimit = [100 - 100/sectionNum+1,100]
idx = isBTSPEvent;
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
y1 = prePost_meanFd_inMap1Field ./ (prePost_meanFd_inMap1Field + prePost_meanFd_outMap1Field);
plot(mean(y1(isThisSection & idx & isSpacePC, :), 1, 'omitnan'), 'Color', colorM(2,:)); hold on;
% plot(mean(y1(isThisSection & idx & isMixPC, :), 1, 'omitnan'), 'Color', colorM(9,:)); hold on;
plot(mean(y1(isThisSection & idx & isRewardPC, :), 1, 'omitnan'), 'Color', colorM(1,:)); hold on;
ylim([0 1]);yticks(0:0.25:1);xlim([0.5,2*prePost_eventNum+1.5]);xticklabels({'-5', '0', '+5'});xlim([0.5,2*prePost_eventNum+1.5]); box off;
xticks([1, prePost_eventNum+1, 2*prePost_eventNum+1]);yline(0.5, '--k'); axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
for i_section = 1:sectionNum
    subplot(1,sectionNum+1,i_section+1);
    lapLimit = [101+(i_section-1)*(100/sectionNum), 100+(i_section)*(100/sectionNum)];
    isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
    plot(mean(y1(isThisSection & idx & isSpacePC, :), 1, 'omitnan'), 'Color', colorM(2,:)); hold on;
%     plot(mean(y1(isThisSection & idx & isMixPC, :), 1, 'omitnan'), 'Color', colorM(9,:)); hold on;
    plot(mean(y1(isThisSection & idx & isRewardPC, :), 1, 'omitnan'), 'Color', colorM(1,:)); hold on;
    ylim([0 1]);xlim([0.5,2*prePost_eventNum+1.5]); box off;xlim([0.5,2*prePost_eventNum+1.5]);
    xticks([1, prePost_eventNum+1, 2*prePost_eventNum+1]);xticklabels({'-5', '0', '+5'});
    yline(0.5, '--k');axis square;yticks(0:0.25:1); set(gca, 'TickDir', 'out', 'FontSize', 15);
end


%% Before-BTSP-Mean and After-BTSP-Mean versus lap Idx 
% this scatter plot depicts 1) the natural evolution of IN/OUT selectity
% and how BTSP affect such selectivity
figure; colorM = cbrewer('qual', 'Set1', 9); colorM = cbrewer('qual', 'Paired', 12);
idx = isFirstBTSPEvent;
subplot(2,2,1);
lapLimit = [1,100];
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
y1 = (- prePost_meanFd_inMap1Field + prePost_meanFd_outMap1Field)  ./ (prePost_meanFd_inMap1Field + prePost_meanFd_outMap1Field);
y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
eventLapIdx_allo = eventLapIdx(isThisSection & idx & isSpacePC);
scatter(eventLapIdx_allo, y1_preEvent_allo, 'filled', 'MarkerFaceColor', colorM(1,:), 'MarkerEdgeColor', colorM(1,:)); hold on; scatter(eventLapIdx_allo, y1_postEvent_allo, 'filled', 'MarkerFaceColor', colorM(2,:), 'MarkerEdgeColor', colorM(2,:));
title('Pre, Allo'); legend('Before Event', 'After Event'); ylabel('allocentric selectivity'); ylim([-1 1]);
subplot(2,2,2)
y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');
eventLapIdx_ego = eventLapIdx(isThisSection & idx & isRewardPC);
scatter(eventLapIdx_ego, y1_preEvent_ego, 'filled', 'MarkerFaceColor', colorM(5,:), 'MarkerEdgeColor', colorM(5,:)); hold on; scatter(eventLapIdx_ego, y1_postEvent_ego, 'filled', 'MarkerFaceColor', colorM(6,:), 'MarkerEdgeColor', colorM(6,:));
title('Pre, Ego'); legend('Before Event', 'After Event'); ylabel('allocentric selectivity'); ylim([-1 1]);
subplot(2,2,3)
lapLimit = [101,200]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
y1 = ( - prePost_meanFd_inMap1Field + prePost_meanFd_outMap1Field) ./ (prePost_meanFd_inMap1Field + prePost_meanFd_outMap1Field);
y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
eventLapIdx_allo = eventLapIdx(isThisSection & idx & isSpacePC);
scatter(eventLapIdx_allo, y1_preEvent_allo,'filled','MarkerFaceColor', colorM(1,:), 'MarkerEdgeColor', colorM(1,:)); hold on; scatter(eventLapIdx_allo, y1_postEvent_allo, 'filled', 'MarkerFaceColor', colorM(2,:), 'MarkerEdgeColor', colorM(2,:));
title('Post, Allo'); legend('Before Event', 'After Event'); ylabel('allocentric selectivity'); ylim([-1 1]);
subplot(2,2,4)
y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');
eventLapIdx_ego = eventLapIdx(isThisSection & idx & isRewardPC);
scatter(eventLapIdx_ego, y1_preEvent_ego, 'filled', 'MarkerFaceColor', colorM(5,:), 'MarkerEdgeColor', colorM(5,:)); hold on; scatter(eventLapIdx_ego, y1_postEvent_ego, 'filled', 'MarkerFaceColor', colorM(6,:), 'MarkerEdgeColor', colorM(6,:));
title('Post, Ego'); legend('Before Event', 'After Event'); ylabel('allocentric selectivity'); ylim([-1 1]);

%% Before-BTSP-Mean versus After-BTSP-Mean of 
figure; colorM = cbrewer('qual', 'Set1', 9);sectionNum = 1;
idx = isFirstBTSPEvent;
for i_section = 1:sectionNum
    subplot(2,sectionNum+1,i_section);
    lapLimit = [1+(i_section-1)*(100/sectionNum), (i_section)*(100/sectionNum)];
    isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
    y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
    y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
    y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
    err = [std(y1_preEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo))), std(y1_event_allo, 'omitnan')/sqrt(length(removeNan(y1_event_allo))), std(y1_postEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo)))];
    errorbar([1,2,3], [mean(y1_preEvent_allo, 'omitnan'), mean(y1_event_allo, 'omitnan'), mean(y1_postEvent_allo, 'omitnan'),], err, ...
        '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor', colorM(2,:), 'Color', colorM(2,:)); hold on;
    
    y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
    y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
    y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');
    err = [std(y1_preEvent_ego, 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego))), ...
        std(y1_event_ego, 'omitnan')/sqrt(length(removeNan(y1_event_ego))), ...
        std(y1_postEvent_ego, 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego)))];
    errorbar([1,2,3], [mean(y1_preEvent_ego, 'omitnan'), mean(y1_event_ego, 'omitnan'), mean(y1_postEvent_ego, 'omitnan'),], err, ...
        '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:));
    
    ylim([-1 1]); yticks(-1:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
    yline(0.33, '--k'); yline(-0.33, '--k'); axis square;set(gca, 'TickDir', 'out', 'FontSize', 15);
end
sgtitle('Pre')
% comment out in 0703-2023
% % % % subplot(2,sectionNum+1,sectionNum+2)
% % % % lapLimit = [100 - 100/sectionNum+1,100]
% % % % 
% % % % isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
% % % % y1 = (prePost_meanFd_inMap1Field - prePost_meanFd_outMap1Field) ./ (prePost_meanFd_inMap1Field + prePost_meanFd_outMap1Field);
% % % % 
% % % % y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
% % % % y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
% % % % y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
% % % % err = [std(y1_preEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo))), std(y1_event_allo, 'omitnan')/sqrt(length(removeNan(y1_event_allo))), std(y1_postEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo)))]
% % % % errorbar([1,2,3], [mean(y1_preEvent_allo, 'omitnan'), mean(y1_event_allo, 'omitnan'), mean(y1_postEvent_allo, 'omitnan'),], err, ...
% % % %         '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor',colorM(2,:), 'Color', colorM(2,:)); hold on;
% % % % 
% % % % y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
% % % % y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
% % % % y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');
% % % % err = [std(y1_preEvent_ego, 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego))), ...
% % % % std(y1_event_ego, 'omitnan')/sqrt(length(removeNan(y1_event_ego))), ...
% % % % std(y1_postEvent_ego, 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego)))]
% % % % errorbar([1,2,3], [mean(y1_preEvent_ego, 'omitnan'), mean(y1_event_ego, 'omitnan'), mean(y1_postEvent_ego, 'omitnan'),], err, ...
% % % %         '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:))
% % % % 
% % % % ylim([-1 1]);yticks(-1:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
% % % % yline(0.5, '--k'); axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
for i_section = 1:sectionNum
    subplot(2,sectionNum+1,i_section+1+sectionNum)
    lapLimit = [101+(i_section-1)*(100/sectionNum), 100+(i_section)*(100/sectionNum)];
    isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
    y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
    y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
    y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
    err = [std(y1_preEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo))), std(y1_event_allo, 'omitnan')/sqrt(length(removeNan(y1_event_allo))), std(y1_postEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo)))];
    errorbar([1,2,3], [mean(y1_preEvent_allo, 'omitnan'), mean(y1_event_allo, 'omitnan'), mean(y1_postEvent_allo, 'omitnan'),], err, ...
        '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor', colorM(2,:), 'Color', colorM(2,:)); hold on;
    
    y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
    y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
    y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');
    err = [std(y1_preEvent_ego, 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego))), ...
        std(y1_event_ego, 'omitnan')/sqrt(length(removeNan(y1_event_ego))), ...
        std(y1_postEvent_ego, 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego)))];
    errorbar([1,2,3], [mean(y1_preEvent_ego, 'omitnan'), mean(y1_event_ego, 'omitnan'), mean(y1_postEvent_ego, 'omitnan'),], err, ...
        '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:));
    
    ylim([-1 1]);yticks(-1:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
    yline(0.33, '--k'); yline(-0.33, '--k'); axis square;set(gca, 'TickDir', 'out', 'FontSize', 15);
end
sgtitle('isFirstBTSPEvent')

% Before-BTSP-Mean versus After-BTSP-Mean
% use the first 1-100 laps to establish some criterion
lapLimit = [1, 100]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
idx = isFirstBTSPEvent;
y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');

% histogram of pre-event selectivitiy, allo vs ego
figure;colorM = cbrewer('qual', 'Set1', 9);
binSize = 0.03;
h1=histogram(y1_preEvent_allo, 'BinWidth', binSize, 'Normalization', 'probability'); hold on;
h1.EdgeColor = 'none'; h1.FaceColor = colorM(2,:); h1.FaceAlpha = 0.5
h2 = histogram(y1_preEvent_ego, 'BinWidth', binSize, 'Normalization', 'probability'); hold on;
h2.EdgeColor = 'none'; h2.FaceColor = colorM(1,:); h2.FaceAlpha = 0.5
yline(binSize, '--k');
alloSelectivityThreshold = 0.33;
sgtitle(['lap #', num2str(lapLimit(1)), '-', num2str(lapLimit(2)), ', isFirstBTSPEvent']);
xline(alloSelectivityThreshold, '--k'); xline(0-alloSelectivityThreshold, '--k');
legend('allo','ego'); xlabel('pre-event allocentric selectivity');
set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; axis square;

% selectivity, pre vs post, allo and ego
figure; colorM = cbrewer('qual', 'Set1', 9);
subplot(1,2,1);
scatter(y1_preEvent_allo, y1_postEvent_allo, 250, colorM(2,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on; axis square; 
xlim([-1.02, 1.02]); ylim([-1.02, 1.02]); xticks(-1:0.25:1); yticks(-1:0.25:1); plot((-1:0.01:1), (-1:0.01:1), '--k'); set(gca, 'TickDir', 'out'); xlabel('pre-event selectivity'); ylabel('post-event selectivity');
subplot(1,2,2);
scatter(y1_preEvent_ego, y1_postEvent_ego, 250, colorM(1,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on; axis square;
xlim([-1.02, 1.02]); ylim([-1.02, 1.02]); xticks(-1:0.25:1); yticks(-1:0.25:1); plot((-1:0.01:1), (-1:0.01:1), '--k'); set(gca, 'TickDir', 'out'); xlabel('pre-event selectivity'); ylabel('post-event selectivity');
sgtitle(['lap #', num2str(lapLimit(1)), '-', num2str(lapLimit(2)), ', isFirstBTSPEvent']);

%% Pre-Post-event selectivity, after reward switch
lapLimit = [101, 200]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
idx = isFirstBTSPEvent;
y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');

% histogram of pre-event allocentric selectivity, allov vs ego
figure;colorM = cbrewer('qual', 'Set1', 9);
binSize = 0.03
h1=histogram(y1_preEvent_allo, 'BinWidth', binSize, 'Normalization', 'probability'); hold on;
h1.EdgeColor = 'none'; h1.FaceColor = colorM(2,:); h1.FaceAlpha = 0.5
h2 = histogram(y1_preEvent_ego, 'BinWidth', binSize, 'Normalization', 'probability'); hold on;
h2.EdgeColor = 'none'; h2.FaceColor = colorM(1,:); h2.FaceAlpha = 0.5
xline(alloSelectivityThreshold, 'Color', colorM(3,:)); set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; axis square
xline(0-alloSelectivityThreshold,  'Color', colorM(3,:)); set(gca, 'FontSize', 15, 'TickDir', 'out'); box off; axis square
sgtitle(['lap #', num2str(lapLimit(1)), '-', num2str(lapLimit(2)), ', isFirstBTSPEvent'])
legend('allo','ego');
xlabel('pre-event allocentric selectivity')
% scatter plot, pre vs post
figure;
colorM = cbrewer('qual', 'Set1', 9);
subplot(1,2,1)
scatter(y1_preEvent_allo, y1_postEvent_allo, 250, colorM(2,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on; axis square; 
plot(mean(y1_preEvent_allo), mean(y1_postEvent_allo), 's', 'Color', 'k', 'MarkerSize', 15)
xlim([-1.02, 1.02]); ylim([-1.02, 1.02]); xticks(-1:0.25:1); yticks(-1:0.25:1); plot((-1:0.01:1), (-1:0.01:1), '--k'); set(gca, 'TickDir', 'out'); xlabel('pre-event selectivity'); ylabel('post-event selectivity')
subplot(1,2,2);
scatter(y1_preEvent_ego, y1_postEvent_ego, 250, colorM(1,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on; axis square;
plot(mean(y1_preEvent_ego), mean(y1_postEvent_ego), 's', 'Color', 'k', 'MarkerSize', 15)

xlim([-1.02, 1.02]); ylim([-1.02, 1.02]); xticks(-1:0.25:1); yticks(-1:0.25:1); plot((-1:0.01:1), (-1:0.01:1), '--k'); set(gca, 'TickDir', 'out'); xlabel('pre-event selectivity'); ylabel('post-event selectivity')
sgtitle(['lap #', num2str(lapLimit(1)), '-', num2str(lapLimit(2)), ', isFirstBTSPEvent'])

Fig5e_space_Pre = y1_preEvent_allo;
Fig5e_space_Post = y1_postEvent_allo;
Fig5e_goal_Pre = y1_preEvent_ego;
Fig5e_goal_Post = y1_postEvent_ego;

x1_allo = mean(y1_preEvent_allo < - alloSelectivityThreshold)
x2_allo = mean(y1_preEvent_ego < - alloSelectivityThreshold)

x1_mix = mean((y1_preEvent_allo <= alloSelectivityThreshold & y1_preEvent_allo >= (0-alloSelectivityThreshold)))
x2_mix = mean(y1_preEvent_ego <= alloSelectivityThreshold & y1_preEvent_ego >= (0-alloSelectivityThreshold))


%% Fig5g
figure;
colorM = cbrewer('qual', 'Set1', 9);
subplot(1,2,1)
p11 = pie([x1_allo, x1_mix, (1-x1_allo-x1_mix)], '%.1f%%')
legend({ 'Strong Allo', 'Non-selective','Strong Ego'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'LineWidth', 2.5); set(gca, 'FontSize', 10); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
if size(p11,2)>=6
    p11(6).FontSize = 10; p11(5).EdgeColor = 'none';p11(5).FaceColor = colorM(1, :);
end
% 
p11(2).FontSize = 10; p11(4).FontSize = 10; 
p11(1).EdgeColor = 'none';p11(3).EdgeColor = 'none';

p11(1).FaceColor = colorM(2, :); p11(3).FaceColor = colorM(9, :);


subplot(1,2,2)
p12 = pie([x2_allo, x2_mix, (1-x2_allo-x2_mix)], '%.1f%%')
legend({ 'Strong Allo', 'Non-selective','Strong Ego'}, 'Location', 'northoutside'); legend('boxoff'); box off
set(gca, 'LineWidth', 2.5); set(gca, 'FontSize', 10); set(gca, 'FontName', 'Arial'); set(gca, 'TickDir', 'out', 'TickLength', [0.02 0.05]);
p12(2).FontSize = 10; p12(4).FontSize = 10; p12(6).FontSize = 10; p12(1).EdgeColor = 'none';p12(3).EdgeColor = 'none';p12(5).EdgeColor = 'none';
p12(1).FaceColor = colorM(2, :); p12(3).FaceColor = colorM(9, :);p12(5).FaceColor = colorM(1, :);
sgtitle('isFirstBTSPEvent')

Fig5g_space = [x1_allo, x1_mix, (1-x1_allo-x1_mix)];
Fig5g_goal = [x2_allo, x2_mix, (1-x2_allo-x2_mix)];

%% all event
%% Fig5h
figure;
lapLimit = [101, 200]
idx = isFirstBTSPEvent;
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');

% get the number out for paper
mean(y1_preEvent_allo)
std(y1_preEvent_allo)/sqrt(length(y1_preEvent_allo))

mean(y1_postEvent_allo)
std(y1_postEvent_allo)/sqrt(length(y1_postEvent_allo))

mean(y1_preEvent_ego)
std(y1_preEvent_ego)/sqrt(length(y1_preEvent_ego))

mean(y1_postEvent_ego)
std(y1_postEvent_ego)/sqrt(length(y1_postEvent_ego))

Fig5h_spacePC_sem = [std(y1_preEvent_allo, 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo()))), ...
    std(y1_event_allo(), 'omitnan')/sqrt(length(removeNan(y1_event_allo()))), ...
    std(y1_postEvent_allo(), 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo())))]
Fig5h_spacePC_mean = [mean(y1_preEvent_allo(), 'omitnan'), mean(y1_event_allo(), 'omitnan'), mean(y1_postEvent_allo(), 'omitnan')]
errorbar([1,2,3], Fig5h_spacePC_mean, Fig5h_spacePC_sem, ...
    '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor', colorM(2,:), 'Color', colorM(2,:)); hold on;
[h,p_space] = ttest(y1_preEvent_allo, y1_postEvent_allo)

Fig5h_goalPC_sem = [std(y1_preEvent_ego(), 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego()))), ...
    std(y1_event_ego(), 'omitnan')/sqrt(length(removeNan(y1_event_ego()))), ...
    std(y1_postEvent_ego(), 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego())))];
Fig5h_goalPC_mean = [mean(y1_preEvent_ego(), 'omitnan'), mean(y1_event_ego(), 'omitnan'), mean(y1_postEvent_ego(), 'omitnan')]

errorbar([1,2,3], Fig5h_goalPC_mean, Fig5h_goalPC_sem, ...
    '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:));
[h,p_goal] = ttest(y1_preEvent_ego(), y1_postEvent_ego())

ylim([-1 1]);yticks(-1:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
yline(alloSelectivityThreshold, '--', 'Color', colorM(3,:)); axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
yline(0-alloSelectivityThreshold, '--', 'Color', colorM(3,:)); axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
sgtitle('isFirstBTSPEvent')


% all events grouped into 3 categories: strong allo, weak selectivity, strong ego
% show pre, event, post selectivity change
% % % figure;
% % % subplot(1,3,1)
% % % lapLimit = [101, 200]
% % % idx = isFirstBTSPEvent;
% % % isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
% % % y1_preEvent_allo = mean(y1(isThisSection & idx & isSpacePC, 1:prePost_eventNum), 2, 'omitnan');
% % % y1_event_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+1), 2, 'omitnan');
% % % y1_postEvent_allo = mean(y1(isThisSection & idx & isSpacePC, prePost_eventNum+2:end), 2, 'omitnan');
% % % y1_preEvent_ego = mean(y1(isThisSection & idx & isRewardPC, 1:prePost_eventNum), 2, 'omitnan');
% % % y1_event_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+1), 2, 'omitnan');
% % % y1_postEvent_ego = mean(y1(isThisSection & idx & isRewardPC, prePost_eventNum+2:end), 2, 'omitnan');
% % % 
% % % y_idx_allo = y1_preEvent_allo>alloSelectivityThreshold 
% % % err = [std(y1_preEvent_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo(y_idx_allo)))), ...
% % %     std(y1_event_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_event_allo(y_idx_allo)))), ...
% % %     std(y1_postEvent_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo(y_idx_allo))))];
% % % errorbar([1,2,3], [mean(y1_preEvent_allo(y_idx_allo), 'omitnan'), mean(y1_event_allo(y_idx_allo), 'omitnan'), mean(y1_postEvent_allo(y_idx_allo), 'omitnan'),], err, ...
% % %     '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor', colorM(2,:), 'Color', colorM(2,:)); hold on;
% % % [h,p] = ttest(y1_preEvent_allo(y_idx_allo), y1_postEvent_allo(y_idx_allo))
% % % 
% % % y_idx_ego = y1_preEvent_ego>alloSelectivityThreshold;
% % % err = [std(y1_preEvent_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego(y_idx_ego)))), ...
% % %     std(y1_event_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_event_ego(y_idx_ego)))), ...
% % %     std(y1_postEvent_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego(y_idx_ego))))];
% % % errorbar([1,2,3], [mean(y1_preEvent_ego(y_idx_ego), 'omitnan'), mean(y1_event_ego(y_idx_ego), 'omitnan'), mean(y1_postEvent_ego(y_idx_ego), 'omitnan'),], err, ...
% % %     '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:));
% % % [h,p] = ttest(y1_preEvent_ego(y_idx_ego), y1_postEvent_ego(y_idx_ego))
% % % 
% % % ylim([-1 1]);yticks(-1:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
% % % yline(0.33, '--', 'Color', colorM(3,:)); yline(-0.33, '--', 'Color', colorM(3,:));axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
% % % 
% % % subplot(1,3,2)
% % % 
% % % y_idx_allo = y1_preEvent_allo<=alloSelectivityThreshold & y1_preEvent_allo>=(0-alloSelectivityThreshold);
% % % err = [std(y1_preEvent_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo(y_idx_allo)))), ...
% % %     std(y1_event_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_event_allo(y_idx_allo)))), ...
% % %     std(y1_postEvent_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo(y_idx_allo))))];
% % % errorbar([1,2,3], [mean(y1_preEvent_allo(y_idx_allo), 'omitnan'), mean(y1_event_allo(y_idx_allo), 'omitnan'), mean(y1_postEvent_allo(y_idx_allo), 'omitnan'),], err, ...
% % %     '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor', colorM(2,:), 'Color', colorM(2,:)); hold on;
% % % [h,p] = ttest(y1_preEvent_allo(y_idx_allo), y1_postEvent_allo(y_idx_allo))
% % % 
% % % y_idx_ego = y1_preEvent_ego<=alloSelectivityThreshold & y1_preEvent_ego>=(0-alloSelectivityThreshold);
% % % err = [std(y1_preEvent_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego(y_idx_ego)))), ...
% % %     std(y1_event_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_event_ego(y_idx_ego)))), ...
% % %     std(y1_postEvent_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego(y_idx_ego))))];
% % % errorbar([1,2,3], [mean(y1_preEvent_ego(y_idx_ego), 'omitnan'), mean(y1_event_ego(y_idx_ego), 'omitnan'), mean(y1_postEvent_ego(y_idx_ego), 'omitnan'),], err, ...
% % %     '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:));
% % % [h,p] = ttest(y1_preEvent_ego(y_idx_ego), y1_postEvent_ego(y_idx_ego))
% % % 
% % % ylim([-1 1]);yticks(-1:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
% % % yline(0.33, '--', 'Color', colorM(3,:)); yline(-0.33, '--', 'Color', colorM(3,:));
% % % axis square;set(gca, 'TickDir', 'out', 'FontSize', 15)
% % % 
% % % 
% % % subplot(1,3,3)
% % % y_idx_allo = y1_preEvent_allo<(0-alloSelectivityThreshold);
% % % err = [std(y1_preEvent_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_preEvent_allo(y_idx_allo)))), ...
% % %     std(y1_event_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_event_allo(y_idx_allo)))), ...
% % %     std(y1_postEvent_allo(y_idx_allo), 'omitnan')/sqrt(length(removeNan(y1_postEvent_allo(y_idx_allo))))];
% % % errorbar([1,2,3], [mean(y1_preEvent_allo(y_idx_allo), 'omitnan'), mean(y1_event_allo(y_idx_allo), 'omitnan'), mean(y1_postEvent_allo(y_idx_allo), 'omitnan'),], err, ...
% % %     '-o','MarkerSize',5,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor', colorM(2,:), 'Color', colorM(2,:)); hold on;
% % % [h,p] = ttest(y1_preEvent_allo(y_idx_allo), y1_postEvent_allo(y_idx_allo))
% % % 
% % % y_idx_ego = y1_preEvent_ego < (0-alloSelectivityThreshold);
% % % err = [std(y1_preEvent_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_preEvent_ego(y_idx_ego)))), ...
% % %     std(y1_event_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_event_ego(y_idx_ego)))), ...
% % %     std(y1_postEvent_ego(y_idx_ego), 'omitnan')/sqrt(length(removeNan(y1_postEvent_ego(y_idx_ego))))];
% % % errorbar([1,2,3], [mean(y1_preEvent_ego(y_idx_ego), 'omitnan'), mean(y1_event_ego(y_idx_ego), 'omitnan'), mean(y1_postEvent_ego(y_idx_ego), 'omitnan'),], err, ...
% % %     '-o','MarkerSize',5,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:), 'Color', colorM(1,:));
% % % 
% % % ylim([-1 1]);yticks(0:0.25:1);xticks([1,2,3]);xticklabels({'Pre', 'Event', 'Post'});xlim([0.5,3.5]); box off;
% % % yline(0.33, '--', 'Color', colorM(3,:)); yline(-0.33, '--', 'Color', colorM(3,:));
% % % axis square;set(gca, 'TickDir', 'out', 'FontSize', 15);
% % % [h,p] = ttest(y1_preEvent_ego(y_idx_ego), y1_postEvent_ego(y_idx_ego))


% [h,p] = ttest2(y1_preEvent_ego(y_idx_allo), y1_postEvent_ego(y_idx_ego))

%% Fig.5, allocentric PCs and egocentric PCs exhibited similar signatures of BTSP

%% Fig5a
% strong events
figure;colorG = {'k', 'r'}
lapLimit = [1, 100]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
prePostIdx = (prePost_plotLapNum - prePost_eventNum + 1):(prePost_plotLapNum + prePost_eventNum + 1);
Fig5a_prePostPeakAmplitude = prePostPeakAmplitude(isThisSection & isBTSPEvent & (isSpacePC | isRewardPC), prePostIdx);
stdshade(Fig5a_prePostPeakAmplitude, 0.25, colorG{1}); hold on;
xlabel('lap index'); ylabel('Mean in-field amplitude (dF/F)');yticks(0:0.5:3); ylim([0 3.01]);
title({['Allo+Ego BTSP events'];...
    [groupNameLabelPool{i_group}, ', d:', dayLabel{i_mouseDay}, ', both maps']});
box off; set(gca, 'TickDir', 'Out');legend('boxoff'); legend('Location', 'southeast');
legend('', ['Allo+Ego PC']);  xlim([0.5,2*prePost_eventNum+1.5]); ylabel('PF Amplitude');
set(gca, 'FontSize', 15); legend('boxoff'); axis square;
xticks([1 prePost_eventNum+1 2*prePost_eventNum+1]); xticklabels({num2str(-1*prePost_eventNum), '0', ['+',num2str(prePost_eventNum)]});

% backward shift
%% Fig5c
lapLimit = [1, 100]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
figure;
colorG = {'k', 'r'}
idx = isBTSPEvent & (isSpacePC | isRewardPC) & isThisSection;
[N_1, E_1] = histcounts(removeNan(PFCOMShift_Post2Induction(idx)), 'BinLimit', [-fieldSpaBinSize, fieldSpaBinSize], 'BinWidth', 0.5, 'Normalization', 'probability'); hold on;
Fig5c_PFCOMShift_sourceData = removeNan(PFCOMShift_Post2Induction(idx));
Fig5c_binnedFraction = N_1;
Fig5c_medianCOMShift = median(removeNan(PFCOMShift_Post2Induction(idx)), 'omitnan')
Fig5c_binCOMShiftValue = E_1(1:end-1)
plot(E_1(1:end-1), N_1, colorG{1});set(gca, 'FontSize', 15); legend('boxoff'); xline(Fig5c_medianCOMShift, '--k')
xticks([-8.3 -20/3.6 -10/3.6 0 10/3.6 20/3.6 30/3.6]); xticklabels({'-30', '-20',  '-10', '0', '10', '20','30'}); xlim([-9 9]); ylabel('Fraction of event');set(gca, 'TickDir', 'Out'); ylim([-0.002 0.15]); yticks([0 0.05 0.1 0.15])
xlabel('PF COM shift rela. to indu. trial (cm)');

legend('Allo+Ego PC'); 
legend('boxoff'); legend('Location', 'northeast')
set(gca, 'FontSize', 15); legend('boxoff'); axis square

%% Fig5b
% resulting event width correlates with induction trial speed
lapLimit = [1, 100]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
idx = isThisSection & (isSpacePC | isRewardPC) & isBTSPEvent;
a1 = 100*(event_fieldRunSpeed(idx));
b1 = 100*(postEvent_MeanOfPFWidth(idx))/100; % remove smaller than 0.2m and very large field width

Fig5b_indVel = a1;
Fig5b_PFWidth = b1;

figure;
scatter(a1, b1, 150,'k', 'filled', 'MarkerFaceAlpha', 0.25); hold on;
mdl = fitlm(a1, b1)
plot(a1, (a1 .* mdl.Coefficients.Estimate(2) + mdl.Coefficients.Estimate(1)));
xlim([0, 60]); xticks(0:15:60); 
yticks(0:25:100); ylim([0 100]); ylabel('post Event Field COM (cm)'); pbaspect([0.618 1 1]);
box off; set(gca, 'TickDir', 'out', 'FontSize', 15,  'FontName', 'Arial');

% fraction of PCs have BTSPs, map1/map2
y1 = perCell_numBTSPEvent_map1(perCell_isSpacePC);
y2 = perCell_numBTSPEvent_map1(perCell_isRewardPC);
y3 = perCell_numBTSPEvent_map1(perCell_isMixPC);

f1 = mean(y1>=1)
f2 = mean(y2>=1)
f3 = mean(y3>=1)

% |Event-Pre| COM shift for each division after reward switch
lapLimit = [76,200]
numLapPerSection = 25;
numSection = (lapLimit(2) - lapLimit(1) +1)/numLapPerSection;
lapIdxPerSection = [lapLimit(1):numLapPerSection:lapLimit(2), lapLimit(2)];
allSection_sectionIdx_space = [];
allSection_COMShift_Ind2Pre_space = [];
allSection_sectionIdx_reward = [];
allSection_COMShift_Ind2Pre_reward = [];
for i_section = 1:numSection
    thisSectionIdx = [lapIdxPerSection(i_section), lapIdxPerSection(i_section+1)];
    % allo
    isThisSection_space = (eventLapIdx_align2RewardSwitch >= thisSectionIdx(1)) & (eventLapIdx_align2RewardSwitch <= thisSectionIdx(2)) & isBTSPEvent & isSpacePC;
    thisSection_COMShift_Ind2Pre_space = abs(removeNan(PFCOMShift_Induction2Pre(isThisSection_space)));
    allSection_COMShift_Ind2Pre_space = [allSection_COMShift_Ind2Pre_space; thisSection_COMShift_Ind2Pre_space];
    thisSectionGroupIdx_space = ones(length(thisSection_COMShift_Ind2Pre_space),1)*i_section;
    allSection_sectionIdx_space = [allSection_sectionIdx_space; thisSectionGroupIdx_space];
    % ego
    isThisSection_reward = (eventLapIdx_align2RewardSwitch >= thisSectionIdx(1)) & (eventLapIdx_align2RewardSwitch <= thisSectionIdx(2)) & isBTSPEvent & isRewardPC;
    thisSection_COMShift_Ind2Pre_reward = abs(removeNan(PFCOMShift_Induction2Pre(isThisSection_reward)));
    allSection_COMShift_Ind2Pre_reward = [allSection_COMShift_Ind2Pre_reward; thisSection_COMShift_Ind2Pre_reward];
    thisSectionGroupIdx_reward = ones(length(thisSection_COMShift_Ind2Pre_reward),1)*i_section;
    allSection_sectionIdx_reward = [allSection_sectionIdx_reward; thisSectionGroupIdx_reward];
end

binEdges = 1:numSection+1; bins = {'Pre-4', 'Post-1', 'Post-2', 'Post-3', 'Post-4'};
groupCC1 = discretize(allSection_sectionIdx_space, binEdges, 'categorical', bins);
groupCC2 = discretize(allSection_sectionIdx_reward, binEdges, 'categorical', bins);

groupByColor1 = 1*ones(length(allSection_sectionIdx_space),1);
groupByColor2 = 2*ones(length(allSection_sectionIdx_reward),1);
colorM = cbrewer('qual', 'Set1', 9);
figure;
bc = boxchart([groupCC1; groupCC2], [allSection_COMShift_Ind2Pre_space; allSection_COMShift_Ind2Pre_reward], 'GroupByColor', [groupByColor1; groupByColor2]);
legend('Allo', 'Ego', 'Location', 'eastoutside');
box off; legend('boxoff');
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'Out');
ylim([-0.5, 25.5]); yticks([0 6.25 12.5 18.75 25]); yticklabels({'0', '', '45', '', '90'});
ylabel('PF COM Change: |Ind-Pre|');
bc(1).BoxFaceColor = colorM(2,:); bc(1).MarkerColor = colorM(2,:); bc(1).LineWidth = 0.5;
bc(2).BoxFaceColor = colorM(1,:); bc(2).MarkerColor = colorM(1,:); bc(2).LineWidth = 0.5;
pbaspect([1, 0.5, 1]);
for i_section = 1:lapLimit(2)/numLapPerSection
    [h, p_btsp(i_section)] = ttest2(allSection_COMShift_Ind2Pre_space(allSection_sectionIdx_space==i_section), allSection_COMShift_Ind2Pre_reward(allSection_sectionIdx_reward==i_section));
end

% |Event-Map Mean| COM shift for each division after reward switch
lapLimit = [76,200]
numLapPerSection = 25;
numSection = (lapLimit(2) - lapLimit(1) +1)/numLapPerSection;
lapIdxPerSection = [lapLimit(1):numLapPerSection:lapLimit(2), lapLimit(2)];
allSection_sectionIdx_space = [];
allSection_COMShift_Ind2Map_space = [];
allSection_sectionIdx_reward = [];
allSection_COMShift_Ind2Map_reward = [];

PFCOM_Ind2MapMean = fieldPositionChange(50, eventPFCOM, cellPeakPosition);
for i_section = 1:numSection
    thisSectionIdx = [lapIdxPerSection(i_section), lapIdxPerSection(i_section+1)];
    % allo
    isThisSection_space = (eventLapIdx_align2RewardSwitch >= thisSectionIdx(1)) & (eventLapIdx_align2RewardSwitch <= thisSectionIdx(2)) & isBTSPEvent & isSpacePC;

    thisSection_COMShift_Ind2Pre_space = abs(removeNan(PFCOM_Ind2MapMean(isThisSection_space)));
    allSection_COMShift_Ind2Map_space = [allSection_COMShift_Ind2Map_space; thisSection_COMShift_Ind2Pre_space];
    thisSectionGroupIdx_space = ones(length(thisSection_COMShift_Ind2Pre_space),1)*i_section;
    allSection_sectionIdx_space = [allSection_sectionIdx_space; thisSectionGroupIdx_space];
    % ego
    isThisSection_reward = (eventLapIdx_align2RewardSwitch >= thisSectionIdx(1)) & (eventLapIdx_align2RewardSwitch <= thisSectionIdx(2)) & isBTSPEvent & isRewardPC;
    thisSection_COMShift_Ind2Pre_reward = abs(removeNan(PFCOM_Ind2MapMean(isThisSection_reward)));
    allSection_COMShift_Ind2Map_reward = [allSection_COMShift_Ind2Map_reward; thisSection_COMShift_Ind2Pre_reward];
    thisSectionGroupIdx_reward = ones(length(thisSection_COMShift_Ind2Pre_reward),1)*i_section;
    allSection_sectionIdx_reward = [allSection_sectionIdx_reward; thisSectionGroupIdx_reward];
end

binEdges = 1:numSection+1; bins = {'Pre-4', 'Post-1', 'Post-2', 'Post-3', 'Post-4'};
groupCC1 = discretize(allSection_sectionIdx_space, binEdges, 'categorical', bins);
groupCC2 = discretize(allSection_sectionIdx_reward, binEdges, 'categorical', bins);

groupByColor1 = 1*ones(length(allSection_sectionIdx_space),1);
groupByColor2 = 2*ones(length(allSection_sectionIdx_reward),1);
colorM = cbrewer('qual', 'Set1', 9);
figure;
bc = boxchart([groupCC1; groupCC2], [allSection_COMShift_Ind2Map_space; allSection_COMShift_Ind2Map_reward], 'GroupByColor', [groupByColor1; groupByColor2]);
legend('Allo', 'Ego', 'Location', 'eastoutside');
box off; legend('boxoff');
set(gca, 'FontSize', 15); set(gca, 'TickDir', 'Out');
ylim([-0.5, 25.5]); yticks([0 6.25 12.5 18.75 25]); yticklabels({'0', '', '45', '', '90'});
ylabel('PF COM Change: |Ind-MapMean|')
bc(1).BoxFaceColor = colorM(2,:); bc(1).MarkerColor = colorM(2,:); bc(1).LineWidth = 0.5;
bc(2).BoxFaceColor = colorM(1,:); bc(2).MarkerColor = colorM(1,:); bc(2).LineWidth = 0.5;
pbaspect([1, 0.5, 1])
p_btsp = []
for i_section = 1:numSection
    [h,p_btsp(i_section)] = kstest2(allSection_COMShift_Ind2Map_space(allSection_sectionIdx_space==i_section), allSection_COMShift_Ind2Map_reward(allSection_sectionIdx_reward==i_section));
end

%% Extended Data Fig.9, allocentric PCs and egocentric PCs exhibited similar signatures of BTSP


% BTSP event peak amplitude

lapLimit = [1,100]
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
a1 = eventPeakAmplitude_sm(isThisSection & isSpacePC & isBTSPEvent);
a2 = eventPeakAmplitude_sm(isThisSection & isRewardPC & isBTSPEvent);

y1 = a1; y2 = a2;
figure;

i1 = 1; n1 = length(y1);
br = bar(i1, mean(y1), 'b'); br.FaceAlpha = 0.2; hold on; br.EdgeColor = 'w'; hold on;
er = errorbar(i1, mean(y1), std(y1)/sqrt(n1), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'b', 'MarkerEdgeColor','b','MarkerFaceColor','b'); hold on;

i2 = 2; n2 = length(y2);
br = bar(i2, mean(y2), 'r'); br.FaceAlpha = 0.2; hold on; br.EdgeColor = 'w'; hold on;
er = errorbar(i2, mean(y2), std(y2)/sqrt(n2), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'r', 'MarkerEdgeColor','r','MarkerFaceColor','r'); hold on;

xlim([0, 3]); xticks(1:2); yticks(0:2:8); ylim([0 8]); ylabel('BTSP event peak amplitude dF/F'); pbaspect([0.618 1 1]);
box off; set(gca, 'TickDir', 'out', 'FontSize', 15,  'FontName', 'Arial');

[h1, p1] = ttest2(a1,a2);
mean(a1);
mean(a2);
std(a1)/sqrt(length(a1));
std(a2)/sqrt(length(a2));

% event frequency
y1 = perCell_numBTSPEvent_map1(perCell_isSpacePC);
y2 = perCell_numBTSPEvent_map1(perCell_isRewardPC);

figure;
i1 = 1; n1 = length(y1);
br = bar(i1, mean(y1), 'b'); br.FaceAlpha = 0.2; hold on; br.EdgeColor = 'w'; hold on;
er = errorbar(i1, mean(y1), std(y1)/sqrt(n1), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'b', 'MarkerEdgeColor','b','MarkerFaceColor','b'); hold on;
i2 = 2; n2 = length(y2);
br = bar(i2, mean(y2), 'r'); br.FaceAlpha = 0.2; hold on; br.EdgeColor = 'w'; hold on;
er = errorbar(i2, mean(y2), std(y2)/sqrt(n2), 'o', 'LineWidth', 0.5, 'MarkerSize',5, 'Color', 'r', 'MarkerEdgeColor','r','MarkerFaceColor','r'); hold on;

xlim([0, 3]); xticks(1:2); yticks(0:1:4); ylim([0 4]); ylabel('BTSP event frequency/PC'); pbaspect([0.618 1 1]);
box off; set(gca, 'TickDir', 'out', 'FontSize', 15,  'FontName', 'Arial');
mean(y1)
std(y1)/sqrt(length(y1));
mean(y2)
std(y2)/sqrt(length(y2));
[h,p] = ttest2(y1,y2)



% BTSP event onset
lapLimit = [1, 100];
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
a1 = removeNan(eventLapIdx_align2RewardSwitch(isThisSection & isSpacePC & isBTSPEvent));
a2 = removeNan(eventLapIdx_align2RewardSwitch(isThisSection & isRewardPC & isBTSPEvent));

figure;
edges = 0:2:100;
[na, ea] = histcounts(a1, edges, 'Normalization', 'cdf'); hold on;
stairs(ea(2:end), na, 'b');
[ne, ee] = histcounts(a2, edges, 'Normalization', 'cdf'); hold on;
stairs(ee(2:end), ne, 'r');

xlim([0, 101]); xticks(0:25:100); 
yticks(0:0.25:1); ylim([0 1]); ylabel('cumulative fraction of BTSP onset'); pbaspect([0.618 1 1]);
box off; set(gca, 'TickDir', 'out', 'FontSize', 15,  'FontName', 'Arial');

[h1, p1] = kstest2(a1,a2)
mean(a1)
mean(a2)
std(a1)/sqrt(length(a1))
std(a2)/sqrt(length(a2))


% BTSP event location vs peakPosition_map
%% Fig5d
idx = isFirstBTSPEvent;
lapLimit = [101, 200];
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
y1_allo = fieldPositionChange(50, cellPeakPosition_map1(idx & isThisSection & isSpacePC), eventPFCOM(idx & isThisSection & isSpacePC));
y1_ego = fieldPositionChange(50, cellPeakPosition_map1(idx & isThisSection & isRewardPC), eventPFCOM(idx & isThisSection & isRewardPC));
err = [std(y1_allo, 'omitnan')/sqrt(length(removeNan(y1_allo))), std(y1_ego, 'omitnan')/sqrt(length(removeNan(y1_ego)))];

Fig5d_space = y1_allo;
Fig5d_goal = y1_ego;

figure;colorM = cbrewer('qual', 'Set1', 9);
colorGrey = cbrewer('seq', 'Greys', 9);
jitter = 0.5; 
i1 = 1; n1 = length(y1_allo);
scatter(i1+jitter*(rand(n1,1)-0.5), abs(y1_allo), 250, colorGrey(5,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on;
i2 = 2; n2 = length(y1_ego);
scatter(i2+jitter*(rand(n2,1)-0.5), abs(y1_ego), 250, colorGrey(5,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on;
errorbar(0.5, mean(abs(y1_allo), 'omitnan'), err(1), 'o','MarkerSize',10,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor',colorM(2,:), 'Color', colorM(2,:), 'LineWidth', 0.25); hold on;
errorbar(2.5, mean(abs(y1_ego), 'omitnan'), err(2), 'o','MarkerSize',10,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:),'Color', colorM(1,:), 'LineWidth', 0.25);
xlim([0,3]); ylim([-1 26]); box off; set(gca, 'TickDir', 'out', 'FontSize', 15); 
xticks([]); yticks([0, 6.25,12.5,18.75,25]); yticklabels({'0', '', '45', '', '90'}); ylabel('|BTSP COM - Pre PF Peak| (cm)');
pbaspect([0.618, 1, 1]);
[h, p] = ttest2(abs(y1_allo), abs(y1_ego))


%% same BTSP event location vs peakPostion analysis, but all PCs
% was BTSP at random location
idx = isFirstBTSPEvent;
lapLimit = [101, 200];
isThisSection = eventLapIdx_align2RewardSwitch >= lapLimit(1) & eventLapIdx_align2RewardSwitch <= lapLimit(2);
idx2 = isMixPC;
y1_allPC = abs(fieldPositionChange(50, cellPeakPosition_map1(idx & isThisSection & idx2), fix(eventPFCOM(idx & isThisSection & idx2))));

binSize = 2; edges = 0:binSize:26
[N1, E1] = histcounts(y1_allPC, edges, 'Normalization', 'probability')

x = cellPeakPosition_map1(idx & isThisSection & idx2)
n = length(y1_allPC);
rng('default')
shuffleNum = 10000
N_shuffle = nan(length(N1), shuffleNum);
p_shuffle = nan(shuffleNum, 1)
spaDivNum = 50
for i_shuffle = 1:shuffleNum
    x_rand = randi(spaDivNum, n, 1);
    y_shuffle = abs(fieldPositionChange(spaDivNum, x, x_rand));
    [N_shuffle(:, i_shuffle), E2] = histcounts(y_shuffle, edges, 'Normalization', 'probability');
    [h1, p_shuffle(i_shuffle)] = kstest2(y1, y_shuffle);
end

% plot real data versus confidence interval
colorM = cbrewer('qual', 'Set1', 9)
% % % figure;
% % % plot(E1(2:end), N1, 'k'); hold on;
% % % plot(E2(2:end), mean(N_shuffle, 2, 'omitnan'),  'Color', colorM(3,:)); hold on;
% % % plot(E2(2:end), prctile(N_shuffle, 95, 2), '--', 'Color', colorM(3,:)); hold on;
% % % plot(E2(2:end), prctile(N_shuffle, 5, 2), '--', 'Color', colorM(3,:)); hold on;
% % % pbaspect([1 1 1]);set(gca, 'TickDir', 'out', 'FontSize', 15); box off;
% % % xticks([2 13 25]); xticklabels({'0', '45', '90'}); yticks(0:0.05:0.2); ylim([0 0.2]); xlim([1 26])
% % % title(['confidence interval:', num2str(mean(p_shuffle<0.05))])
% % % xlabel('delta place field position (cm)'); ylabel('Fraction of PCs')

% % % 
% % % figure;colorM = cbrewer('qual', 'Set1', 9);
% % % colorGrey = cbrewer('seq', 'Greys', 9);
% % % jitter = 0.5; 
% % % i1 = 1; n1 = length(y1_allPC);
% % % scatter(i1+jitter*(rand(n1,1)-0.5), abs(y1_allPC), 250, colorGrey(5,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on;
% % % i2 = 2; n2 = length(y1_ego);
% % % 
% % % figure;
% % % histogram(abs(y1_allPC), 'BinWidth', 2)
% % % 
% % % scatter(i2+jitter*(rand(n2,1)-0.5), abs(y1_ego), 250, colorGrey(5,:), 'filled', 'MarkerFaceAlpha', 0.5); hold on;
% % % errorbar(0.5, mean(abs(y1_allo), 'omitnan'), err(1), 'o','MarkerSize',10,'MarkerEdgeColor',colorM(2,:),'MarkerFaceColor',colorM(2,:), 'Color', colorM(2,:), 'LineWidth', 0.25); hold on;
% % % errorbar(2.5, mean(abs(y1_ego), 'omitnan'), err(2), 'o','MarkerSize',10,'MarkerEdgeColor',colorM(1,:),'MarkerFaceColor',colorM(1,:),'Color', colorM(1,:), 'LineWidth', 0.25);
% % % xlim([0,3]); ylim([-1 26]); box off; set(gca, 'TickDir', 'out', 'FontSize', 15); 
% % % xticks([]); yticks([0, 6.25,12.5,18.75,25]); yticklabels({'0', '', '45', '', '90'}); ylabel('|BTSP COM - Pre PF Peak| (cm)');
% % % pbaspect([0.618, 1, 1]);
% % % [h, p] = ttest2(abs(y1_allo), abs(y1_ego))



% mean +- sem
mean(abs(y1_allo) * 3.6)
std(3.6*abs(y1_allo))/sqrt(length(y1_allo))

mean(abs(y1_ego) * 3.6)
std(3.6*abs(y1_ego))/sqrt(length(y1_ego))

end