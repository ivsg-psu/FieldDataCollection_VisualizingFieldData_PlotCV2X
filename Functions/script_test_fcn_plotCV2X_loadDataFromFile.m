%% script_test_fcn_plotCV2X_loadDataFromFile
% This is a script to exercise the function:
% fcn_plotCV2X_loadDataFromFile.m
% This function was written on 2024_08_15 by S. Brennan, sbrennan@psu.edu


%% test 1 - load the 2024_08_09a test file
fig_num = 1;
figure(fig_num);
clf;

csvFile = 'TestTrack_PendulumRSU_InstallTest_2024_08_09a.csv'; % Path to your CSV file

[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1149;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)

%% test 2 - collect data with no plotting
fig_num = 2;
figure(fig_num);
clf;

csvFile = 'TestTrack_PendulumRSU_InstallTest_2024_08_09a.csv'; % Path to your CSV file

[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, ([]));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1149;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)


close(2);

%% Speed test

csvFile = 'TestTrack_PendulumRSU_InstallTest_2024_08_09a.csv'; % Path to your CSV file

fig_num=[];
REPS=5; 
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
    maxTimeSlow=max(telapsed,maxTimeSlow);
end
averageTimeSlow=toc/REPS;
%slow mode END
%Fast Mode Calculation
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
%Display Console Comparison
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

