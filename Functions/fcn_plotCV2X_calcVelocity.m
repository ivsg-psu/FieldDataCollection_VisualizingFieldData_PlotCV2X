function velocity = fcn_plotCV2X_calcVelocity(tLLA, tENU, modeIndex, offsetCentisecondsToMode, varargin)
%fcn_plotCV2X_calcVelocity  calculates velocity given tENU coordinates
%
% this function calculates the apparent velocity of the data given tENU
% coordinate inputs. 
%
% FORMAT:
%
%       velocity = fcn_plotCV2X_calcVelocity(tENU, (fig_num))
%
% INPUTS:
%
%      tLLA: the [time Latitude Longitude Altitude] data as an [Nx4] vector
%
%      tENU: the [time East North Up] data as an [Nx4] vector, using the
%      origin as set in the main demo script
%
%      modeIndex: the integer denoting which intercept is being shared with
%      neighbors. This is found by examining the centiSecond delay in each
%      data, and then finding common modes with a 1-second window.
%
%      offsetCentisecondsToMode: an integer count of the hundreths of
%      seconds that the current sample is off from the current linear time
%      increase, based on the current mode.
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      velocity: the velocity in m/s as a [Nx1] vector. The last velocity
%      is repeated so that velocity is the same length vector as tENU
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotCV2X_calcVelocity
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
if (nargin==5 && isequal(varargin{end},-1))
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
        narginchk(4,5);

    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
fig_num = []; % Initialize the figure number to be empty
if (0==flag_max_speed) && (2 <= nargin)
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

% Calculate ENU distances
XYdistances = real(sum(diff(tENU(:,2:3)).^2,2).^0.5);
XYdistances = [XYdistances(1); XYdistances];

% Check inputs (debugging)
if 1==flag_do_debug
    disp([tENU XYdistances offsetCentisecondsToMode modeIndex])
end

% Initialize output vector
velocity = nan(Ndata,1);

% Time deltas are not valid across mode changes, so we loop through modes
% and calculate time/distance for each. As well, keep track of the
% variances and counts of each domain
Nmodes = modeIndex(end);
timeVariances = nan(Nmodes,1);
countModes    = nan(Nmodes,1);
for ith_mode = 1:Nmodes
    flags_thisMode = modeIndex==ith_mode;
    indicies_thisMode = find(flags_thisMode);

    % Is this a good mode? Do we have 1 second of data in this mode?
    if length(indicies_thisMode)>=10
        countModes(ith_mode,1) = sum(flags_thisMode);        

        % Clean up distances - looking for outliers
        thisModeDistances = XYdistances(indicies_thisMode,1);
        goodIndiciesDistances = fcn_INTERNAL_removeDistanceOutliers(thisModeDistances);

        % Clean up times - looking for outliers
        thisModeDeltaTimes = diff(tENU(indicies_thisMode,1));
        thisModeDeltatimes = [thisModeDeltaTimes(1); thisModeDeltaTimes];
        goodIndiciesTimes = fcn_INTERNAL_removeTimeOutliers(thisModeDeltatimes);
        meanDeltaT = mean(thisModeDeltatimes(goodIndiciesTimes));
        timeVariances(ith_mode,1) = std(thisModeDeltatimes(goodIndiciesTimes));
        
        if any(thisModeDeltatimes(goodIndiciesTimes)<0.01)
            warning('on','backtrace');
            warning('A poorly defined time interval was encountered. - throwing an error.')
            error('Small or negative time differences encountered. Cannot calculate velocity.');
        end

        thisModeVelocities = thisModeDistances./thisModeDeltatimes;

        % Check results
        if 1==flag_do_debug
            disp([thisModeDistances thisModeDeltatimes goodIndiciesDistances goodIndiciesTimes])
        end

        goodIndicies = goodIndiciesTimes.*goodIndiciesDistances;
        goodIndicies_thisMode = indicies_thisMode(find(goodIndicies)); %#ok<FNDSB>

        % Calculate velocities
        velocity(goodIndicies_thisMode) = thisModeVelocities(find(goodIndicies)); %#ok<FNDSB>
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

% before opeaning up a figure, lets start to capture the frames for an
% animation if the user has entered a name for the mov file
if flag_do_plots == 1


    % Prep the data
    goodPlottingIndicies = ~isnan(velocity);
    rawXYData = [tENU(:,2:3) velocity];
    plotXYData = rawXYData(goodPlottingIndicies,:);
    rawLLData = [tLLA(:,2:3) velocity];
    plotLLData = rawLLData(goodPlottingIndicies,:);


    figure(fig_num);


    clear plotFormat
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 5;
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 10;
    colorMapMatrixOrString = colormap('turbo');
    Ncolors = 16;
    reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrixOrString, Ncolors, -1);


    subplot(1,2,1);
    fcn_plotRoad_plotXYI(plotXYData, (plotFormat), (reducedColorMap), (fig_num));    


    subplot(1,2,2);
    fcn_plotRoad_plotLLI(plotLLData, (plotFormat), (reducedColorMap), (fig_num));    

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

function goodIndicies = fcn_INTERNAL_removeDistanceOutliers(badData)
% How many points should be used for the median filter? Use at least 7 if
% we can, but use the data length if we cannot
Nmedian = min(7,length(badData(:,1)));

% Do median filtering to find outliers
medianData = medfilt1(badData,Nmedian,'omitnan','truncate'); % Do median filter to remove outliers
stdMedianData = std(medianData,'omitmissing'); % Find standard deviaiont
stdMedianData = max(stdMedianData,0.02);  % Make sure standard deviation is not zero
stdMedianData = min(stdMedianData,0.2);  % Make sure standard deviation does not over-inflate due to bad data
errorsRelativeToMedian = medianData - badData; % Find differences between data and median filtered values
goodIndicies = abs(errorsRelativeToMedian)<2*stdMedianData; % Keep only the good data

% Check results
if 1==0
    disp([goodIndicies badData errorsRelativeToMedian])
    disp(min(badData(goodIndicies)));
    disp(max(badData(goodIndicies)));
    disp(stdMedianData)
end

% Call the function again to be sure results do not change after outliers
% removed. Sometimes the outliers distort the results enough that it causes
% other outliers to be missed.
if sum(goodIndicies) ~=length(badData)
    indicies_to_check = find(goodIndicies);
    betterIndicies = fcn_INTERNAL_removeDistanceOutliers(badData(indicies_to_check));
    goodIndicies = indicies_to_check(find(betterIndicies)); %#ok<FNDSB>
end

% Save results back into "flag" format (1's and 0's)
tempOutput = zeros(length(badData(:,1)),1);
tempOutput(goodIndicies,1) = 1;
goodIndicies = tempOutput;
end

function goodIndicies = fcn_INTERNAL_removeTimeOutliers(badData)
% medianData = medfilt1(badData,5,'omitnan','truncate'); % Do median filter to remove outliers
% stdTimeData = std(medianData,'omitmissing'); % Find standard deviaiont
% stdTimeData = max(stdTimeData,0.01);  % Make sure standard deviation is not zero

% Hard code allowable variance - time delta should never change
stdTimeData = 0.01;
errorsRelativeToMean = 0.1 - badData; % Find differences between expected time sample and actual time sample
goodIndicies = abs(errorsRelativeToMean)<2*stdTimeData; % Keep only the good data

if 1==0
    disp([goodIndicies badData])
end
end