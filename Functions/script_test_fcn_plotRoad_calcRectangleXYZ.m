%% script_test_fcn_plotRoad_calcRectangleXYZ.m
% This is a script to exercise the function:
% fcn_plotRoad_calcRectangleXYZ.m


% Revision history:
% 2023_08_13 by S. Brennan, sbrennan@psu.edu
% -- start writing function by heavily modifying version from PlotTestTrack

%% Basic Example 1: Basic rectangle
fig_num = 1;
figure(fig_num);
clf;


centerPointXYZ = [0 0];
LWH = [4 2];
yawAngle = [];
centerOffsetLWH = [];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(fig_num)));
assert(length(cornersXYZ(:,1))==5);
assert(length(cornersXYZ(1,:))==2);
assert(isequal(round(cornersXYZ,4),[...
    -2    -1
    2    -1
    2     1
    -2     1
    -2    -1]));


%% Basic Example 2: Basic rectangle, moved location
fig_num = 2;
figure(fig_num);
clf;


centerPointXYZ = [2 1];
LWH = [4 2];
yawAngle = [];
centerOffsetLWH = [];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(fig_num)));
assert(length(cornersXYZ(:,1))==5);
assert(length(cornersXYZ(1,:))==2);
assert(isequal(round(cornersXYZ,4),[...
    0     0
    4     0
    4     2
    0     2
    0     0]));


%% Basic Example 3: Basic rectangle, moved and rotated
fig_num = 3;
figure(fig_num);
clf;


centerPointXYZ = [2 1];
LWH = [4 2];
yawAngle = 45*pi/180;
centerOffsetLWH = [];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(fig_num)));
assert(length(cornersXYZ(:,1))==5);
assert(length(cornersXYZ(1,:))==2);
assert(isequal(round(cornersXYZ,4),[...
    1.2929   -1.1213
    4.1213    1.7071
    2.7071    3.1213
    -0.1213    0.2929
    1.2929   -1.1213]));

%% Basic Example 4: Basic rectangle, moved and rotated and measured from back corner
fig_num = 4;
figure(fig_num);
clf;


centerPointXYZ = [0 0];
LWH = [4 2];
yawAngle = 45*pi/180;
centerOffsetLWH = [2 1];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(fig_num)));
assert(length(cornersXYZ(:,1))==5);
assert(length(cornersXYZ(1,:))==2);
assert(isequal(round(cornersXYZ,4),[...
    0         0
    2.8284    2.8284
    1.4142    4.2426
    -1.4142    1.4142
    0         0]));


%% Basic Example 5: Basic 3D rectangle, moved and rotated and measured from back corner
fig_num = 5;
figure(fig_num);
clf;


centerPointXYZ = [0 0 0];
LWH = [4 2 1];
yawAngle = 45*pi/180;
centerOffsetLWH = [2 1 0.5];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(fig_num)));
assert(length(cornersXYZ(:,1))==5*6);
assert(length(cornersXYZ(1,:))==3);
assert(isequal(round(cornersXYZ,4),[...
         0         0         0
   -1.4142    1.4142         0
    1.4142    4.2426         0
    2.8284    2.8284         0
         0         0         0
         0         0         0
         0         0    1.0000
   -1.4142    1.4142    1.0000
   -1.4142    1.4142         0
         0         0         0
         0         0         0
    2.8284    2.8284         0
    2.8284    2.8284    1.0000
         0         0    1.0000
         0         0         0
         0         0    1.0000
    2.8284    2.8284    1.0000
    1.4142    4.2426    1.0000
   -1.4142    1.4142    1.0000
         0         0    1.0000
    2.8284    2.8284    1.0000
    2.8284    2.8284         0
    1.4142    4.2426         0
    1.4142    4.2426    1.0000
    2.8284    2.8284    1.0000
    1.4142    4.2426    1.0000
   -1.4142    1.4142    1.0000
   -1.4142    1.4142         0
    1.4142    4.2426         0
    1.4142    4.2426    1.0000]));

%% Testing speed mode

centerPointXYZ = [0 0];
LWH = [4 2];
yawAngle = 45*pi/180;
centerOffsetLWH = [2 1];


% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;

% Slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
% Slow mode END

% Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
    tstart = tic;
    cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotRoad_calcRectangleXYZ without speed setting (slow) and with speed setting (fast):\n');
    fprintf(1,'N repetitions: %.0d\n',REPS);
    fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
    fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
    fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
    fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
    fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
    fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
end
%Assertion on averageTime NOTE: Due to the variance, there is a chance that
%the assertion will fail.
assert(averageTimeFast<averageTimeSlow);
diff = averageTimeFast*10000 - averageTimeSlow*10000;
