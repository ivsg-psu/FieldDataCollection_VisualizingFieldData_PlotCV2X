function fcn_PlotTestTrack_plotPointsColorMap(...
    ENU_coordinates, values, varargin)
%% fcn_PlotTestTrack_plotSpeedofAV
% Takes the input csv file, reads the LLA and time data from those files
% and calculates the speed of the Av at every point. Also plots the speed
% of the AV in different colours
%
% FORMAT:
%
%      fcn_PlotTestTrack_plotPointsColorMap(...
%        ENU_coordinates, values (base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num))
%
% INPUTS:
%
%       ENU_coordinates: coordinates of points to plot in ENU.
%
%       values: The raw values you want to plot as a color on the map.
%
%      (OPTIONAL INPUTS)
%
%       base_station_coordinates: the reference latitude, reference
%       longitude and reference altitude for the base station that we can
%       use to convert ENU2LLA and vice-versa
%
%       maxValue: maximum value of the list of values to allow. For
%       example, a 70mph speed limit
%
%       minValue: minimum value to plot.
%
%       plot_color: a colormap color string such as 'jet' or 'summer'
%
%       LLA_fig_num: a figure number for the LLA plot
%
%       ENU_fig_num: a figure number for the ENU plot
%
% OUTPUTS:
%
%       (none)
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotPointsColorMap.m for a full
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
if (nargin==8 && isequal(varargin{end},-1))
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
        narginchk(2,8);
    end
end

% base station coordinates
% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude]; % Default
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        base_station_coordinates = temp;
        reference_latitude= base_station_coordinates(1);
        reference_longitude= base_station_coordinates(2);
        reference_altitude = base_station_coordinates(3);
    end
end

% maxValue
maxValue = 85; % Default is at 85mph with is the fastest highway speed assigned in the US
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp) % if temp is not empty
        maxValue = temp;
    end
end

% minVelocity
minValue = 15; % Default is at 15mph with is the slowest speed limit assigned in the US
if 5 <= nargin
    temp = varargin{3};
    if ~isempty(temp) % if temp is not empty
        minValue = temp;
    end
end

% Does user want to specify plot_color?
color_mapArray = load("Data\colourmap_jet.mat","old_colormap"); % Default
color_map = color_mapArray.old_colormap;
if 6 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        find_colormap = temp;
        color_map = 0;
    end
end

% Does user want to specify LLA_fig_num?
LLA_fig_num = 100; % Default
if 7 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        LLA_fig_num = temp;
    end
end

% Does user want to specify ENU_fig_num?
ENU_fig_num = 200; % Default is do not plot
if 8 <= nargin
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
    temp2 = varargin{end-1};
    if ~isempty(temp)
        ENU_fig_num = temp;
        flag_do_plots = 1;
    end
    if ~isempty(temp2)
        LLA_fig_num = temp2;
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
gps_object = GPS(base_station_coordinates(1),base_station_coordinates(2),base_station_coordinates(3)); % Load the GPS class

LLA_coordinates = gps_object.ENU2WGSLLA(ENU_coordinates);

%Calculate percentage
percent = fcn_INTERNAL_calculatePercentage(maxValue,minValue,values);


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

    % since colourmap opeans a figure always
    % find colormap
    if color_map == 0 
        color_map = fcn_INTERNAL_getColorMap(find_colormap);
    end
    %convert to color:
    [colors,sizes] = fcn_INTERNAL_assignColor(color_map, percent, LLA_coordinates);

    f = figure(LLA_fig_num);
    clf;

    h_geoplot = geoplot(base_station_coordinates(:,1), base_station_coordinates(:,2), '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
    h_parent =  get(h_geoplot,'Parent');
    set(h_parent);


    try
        geobasemap satellite

    catch
        geobasemap openstreetmap
    end
    geotickformat -dd

    set(f,"Tag", "1");

    maxLat = max(LLA_coordinates(:,1));
    minLat = min(LLA_coordinates(:,1));

    maxLong = max(LLA_coordinates(:,2));
    minLong = min(LLA_coordinates(:,2));


    geolimits("manual");
    geolimits([minLat maxLat], [minLong maxLong]);




    for i = 1:size(colors,1)
        hold on;
        if sizes(i)>1
            input_coordinates_type = "LLA";
            MarkerSize = [];
            fcn_PlotTestTrack_plotPointsAnywhere(...
                reshape(colors(i,2:sizes(i),1:3),sizes(i)-1,3), input_coordinates_type, base_station_coordinates,...
                reshape(colors(i,1,1:3),1,3), MarkerSize, LLA_fig_num, ENU_fig_num);
        end

    end
    hold off;
    figure(LLA_fig_num);
    colormap(color_map);
    c = colorbar('Ticks',0:.1:1,...
        'TickLabels',{linspace(minValue,maxValue,11)});


    figure(ENU_fig_num);
    colormap(color_map);
    c = colorbar('Ticks',0:.1:1,...
        'TickLabels',{linspace(minValue,maxValue,11)});




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


%% fcn_INTERNAL_calculatePercentage

function percentage = fcn_INTERNAL_calculatePercentage(max_speed, min_speed, input_speed)
percentage = zeros(1,length(input_speed));
for i = 1:length(input_speed)
    input_speed(i);
    usable_speed = min(max_speed, max(min_speed, input_speed(i)));
    percentage(i) = (usable_speed - min_speed)/(max_speed-min_speed);
end
end

%% fcn_INTERNAL_assignColor

function [color, sizes] = fcn_INTERNAL_assignColor(color_map, percentages,coordinates)
color(:,1,1:3) = color_map;
sizes = ones(size(color,1),1);
for i = 1:length(percentages)
    idx = max(round(size(color_map,1)*percentages(i)),1);
    sizes(idx) = sizes(idx)+1;
    color(idx,sizes(idx),1:3) = coordinates(i,1:3);
end
end


%% fcn_INTERNAL_color_map

function color_map = fcn_INTERNAL_getColorMap(colormap_string)

% Use user-defined colormap_string
% old_colormap = colormap;
if strcmp(colormap_string,'redtogreen')
    new_colormap = colormap('hsv');
    color_ordering = [new_colormap(1:85,:); [0 1 0]];
else
    color_ordering = colormap(colormap_string);
end
color_map = color_ordering;


end


