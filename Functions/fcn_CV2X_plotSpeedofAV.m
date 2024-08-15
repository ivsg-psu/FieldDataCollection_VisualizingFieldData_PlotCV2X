function AV_Speed_Final  = fcn_PlotTestTrack_plotSpeedofAV(...
    csvFilename, varargin)
%% fcn_PlotTestTrack_plotSpeedofAV
% Takes the input csv file, reads the LLA and time data from those files
% and calculates the speed of the Av at every point. Also plots the speed
% of the AV in different colours
%
% FORMAT:
%
%      SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
%       csvFilename, (base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num))
%
% INPUTS:
%
%      csv_filenames: The name of the .csv file that contains the latitude,
%                    longitude and optionally the altitude alsong with the
%                    time at the of the location at which the OBU sent out
%                    the BSM message to the RSU that was in range
%
%      (OPTIONAL INPUTS)
%
%       base_station_coordinates: the reference latitude, reference
%       longitude and reference altitude for the base station that we can
%       use to convert ENU2LLA and vice-versa
%
%       maxVelocity: maximum velocity allowed in mph
%
%       minVelocity: minimum velocity allowed in mph
%
%       plot_color: a colormap color string such as 'jet' or 'summer'
%
%       LLA_fig_num: a figure number for the LLA plot
%
%       ENU_fig_num: a figure number for the ENU plot
%
% OUTPUTS:
%
%       SpeedofAV: a 1XN matirx with the speed of the AV in mph that
%       correspondes to every LLA location of the AV from the BSMs sent by OBU
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotSpeedofAV.m for a full
%       test suite.
%
% This function was written on 2024_07_14 by V. Wagh
% Questions or comments? vbw5054@psu.edu

% Revision history:
% 2024_07_14 by V. Wagh
% -- start writing function from fcn_PlotTestTrack_plotPointsAnywhere

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==7 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS");
    MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG = getenv("MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS);
    end
end

flag_do_debug = 1;

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
        narginchk(1,7);
    end
end

% base station coordinates
% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude]; % Default
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        base_station_coordinates = temp;
        reference_latitude= base_station_coordinates(1);
        reference_longitude= base_station_coordinates(2);
        reference_altitude = base_station_coordinates(3);
    end
end

% maxVelocity
maxVelocity = 85; % Default is at 85mph with is the fastest highway speed assigned in the US
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp) % if temp is not empty
        maxVelocity = temp;
    end
end

% minVelocity
minVelocity = 15; % Default is at 15mph with is the slowest speed limit assigned in the US
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp) % if temp is not empty
        minVelocity = temp;
    end
end

% Does user want to specify plot_color?
plot_color = 'jet'; % Default
if 5 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        plot_color = temp;
    end
end

% Does user want to specify LLA_fig_num?
LLA_fig_num = 100; % Default
if 6 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        LLA_fig_num = temp;
    end
end

% Does user want to specify ENU_fig_num?
ENU_fig_num = 200; % Default is do not plot
if 7 <= nargin
    temp = varargin{6};
    if ~isempty(temp)
        ENU_fig_num = temp;
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (7<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
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

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°,
% -77.83592832°, 344.189 m] for the default
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

% read the csv file
% Read csv file containing LLA coordinates and time of the OBU when the BSM
% message was sent out to the RSU
LLAandTime = readmatrix(csvFilename); %#ok<*CSVRD>
time = readtable(csvFilename);
time = time.timediff;

LLAandTime(:,4) = arrayfun(@(a) fcn_INTERNAL_totalSeconds(a), time);
LLAandTime = sortrows(LLAandTime,4,"ascend");
% LLA is collected as an integer X 10^4, so convert back to standard
% decimal format for LLA
BSMs_LLA_corrected = [LLAandTime(:,1)/10000000 LLAandTime(:,2)/10000000 LLAandTime(:,3)];

% setting up for output of function
LLA_BSM_coordinates = BSMs_LLA_corrected;
ENU_BSM_coordinates =[];

% convert LLA to ENU
ENU_data_with_nan = [];
[ENU_positions_cell_array, ~] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,BSMs_LLA_corrected,base_station_coordinates);

ENU_BSM_coordinates = ENU_positions_cell_array{1};

% get the time from BSMs
Time_BSMs = LLAandTime(:,4);

% get speed
NumLength = length(ENU_BSM_coordinates)-1;
newPoints = zeros(1,3);
newTimes =  zeros(1,1);
map = zeros(1,1);
for ith_coordinate = 2:NumLength
    point1 = ENU_BSM_coordinates(ith_coordinate-1,1:2);
    point2 = ENU_BSM_coordinates(ith_coordinate,1:2);
    point3 = ENU_BSM_coordinates(ith_coordinate+1);
    if point1 == point2

        %point2 = (point1+point3)/2

        %ENU_BSM_coordinates(ith_coordinate+1,(1:2)) = point2(1:2)

    end
    if ~(point1 == point2)
        newPoints(size(newPoints,1)+1,:) = ENU_BSM_coordinates(ith_coordinate-1,:);
        newTimes(length(newTimes)+1,:) = Time_BSMs(ith_coordinate-1,:);
        map(length(map)+1,1) = ith_coordinate;
        if(size(newPoints,1) ~= size(newTimes,1))
            size(newPoints)
        end
    end
end

ENU_BSM_coordinates = newPoints;
Time_BSMs = newTimes;

NumLength = length(ENU_BSM_coordinates)-1;

enuDiff(2:length(diff(ENU_BSM_coordinates(:,1)))+1,1) = sqrt(sum(transpose(diff(ENU_BSM_coordinates(:,1:2)).^2)))';

%abc = enuDiff(2:length(diff(ENU_BSM_coordinates(:,1)))+1,1);
% def = sqrt(sum(transpose(diff(ENU_BSM_coordinates(:,1:2)).^2)))';
%
% if all(abc(:) == def(:))
%     same = 1;
% else
%     same = 0;
% end

enuDiff(1) = 0;
enuDiff(length(enuDiff)+1) = 0;
enuDiff2(2:length(diff(enuDiff))+1,1) = abs(diff(enuDiff));

timeDiff(2:length(diff(Time_BSMs))+1,1) = diff(Time_BSMs);
timeDiff(1) = .1;
timeDiff(length(timeDiff)+1) = .1;

% checking csv data
if 1 == 0
    figure;
    hold on
    plot(enuDiff2);

    plot(timeDiff);
    hold off
    title("Enu Diff and Time Diff")
    ylim([-1,5]);
    spikeprev = 0;
end
spikeprev = 0;

newtimeDiff = zeros(length(NumLength)+1);
for ith_coordinate = 2:NumLength+1
    newtimeDiff(ith_coordinate,1) = timeDiff(ith_coordinate);
    if timeDiff(ith_coordinate) <.5

        if enuDiff2(ith_coordinate,1)<.1 || spikeprev == 1
            newtimeDiff(ith_coordinate) = .1;
            spikeprev = 0;
        else
            newtimeDiff(ith_coordinate) = max(max(timeDiff(ith_coordinate-1:ith_coordinate)),.1);
            spikeprev = 1;
        end
    end
    Time_BSMs(ith_coordinate) = Time_BSMs(ith_coordinate-1)+newtimeDiff(ith_coordinate);
end
timeDiff = newtimeDiff;

SpeedofAV_mps = zeros(length(NumLength));
for ith_coordinate = 1:NumLength
    point1 = ENU_BSM_coordinates(ith_coordinate,1:2);
    point2 = ENU_BSM_coordinates(ith_coordinate+1,1:2);
    timeatpt1 = Time_BSMs(ith_coordinate,:);
    timeatpt2 = Time_BSMs(ith_coordinate+1,:);
    if ~(point1 == point2)
        SpeedofAV_mps(ith_coordinate) = fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2);
    end
end


ith_coordinate = 242;
troublePoints = ENU_BSM_coordinates(ith_coordinate-5:ith_coordinate+5, :);

point1 = ENU_BSM_coordinates(ith_coordinate,1:2);
point2 = ENU_BSM_coordinates(ith_coordinate+1,1:2);
timeatpt1 = Time_BSMs(ith_coordinate,:);
timeatpt2 = Time_BSMs(ith_coordinate+1,:);
if abs(timeatpt2 -timeatpt1) < .5
    timeatpt2 = timeatpt1+.1;
end

% fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2) * 2.23694;
Speed_mps_correct = SpeedofAV_mps';
Speed_mps_correct(end+1,:) = Speed_mps_correct(end,:);

% convert speed from m/s tp mph
%SpeedofAV = SpeedofAV_mps*2.23694;


%SpeedofAV = smoothdata(SpeedofAV,'movmedian',10)


% checking csv data
if 1 == 0
    figure;
    hold on
    plot(enuDiff);
    plot(timeDiff);
    hold off
    title("Enu Diff and Time Diff")
    ylim([-1,5]);
    figure;
    hold on
    plot(SpeedofAV);
    hold off
    title('Speed of AV in mph');
    ylim([0,45]);
end


%figure;
%p = plot(smoothdata(SpeedofAV,'movmean',3));
%ylim([0,45]);
%title('Speed of AV in mph after filtering and smoothing');
SpeedAndENU = [Speed_mps_correct ENU_BSM_coordinates];
MatrixNoExtremes = fcn_INTERNAL_modifyMatrix(SpeedAndENU);
AV_Speed_Final = MatrixNoExtremes(:,1)*2.23694;
ENU_Final = MatrixNoExtremes(:,2:end);

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
    fcn_PlotTestTrack_plotPointsColorMap(ENU_Final,AV_Speed_Final, ...
        base_station_coordinates,maxVelocity,minVelocity,plot_color,LLA_fig_num,ENU_fig_num)


    figure(LLA_fig_num);
    %clf;

    %c.Label.String = 'Speed (mph)';


    figure(ENU_fig_num);
    %clf;

    %c.Label.String = 'Speed (mph)';



    %end
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function for fcn_PlotTestTrack_plot

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
%% fcn_INTERNAL_calcSpeed
function speed = fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2)

% Calculate the distance between the two points
distance = norm(point2 - point1);

timeInterval = timeatpt2-timeatpt1;

% Calculate the speed
speed = distance / timeInterval;
end

%% fcn_INTERNAL_totalSeconds

function totalSeconds = fcn_INTERNAL_totalSeconds(timeStr)
% Check if the string contains hours, minutes, and seconds or just minutes and seconds
timeStr = string(timeStr);
parts = split(timeStr, ':');
numParts = length(parts);

if numParts == 3
    % Time string contains hours, minutes, and seconds
    hours = str2double(parts{1});
    minutes = str2double(parts{2});
    seconds = str2double(parts{3});
elseif numParts == 2
    % Time string contains only minutes and seconds
    hours = 0;
    minutes = str2double(parts{1});
    seconds = str2double(parts{2});
else
    error('Invalid time format');
end

% Convert hours and minutes to seconds and add them up
totalSeconds = hours * 3600 + minutes * 60 + seconds;
end



%% fcn_INTERNAL_prepDataForOutput
function [ENU_positions_cell_array, LLA_positions_cell_array] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,LLA_data_with_nan,base_station_coordinates)
% This function breaks data into sub-arrays if separated by NaN, and as
% well fills in ENU data if this is empty via LLA data, or vice versa

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude= base_station_coordinates(1);
reference_longitude= base_station_coordinates(2);
reference_altitude = base_station_coordinates(3);
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class


if isempty(ENU_data_with_nan) && isempty(LLA_data_with_nan)
    error('At least one of the ENU or LLA data arrays must be filled.');
elseif isempty(ENU_data_with_nan)
    ENU_data_with_nan  = gps_object.WGSLLA2ENU(LLA_data_with_nan(:,1), LLA_data_with_nan(:,2), LLA_data_with_nan(:,3));
elseif isempty(LLA_data_with_nan)
    LLA_data_with_nan =  gps_object.ENU2WGSLLA(ENU_data_with_nan');
end


% The data passed in may be separated into sections, separated by NaN
% values. Here, we break them into sub-arrays
indicies_cell_array = fcn_plotRoad_breakArrayByNans(ENU_data_with_nan);
ENU_positions_cell_array{length(indicies_cell_array)} = {};
LLA_positions_cell_array{length(indicies_cell_array)} = {};
for ith_array = 1:length(indicies_cell_array)
    current_indicies = indicies_cell_array{ith_array};
    ENU_positions_cell_array{ith_array} = ENU_data_with_nan(current_indicies,:);
    LLA_positions_cell_array{ith_array} = LLA_data_with_nan(current_indicies,:);
end
end % Ends fcn_INTERNAL_prepDataForOutput

%% fcn_INTERNAL_modifyMatrix
function MatrixNoExtremes = fcn_INTERNAL_modifyMatrix(MatrixWithExtremes)
% Calculate the mean and standard deviation of the first column
mu = mean(MatrixWithExtremes(:, 1), 'omitnan');
sigma = std(MatrixWithExtremes(:, 1), 'omitnan');

% Define the threshold for extreme values (e.g., 3 standard deviations)
threshold = 2 * sigma;

% Create a copy of the input matrix
MatrixNoExtremes = MatrixWithExtremes;

% Find elements in the first column that are extreme values
extremeIndices = abs(MatrixWithExtremes(:, 1) - mu) > threshold;

% Replace extreme values in the first column with NaN
MatrixNoExtremes(extremeIndices, 1) = NaN;

% Find rows with values less than 0.5 in the first column
lowValueRows = MatrixWithExtremes(:, 1) < 0.05;

% Delete rows with low values in the first column
MatrixNoExtremes(lowValueRows, :) = [];
end
%% Unused functions
% %% fcn_INTERNAL_calculatePercentage
%
% function percentage = fcn_INTERNAL_calculatePercentage(max_speed, min_speed, input_speed)
%     for i = 1:length(input_speed)
%         input_speed(i);
%         usable_speed = min(max_speed, max(min_speed, input_speed(i)));
%         percentage(i) = (usable_speed - min_speed)/(max_speed-min_speed);
%     end
% end
%
% %% fcn_INTERNAL_assignColor
%
% function color = fcn_INTERNAL_assignColor(color_map, percentages)
%     c = color_map;
%
%     for i = 1:length(percentages)
%
%         color(i,1:3) = c(max(round(size(c,1)*percentages(i)),1),1:3);
%     end
% end
% %% fcn_INTERNAL_createCategories
%
% function categories = fcn_INTERNAL_createCategories(lowerLimit, upperLimit, numCategories)
%     % Check if the number of categories is valid
%     if numCategories < 1
%         error('Number of categories must be at least 1');
%     end
%
%     % Check if the limits are valid
%     if lowerLimit >= upperLimit
%         error('Lower limit must be less than upper limit');
%     end
%
%     % Calculate the step size
%     stepSize = (upperLimit - lowerLimit) / numCategories;
%
%     % Initialize the categories array
%     categories = cell(numCategories, 1);
%
%     % Populate the categories
%     for i = 1:numCategories
%         lowerBound = lowerLimit + (i-1) * stepSize;
%         upperBound = lowerLimit + i * stepSize;
%         categories{i} = [lowerBound, upperBound];
%     end
% end
% %% fcn_INTERNAL_getColorMap
% function color_map = fcn_INTERNAL_getColorMap(colormap_string)
%
%     % Use user-defined colormap_string
%     old_colormap = colormap;
%     if strcmp(colormap_string,'redtogreen')
%         new_colormap = colormap('hsv');
%         color_ordering = [new_colormap(1:85,:); [0 1 0]];
%     else
%         color_ordering = colormap(colormap_string);
%     end
%     color_map = color_ordering;
%
%
% end


