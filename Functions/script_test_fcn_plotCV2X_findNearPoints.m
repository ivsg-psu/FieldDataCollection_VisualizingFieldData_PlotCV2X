%% script_test_fcn_plotCV2X_findNearPoints
% This is a script to exercise the function:
% fcn_plotCV2X_findNearPoints.m
% This function was written on 2024_08_26 by S. Brennan, sbrennan@psu.edu


%% test 1 - velocity calculation using TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv test file
fig_num = 1;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 50;
nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (fig_num));
title({sprintf('Example %.0d: showing fcn_plotCV2X_findNearPoints',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right size?
Nrows_expected = length(tLLA(:,1));
assert(length(nearbyIndicies(1,:))== Nrows_expected)




%% test 2 - collect data with no plotting
fig_num = 2;
figure(fig_num);
close(fig_num);

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 50;
nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, ([]));
title({sprintf('Example %.0d: showing fcn_plotCV2X_findNearPoints',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(~ishandle(fig_num)));

% Does the data have right size?
Nrows_expected = length(tLLA(:,1));
assert(length(nearbyIndicies(1,:))== Nrows_expected)


%% test 3 - testing association by distance and angle

fig_num = 1;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));


% Test the function
searchRadiusAndAngles = [500 10*pi/180];
nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (fig_num));
title({sprintf('Example %.0d: showing fcn_plotCV2X_findNearPoints',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right size?
Nrows_expected = length(tLLA(:,1));
assert(length(nearbyIndicies(1,:))== Nrows_expected)



%% Speed test

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));
searchRadiusAndAngles = 50;

% Test the function
fig_num=[];
REPS=5; 
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;

% Slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (fig_num));
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
    nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotCV2X_findNearPoints without speed setting (slow) and with speed setting (fast):\n');
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
assert(averageTimeFast<4*averageTimeSlow);