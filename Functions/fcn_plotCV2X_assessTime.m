function [modeIndex, modeJumps, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tLLA, tENU, varargin)
%fcn_plotCV2X_assessTime  classifies the time vector of the data for errors
%
% given the tENU data from a CV2X radio, this function assesses whether the
% data contain common errors. The time differences between sequential data
% are analyzed. 
% 
% Common errors include the following:
%
%       * modeJumps - the time suddenly has a different zero intercept
%       * offsets - at each individual time sample, for a given intercept,
%       the data comes in early, on time, or late. This difference creates
%       an offset.
%
% FORMAT:
%
%       [modeIndex, modeJumps, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tENU, (fig_num))
%
% INPUTS:
%
%      tLLA: the [time Latitude Longitude Altitude] data as an [Nx4]
%      vector. Note: this is only used for plotting. Set as an empty vector
%      if this is not available, and the plot will not be created but the
%      function will still operate. 
%
%      tENU: the [time East North Up] data as an [Nx4] vector, using the
%      origin as set in the main demo script
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      modeIndex: the integer denoting which intercept is being shared with
%      neighbors. This is found by examining the centiSecond delay in each
%      data, and then finding common modes with a 1-second window.
%
%      modeJumps: locations where the apparent time intercept suddendly changes
% 
%      offsetCentisecondsToMode: an integer count of the hundreths of
%      seconds that the current sample is off from the current linear time
%      increase, based on the current mode.
%
% DEPENDENCIES:
%
%      fcn_geometry_fillColorFromNumberOrName
%      fcn_DebugTools_debugPrintTableToNCharacters
%      fcn_plotRoad_plotTraceXY
%      fcn_plotRoad_plotTraceLL
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotCV2X_assessTime
%
% This function was written on 2024_08_21 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision History
% 2024_08_21 S. Brennan
% -- started writing function

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 999978;
else
    debug_fig_num = [];
end

%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(2,3);

    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
fig_num = []; % Initialize the figure number to be empty
if (0==flag_max_speed) && (3 <= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end


%% Write main code for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ndata = length(tENU(:,1));

% Check the slippage in time, namely - how far off the reported time is
% from the actual time
expected_deltaT = 0.1; % Units are seconds
expectedCentiSeconds = (0:Ndata-1)'*10;

time = tENU(:,1);
rezeroTimeCentiSeconds = (time - time(1,1))*100;
offsetTimeCentiSeconds = rezeroTimeCentiSeconds - expectedCentiSeconds;

% Mode filter the data - this finds all the data that have the same offsets
modeData = fcn_INTERNAL_modeFilter(round(offsetTimeCentiSeconds),11);
offsetCentisecondsToMode = offsetTimeCentiSeconds - modeData;
offsetCentisecondsToMode(abs(offsetCentisecondsToMode)<0.001) = 0;
modeData(abs(modeData)<0.001) = 0;

% Look for modes that jump more than 1 value, these are truly new modes
modeJumps = [0; abs(diff(modeData))>1];
modeIndex = cumsum(modeJumps)+1;
Nmodes = modeIndex(end);

% Show raw data?
if flag_do_debug
    dataToPrint = [expectedCentiSeconds rezeroTimeCentiSeconds modeData offsetCentisecondsToMode modeJumps modeIndex];
    header_strings = [{'Expected'}, {'Actual'}, {'SoftMode'}, {'OffsetToMode'}, {'ModeJump'},  {'modeIndex'}]; % Headers for each column
    formatter_strings = [{'%.0f'},{'%.0f'},{'%.0f'},{'%.0f'}, {'%.0f'}, {'%.0f'}]; % How should each column be printed?
    N_chars = [15, 15, 15, 15, 15, 15]; % Specify spaces for each column
    fcn_DebugTools_debugPrintTableToNCharacters(dataToPrint, header_strings, formatter_strings, N_chars);

    figure(debug_fig_num);
    clf;

    subplot(2,2,1);
    title('Expected versus recorded time');
    plot(expectedCentiSeconds,rezeroTimeCentiSeconds,'-');
    
    subplot(2,2,2);
    hold on;
    title('offsetTimeCentiSeconds');
    badIndicies = abs(offsetCentisecondsToMode)>10;
    plot(expectedCentiSeconds(badIndicies,:), offsetTimeCentiSeconds(badIndicies,:),'r.','Markersize',20);

    for ith_mode = 1:Nmodes
        currentIndicies = find(modeIndex==ith_mode);
        plot(expectedCentiSeconds(currentIndicies,:), offsetTimeCentiSeconds(currentIndicies,:),'-');
    end

end


%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_do_plots == 1

    figure(fig_num);
    clf;



    for ith_mode = 1:Nmodes
        color_vector = fcn_geometry_fillColorFromNumberOrName(ith_mode);

        clear plotFormat
        plotFormat.Color = color_vector;
        plotFormat.Marker = '.';
        plotFormat.MarkerSize = 10;
        plotFormat.LineStyle = '-';
        plotFormat.LineWidth = 5;

        flag_plot_headers_and_tailers = 0;

        currentIndicies = modeIndex==ith_mode;

        subplot(1,2,1);
        fcn_plotRoad_plotTraceXY(tENU(currentIndicies,2:3), (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

        if ~isempty(tLLA)
            subplot(1,2,2);
            fcn_plotRoad_plotTraceLL(tLLA(currentIndicies,2:3), (plotFormat), (flag_plot_headers_and_tailers), (fig_num));
        end
    end

    % Plot the bad indicies in grey
    clear plotFormat
    plotFormat.Color = 0.5*[1 1 1];
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 30;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 5;

    flag_plot_headers_and_tailers = 0;

    badIndicies = abs(offsetCentisecondsToMode)>10;

    subplot(1,2,1);
    fcn_plotRoad_plotTraceXY(tENU(badIndicies,2:3), (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

    subplot(1,2,2);
    fcn_plotRoad_plotTraceLL(tLLA(badIndicies,2:3), (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end
%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

function modeData = fcn_INTERNAL_modeFilter(inputData,modeWindow)
% Perform mode filtering on the data of window N
% This is done by arranging the indicies into M columns, where M is the
% modeWindow. These columns represent the offsets from the current index,
% for example [-2 -1 0 1 2]. The overall indicies are obtained by adding
% these offsets to the true indicies, and constraining them to be between 1
% to N for the data. Then the "mode" function is used along columns.

Ndata = length(inputData(:,1));
indexRange = round((modeWindow-1)/2);
indexOffsets = (-indexRange:indexRange);
Moffsets = length(indexOffsets);

originalIndicies = (1:Ndata)'*ones(1,Moffsets);

shiftedIndicies = originalIndicies + ones(Ndata,1)*indexOffsets;

% Fix by repeating 1st value
if 1==0
    shiftedIndiciesValid = max(min(shiftedIndicies,Ndata),1);
else
    shiftedIndiciesValid = shiftedIndicies;
    shiftedIndiciesValid(1:indexRange,:) = ones(indexRange,1)*shiftedIndiciesValid(indexRange+1,:);
    shiftedIndiciesValid((end-indexRange+1):end,:) = ones(indexRange,1)*shiftedIndiciesValid(end-indexRange,:);   
end
dataToFilter = round(inputData(shiftedIndiciesValid));
modeData = mode(dataToFilter,2);

differences = round(inputData) - modeData;

% For debugging
if 1 == 0
    clc;
    disp([inputData modeData differences])
end

% Fix the data and try again?
temp = abs(differences);
temp2 = temp<2.5;
fixedInputData = inputData - temp2.*differences;

if ~isequal(fixedInputData,inputData)
    modeData = fcn_INTERNAL_modeFilter(fixedInputData,modeWindow);
end

end