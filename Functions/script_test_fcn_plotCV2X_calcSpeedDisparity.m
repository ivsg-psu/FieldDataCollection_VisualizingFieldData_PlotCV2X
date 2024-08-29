%% script_test_fcn_plotCV2X_calcSpeedDisparity
% This is a script to exercise the function:
% fcn_plotCV2X_calcSpeedDisparity.m
% This function was written on 2024_08_28 by S. Brennan, sbrennan@psu.edu


%% test 1 - velocity calculation using TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv test file
fig_num = 1;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 20;
[speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcSpeedDisparity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)
assert(length(meanVelocityVector(1,:))== 2)
assert(length(stdVelocityVector(1,:))== 2)
assert(length(Mspeeds(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)
assert(length(meanVelocityVector(:,1))== Nrows_expected)
assert(length(stdVelocityVector(:,1))== Nrows_expected)
assert(length(Mspeeds(:,1))== Nrows_expected)


%% test 2 - collect data with no plotting
fig_num = 2;
figure(fig_num);
close(fig_num);

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 20;
[speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, ([]));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcSpeedDisparity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(~ishandle(fig_num)));


% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)
assert(length(meanVelocityVector(1,:))== 2)
assert(length(stdVelocityVector(1,:))== 2)
assert(length(Mspeeds(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)
assert(length(meanVelocityVector(:,1))== Nrows_expected)
assert(length(stdVelocityVector(:,1))== Nrows_expected)
assert(length(Mspeeds(:,1))== Nrows_expected)


%% test 3 - load the TestTrack_PendulumRSU_InstallTest_OuterLane2_2024_08_09.csv test file
fig_num = 3;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane2_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 20;
[speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcSpeedDisparity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));


% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)
assert(length(meanVelocityVector(1,:))== 2)
assert(length(stdVelocityVector(1,:))== 2)
assert(length(Mspeeds(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)
assert(length(meanVelocityVector(:,1))== Nrows_expected)
assert(length(stdVelocityVector(:,1))== Nrows_expected)
assert(length(Mspeeds(:,1))== Nrows_expected)


%% test 4 - load the TestTrack_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv test file
fig_num = 4;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 20;
[speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcSpeedDisparity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)
assert(length(meanVelocityVector(1,:))== 2)
assert(length(stdVelocityVector(1,:))== 2)
assert(length(Mspeeds(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)
assert(length(meanVelocityVector(:,1))== Nrows_expected)
assert(length(stdVelocityVector(:,1))== Nrows_expected)
assert(length(Mspeeds(:,1))== Nrows_expected)

%% test 5 - load the TestTrack_PendulumRSU_InstallTest_InnerLane2_2024_08_09.csv test file
fig_num = 5;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_InnerLane2_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 1.5;
[speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcSpeedDisparity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));


% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)
assert(length(meanVelocityVector(1,:))== 2)
assert(length(stdVelocityVector(1,:))== 2)
assert(length(Mspeeds(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)
assert(length(meanVelocityVector(:,1))== Nrows_expected)
assert(length(stdVelocityVector(:,1))== Nrows_expected)
assert(length(Mspeeds(:,1))== Nrows_expected)

%% test 6 - find the variance-minimizing means
% The following code performs AVAR analysis on the data to see how the mean
% values change as we include larger/larger amounts of data around each
% point to calculate the mean. There are two competing effects: as more
% data is added, the variance decreases by the square-root of the count.
% However, as more data is added around the point, the speed will change
% from the average due to the speed actually changing. These effects
% "fight" each other. The minimum variance result gives the "best" mean
% velocity estimate we can find, and as well tells us the best uncertainty
% we should expect.
%
% This shows that ~6 meters is the variance-minimizing search distance, and
% the best variance we will see is about 0.1 m/s.

fig_num = 6;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function across a large range
% rangesToTest = (0.01*2.^(0:16))';
rangesToTest = logspace(-1,2,50)';
Npoints = length(tLLA(:,1));
Nranges = length(rangesToTest);

% Initialize storage arrays
AllMeanVelocities = zeros(Npoints,Nranges);
AllStdsVelocities = zeros(Npoints,Nranges);
AllMvalVelocities = zeros(Npoints,Nranges);

% For each range, do calculations
for ith_range = 1:Nranges
    searchRadiusAndAngles = rangesToTest(ith_range,1);
    fprintf(1,'Testing range: %.2f meters\n',searchRadiusAndAngles(1));
    [speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (-1));
    AllMeanVelocities(:,ith_range) = real(sum(meanVelocityVector.^2,2).^0.5);
    AllStdsVelocities(:,ith_range) = real(sum(stdVelocityVector.^2,2).^0.5);
    AllMvalVelocities(:,ith_range) = Mspeeds;
end

% Remove bad values
goodIndicies = ~isnan(AllMeanVelocities(:,end));
goodAllMeanVelocities = AllMeanVelocities(goodIndicies,:);
goodAllStdsVelocities = AllStdsVelocities(goodIndicies,:);
goodAllMvalVelocities = AllMvalVelocities(goodIndicies,:);

% Standard deviations of infinity and less than 0.1 are not possible. 
maxStd = max(goodAllStdsVelocities(~isinf(goodAllStdsVelocities)),[],'all');
goodAllStdsVelocities(isinf(goodAllStdsVelocities)) = nan;
goodAllStdsVelocities(0.1>=goodAllStdsVelocities) = nan;

meanStds = goodAllStdsVelocities./(goodAllMvalVelocities.^0.5);

meanOfMeanStds = mean(meanStds,1,'omitnan')';

% Check results with plot
figure(345);
clf;
for ith_point = 1:1:length(meanStds(:,1))
    loglog(rangesToTest,meanStds(ith_point,:),'.','MarkerSize',20)
    if ith_point==1
        hold on;
        grid on;
        xlabel('Search range');
        ylabel('Variance in mean');
    end
end
loglog(rangesToTest,meanOfMeanStds,'b-','LineWidth',5);



% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)
assert(length(meanVelocityVector(1,:))== 2)
assert(length(stdVelocityVector(1,:))== 2)
assert(length(Mspeeds(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)
assert(length(meanVelocityVector(:,1))== Nrows_expected)
assert(length(stdVelocityVector(:,1))== Nrows_expected)
assert(length(Mspeeds(:,1))== Nrows_expected)
%% Speed test

% Load the data
csvFile = 'TestTrack_PendulumRSU_InstallTest_InnerLane2_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));
searchRadiusAndAngles = 20;

% Test the function
fig_num=[];
REPS=5; 
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;

% Slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    [speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
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
    [speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotCV2X_calcSpeedDisparity without speed setting (slow) and with speed setting (fast):\n');
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

