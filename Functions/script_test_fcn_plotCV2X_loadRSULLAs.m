%% script_test_fcn_plotCV2X_loadRSULLAs
% This is a script to exercise the function: fcn_plotCV2X_loadRSULLAs
% This function was written on 2024_08_21 by S. Brennan, sbrennan@psu.edu

% Revision history:
% 2024_08_25 - S. Brennan
% -- first write of the code



%% PSU Test Track Coordinates
fig_num = 1;
figure(fig_num);
clf;

% Test the function
RSUid = 1;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
title(sprintf('Example %.0d: fcn_plotCV2X_loadRSULLAs',fig_num), 'Interpreter','none');
subtitle('Basic example');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of LLAsOfRSUs correct?
N_RSUs = 1;
assert(N_RSUs==length(LLAsOfRSUs(:,1)));
assert(3==length(LLAsOfRSUs(1,:)));

% Are the dimensions of numericRSUids correct?
assert(N_RSUs==length(numericRSUids(:,1)));
assert(1==length(numericRSUids(1,:)));

% Are the dimensions of numericRSUids correct?
assert(1==numericRSUids);



%% PSU Test Track Coordinates - NO PLOTTING
fig_num = 2;
figure(fig_num);
close(fig_num);

% Test the function
RSUid = 1;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), ([]));
title(sprintf('Example %.0d: fcn_plotCV2X_loadRSULLAs',fig_num), 'Interpreter','none');
subtitle('Basic example');

% Check results
% Was a figure created?
assert(all(~ishandle(fig_num)));

% Are the dimensions of LLAsOfRSUs correct?
N_RSUs = 1;
assert(N_RSUs==length(LLAsOfRSUs(:,1)));
assert(3==length(LLAsOfRSUs(1,:)));

% Are the dimensions of numericRSUids correct?
assert(N_RSUs==length(numericRSUids(:,1)));
assert(1==length(numericRSUids(1,:)));

% Are the dimensions of numericRSUids correct?
assert(1==numericRSUids);


%% PSU Test Track Coordinates - by string
fig_num = 3;
figure(fig_num);
clf;

% Test the function
RSUid = 'TestTrack';

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
title(sprintf('Example %.0d: fcn_plotCV2X_loadRSULLAs',fig_num), 'Interpreter','none');
subtitle('Using string call');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of LLAsOfRSUs correct?
N_RSUs = 3;
assert(N_RSUs==length(LLAsOfRSUs(:,1)));
assert(3==length(LLAsOfRSUs(1,:)));

% Are the dimensions of numericRSUids correct?
assert(N_RSUs==length(numericRSUids(:,1)));
assert(1==length(numericRSUids(1,:)));

% Are the dimensions of numericRSUids correct?
assert(isequal(numericRSUids,[1 2 3]'));


%% Site1 - by string
fig_num = 4;
figure(fig_num);
clf;

% Test the function
RSUid = 'Site1';

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 50;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
title(sprintf('Example %.0d: fcn_plotCV2X_loadRSULLAs',fig_num), 'Interpreter','none');
subtitle('Using string call');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of LLAsOfRSUs correct?
N_RSUs = 1;
assert(N_RSUs==length(LLAsOfRSUs(:,1)));
assert(3==length(LLAsOfRSUs(1,:)));

% Are the dimensions of numericRSUids correct?
assert(N_RSUs==length(numericRSUids(:,1)));
assert(1==length(numericRSUids(1,:)));

% Are the dimensions of numericRSUids correct?
assert(isequal(numericRSUids,(201)'));

%% Site2 - first RSU
fig_num = 5;
figure(fig_num);
clf;

% Test the function
RSUid = 301;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
title(sprintf('Example %.0d: fcn_plotCV2X_loadRSULLAs',fig_num), 'Interpreter','none');
subtitle('Basic example');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of LLAsOfRSUs correct?
N_RSUs = 1;
assert(N_RSUs==length(LLAsOfRSUs(:,1)));
assert(3==length(LLAsOfRSUs(1,:)));

% Are the dimensions of numericRSUids correct?
assert(N_RSUs==length(numericRSUids(:,1)));
assert(1==length(numericRSUids(1,:)));

% Are the dimensions of numericRSUids correct?
assert(301==numericRSUids);



%% Site2 - by string
fig_num = 6;
figure(fig_num);
clf;

% Test the function
RSUid = 'Site2';

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 50;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
title(sprintf('Example %.0d: fcn_plotCV2X_loadRSULLAs',fig_num), 'Interpreter','none');
subtitle('Using string call');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of LLAsOfRSUs correct?
N_RSUs = 4;
assert(N_RSUs==length(LLAsOfRSUs(:,1)));
assert(3==length(LLAsOfRSUs(1,:)));

% Are the dimensions of numericRSUids correct?
assert(N_RSUs==length(numericRSUids(:,1)));
assert(1==length(numericRSUids(1,:)));

% Are the dimensions of numericRSUids correct?
assert(isequal(numericRSUids,[301 302 303 304]'));




%% Speed test

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 50;
plotFormat.Color = [1 0 1];

fig_num=[];
REPS=5; 
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;

% Slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    [LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
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
    [LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotCV2X_loadRSULLAs without speed setting (slow) and with speed setting (fast):\n');
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
assert(averageTimeFast<averageTimeSlow);

