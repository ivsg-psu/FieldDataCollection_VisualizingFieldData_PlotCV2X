%% script_test_fcn_PlotTestTrack_plotBSMfromOBUtoRSU.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotBSMfromOBUtoRSU.m
% This function was written on 2024_06_02 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_06_02
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

%% Basic example 1 - RSU range test at the pendulum for 50ft

csv_filename = 'Pendulum50ft.csv';


[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = ...
    fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
    csv_filename);

assert(length(LLA_BSM_coordinates) == 2211)
assert(length(ENU_BSM_coordinates) == 2211)
assert(length(STH_BSM_coordinates) == 2211)
%%  Basic example 2 - RSU range test at the bridge tower for 30ft

csv_filename = 'Bridge20ft.csv';
fig_num = [];

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = ...
    fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
    csv_filename,fig_num);

assert(length(LLA_BSM_coordinates) == 1343)
assert(length(ENU_BSM_coordinates) == 1343)
assert(length(STH_BSM_coordinates) == 1343)

%%  Basic example 3 - RSU range test at the loading doack tower for 20ft, plot spokes and hubs

csv_filename = '20ft.csv';
flag_plot_spokes = 1;
flag_plot_hubs = 1;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [];
fig_num = 122;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 1591)
assert(length(ENU_BSM_coordinates) == 1591)
assert(length(STH_BSM_coordinates) == 1591)

%%  Basic example 4 - RSU range test at the loading doack tower for 20ft, do not plot spokes and hubs

csv_filename ='PittsburgTestMiddle.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [1 0 0];
fig_num = 123;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 1270)
assert(length(ENU_BSM_coordinates) == 1270)
assert(length(STH_BSM_coordinates) == 1270)

%% 5

csv_filename_one = 'PittsburgTestStartMiddlePart1.csv';
csv_filename_two = 'PittsburgTestStartMiddlePart2.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color_one = [1 0 0];
plot_color_two = [1 1 0];
fig_num = 124;
figure(fig_num);
[LLA_BSM_coordinates_one, ENU_BSM_coordinates_one, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
[LLA_BSM_coordinates_two, ENU_BSM_coordinates_two, STH_BSM_coordinates_two]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename_two, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color_two,fig_num);

assert(length(LLA_BSM_coordinates_one) == 1769)
assert(length(ENU_BSM_coordinates_one) == 1769)
assert(length(STH_BSM_coordinates_one) == 1769)

assert(length(LLA_BSM_coordinates_two) == 1270)
assert(length(ENU_BSM_coordinates_two) == 1270)
assert(length(STH_BSM_coordinates_two) == 1270)

%%  Basic example 6 - RSU range test at Pittsburg with time 10/07/2024

csv_filename ='Pittssburgh_Test_Run_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [1 1 0];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 1458)
assert(length(ENU_BSM_coordinates) == 1458)
assert(length(STH_BSM_coordinates) == 1458)

%%  Basic example 7 - RSU range test at Pittsburg with time 10/07/2024

csv_filename ='Pittsburgh_1_(Ended_Early)_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [0 1 1];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 932)
assert(length(ENU_BSM_coordinates) == 932)
assert(length(STH_BSM_coordinates) == 932)

%%  Basic example 8 - RSU range test at Pittsburg with time 10/07/2024

csv_filename ='Pittsburgh_1_11_07_2024_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [0 1 1];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 2281)
assert(length(ENU_BSM_coordinates) == 2281)
assert(length(STH_BSM_coordinates) == 2281)

%%  Basic example 9 - RSU range test at Pittsburg with time 10/07/2024

csv_filename ='Pittsburgh_2_11_07_2024_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 0 1];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 5989)
assert(length(ENU_BSM_coordinates) == 5989)
assert(length(STH_BSM_coordinates) == 5989)

reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.44203, -79.76149, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color = [0 1 1];
MarkerSize = 10;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

%%  Basic example 10 - Site 3 test 1

csv_filename ='PA_288_1_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 0 1];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 1440)
assert(length(ENU_BSM_coordinates) == 1440)
assert(length(STH_BSM_coordinates) == 1440)

reference_latitute = 40.8471670113384;
reference_longitude = -80.26182223666619;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.8471670113384 -80.26182223666619 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color = [0 1 1];
MarkerSize = 10;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

%%  Basic example 11 - Site 3 test 2

csv_filename ='PA_288_2_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 0 1];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 640)
assert(length(ENU_BSM_coordinates) == 640)
assert(length(STH_BSM_coordinates) == 640)

reference_latitute = 40.846818264181195;
reference_longitude = -80.2619054293138;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.846818264181195 -80.2619054293138 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color = [0 1 1];
MarkerSize = 10;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

%%  Basic example 11 - Site 3 test 2

csv_filename ='PA_288_3_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 0 1];
fig_num = 245;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 1742)
assert(length(ENU_BSM_coordinates) == 1742)
assert(length(STH_BSM_coordinates) == 1742)

reference_latitute = 40.84673063449941;
reference_longitude = -80.25869681168975;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.84673063449941 -80.25869681168975 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color = [0 1 1];
MarkerSize = 10;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

%%  Basic example 11 - Site 3 test 2

csv_filename ='PA_288_4_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 0 1];
fig_num = 446;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 1605)
assert(length(ENU_BSM_coordinates) == 1605)
assert(length(STH_BSM_coordinates) == 1605)

reference_latitute = 40.84673063449941;
reference_longitude = -80.25869681168975;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.84673063449941 -80.25869681168975 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color = [0 1 1];
MarkerSize = 10;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

%%  Site 2 test 2

csv_filename ='site2_2_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 0 1];
fig_num = 666;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

assert(length(LLA_BSM_coordinates) == 688)
assert(length(ENU_BSM_coordinates) == 688)
assert(length(STH_BSM_coordinates) == 688)


reference_latitute = 40.84673063449941;
reference_longitude = -80.25869681168975;
reference_altitude = 327.428;

rsu_coordinates_lla = [39.9952318, -79.4455219, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color = [1 0 1];
MarkerSize = 10;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

csv_filename ='site2_2_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [1 0 1];
fig_num = 666;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);


assert(length(LLA_BSM_coordinates) == 688)
assert(length(ENU_BSM_coordinates) == 688)
assert(length(STH_BSM_coordinates) == 688)

%%  Site 2 test 3


reference_latitute = 40.84673063449941;
reference_longitude = -80.25869681168975;
reference_altitude = 327.428;

rsu_coordinates_lla = [39.9882008, -79.4210206, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
plot_color =[0 1 1];
MarkerSize = 10;
fig_num = 666;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);

csv_filename ='site2_3_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 1 1];


[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);

legend('Falling Water Site 1 RSU location', 'Falling Water Site 1 RSU Range','Falling water Site 1 BSM locations', 'Falling Water Site 2 RSU location', 'Falling Water Site 2 RSU Range','Falling water Site 2 BSM locations');

assert(length(LLA_BSM_coordinates) == 752)
assert(length(ENU_BSM_coordinates) == 752)
assert(length(STH_BSM_coordinates) == 752)

%% testing speed of function

% load inputs
csv_filename ='site2_3_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
Plot_color = [0 1 1];

% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;
[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);telapsed=toc(tstart);
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
[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);telapsed = toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotBSMfromOBUtoRSU without speed setting (slow) and with speed setting (fast):\n');
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

%% to be moved to another repo in its own script
% %% PPT figure Pittsburg
% 
% % Pittsburg Stattion Coordinates
% reference_latitute = 40.44181017;
% reference_longitude = -79.76090840;
% reference_altitude = 327.428;
% 
% rsu_coordinates_lla = [40.43073, -79.87261, 0];
% 
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% 
% radius = 1000;
% 
% plot_color = [1 1 0];
% MarkerSize = [];
% fig_num = 124;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename_one = 'PittsburgTestStartMiddlePart1.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% plot_color_one = [1 0 1];
% fig_num = 124;
% [LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
% legend('RSU Location', 'Expected Range of RSU','OBU Location when BSM was sent', 'Start of test location','End of test location');
% 
% %% PPT figure PA-288
% 
% 
% % Pittsburg Stattion Coordinates
% reference_latitute = 40.44181017;
% reference_longitude = -79.76090840;
% reference_altitude = 327.428;
% 
% rsu_coordinates_lla = [40.84673063449941, -80.25869681168975, 0];
% 
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% 
% radius = 1000;
% 
% plot_color = [1 1 0];
% MarkerSize = [];
% fig_num = 225;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename_one = 'PA_288_4_noTime.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% plot_color_one = [1 0 1];
% [LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
% legend('RSU Location', 'Expected Range of RSU','OBU Location when BSM was sent', 'Start of test location','End of test location');
% 
% %% PPT figure Falling Waters
% 
% % Pittsburg Stattion Coordinates
% reference_latitute = 40.44181017;
% reference_longitude = -79.76090840;
% reference_altitude = 327.428;
% 
% rsu_coordinates_lla = [39.9882008, -79.4210206, 0];
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% 
% radius = 1000;
% 
% plot_color = [1 1 0];
% MarkerSize = [];
% fig_num = 325;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename_one = 'site2_3_noTime.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% plot_color_one = [1 0 1];
% [LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
% %legend('RSU Location', 'Expected Range of RSU','OBU Location when BSM was sent', 'Start of test location','End of test location');
% 
% %% PPT Test Track 3 locations
% 
% % The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
% reference_latitude = 40.86368573;
% reference_longitude = -77.83592832;
% reference_altitude = 344.189;
% 
% % RSU at Pendulum test
% 
% rsu_coordinates_lla = [40.864860, -77.830381, 0];
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% radius = 1000;
% 
% plot_color = [1 1 0];
% MarkerSize = [];
% fig_num = 325;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename_one = 'Pendulum50ft.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% plot_color_one ='y';
% [LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
% 
% % The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
% reference_latitude = 40.86368573;
% reference_longitude = -77.83592832;
% reference_altitude = 344.189;
% 
% % RSU at End Bridge
% 
% rsu_coordinates_lla = [40.864134, -77.837205, 0];
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% radius = 1000;
% 
% plot_color = [0 1 1];
% MarkerSize = [];
% fig_num = 325;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename_one = 'end bridge.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% plot_color_one ='c';
% [LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
% 
% % RSU at Loading Dock
% 
% rsu_coordinates_lla = [40.863140, -77.834939, 0];
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% radius = 1000;
% 
% plot_color = [1 0 1];
% MarkerSize = [];
% fig_num = 325;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename_one = '50ft.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% plot_color_one ='m';
% [LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
% legend('RSU at Pendulum 50ft', 'RSU Range at Pendulum','Plot of BSMs for Pendulum RSU',...
%     'RSU at End Bridge 20ft', 'RSU Range at End Bridge','Plot of BSMs for End Bridge RSU',...
%     'RSU at Loading Dock 50ft', 'RSU Range at Loading Dock','Plot of BSMs for Loading Dock RSU');
% 
% %% PPT Fallwing Waters both sites
% 
% % site 2 test 2
% reference_latitute = 40.84673063449941;
% reference_longitude = -80.25869681168975;
% reference_altitude = 327.428;
% 
% rsu_coordinates_lla = [39.9952318, -79.4455219, 0];
% 
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% 
% radius = 1000;
% plot_color = [1 0 1];
% MarkerSize = 10;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename ='site2_2_noTime.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% Plot_color = [1 0 1];
% fig_num = 666;
% 
% [LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);
% 
% %  Site 2 test 3
% 
% reference_latitute = 40.84673063449941;
% reference_longitude = -80.25869681168975;
% reference_altitude = 327.428;
% 
% rsu_coordinates_lla = [39.9882008, -79.4210206, 0];
% 
% gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));
% 
% radius = 1000;
% plot_color =[0 1 1];
% MarkerSize = 10;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize, fig_num);
% 
% csv_filename ='site2_3_noTime.csv';
% flag_plot_spokes = 0;
% flag_plot_hubs = 0;
% flag_plot_LLA = 1;
% flag_plot_ENU = 0;
% flag_plot_STH = 0;
% Plot_color = [0 1 1];
% fig_num = 666;
% 
% [LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%        csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,Plot_color,fig_num);
% 
% 
% 
% legend( 'Falling Water Site 1 RSU location', 'Falling Water Site 1 RSU Range','Falling water Site 1 BSM locations', 'Falling Water Site 2 RSU location', 'Falling Water Site 2 RSU Range','Falling water Site 2 BSM locations');
