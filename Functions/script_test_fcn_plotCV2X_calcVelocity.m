%% script_test_fcn_plotCV2X_calcVelocity
% This is a script to exercise the function:
% fcn_plotCV2X_calcVelocity.m
% This function was written on 2024_08_15 by S. Brennan, sbrennan@psu.edu


%% test 1 - velocity calculation using TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv test file
fig_num = 1;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
velocity = fcn_plotCV2X_calcVelocity(tENU, (fig_num));
title({sprintf('Example %.0d: showing fcn_plotCV2X_calcVelocity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 4 columns?
assert(length(velocity(1,:))== 1)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1149;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)

%% test 2 - collect data with no plotting
fig_num = 2;
figure(fig_num);
clf;

csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file

[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, ([]));

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1149;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)


close(2);

%% test 3 - load the TestTrack_PendulumRSU_InstallTest_OuterLane2_2024_08_09.csv test file
fig_num = 3;
figure(fig_num);
clf;

csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane2_2024_08_09.csv'; % Path to your CSV file

[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
subplot(1,2,1); title('ENU'); subplot(1,2,2); title('LLA');
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_loadDataFromFile',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1081;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)

%% test 4 - load the TestTrack_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv test file
fig_num = 4;
figure(fig_num);
clf;

csvFile = 'TestTrack_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'; % Path to your CSV file

[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
subplot(1,2,1); title('ENU'); subplot(1,2,2); title('LLA');
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_loadDataFromFile',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1688;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)

%% test 5 - load the TestTrack_PendulumRSU_InstallTest_InnerLane2_2024_08_09.csv test file
fig_num = 5;
figure(fig_num);
clf;

csvFile = 'TestTrack_PendulumRSU_InstallTest_InnerLane2_2024_08_09.csv'; % Path to your CSV file

[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
subplot(1,2,1); title('ENU'); subplot(1,2,2); title('LLA');
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_loadDataFromFile',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1697;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)


%% Speed test

csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file

fig_num=[];
REPS=5; 
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;

% Slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
    maxTimeSlow=max(telapsed,maxTimeSlow);
end
averageTimeSlow=toc/REPS;
% Slow mode END

% Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
    tstart = tic;
    [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotCV2X_loadDataFromFile without speed setting (slow) and with speed setting (fast):\n');
    fprintf(1,'N repetitions: %.0d\n',REPS);
    fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
    fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
    fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
    fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
    fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
    fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',maxTimeSlow/minTimeFast);
end
%Assertion on averageTime NOTE: Due to the variance, there is a chance that
%the assertion will fail.
assert(averageTimeFast<averageTimeSlow);

