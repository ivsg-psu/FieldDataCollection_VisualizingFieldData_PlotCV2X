function [tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile,varargin)
%fcn_plotCV2X_loadDataFromFile  loads time+ENU and time+LLA data from file
%
% FORMAT:
%
%       [tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num))
%
% INPUTS:
%       csvFile: A string variable containing the name of the .csv file.
%       The CSV file should contain, in column order, the latitude,
%       longitude, altitude, and time data. Usually this data represents
%       the location at which the OBU sent out the BSM message to the RSU
%       that was in range.
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      tLLA: the [time Latitude Longitude Altitude] data as an [Nx4] vector
%
%      tENU: the [time East North Up] data as an [Nx4] vector, using the
%      origin as set in the main demo script
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotCV2X_loadDataFromFile
%
% This function was written on 2024_08_15 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision History
% 2024_08_15 S. Brennan
% -- started writing function

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==2 && isequal(varargin{end},-1))
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
        narginchk(1,2);

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


% Read csv file
fileID = fopen(csvFile,'r');
% Read the header
header_text = textscan(fileID,'%s %s %s %s %s',1,'Delimiter',',');

% Read the data
data = textscan(fileID,'%f %f %f %s %s','Delimiter',',');
fclose(fileID);

% Check the data
Ndata = length(data{1});
assert(Ndata == length(data{2}));
assert(Ndata == length(data{3}));
assert(Ndata == length(data{4}));
%assert(Ndata == length(data{5}));

% Convert the time data from string into seconds
timeSeconds = nan(Ndata,1); % Initialize the variable

% Break the data into parts using ":" as the separator
for ith_entry = 1:Ndata
    timeString = data{4}(ith_entry);
    splitStr = regexp(timeString,':','split');
    cellContents = splitStr{1};
    if length(cellContents)==3
        time_hours = str2double(cellContents{1});
        time_minutes = str2double(cellContents{2});
        time_60seconds = str2double(cellContents{3});
    elseif length(cellContents)==2
        time_hours = 0;
        time_minutes = str2double(cellContents{1});
        time_60seconds = str2double(cellContents{2});
 
    else
        error('weird cell contents found!');
    end

    % Convert this into seconds
    timeSeconds(ith_entry,1) = time_hours*3600 + time_minutes*60 + time_60seconds;
end

% Extract latitude, longitude, elevation, and time values, here we get time
% as NaNs
lat = data{1}/10000000;
lon = data{2}/10000000;
elv = data{3}/1.0;

% Save result in output format
tLLA = [timeSeconds lat lon elv];
OBUID = [data{5}];
OBUID = convertCharsToStrings(OBUID);

% convert LLA to ENU
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE");
MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE");
MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE");
if ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE) && ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE) && ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE)
    reference_latitude  = str2double(MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE);
    reference_longitude = str2double(MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE);
    reference_altitude  = str2double(MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE);
end
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class
ENU_coordinates = gps_object.WGSLLA2ENU(lat,lon,elv,reference_latitude,reference_longitude,reference_altitude);

% Save result in output format
tENU = [timeSeconds ENU_coordinates];

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

    figure(fig_num);
    clf;
    
    clear plotFormat
    
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 10;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 5;
    
    flag_plot_headers_and_tailers = 1;
    
    N_OBUIDs = length(OBUID);
    OBUID_List = [OBUID(1)];
    tENU_data = cell(2,1);
    tLLA_data = cell(2,1);
    
    if isempty(OBUID{1})
    
        plotFormat.Color = [0 0 1];
    
        subplot(1,2,1);
        fcn_plotRoad_plotTraceXY(tENU(:,2:3), (plotFormat), (flag_plot_headers_and_tailers), (fig_num));
        subplot(1,2,2);
        fcn_plotRoad_plotTraceLL(tLLA(:,2:3), (plotFormat), (flag_plot_headers_and_tailers), (fig_num));
    else
        
        for ith_OBUID = 1:N_OBUIDs
            current_OBUID = 0;
    
            for ith_OBUID_List = 1:length(OBUID_List)
                if OBUID(ith_OBUID) == OBUID_List(ith_OBUID_List)
                    current_OBUID = ith_OBUID_List;
                end
            end
    
            if current_OBUID == 0
                OBUID_List = [OBUID_List; OBUID(ith_OBUID)];
                current_OBUID = length(OBUID_List);
            end
    
            tENU_data{current_OBUID,1} = [tENU_data{current_OBUID,1};tENU(ith_OBUID,2:3)];
            tLLA_data{current_OBUID,1} = [tLLA_data{current_OBUID,1};tLLA(ith_OBUID,2:3)];
    
        end
    
        for ith_OBUID_List = 1:length(OBUID_List)
            color_vector = fcn_geometry_fillColorFromNumberOrName(ith_OBUID_List);
            plotFormat.Color = color_vector;
    
            subplot(1,2,1);
            fcn_plotRoad_plotTraceXY(tENU_data{ith_OBUID_List}, (plotFormat), (flag_plot_headers_and_tailers), (fig_num));
            subplot(1,2,2);
            fcn_plotRoad_plotTraceLL(tLLA_data{ith_OBUID_List}, (plotFormat), (flag_plot_headers_and_tailers), (fig_num));
        end
        
    end


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



