%% script_test_fcn_PlotTestTrack_plotSpeedofAV.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotSpeedofAV.m
% This function was written on 2024_07_14 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_07_14
% -- first write of the code

%% Basic Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ____            _        ______                           _
%  |  _ \          (_)      |  ____|                         | |
%  | |_) | __ _ ___ _  ___  | |__  __  ____ _ _ __ ___  _ __ | | ___
%  |  _ < / _` / __| |/ __| |  __| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \
%  | |_) | (_| \__ \ | (__  | |____ >  < (_| | | | | | | |_) | |  __/
%  |____/ \__,_|___/_|\___| |______/_/\_\__,_|_| |_| |_| .__/|_|\___|
%                                                      | |
%                                                      |_|
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Basic%20Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% Basic example 1 - Speed Plot of Pittsburgh_2

csvFilename = 'Pittsburgh_2_11_07_2024.csv';

reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

base_station_coordinates = [reference_latitute, reference_longitude, reference_altitude];
maxVelocity = [];
minVelocity = [];
plot_color = 'jet';
LLA_fig_num = 101;
ENU_fig_num = 102;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
        csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==516);

%% Basic example 2 - RSU range test at PA-288 with time

csvFilename = 'PA_288_1.csv';

reference_latitute = 40.8471670113384;
reference_longitude = -80.26182223666619;
reference_altitude = 327.428;

base_station_coordinates = [reference_latitute, reference_longitude, reference_altitude];
maxVelocity = [];
minVelocity = [];
plot_color = 'jet';
LLA_fig_num = 101;
ENU_fig_num = 102;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
        csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==971);
%% Basic example 3 - RSU range test at Falling waters with time

csvFilename = 'site2_3.csv';

reference_latitute = 39.9882008;
reference_longitude =  -79.4210206;
reference_altitude = 327.428;

base_station_coordinates = [reference_latitute, reference_longitude, reference_altitude];
maxVelocity = [];
minVelocity = [];
plot_color = 'jet';
LLA_fig_num = 301;
ENU_fig_num = 302;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
        csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==501);
%% Basic example 4 - Speed Plot of TestTrack 1

csvFilename = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

maxVelocity = 30;
minVelocity = 5;
plot_color = 'jet';
LLA_fig_num = 201;
ENU_fig_num = 202;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
       csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==742);
%% Basic example 5 - Speed Plot of TestTrack 2
csvFilename = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

maxVelocity = 85;
minVelocity = 15;
plot_color = 'jet';
LLA_fig_num = 301;
ENU_fig_num = 302;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
       csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==678);

%% Basic example 6 - Speed Plot of TestTrack 1 with differentplot color
csvFilename = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

maxVelocity = 30;
minVelocity = 1;
plot_color = 'spring';
LLA_fig_num = 401;

ENU_fig_num = 402;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
       csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==742);
%% Basic example 7 - Speed Plot of TestTrack 2 with different max velocities and plot color
csvFilename = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

maxVelocity = 50;
minVelocity = 10;
plot_color = 'winter';
LLA_fig_num = 501;
ENU_fig_num = 502;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
       csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

assert(length(SpeedofAV)==678);

%% testing speed of function

% load inputs
csvFilename = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

maxVelocity = 50;
minVelocity = 10;
plot_color = 'winter';

% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
       csvFilename, base_station_coordinates, maxVelocity, ...
       minVelocity, plot_color, fig_num, fig_num);
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

SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
       csvFilename, base_station_coordinates, maxVelocity,...
       minVelocity, plot_color, fig_num, fig_num);
telapsed = toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotSpeedofAV without speed setting (slow) and with speed setting (fast):\n');
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
