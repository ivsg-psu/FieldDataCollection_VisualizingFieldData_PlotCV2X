%% script_test_fcn_PlotTestTrack_calculateLaneLines.m 

% This is a script to exercise the function:
% fcn_PlotTestTrack_calculateLaneLines.m 
% This function was written on 2024_08_05 by Vaishnavi Wagh vbw5054@psu.edu


%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_2_11_07_2024.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
baseAlt = reference_altitude_pitts;
laneWidth = [];
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 5988)
assert(length(ENU_LeftLaneY) == 5988)
assert(length(ENU_RightLaneX) == 5988)
assert(length(ENU_RightLaneY) == 5988)
assert(length(ENU_LaneCenterX) == 5988)
assert(length(ENU_LaneCenterY) == 5988)

%% Test Track
csvFile = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = [];
reference_longitude = [];
reference_altitude= [];
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = [];
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 754)
assert(length(ENU_LeftLaneY) == 754)
assert(length(ENU_RightLaneX) == 754)
assert(length(ENU_RightLaneY) == 754)
assert(length(ENU_LaneCenterX) == 754)
assert(length(ENU_LaneCenterY) == 754)

%% Basic example 3 - TestTrack 2
csvFile = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;


baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 4;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);
assert(length(ENU_LeftLaneX) == 713)
assert(length(ENU_LeftLaneY) == 713)
assert(length(ENU_RightLaneX) == 713)
assert(length(ENU_RightLaneY) == 713)
assert(length(ENU_LaneCenterX) == 713)
assert(length(ENU_LaneCenterY) == 713)

%% Basic example 4 - TestTrack 1 with different lane width
csvFile = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;



baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 6;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 754)
assert(length(ENU_LeftLaneY) == 754)
assert(length(ENU_RightLaneX) == 754)
assert(length(ENU_RightLaneY) == 754)
assert(length(ENU_LaneCenterX) == 754)
assert(length(ENU_LaneCenterY) == 754)

%% Basic example 5 - Speed Plot of TestTrack 2 with different lane width and plot color
csvFile = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 10;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 713)
assert(length(ENU_LeftLaneY) == 713)
assert(length(ENU_RightLaneX) == 713)
assert(length(ENU_RightLaneY) == 713)
assert(length(ENU_LaneCenterX) == 713)
assert(length(ENU_LaneCenterY) == 713)

%% testing speed of function

% load inputs
csvFile = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 10;

% Speed Test Calculation
% fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);
telapsed=toc(tstart);
minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
%slow mode END
%Fast Mode Calculation
minTimeFast = Inf;
tic;
for i=1:REPS
tstart = tic;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);
telapsed=toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_PlotTestTrack_calculateLaneLines without speed setting (slow) and with speed setting (fast):\n');
fprintf(1,'N repetitions: %.0d\n',REPS);
fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
end
% no assertion as function does not plot anything