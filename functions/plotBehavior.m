function plotBehavior(MAP, i_group, i_mouseDay, dayLabel, groupNameLabelPool)
i_map = 1; j_map = 2;
if i_mouseDay >= 4
    figure;
    stdshade(MAP{i_group}.map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1}', 0.2, 'k'); hold on;
    stdshade(MAP{i_group}.map(j_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1}', 0.2, 'r'); hold on;
    xline(14, '--k');
    xline(39, '--r')
    xticks([1 25 50]); ylim([-0.02 1.02]); xlim([0 51]); yticks([0 0.25 0.5 0.75 1]); box off;set(gca, 'TickDir','out'); xticklabels('');yticklabels('')
    title([groupNameLabelPool{i_group}, ', day: ', dayLabel{i_mouseDay}])
    
    figure;
    stdshade(MAP{i_group}.map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1}', 0.2, 'k'); hold on;
    stdshade(MAP{i_group}.map(j_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1}', 0.2, 'r'); hold on;
    xline(14, '--k');
    xline(39, '--r')
    xticks([1 25 50]); ylim([-0.02 0.51]); xlim([0 51]); yticks([0 0.125 0.25 0.375 0.50]); box off;set(gca, 'TickDir','out'); xticklabels('');yticklabels('')
    title([groupNameLabelPool{i_group}, ', day: ', dayLabel{i_mouseDay}])
    

    % get figure source data
    x1 = MAP{i_group}.map(i_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1}';
    x2 = MAP{i_group}.map(j_map).eachSpaDivLickProbability_allMice{i_mouseDay, 1}';
    
    y1 = MAP{i_group}.map(i_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1}';
    y2 = MAP{i_group}.map(j_map).eachSpaDivSpeed_allMice_oneMouseOneTrace{i_mouseDay, 1}';
else
    
    
    
    
    
    
    
end


end