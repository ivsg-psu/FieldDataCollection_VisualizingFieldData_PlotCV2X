%% script_test_fcn_plotRoad_plotXYI
% This is a script to exercise the function: fcn_plotRoad_plotXYI
% This function was written on 2023_08_12 by S. Brennan, sbrennan@psu.edu


% Revision history:
% 2023_08_12
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
% function only plots, has no outputs

%% BASIC example 1 - all defaults
fig_num = 1;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];

% Test the function
plotFormat = [];
colorMap = [];
h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing basic plotting',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(h_plot(:))));


%% BASIC example 2 - specifying the color
fig_num = 2;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];

% Test the function
plotFormat = 'r';
colorMap = [];
h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing user-defined color to produce colormap',fig_num), 'Interpreter','none');

% Check results
assert(all(ishandle(h_plot(:))));


%% BASIC example 3 - specifying the colorMap
fig_num = 3;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];

% Test the function
plotFormat = [];
colorMap = 'hot';
h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing user-defined color map',fig_num), 'Interpreter','none');

% Check results
good_indicies = find(~isnan(h_plot));
assert(all(ishandle(h_plot(good_indicies,1))));



%% BASIC example 4 - specifying the linestyle
fig_num = 4;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];

% Test the function
plotFormat = '-';
colorMap = 'hot';
h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing use of a linestyle',fig_num), 'Interpreter','none');

% Check results
good_indicies = find(~isnan(h_plot));
assert(all(ishandle(h_plot(good_indicies,1))));

%% BASIC example 5 - specifying the full plotFormat
fig_num = 5;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];

% Test the function
clear plotFormat
plotFormat.LineStyle = ':';
plotFormat.LineWidth = 5;
plotFormat.Marker = '+';
plotFormat.MarkerSize = 10;
colorMap = 'hot';
h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing use of a complex plotFormat',fig_num), 'Interpreter','none');

% Check results
good_indicies = find(~isnan(h_plot));
assert(all(ishandle(h_plot(good_indicies,1))));


%% testing speed of function



time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];


% Test the function
clear plotFormat
plotFormat.LineStyle = ':';
plotFormat.LineWidth = 5;
plotFormat.Marker = '+';
plotFormat.MarkerSize = 10;
colorMap = 'hot';

% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;

% Slow mode calculation
for i=1:REPS
    tstart=tic;
    h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
%slow mode END

% Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
    tstart = tic;
    h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotTraceENU without speed setting (slow) and with speed setting (fast):\n');
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