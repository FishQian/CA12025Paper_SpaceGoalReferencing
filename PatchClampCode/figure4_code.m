%% Figure 4
% panel A
filename = 'Figure4_data.xlsx';
sheetName = 'panel A';
range = 'B3:E490003';
exampleCell = readtable(filename, 'Sheet', sheetName, 'Range', range);
exampleCell = table2array(exampleCell);
 
samplerate = 20000/10;
[time,~] = size(exampleCell);
time = time/samplerate +1 -1/samplerate;

figure
plot(1:1/samplerate:time,exampleCell(:,1),'k')
hold on
plot(1:1/samplerate:time,exampleCell(:,2)*300+40,'b')
plot(1:1/samplerate:time,exampleCell(:,3)+40,'r')
plot(1:1/samplerate:time,exampleCell(:,4)*300+40,'g')
xlabel('Time(s)')
ylabel('Voltage(mV) Distance(cm)')

%% panel B
sheetName = 'B';
range = 'A1:GB41';
spacePC = readtable(filename, 'Sheet', sheetName, 'Range', range);
spacePC = table2array(spacePC);
Pre = 1:17; % trials before reward switch
Post = [18 21:40]; % trials after reward switch

figure;
subplot(2,1,1)
a = smoothdata(spacePC,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([-55 -45])

hold on;
[rows, cols] = find(isnan(spacePC)); % Find NaN indices
for i = 1:length(rows)
    rectangle('Position', [cols(i)-0.5, rows(i)-0.5, 1, 1], 'FaceColor', 'blue', 'EdgeColor', 'none');
end

plot([184 184],[0 Pre(end)+0.5],'--k','linewidth',2)
plot([92 92],[Pre(end)+0.5 Post(end)+0.5],'--k','linewidth',2)
plot([0 184],[Pre(end)+0.5 Pre(end)+0.5],'--k','linewidth',2)

xlabel('Location(cm)');
ylabel('Laps');
title('space PC');

subplot(2,1,2)
plot(smoothdata(mean(spacePC(Pre,:)),'gaussian',5),'Color', [0.5, 0.5, 0.5], 'LineWidth', 2)
hold on
plot(smoothdata(mean(spacePC(Post,:)),'gaussian',5),'Color', [0, 0, 0], 'LineWidth', 2)
xlim([0 184])
ylim([-60 -45])
legend(['pre',newline],['post',newline])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

%% panel C
sheetName = 'C';
range = 'A1:GB24';
goalPC = readtable(filename, 'Sheet', sheetName, 'Range', range);
goalPC = table2array(goalPC);
Pre = 1:13; % trials before reward switch
Post = 14:23; % trials after reward switch

figure;
subplot(2,1,1)
a = smoothdata(goalPC,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([-51 -43])

hold on;
plot([184 184],[0 Pre(end)+0.5],'--k','linewidth',2)
plot([92 92],[Pre(end)+0.5 Post(end)+0.5],'--k','linewidth',2)
plot([0 184],[Pre(end)+0.5 Pre(end)+0.5],'--k','linewidth',2)

xlabel('Location(cm)');
ylabel('Laps');
title('space PC');

subplot(2,1,2)
plot(smoothdata(mean(goalPC(Pre,:)),'gaussian',5),'Color', [0.5, 0.5, 0.5], 'LineWidth', 2)
hold on
plot(smoothdata(mean(goalPC(Post,:),'omitnan'),'gaussian',5),'Color', [0, 0, 0], 'LineWidth', 2)
xlim([0 184])
ylim([-57 -43])
legend(['pre',newline],['post',newline])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

%% panel D
PF = 69; % the PF was calculated from the COM of spike
Pre = 1:17; % trials before reward switch
Post = [18 21:40]; % trials after reward switch

% calculate goalVm
tmp = mean(spacePC(Post,:) - mean(spacePC(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
spaceCell_goalVm = tmp(PF:184+PF-1);

% calculate spaceVm
spacePC_toReward(Pre,:) = spacePC(Pre,:);
spacePC_toReward(Post,1:92) = spacePC(Post,92+1:184);
spacePC_toReward(Post,92+1:184) = spacePC(Post,1:92);
tmp = mean(spacePC_toReward(Post,:) - mean(spacePC_toReward(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
spaceCell_spaceVm = tmp(PF:184+PF-1);

figure
subplot(1,2,1)
plot(spaceCell_goalVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
y = spaceCell_goalVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'r')

plot(smoothdata(spaceCell_goalVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-12 12])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Goal Vm');

subplot(1,2,2)
plot(spaceCell_spaceVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
y = spaceCell_spaceVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'b')

plot(smoothdata(spaceCell_spaceVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-12 12])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Space Vm');

%% panel E
PF = 52; % the PF was calculated from the COM of spike
Pre = 1:13; % trials before reward switch
Post = 14:23; % trials after reward switch

% calculate goalVm
tmp = mean(goalPC(Post,:) - mean(goalPC(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
goalCell_goalVm = tmp(PF:184+PF-1);

% calculate spaceVm
goalPC_toReward(Pre,:) = goalPC(Pre,:);
goalPC_toReward(Post,1:92) = goalPC(Post,92+1:184);
goalPC_toReward(Post,92+1:184) = goalPC(Post,1:92);
tmp = mean(goalPC_toReward(Post,:)) - mean(goalPC_toReward(Pre,:));
tmp(184+1:184+PF) = tmp(1:PF);
goalCell_spaceVm = tmp(PF:184+PF-1);

figure
subplot(1,2,1)
plot(goalCell_goalVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 2)
hold on
y = goalCell_goalVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'r')

plot(smoothdata(goalCell_goalVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-6 6])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Goal Vm');

subplot(1,2,2)
plot(goalCell_spaceVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 2)
hold on
y = goalCell_spaceVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'b')

plot(smoothdata(goalCell_spaceVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-6 6])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Space Vm');

%% panel F
sheetName = 'F';
range = 'A1:B26';
Displacement = readtable(filename, 'Sheet', sheetName, 'Range', range);
Displacement = table2array(Displacement);

range = 'D1:D7';
Cell_id_goal = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_goal = table2array(Cell_id_goal);

range = 'E1:E11';
Cell_id_space = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_space = table2array(Cell_id_space);

range = 'F1:F10';
Cell_id_inter = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_inter = table2array(Cell_id_inter);

figure
scatter(Displacement(Cell_id_goal,1),Displacement(Cell_id_goal,2),'r','filled')
hold on
scatter(Displacement(Cell_id_space,1),Displacement(Cell_id_space,2),'b','filled')
scatter(Displacement(Cell_id_inter,1),Displacement(Cell_id_inter,2),'k','filled')

x = [-1 1];
P = polyfit(Displacement(:,1),Displacement(:,2),1);
yfit = polyval(P,x);
mdl = fitlm(Displacement(:,1),Displacement(:,2));
plot(x,yfit,'g')

xlim([-1 1])
ylim([-5 95])
xlabel('Goal/Space index');
ylabel('Distance shifted(cm)')
%% panel G
sheetName = 'G';
range = 'A1:B26';
PlateauRate = readtable(filename, 'Sheet', sheetName, 'Range', range);
PlateauRate = table2array(PlateauRate);

figure
scatter(ones(1,25),PlateauRate(:,1),'k','filled')
hold on
scatter(2*ones(1,25),PlateauRate(:,2),'k','filled')
for i=1:25
    plot([1,2],[PlateauRate(i,1),PlateauRate(i,2)],'-k')
end
xlim([0.5 2.5])
ylim([0 1])
xticks([1 2])
ylabel('Plateau rate(/100AP)')
plot(0.8,mean(PlateauRate(:,1)),'*k')
plot(2.2,mean(PlateauRate(:,2)),'*k')

[h p] = ttest(PlateauRate(:,1), PlateauRate(:,2))

%% panel H
sheetName = 'H';
range = 'A1:B36';
PlateauLocation = readtable(filename, 'Sheet', sheetName, 'Range', range);
PlateauLocation = table2array(PlateauLocation);

range = 'D1:D10';
Cell_id_goal = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_goal = table2array(Cell_id_goal);

range = 'E1:E8'; 
Cell_id_space = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_space = table2array(Cell_id_space);

range = 'F1:F20';
Cell_id_inter = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_inter = table2array(Cell_id_inter);

figure
scatter(PlateauLocation(Cell_id_goal,1),PlateauLocation(Cell_id_goal,2),'r','filled')
hold on
scatter(PlateauLocation(Cell_id_space,1),PlateauLocation(Cell_id_space,2),'b','filled')
scatter(PlateauLocation(Cell_id_inter,1),PlateauLocation(Cell_id_inter,2),'k','filled')

x = [0 184];
P = polyfit(PlateauLocation(:,1),PlateauLocation(:,2),1);
yfit = polyval(P,x);
mdl = fitlm(PlateauLocation(:,1),PlateauLocation(:,2));
plot(x,yfit,'g')

plot([0 184],[0 184],'--k','linewidth',1)
plot([92 92],[0 184],'--k','linewidth',1)

xlim([0 184])
ylim([0 184])
xlabel('Plateau location(cm)');
ylabel('PF location(cm),post')