%% Extended Figure 10
% panel A
filename = 'ExtendedData_10_data.xlsx';
sheetName = 'panel A';
range = 'B2:E320288';
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
range = 'A1:GB85';
examplePC = readtable(filename, 'Sheet', sheetName, 'Range', range);
examplePC = table2array(examplePC);
Pre = 1:15; % trials before reward switch
Post = 16:84; % trials after reward switch

figure;
a = smoothdata(examplePC,2,'gaussian',11,'omitnan'); 
imagesc(a);
colormap(flipud(gray));
colorbar;
caxis([-56 -38])

hold on;
plot([184 184],[0 Pre(end)+0.5],'--k','linewidth',2)
plot([92 92],[Pre(end)+0.5 Post(end)+0.5],'--k','linewidth',2)
plot([0 184],[Pre(end)+0.5 Pre(end)+0.5],'--k','linewidth',2)

xlabel('Location(cm)');
ylabel('Laps');

%% panel C
Pre = 1:15; % trials before reward switch
Post = 16:37; % trials after reward switch

figure
plot(smoothdata(mean(examplePC(Pre,:)),'gaussian',5),'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
plot(smoothdata(mean(examplePC(Post,:)),'gaussian',5),'Color', [0, 0, 0], 'LineWidth', 1)
plot([73 73],[-59 -44],'--b','linewidth',1)
plot([165 165],[-59 -44],'--r','linewidth',1)
xlim([0 184])
ylim([-59 -44])
legend(['pre',newline],['post, before 1st plateau',newline])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

%% panel D
PF = 73; % the PF was calculated from the COM of spike
Pre = 1:15; % trials before reward switch
Post = 16:37; % trials after reward switch

% calculate goalVm
tmp = mean(examplePC(Post,:) - mean(examplePC(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
examplePC_goalVm = tmp(PF:184+PF-1);

% calculate spaceVm
examplePC_toReward(Pre,:) = examplePC(Pre,:);
examplePC_toReward(Post,1:92) = examplePC(Post,92+1:184);
examplePC_toReward(Post,92+1:184) = examplePC(Post,1:92);
tmp = mean(examplePC_toReward(Post,:) - mean(examplePC_toReward(Pre,:)));
tmp(184+1:184+PF) = tmp(1:PF);
examplePC_spaceVm = tmp(PF:184+PF-1);

figure
subplot(1,2,1)
plot(examplePC_goalVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
y = examplePC_goalVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'r')

plot(smoothdata(examplePC_goalVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-12 12])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Goal Vm');

subplot(1,2,2)
plot(examplePC_spaceVm,'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
y = examplePC_spaceVm(62:122);
y = [0 y 0];
x = [62 62:122 122];
fill(x,y,'b')

plot(smoothdata(examplePC_spaceVm,'gaussian',51),'Color', [0, 0, 0], 'LineWidth', 2)
plot([0 184],[0 0],'--k','linewidth',1)
plot([92 92],[-12 12],'--k','linewidth',1)
xlim([0 184])
ylim([-12 12])
xlabel('Distance to PF(cm)');
ylabel('delta Vm(mV)')
title('Space Vm');

%% panel E
Pre = 39:46; % trials before reward switch
Post = 48:50; % trials after reward switch

figure
plot(smoothdata(mean(examplePC(Pre,:)),'gaussian',5),'Color', [0.5, 0.5, 0.5], 'LineWidth', 1)
hold on
plot(smoothdata(mean(examplePC(Post,:)),'gaussian',5),'Color', [0, 0, 0], 'LineWidth', 1)
plot([73 73],[-59 -35],'--b','linewidth',1)
plot([165 165],[-59 -35],'--r','linewidth',1)
xlim([0 184])
ylim([-59 -35])
legend(['pre',newline],['post, before 1st plateau',newline])
xlabel('Location(cm)');
ylabel('Voltage(mV)')

%% panel F
sheetName = 'F';
range = 'A1:B301';
Kernel = readtable(filename, 'Sheet', sheetName, 'Range', range);
Kernel = table2array(Kernel);

figure
plot(Kernel(:,1),smoothdata(Kernel(:,2),'movmean',11),'k')
hold on
plot([0 0],[-6 12],'k')
plot([-5 5],[0 0],'k')
xlim([-5 5])
ylim([-6 12])
xlabel('Times form plateau(s)')
ylabel('delta Vm(mV)')

%% panel G
sheetName = 'G';
range = 'A1:B301';
Kernel = readtable(filename, 'Sheet', sheetName, 'Range', range);
Kernel = table2array(Kernel);

figure
plot(Kernel(:,1),smoothdata(Kernel(:,2),'movmean',11),'k')
hold on
plot([0 0],[-6 12],'k')
plot([-5 5],[0 0],'k')
xlim([-5 5])
ylim([-6 12])
xlabel('Times form plateau(s)')
ylabel('delta Vm(mV)')