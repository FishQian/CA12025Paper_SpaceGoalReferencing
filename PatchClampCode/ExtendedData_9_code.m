%% Extended Figure 9
% panel A
filename = 'ExtendedData_9_data.xlsx';
sheetName = 'panel A';
range = 'A1:GB26';
goalVm = readtable(filename, 'Sheet', sheetName, 'Range', range);
goalVm = table2array(goalVm);

range = 'A29:CW54';
spaceVm = readtable(filename, 'Sheet', sheetName, 'Range', range);
spaceVm = table2array(spaceVm);

range = 'A57:A63';
goalCellID = readtable(filename, 'Sheet', sheetName, 'Range', range);
goalCellID = table2array(goalCellID);

range = 'B57:B67';
spaceCellID = readtable(filename, 'Sheet', sheetName, 'Range', range);
spaceCellID = table2array(spaceCellID);

range = 'C57:C66';
interCellID = readtable(filename, 'Sheet', sheetName, 'Range', range);
interCellID = table2array(interCellID);


figure
for i = 1:length(goalCellID)
    subplot(11,6,i*6-5)
    plot(goalVm(goalCellID(i),:),'k')
    hold on
    plot([92 92],[-15 15],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-15 15])
    
    subplot(11,6,i*6-4)
    plot(0:1.84:184,spaceVm(goalCellID(i),:),'k')
    hold on
    plot([92 92],[-15 15],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-15 15])
end

subplot(11,6,37)
plot(mean(goalVm(goalCellID(:),:)),'k','Linewidth',2)
hold on
plot([92 92],[-15 15],'--k')
plot([0 184],[0 0],'--k')
xlim([0 184])
ylim([-15 15])

subplot(11,6,38)
plot(0:1.84:184,mean(spaceVm(goalCellID(:),:)),'k','Linewidth',2)
hold on
plot([92 92],[-15 15],'--k')
plot([0 184],[0 0],'--k')
xlim([0 184])
ylim([-15 15])

for i = 1:length(spaceCellID)
    subplot(11,6,i*6-3)
    plot(goalVm(spaceCellID(i),:),'k')
    hold on
    plot([92 92],[-15 15],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-15 15])
    
    subplot(11,6,i*6-2)
    plot(0:1.84:184,spaceVm(spaceCellID(i),:),'k')
    hold on
    plot([92 92],[-15 15],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-15 15])
end

subplot(11,6,63)
plot(mean(goalVm(spaceCellID(:),:)),'k','Linewidth',2)
hold on
plot([92 92],[-15 15],'--k')
plot([0 184],[0 0],'--k')
xlim([0 184])
ylim([-15 15])

subplot(11,6,64)
plot(0:1.84:184,mean(spaceVm(spaceCellID(:),:)),'k','Linewidth',2)
hold on
plot([92 92],[-15 15],'--k')
plot([0 184],[0 0],'--k')
xlim([0 184])
ylim([-15 15])

for i = 1:length(interCellID)
    subplot(11,6,i*6-1)
    plot(goalVm(interCellID(i),:),'k')
    hold on
    plot([92 92],[-15 15],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-15 15])
    
    subplot(11,6,i*6)
    plot(0:1.84:184,spaceVm(interCellID(i),:),'k')
    hold on
    plot([92 92],[-15 15],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-15 15])
end

subplot(11,6,59)
plot(mean(goalVm(interCellID(:),:)),'k','Linewidth',2)
hold on
plot([92 92],[-15 15],'--k')
plot([0 184],[0 0],'--k')
xlim([0 184])
ylim([-15 15])

subplot(11,6,60)
plot(0:1.84:184,mean(spaceVm(interCellID(:),:)),'k','Linewidth',2)
hold on
plot([92 92],[-15 15],'--k')
plot([0 184],[0 0],'--k')
xlim([0 184])
ylim([-15 15])

%% panel B
sheetName = 'B';
range = 'A1:A7';
goalCell = readtable(filename, 'Sheet', sheetName, 'Range', range);
goalCell = table2array(goalCell);

range = 'B1:B11';
spaceCell = readtable(filename, 'Sheet', sheetName, 'Range', range);
spaceCell = table2array(spaceCell);

range = 'C1:C9';
interCell = readtable(filename, 'Sheet', sheetName, 'Range', range);
interCell = table2array(interCell);

figure
scatter(ones(1,6),goalCell,'filled','r')
hold on
scatter(2*ones(1,10),spaceCell,'filled','b')
scatter(3*ones(1,8),interCell,'filled','k')
xlim([0.5 3.5])
ylim([-1 1])
ylabel('Goal/space index')
%% panel C
ego1 = [5 11];
allo1 = [9 12 15:17 20 24];
mix1 = [1 2 8 10 14 18 25];

for i = 1:25
    tmp = spaceVm(i,:);
a1(i,1) = trapz(tmp(35:50))*1.84;
a1(i,2) = trapz(tmp(50:65))*1.84;

    tmp = goalVm(i,:);
a2(i,1) = trapz(tmp(62:92));
a2(i,2) = trapz(tmp(92:122));
a(i,1) = (min(a1(i,:))+min(a2(i,:)))/(max(a1(i,:))+max(a2(i,:)));
end

figure
jitter = 0.1
scatter(ones(1,2) + (rand(1,2)-0.5)*jitter,a(ego1,1),'filled','r')
hold on
scatter(2*(ones(1,7) + (rand(1,7)-0.5)*jitter),a(allo1,1),'filled','b')
scatter(3*(ones(1,7) + (rand(1,7)-0.5)*jitter),a(mix1,1),'filled','k')
xlim([0.5 3.5])
ylim([0 1])
yticks([0 0.5 1 1.5 2])
xticks([1 2 3])
[h p] = ttest2(a(mix1,1), a(ego1,1))
[h p] = ttest2(a(mix1,1), a(allo1,1))