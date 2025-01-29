%% Extended Figure 6
% panel A
filename = 'ExtendedData_6_data.xlsx';
sheetName = 'panel A';
range = 'A1:B27';
PF_COM_pre = readtable(filename, 'Sheet', sheetName, 'Range', range);
PF_COM_pre = table2array(PF_COM_pre);

range = 'D1:D7';
Cell_id_goal = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_goal = table2array(Cell_id_goal);

range = 'E1:E11';
Cell_id_space = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_space = table2array(Cell_id_space);

range = 'F1:F11';
Cell_id_inter = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_inter = table2array(Cell_id_inter);

figure
scatter(PF_COM_pre(Cell_id_goal,1),PF_COM_pre(Cell_id_goal,2),'r','filled')
hold on
scatter(PF_COM_pre(Cell_id_space,1),PF_COM_pre(Cell_id_space,2),'b','filled')
scatter(PF_COM_pre(Cell_id_inter,1),PF_COM_pre(Cell_id_inter,2),'k','filled')

x = [0 184];
P = polyfit(PF_COM_pre(:,1),PF_COM_pre(:,2),1);
yfit = polyval(P,x);
mdl = fitlm(PF_COM_pre(:,1),PF_COM_pre(:,2));
plot(x,yfit,'g')
plot([0 184],[0 184],'--k')

xlim([0 184])
ylim([0 184])
xlabel('Vm COM(cm),pre');
ylabel('PF COM(cm),pre')

%% panel B
sheetName = 'B';
range = 'A1:B27';
PF_COM = readtable(filename, 'Sheet', sheetName, 'Range', range);
PF_COM = table2array(PF_COM);

range = 'D1:D7';
Cell_id_goal = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_goal = table2array(Cell_id_goal);

range = 'E1:E11';
Cell_id_space = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_space = table2array(Cell_id_space);

range = 'F1:F11';
Cell_id_inter = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_inter = table2array(Cell_id_inter);

figure
scatter(PF_COM(Cell_id_goal,1),PF_COM(Cell_id_goal,2),'r','filled')
hold on
scatter(PF_COM(Cell_id_space,1),PF_COM(Cell_id_space,2),'b','filled')
scatter(PF_COM(Cell_id_inter,1),PF_COM(Cell_id_inter,2),'k','filled')

plot([0 92],[92 184],'--k')
plot([0 184],[0 184],'--k')
plot([92 184],[0 92],'--k')

xlim([0 184])
ylim([0 184])
xlabel('PF COM(cm),pre');
ylabel('PF COM(cm),post')

%% panel C
sheetName = 'C';
range = 'A1:B27';
PF_COM_post = readtable(filename, 'Sheet', sheetName, 'Range', range);
PF_COM_post = table2array(PF_COM_post);

range = 'D1:D7';
Cell_id_goal = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_goal = table2array(Cell_id_goal);

range = 'E1:E11';
Cell_id_space = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_space = table2array(Cell_id_space);

range = 'F1:F11';
Cell_id_inter = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_inter = table2array(Cell_id_inter);

figure
scatter(PF_COM_post(Cell_id_goal,1),PF_COM_post(Cell_id_goal,2),'r','filled')
hold on
scatter(PF_COM_post(Cell_id_space,1),PF_COM_post(Cell_id_space,2),'b','filled')
scatter(PF_COM_post(Cell_id_inter,1),PF_COM_post(Cell_id_inter,2),'k','filled')

x = [0 184];
P = polyfit(PF_COM_post(:,1),PF_COM_post(:,2),1);
yfit = polyval(P,x);
mdl = fitlm(PF_COM_post(:,1),PF_COM_post(:,2));
plot(x,yfit,'g')
plot([0 184],[0 184],'--k')

xlim([0 184])
ylim([0 184])
xlabel('Vm COM(cm),post');
ylabel('PF COM(cm),post')

%% panel D
sheetName = 'D';
range = 'A1:A428';
imaging_PFChange = readtable(filename, 'Sheet', sheetName, 'Range', range);
imaging_PFChange = table2array(imaging_PFChange);

range = 'B1:B27';
wholeCell_PFChanges = readtable(filename, 'Sheet', sheetName, 'Range', range);
wholeCell_PFChanges = table2array(wholeCell_PFChanges);

% ks test
[h,p] = kstest2(imaging_PFChange, wholeCell_PFChanges)
% [p,h] = ranksum(x, wholeCell_filedPostiionChange_abs)

[N1, E1] = histcounts(imaging_PFChange, 'BinLimit', [0 25], 'BinWidth', 2, 'Normalization', 'probability')
[N2, E2] = histcounts(wholeCell_PFChanges, 'BinLimit', [0 25], 'BinWidth', 2, 'Normalization', 'probability')

colorM = cbrewer('qual', 'Set1', 9)
figure;
E1(end) = 26 % make it symmetric
plot(E1(2:end), N1, 'k'); hold on;
plot(E1(2:end), N2, 'Color', colorM(3, :))
axis square
xticks([2 14 26]); xticklabels({'0', '45', '90'}); box off; set(gca, 'FontSize', 15); 
yticks([0  0.05  0.1 0.15 0.2]); set(gca,'TickDir','out'); xlim([1 27]); ylim([-0.01 0.21])
xlabel('delta PF Position (cm)'); ylabel('Fraction of PCs')
title(['p value is ', num2str(p, '%.2f') ', ks-test']); 
legend('imaging', 'whole-cell');legend('boxoff')

%% panel E
sheetName = 'E1';
range = 'A1:GB16';
exampleCell = readtable(filename, 'Sheet', sheetName, 'Range', range);
exampleCell = table2array(exampleCell);

figure;
a = smoothdata(exampleCell,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([-54 -42])
hold on;

plot([184 184],[0 11.5],'--k','linewidth',2)
plot([92 92],[11.5 15.5],'--k','linewidth',2)
plot([0 184],[11.5 11.5],'--k','linewidth',2)

xlabel('Location(cm)');
ylabel('Laps');

sheetName = 'E2';
range = 'A1:B185';
exampleCellFR = readtable(filename, 'Sheet', sheetName, 'Range', range);
exampleCellFR = table2array(exampleCellFR);

figure
subplot(2,1,1)
plot(smoothdata(mean(exampleCell(1:11,:)),'gaussian',5),'Color', [0.5, 0.5, 0.5])
hold on
plot(smoothdata(mean(exampleCell(12:15,:)),'gaussian',5),'Color', [0, 0, 0])
plot([34 34],[-60 -40],'--b')
plot([126 126],[-60 -40],'--r')
xlim([0 184])
ylim([-60 -40])
legend(['pre',newline],['post, before 1st plateau',newline])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

subplot(2,1,2)
plot(smoothdata(exampleCellFR(:,1),'gaussian',5),'Color', [0.5, 0.5, 0.5])
hold on
plot(smoothdata(exampleCellFR(:,2),'gaussian',5),'Color', [0, 0, 0])
plot([34 34],[-60 -40],'--b')
plot([126 126],[-60 -40],'--r')
xlim([0 184])
ylim([0 35])
legend(['pre',newline],['post',newline])
xlabel('Location(cm)');
ylabel('Firing rate(Hz)')

%% panel F
sheetName = 'F';
range = 'A1:B27';
GS_index = readtable(filename, 'Sheet', sheetName, 'Range', range);
GS_index = table2array(GS_index);

range = 'D1:D7';
Cell_id_goal = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_goal = table2array(Cell_id_goal);

range = 'E1:E11';
Cell_id_space = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_space = table2array(Cell_id_space);

range = 'F1:F11';
Cell_id_inter = readtable(filename, 'Sheet', sheetName, 'Range', range);
Cell_id_inter = table2array(Cell_id_inter);

figure
scatter(GS_index(Cell_id_goal,1),GS_index(Cell_id_goal,2),'r','filled')
hold on
scatter(GS_index(Cell_id_space,1),GS_index(Cell_id_space,2),'b','filled')
scatter(GS_index(Cell_id_inter,1),GS_index(Cell_id_inter,2),'k','filled')

x = [0 184];
P = polyfit(GS_index(:,1),GS_index(:,2),1);
yfit = polyval(P,x);
mdl = fitlm(GS_index(:,1),GS_index(:,2));
plot(x,yfit,'g')
plot([0 184],[0 0],'--k')

ylim([-1 1])
xlim([0 184])
xlabel('PF COM(cm),pre');
ylabel('Goal/space index')

%% panel G
sheetName = 'G';
range = 'A1:B36';
Plateau_location = readtable(filename, 'Sheet', sheetName, 'Range', range);
Plateau_location = table2array(Plateau_location);

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
scatter(Plateau_location(Cell_id_goal,1),Plateau_location(Cell_id_goal,2),'r','filled')
hold on
scatter(Plateau_location(Cell_id_space,1),Plateau_location(Cell_id_space,2),'b','filled')
scatter(Plateau_location(Cell_id_inter,1),Plateau_location(Cell_id_inter,2),'k','filled')

x = [0 184];
P = polyfit(Plateau_location(:,1),Plateau_location(:,2),1);
yfit = polyval(P,x);
mdl = fitlm(Plateau_location(:,1),Plateau_location(:,2));
plot(x,yfit,'g')
plot([0 184],[0 184],'--k')
plot([92 92],[0 184],'--k')

ylim([0 184])
xlim([0 184])
xlabel('PF COM(cm), before plateau');
ylabel('Plateau location(cm)')