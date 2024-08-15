%% script_test_fcn_plotRoad_plotTraces
% This is a script to exercise the function: fcn_plotRoad_plotTraces
% This function was written on 2023_03_25 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2023_03_25
% -- first write of the code
% 2024_08_14 - S Brennan
% -- changed the argument input to allow variable plot styles



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

%% Basic example 1 - input  ENU coordinates and plot a trace in only LLA (do not specify any figure number)

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 * [

-0.681049494040000  -1.444101004200000   0.225959982543000
-0.635840916402000  -1.480360972130000   0.225959615156000
-0.591458020164000  -1.513620272760000   0.225949259327000
-0.526826099435000  -1.557355626820000   0.226468769561000
-0.455230413850000  -1.601954836740000   0.226828212563000
-0.378844266810000  -1.644026018910000   0.227087638509000
-0.302039949257000  -1.680678797970000   0.227207090339000
-0.217481846757000  -1.715315663660000   0.227336509752000
-0.141767378277000  -1.742610853740000   0.227585981357000
-0.096035753167200  -1.756950994360000   0.227825672033000
];

input_coordinates_type = "ENU";
fcn_plotRoad_plotTraces(Trace_coordinates, input_coordinates_type);

%% Basic example 2 - input LLA coordinates and plot a trace in only LLA coordinates
% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 *[

0.408623854107731  -0.778367360663248   3.667869999985497
0.408623527614556  -0.778366824471459   3.667869999850096
0.408623228140075  -0.778366298073317   3.667860000095597
0.408622834336925  -0.778365531515185   3.668379999958485
0.408622432755178  -0.778364682365638   3.668739999760671
0.408622053936209  -0.778363776401051   3.669000000069386
0.408621723905615  -0.778362865478155   3.669120000111036
0.408621412026466  -0.778361862594228   3.669249999930642
0.408621166253217  -0.778360964599280   3.669500000276769
0.408621037130544  -0.778360422209667   3.669740000166511
];

input_coordinates_type = "LLA";
fcn_plotRoad_plotTraces(Trace_coordinates, input_coordinates_type);

%% Basic example 3 - input STH coordinates and plot a trace in only LLA coordinates
%
Trace_coordinates = 1.0e+02 * [
    -1.417887076590627  -0.734065638611450
    -1.403976165265653  -0.790324747332070
    -1.388899679423392  -0.843698168878688
    -1.364092650055747  -0.917689233677463
    -1.334276443299194  -0.996594401662616
    -1.299118841207131  -1.076398980722342
    -1.260339470150470  -1.152151801052434
    -1.214174858471968  -1.231009988940817
    -1.170580581946491  -1.298665344937900
    -1.142946654037681  -1.337823833081837
    ];
input_coordinates_type = "STH";
fcn_plotRoad_plotTraces(Trace_coordinates, input_coordinates_type);

%% Basic example 4 - input ENU coordinates and plot a trace in only ENU

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 * [

-0.681049494040000  -1.444101004200000   0.225959982543000
-0.635840916402000  -1.480360972130000   0.225959615156000
-0.591458020164000  -1.513620272760000   0.225949259327000
-0.526826099435000  -1.557355626820000   0.226468769561000
-0.455230413850000  -1.601954836740000   0.226828212563000
-0.378844266810000  -1.644026018910000   0.227087638509000
-0.302039949257000  -1.680678797970000   0.227207090339000
-0.217481846757000  -1.715315663660000   0.227336509752000
-0.141767378277000  -1.742610853740000   0.227585981357000
-0.096035753167200  -1.756950994360000   0.227825672033000
];

input_coordinates_type = "ENU";
LLA_fig_num =[];
ENU_fig_num = 145;
STH_fig_num = [];
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];

hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];

plotFormat = [];

fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

%% Basic example 5 - input ENU coordinates and plot a trace in only STH

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 * [

-0.681049494040000  -1.444101004200000   0.225959982543000
-0.635840916402000  -1.480360972130000   0.225959615156000
-0.591458020164000  -1.513620272760000   0.225949259327000
-0.526826099435000  -1.557355626820000   0.226468769561000
-0.455230413850000  -1.601954836740000   0.226828212563000
-0.378844266810000  -1.644026018910000   0.227087638509000
-0.302039949257000  -1.680678797970000   0.227207090339000
-0.217481846757000  -1.715315663660000   0.227336509752000
-0.141767378277000  -1.742610853740000   0.227585981357000
-0.096035753167200  -1.756950994360000   0.227825672033000
];


plotFormat = [];
input_coordinates_type = "ENU";
LLA_fig_num =[];
ENU_fig_num = [];
STH_fig_num = 678;
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];


fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

%% Basic example 6 - input STH coordinates and plot a trace in only STH

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 * [
    -1.417887076590627  -0.734065638611450
    -1.403976165265653  -0.790324747332070
    -1.388899679423392  -0.843698168878688
    -1.364092650055747  -0.917689233677463
    -1.334276443299194  -0.996594401662616
    -1.299118841207131  -1.076398980722342
    -1.260339470150470  -1.152151801052434
    -1.214174858471968  -1.231009988940817
    -1.170580581946491  -1.298665344937900
    -1.142946654037681  -1.337823833081837
    ];

plotFormat = [];

input_coordinates_type = "STH";
LLA_fig_num =[];
ENU_fig_num = [];
STH_fig_num = 678;
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];

fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

%% Basic example 7 - input STH coordinates and plot a trace in only LLA

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 * [
    -1.417887076590627  -0.734065638611450
    -1.403976165265653  -0.790324747332070
    -1.388899679423392  -0.843698168878688
    -1.364092650055747  -0.917689233677463
    -1.334276443299194  -0.996594401662616
    -1.299118841207131  -1.076398980722342
    -1.260339470150470  -1.152151801052434
    -1.214174858471968  -1.231009988940817
    -1.170580581946491  -1.298665344937900
    -1.142946654037681  -1.337823833081837
    ];


plotFormat = [];
input_coordinates_type = "STH";
LLA_fig_num =1232;
ENU_fig_num = [];
STH_fig_num = [];
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];

fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

%% Basic example 8 - input STH coordinates and plot a trace in only ENU

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
Trace_coordinates = 1.0e+02 * [
    -1.417887076590627  -0.734065638611450
    -1.403976165265653  -0.790324747332070
    -1.388899679423392  -0.843698168878688
    -1.364092650055747  -0.917689233677463
    -1.334276443299194  -0.996594401662616
    -1.299118841207131  -1.076398980722342
    -1.260339470150470  -1.152151801052434
    -1.214174858471968  -1.231009988940817
    -1.170580581946491  -1.298665344937900
    -1.142946654037681  -1.337823833081837
    ];

plotFormat = [];
input_coordinates_type = "STH";
LLA_fig_num =[];
ENU_fig_num = 8989;
STH_fig_num = [];
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];

fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

%% Basic example 999 - input LLA coordinates and plot all traces
% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1

Trace_coordinates = 1.0e+02 *[

0.408623854107731  -0.778367360663248   3.667869999985497
0.408623527614556  -0.778366824471459   3.667869999850096
0.408623228140075  -0.778366298073317   3.667860000095597
0.408622834336925  -0.778365531515185   3.668379999958485
0.408622432755178  -0.778364682365638   3.668739999760671
0.408622053936209  -0.778363776401051   3.669000000069386
0.408621723905615  -0.778362865478155   3.669120000111036
0.408621412026466  -0.778361862594228   3.669249999930642
0.408621166253217  -0.778360964599280   3.669500000276769
0.408621037130544  -0.778360422209667   3.669740000166511
];

clear plotFormat
plotFormat.Color = [1 1 1];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;


input_coordinates_type = "LLA";
LLA_fig_num = 1111;
ENU_fig_num = 2222;
STH_fig_num = 3333;
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];

fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

%% Plot the electric poles on the test track


% Power Pole by the garage, Height ~ 8 meters
Trace_coordinates = [
    -41.54388324160499 -111.0086546354483 -12.592103434894112
    -41.569363315580546 -110.75959350573615 -12.613099216676304
    -41.34223821788768 -110.66675022734344 -12.70109625294922
    -41.162258919321594 -110.78811147949827 -12.855097101992692
    ];

input_coordinates_type = "ENU";
[LLA_trace, ENU_trace, STH_trace] = fcn_plotRoad_plotTraces(Trace_coordinates, input_coordinates_type);

%% testing speed of function
% NOTHING to test - plot requires fig_num input 
%
% % load inputs
% Trace_coordinates = [
%     -41.54388324160499 -111.0086546354483 -12.592103434894112
%     -41.569363315580546 -110.75959350573615 -12.613099216676304
%     -41.34223821788768 -110.66675022734344 -12.70109625294922
%     -41.162258919321594 -110.78811147949827 -12.855097101992692
%     ];
% 
% input_coordinates_type = "ENU";
% plot_color = [];
% line_width = [];
% reference_unit_tangent_vector =[];
% flag_plot_headers_and_tailers =[];
% flag_plot_points =[];
% % Speed Test Calculation
% fig_num=[];
% REPS=5; minTimeSlow=Inf;
% tic;
% %slow mode calculation - code copied from plotVehicleXYZ
% for i=1:REPS
%     tstart=tic;
%     fcn_plotRoad_plotTraces(Trace_coordinates, input_coordinates_type,...
%         plot_color,line_width,...
%         fig_num,fig_num,fig_num,reference_unit_tangent_vector,...
%         flag_plot_headers_and_tailers, flag_plot_points);
%     telapsed=toc(tstart);
%     minTimeSlow=min(telapsed,minTimeSlow);
% end
% averageTimeSlow=toc/REPS;
% %slow mode END
% %Fast Mode Calculation
% fig_num = -1;
% minTimeFast = Inf;
% tic;
% for i=1:REPS
%     tstart = tic;
%     fcn_plotRoad_plotTraces(Trace_coordinates, input_coordinates_type,...
%         plot_color,line_width,...
%         fig_num,fig_num,fig_num,reference_unit_tangent_vector,...
%         flag_plot_headers_and_tailers, flag_plot_points);
%     telapsed = toc(tstart);
%     minTimeFast = min(telapsed,minTimeFast);
% end
% averageTimeFast = toc/REPS;
% %Display Console Comparison
% if 1==1
%     fprintf(1,'\n\nComparison of fcn_plotRoad_plotTraces without speed setting (slow) and with speed setting (fast):\n');
%     fprintf(1,'N repetitions: %.0d\n',REPS);
%     fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
%     fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
%     fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
%     fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
%     fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
%     fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
% end
% %Assertion on averageTime NOTE: Due to the variance, there is a chance that
% %the assertion will fail.
% assert(averageTimeFast<averageTimeSlow);

%%
% % Power pole by the gas tank, Height ~ 10 meters
% Trace_coordinates = [
%     -21.40996058267557 -155.877934772639 -12.619945213934377
%     -21.696278918166733 -155.5923098173332 -12.799939125302663
%     -21.49622204557925 -155.39168323388697 -13.076933568764803
%     -21.303510770519477 -155.80328193434454 -12.990942944232422
%     ];
% 
% 
% % Power pole by the detour, Height ~ 9 meters
% Trace_coordinates = [
%     78.71383357714284 -60.13763178116716 -10.848769161102917
%     79.03023381125868 -60.32544193559029 -10.837774873095212
%     79.10750861899513 -59.97611791541015 -10.928772508608263
%     ];
% 
% % Pole by the power box
% Trace_coordinates = [
%     177.25079175008634 -65.87782891848394 -10.944800271314927
%     177.15685372419267 -65.77935090065267 -10.904796673066361
%     177.31311993605033 -65.64101993680194 -10.965799568491546
%     177.14152953801488 -65.55493136920194 -10.938793925945527
%     ];
% 
% % Pole by the lane test area,Height ~ 10.5 meters
% Trace_coordinates = [
%     261.5226068612395 0.9362222334994122 -10.041353704834773
%     ];
% 
% % Pole at the crash test area - East, Height ~ 13 meters
% Trace_coordinates = [
%     236.28759539790076 183.8291816550618 -7.3790257131302175
%     236.05407107157055 183.5837907686659 -7.360009986409101
%     236.3207845599469 183.41359282485251 -7.457014939358887
%     236.5685821050103 183.69361452995355 -7.392032167109995
%     ];
% 
% % Pole at the crash test area - Middle, Height ~ 13 meters
% Trace_coordinates = [
%     128.68142817896114 169.2357589741786 -8.40854669915419
%     128.62742879585699 169.6217723298374 -8.4625559274015
%     128.25611223548336 169.41805880145833 -8.259542975238142
%     ];
% 
% 
% % Pole with the time led, Height ~ 13 meters
% Trace_coordinates = [
%     29.746349250935626 124.74785860585521 -9.039292080071405
%     29.447189318890306 124.39763191177158 -8.900283825174755
%     30.176223319201664 124.77931428005161 -9.054294749489568
%     28.094379928955114 124.17387655376811 -15.252273398621956
%     ];
% 
% 
% Pole - white pipe
% 241.20944407887026 -72.95601156337904 -9.364972520487274
% 
% Pole - opposite box
% 200.0578802380644 -46.661535005989734 -9.5033039405793
% 
% Pole on the grass by the storage bin
% 382.36760523575947 109.15657120766576 -8.940380675262062
% 
% Power box by the road
% 393.94356305208527 95.94396223194781 -10.592871155655226
% 
% Power box no lid
% 382.1248461037517 90.26906282091701 -10.351070077201964
% 
% Light Pole east corner
% 468.7771748930397 128.66683330454703 -8.282502229370525
% Height 22 meters
% 
% Light Pole North Corner
% 419.5481152890079 210.2952422867348 -9.173253201708432
% Height 12 meters
% 
% Light pole by the bridge
% -111.36353729525754 21.531683473911414 -10.675007158762758
% Height 12 meters
% 
% 
% Light pole by the road
% -54.9088363936229 -218.70867368807137 -14.809994690085148
% Height 8 meters
% 
% 
