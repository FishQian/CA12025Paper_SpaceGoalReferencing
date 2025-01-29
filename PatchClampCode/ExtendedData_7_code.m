%% Extended Figure 7
% panel B
filename = 'ExtendedData_7_data.xlsx';
sheetName = 'panel B';
range = 'A1:GB14';
FR = readtable(filename, 'Sheet', sheetName, 'Range', range);
FR = table2array(FR);

% calculate the PF COM
tmpData = smoothdata(mean(FR),'gaussian',21);
threshold = 0.2 * max(tmpData);
aboveThreshold = find(tmpData >= threshold);
maxIndex = find(tmpData ==  max(tmpData), 1, 'first');
beforeMax = aboveThreshold(aboveThreshold < maxIndex);
afterMax = aboveThreshold(aboveThreshold > maxIndex);
PF = round(sum((beforeMax(1): afterMax(end)).* tmpData(beforeMax(1): afterMax(end))) / sum(tmpData(beforeMax(1): afterMax(end))));

figure;
subplot(2,1,1)
a = smoothdata(FR,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([0 35])

xlabel('Location(cm)');
ylabel('Laps');
title('Firing rate,pre');

subplot(2,1,2)
plot(smoothdata(mean(FR),'gaussian',5),'k')
hold on
plot(smoothdata(mean(FR),'gaussian',21),'r')
xlim([0 184])
ylim([0 30])
legend(['Firing rate',newline],['Gaussian smooth',newline])
xlabel('Location(cm)');
ylabel('Firing rate(Hz)')

%% panel C
sheetName = 'C';
range = 'A1:GB24';
exampleCell = readtable(filename, 'Sheet', sheetName, 'Range', range);
exampleCell = table2array(exampleCell);
Pre = 1:13;
Post = 14:23;

figure;
a = smoothdata(exampleCell,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([-51 -43])

hold on
plot([184 184],[0 Pre(end)+0.5],'--k','linewidth',2)
plot([92 92],[Pre(end)+0.5 Post(end)+0.5],'--k','linewidth',2)
plot([0 184],[Pre(end)+0.5 Pre(end)+0.5],'--k','linewidth',2)

xlabel('Location(cm)');
ylabel('Laps');
title('Vm reference to location');

%% panel D
sheetName = 'D';
range = 'A1:B185';
Velocity = readtable(filename, 'Sheet', sheetName, 'Range', range);
Velocity = table2array(Velocity);

figure
plot(smoothdata(Velocity(:,1),'gaussian',3),'k')
hold on
plot(smoothdata(Velocity(:,2),'gaussian',3),'r')
xlim([0 184])
ylim([0 35])
legend(['pre',newline],['post',newline])
xlabel('Location(cm)');
ylabel('Velocity(cm/s)')

%% panel E
Pre = 1:13;
Post = 14:23;

figure
plot(smoothdata(mean(exampleCell(Pre,:)),'movmean',5),'k')
hold on
plot(smoothdata(mean(exampleCell(Post,:)),'movmean',5),'r')

plot([PF PF],[-58 -42],'--k')
plot([PF+92 PF+92],[-58 -42],'--k')

xlim([0 184])
ylim([-58 -42])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

%% panel F
tmp = mean(exampleCell(Post,:) - mean(exampleCell(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
goalVm = tmp(PF:184+PF-1);

figure
plot(goalVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
y = goalVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'r')

plot(smoothdata(goalVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-6 6])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Goal Vm');

%% panel G
exampleCell_toReward = exampleCell(Pre,:);
exampleCell_toReward(Post,1:92) = exampleCell(Post,93:184);
exampleCell_toReward(Post,93:184) = exampleCell(Post,1:92);

figure;
a = smoothdata(exampleCell_toReward,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([-51 -43])

hold on
plot([184 184],[0 23.5],'--k','linewidth',2)
plot([0 184],[13.5 13.5],'--k','linewidth',2)

xlabel('Distance from run start(cm)');
ylabel('Laps');
title('Vm reference to run start');
%% panel H
sheetName = 'H';
range = 'A1:B185';
Velocity = readtable(filename, 'Sheet', sheetName, 'Range', range);
Velocity = table2array(Velocity);

figure
plot(smoothdata(Velocity(:,1),'movmean',5),'k')
hold on
plot(smoothdata(Velocity(:,2),'movmean',5),'b')
xlim([0 184])
ylim([0 35])
legend(['pre',newline],['post',newline])
xlabel('Location(cm)');
ylabel('Velocity(cm/s)')

%% panel I
figure
plot(smoothdata(mean(exampleCell_toReward(Pre,:)),'movmean',5),'k')
hold on
plot(smoothdata(mean(exampleCell_toReward(Post,:)),'movmean',5),'b')

plot([PF PF],[-58 -42],'--k')
plot([PF+92 PF+92],[-58 -42],'--k')

xlim([0 184])
ylim([-58 -42])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

%% panel J
tmp = mean(exampleCell_toReward(Post,:) - mean(exampleCell_toReward(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
goalVm = tmp(PF:184+PF-1);

figure
plot(goalVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
y = goalVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'b')

plot(smoothdata(goalVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-6 6])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Goal Vm');