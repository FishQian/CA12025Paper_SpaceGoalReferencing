%% Extended Figure 8
% panel A
filename = 'ExtendedData_8_data.xlsx';
sheetName = 'panel A';
range = 'A1:GB26';
goalVm = readtable(filename, 'Sheet', sheetName, 'Range', range);
goalVm = table2array(goalVm);

range = 'A29:GB54';
spaceVm = readtable(filename, 'Sheet', sheetName, 'Range', range);
spaceVm = table2array(spaceVm);

range = 'A57:GB82';
originalVm = readtable(filename, 'Sheet', sheetName, 'Range', range);
originalVm = table2array(originalVm);

range = 'A85:A91';
goalCellID = readtable(filename, 'Sheet', sheetName, 'Range', range);
goalCellID = table2array(goalCellID);

range = 'B85:B95';
spaceCellID = readtable(filename, 'Sheet', sheetName, 'Range', range);
spaceCellID = table2array(spaceCellID);

range = 'C85:C94';
interCellID = readtable(filename, 'Sheet', sheetName, 'Range', range);
interCellID = table2array(interCellID);

range = 'E85:E110';
baseline = readtable(filename, 'Sheet', sheetName, 'Range', range);
baseline = table2array(baseline);


figure
for i = 1:length(goalCellID)
    subplot(10,3,i*3-2)
    plot(originalVm(goalCellID(i),:)+baseline(goalCellID(i)),'k')
    hold on
    plot(goalVm(goalCellID(i),:),'r')
    plot(spaceVm(goalCellID(i),:),'b')
    plot(goalVm(goalCellID(i),:)+spaceVm(goalCellID(i),:),'g')
    plot([92 92],[-20 20],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-20 20])
end

for i = 1:length(spaceCellID)
    subplot(10,3,i*3-1)
    plot(originalVm(spaceCellID(i),:)+baseline(spaceCellID(i)),'k')
    hold on
    plot(goalVm(spaceCellID(i),:),'r')
    plot(spaceVm(spaceCellID(i),:),'b')
    plot(goalVm(spaceCellID(i),:)+spaceVm(spaceCellID(i),:),'g')
    plot([92 92],[-20 20],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-20 20])
end

for i = 1:length(interCellID)
    subplot(10,3,i*3)
    plot(originalVm(interCellID(i),:)+baseline(interCellID(i)),'k')
    hold on
    plot(goalVm(interCellID(i),:),'r')
    plot(spaceVm(interCellID(i),:),'b')
    plot(goalVm(interCellID(i),:)+spaceVm(interCellID(i),:),'g')
    plot([92 92],[-20 20],'--k')
    plot([0 184],[0 0],'--k')
    xlim([0 184])
    ylim([-20 20])
end

%% panel B
for i = 1:25
    tmp = Vm_original(i,:) + baseline(i);
    a(i,1) = trapz(tmp(62:122));
    a(i,2) = trapz(Vm_ego(i,62:122));
    a(i,3) = trapz(Vm_allo(i,62:122));
    a(i,4) = (a(i,2)+a(i,3))/a(i,1);
end

figure
scatter(ones(1,6),a(goalCellID,4),'r','filled')
hold on
scatter(2*ones(1,10),a(spaceCellID,4),'b','filled')
scatter(3*ones(1,9),a(interCellID,4),'k','filled')
plot([0 4],[1 1],'--k')
ylim([0 2])
xlim([0 4])
ylabel('Area ratio(reconstructed/original)')