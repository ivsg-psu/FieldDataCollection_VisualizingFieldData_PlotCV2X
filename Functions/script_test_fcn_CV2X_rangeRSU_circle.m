%% script_test_fcn_PlotTestTrack_rangeRSU_circle.m
% This is a script to exercise the function: fcn_PlotTestTrack_rangeRSU_circle.m
% This function was written on 2024_07_10 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_07_10
% -- first write of the code



%% Pittsburg Stattion Coordinates
reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.43073, -79.87261, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius);

%% Pittsburg Stattion Coordinates
reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.43073, -79.87261, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;

plot_color = [1 1 0];
MarkerSize = 20;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize);

%% Reber Building Coordinates
reference_latitute = 40.79347940;
reference_longitude = -77.86444659;
reference_altitude = 357;

rsu_coordinates_lla = [40.79382193, -77.91282763, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 500;

plot_color = [0 1 0];
MarkerSize = 18;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize);

%% Penn State Harrisburg Olmsted Building
reference_latitute = 40.2055177;
reference_longitude = -76.742607439;
reference_altitude = 113;

rsu_coordinates_lla = [40.19937297, -76.601272728, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1500;

plot_color = [1 0 1];
MarkerSize = 25;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize);

%% CMU Hunt Library
reference_latitute = 40.44111100;
reference_longitude = -79.94373997;
reference_altitude = 296;

rsu_coordinates_lla = [40.43281728, -79.87362727, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 300;

plot_color = [0 0 1];
MarkerSize = 15;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize);