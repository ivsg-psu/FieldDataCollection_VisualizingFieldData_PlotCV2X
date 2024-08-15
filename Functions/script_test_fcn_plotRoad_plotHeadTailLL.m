%% script_test_fcn_plotRoad_plotHeadTailLL
% This is a script to exercise the function: fcn_plotRoad_plotHeadTailLL
% This function was written on 2024_08_14 by S. Brennan, sbrennan@psu.edu

% Revision history:
% 2024_08_14
% -- first write of the code

close all;

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

%% BASIC example 2
% Plot data onto an empty figure. This will force the code to check to see
% if the figure has data inside it, and if not, it will prepare the figure
% the same way as a new figure.

fig_num = 2;
figure(fig_num);
clf;

% Fill in some dummy data (East curve from scenario 1_1)

data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0
    -77.83060707999994,40.86467151800008,0
    -77.83057291199998,40.86473474700006,0
    -77.83054614799994,40.86479999100004,0
    -77.83052443199995,40.86486635700004,0
    -77.83051053899999,40.86493399600005,0
    -77.83050385699994,40.86500232600008,0
    -77.83050469499995,40.86507096000003,0
    -77.83051096999998,40.86513880700005,0
    -77.83051548199995,40.86516167900004,0
    -77.83052813799998,40.86520696400004,0
    -77.83055303799995,40.86527300500006,0
    -77.83058410099994,40.86533739600003,0
    -77.83062308399997,40.86539921800005,0
    -77.83066833899994,40.86545839100006,0
    -77.83071974699999,40.86551445800006,0
    -77.83077704999994,40.86556697700007,0
    -77.83084030799995,40.86561520700008,0
    -77.83090661499995,40.86566081200004,0
    -77.83097722599996,40.86570252900003,0
    -77.83105323399997,40.86573830000003,0
    -77.83113270799998,40.86576916300004,0
    -77.83121508099998,40.86579495800004,0
    -77.83129931099995,40.86581674200005,0
    -77.83138581099996,40.86583237300005,0
    -77.83147340899995,40.86584355000008,0
    -77.83156186599996,40.86584960200003,0
    -77.83165067999994,40.86585007100007,0
    -77.83173939599999,40.86584604200004,0
    -77.83182788999994,40.86583809200005,0
    -77.83191641299999,40.86582709200007,0
    -77.83198191299994,40.86581637600005,0
    -77.83211176999998,40.86579081600007,0
    ];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];

% Test the function
plotFormat = [];
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
fcn_plotRoad_plotHeadTailLL(LLdata, fig_num, plotFormat);

title(sprintf('Example %.0d: showing plotting of data',fig_num), 'Interpreter','none');

% Check results
assert(ishandle(h_geoplot));

%% Basic example 3 - plot data onto an existing figure
fig_num = 3;
figure(fig_num);
clf;

% call the function with empty inputs, but with a figure number,
% and it should create the plot with
% the focus on the test track, satellite view
LLdata = [];

% Test the function
plotFormat = [];
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));

% Check results
assert(ishandle(h_geoplot));


% Now call the function again to plot data into an existing figure to check
% that this works
data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];

% Test the function
plotFormat = [];
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
fcn_plotRoad_plotHeadTailLL(LLdata, fig_num, plotFormat);

title(sprintf('Example %.0d: showing plotting of data on existing figure',fig_num), 'Interpreter','none');

% Check results
assert(ishandle(h_geoplot));

%% Basic example 4 - plot data with simple formatting string
fig_num = 4;
figure(fig_num);
clf;

% Fill in data
data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];

% Test the function
plotFormat = 'y.-';
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
fcn_plotRoad_plotHeadTailLL(LLdata, fig_num, plotFormat);

title(sprintf('Example %.0d: showing use of simple formatting string',fig_num), 'Interpreter','none');

% Check results
assert(ishandle(h_geoplot));

%% Basic example 5 - Plot data with user-given color vector

fig_num = 5;
figure(fig_num);
clf;

% Fill in data
data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];

% Test the function
plotFormat = [0 1 0];
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
fcn_plotRoad_plotHeadTailLL(LLdata, fig_num, plotFormat);

title(sprintf('Example %.0d: showing use of color vector',fig_num), 'Interpreter','none');

% Check results
assert(ishandle(h_geoplot));

%% Basic example 6 - Plot data with format structure

fig_num = 6;
figure(fig_num);
clf;

% Fill in data
data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];

% Test the function
clear plotFormat
plotFormat.Color = [0 0.7 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
fcn_plotRoad_plotHeadTailLL(LLdata, fig_num, plotFormat);

title(sprintf('Example %.0d: showing use of format structure',fig_num), 'Interpreter','none');

% Check results
assert(ishandle(h_geoplot));


%% testing speed of function
% Speed testing is not possible as fig_num is a required input
 
% 
% % Now call the function again to plot data into an existing figure to check
% % that this works
% data3 = [
%     -77.83108116099999,40.86426763900005,0
%     -77.83098509099995,40.86432365200005,0
%     -77.83093857199998,40.86435301300003,0
%     -77.83087253399998,40.86439877000004,0
%     -77.83080882499996,40.86444684500003,0
%     -77.83075077399997,40.86449883100005,0
%     -77.83069596999997,40.86455288200005,0
%     -77.83064856399994,40.86461089600004,0];
% 
% % NOTE: above data is in BAD column order, so we
% % have to manually rearrange it.
% LLdata = [data3(:,2), data3(:,1), data3(:,3)];
% 
% % Test the function
% clear plotFormat
% plotFormat.Color = [0 1 1];
% plotFormat.Marker = '.';
% plotFormat.MarkerSize = 10;
% plotFormat.LineStyle = '-';
% plotFormat.LineWidth = 3;
% labelText = 'Test of text';
% 
% % Speed Test Calculation
% fig_num=[];
% REPS=5; minTimeSlow=Inf;
% tic;
% % Slow mode calculation - code copied from plotVehicleXYZ
% for i=1:REPS
%     tstart=tic;
%     h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
%     telapsed=toc(tstart);
%     minTimeSlow=min(telapsed,minTimeSlow);
% end
% averageTimeSlow=toc/REPS;
% % Slow mode END
% 
% close all;
% 
% % Fast Mode Calculation
% fig_num = -1;
% minTimeFast = Inf;
% tic;
% for i=1:REPS
%     tstart = tic;
%     h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));
%     telapsed = toc(tstart);
%     minTimeFast = min(telapsed,minTimeFast);
% end
% averageTimeFast = toc/REPS;
% 
% % Display Console Comparison
% if 1==1
%     fprintf(1,'\n\nComparison of fcn_plotRoad_plotLL without speed setting (slow) and with speed setting (fast):\n');
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
% assert(averageTimeFast<2*averageTimeSlow);