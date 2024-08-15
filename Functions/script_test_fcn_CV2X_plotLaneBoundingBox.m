%% script_test_fcn_PlotTestTrack_plotLaneBoundingBox.m 

% This is a script to exercise the function:
% fcn_PlotTestTrack_animateAVLane.m 
% This function was written on 2024_07_18 by Joseph Baker jmb9658@psu.edu


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
left_color = [];
right_color= [];
center_color = [];
lane_color = [];
fig_num = 177;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);

assert(length(LLA_leftLane) == 5988)
assert(length(LLA_rightLane) == 5988)
assert(length(LLA_centerOfLane) == 5988)


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
left_color = [];
right_color= [];
center_color = [];
lane_color = [];
fig_num = 200;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);

assert(length(LLA_leftLane) == 754)
assert(length(LLA_rightLane) == 754)
assert(length(LLA_centerOfLane) == 754)

%% Basic example 3 - TestTrack 2
csvFile = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;


baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 4;
left_color = [1 0 0];
right_color= [0 0 1];
center_color = [0 1 0];
lane_color = [.8 .8 .8];
fig_num = 300;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);

assert(length(LLA_leftLane) == 713)
assert(length(LLA_rightLane) == 713)
assert(length(LLA_centerOfLane) == 713)


%% Basic example 4 - TestTrack 1 with different lane width
csvFile = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;



baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 6;
left_color = [];
right_color= [];
center_color = [];
lane_color = [];
fig_num = 400;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);

assert(length(LLA_leftLane) == 754)
assert(length(LLA_rightLane) == 754)
assert(length(LLA_centerOfLane) == 754)


%% Basic example 5 - Speed Plot of TestTrack 2 with different lane width and plot color
csvFilename = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 10;
left_color = [0 0 1];
right_color= [0 1 1];
center_color = [1 0 0];
lane_color = [0 0 0];
fig_num = 500;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFilename, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);

assert(length(LLA_leftLane) == 713)
assert(length(LLA_rightLane) == 713)
assert(length(LLA_centerOfLane) == 713)

%% testing speed of function

% load inputs
csvFilename = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 10;
left_color = [0 0 1];
right_color= [0 1 1];
center_color = [1 0 0];
lane_color = [0 0 0];

% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFilename, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);
telapsed=toc(tstart);
minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
%slow mode END
%Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
tstart = tic;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFilename, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);
telapsed = toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotLaneBoundingBox without speed setting (slow) and with speed setting (fast):\n');
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