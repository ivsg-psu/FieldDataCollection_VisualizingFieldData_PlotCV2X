function [LLA_leftLane, LLA_rightLane, LLA_centerLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, varargin)
%% fcn_PlotTestTrack_plotLaneBoundingBox
%
% create a plot of the lanes with a bounding box appearing under the lanes.
%
% FORMAT:
%
%       [LLA_leftLane, LLA_rightLane, LLA_centerLane] = fcn_PlotTestTrack_laneBoundingBox(csvFile, ...
%                      (baseLat,baseLon,baseAlt,laneWidth, left_color, right_color, center_color, lane_color, fig_num))
%
% INPUTS:
%
%      (MANDATORY INPUTS)
%       csvFile: The name of the .csv file that contains the latitude,
%                    longitude, altitude, and time of the location
%                    at which the OBU sent out the BSM message to the RSU
%                    that was in range. The code assumes latitude in first
%                    column, longitude in second, altitude in third, and
%                    time in fourth.
%
%       (OPTIONAL INPUTS)
%      baseLat: Latitude of the base location. Default is 40.8637.
%
%      baseLon: Longitude of the base location. Default is -77.8359.
%
%      baseAlt: Altitude of the base location. Default is 344.189.
%
%      laneWidth: Width of the lane in meters. Default is 3.6
%
%      left_color: Color of the left lane lines in the plot. Default is [0 0 1]
%
%      right_color: Color of the left lane lines in the plot. Default is [0 1 1]
%
%      center_color: Color of the left lane lines in the plot. Default is [1 0 0]
%
%      lane_color: Color of the left lane lines in the plot. Default is [1 0 1]
%
%      fig_num: figure number. Default is 100.
%
% OUTPUTS:
%
%      LLA_leftLane: Latitude and Longitude of the left side lane lines.
%
%      LLA_rightLane: Latitude and longitude of the right side lane lines.
%
%      LLA_centerLane: Latitude and longitude of the center of the lane.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotLaneBoundingBox.m
%
% This function was written on 2024_07_18 by Joseph Baker
% --Start to write the function
% Questions or comments? jmb9658@psu.edu


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==10 && isequal(varargin{end},-1))
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
        narginchk(1,10);
    end
end

% Default base location coordinates (PSU test track)
baseLat = 40.8637; % default
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        baseLat = temp;
    end
end

baseLon = -77.8359;% default
% Default base location coordinates (PSU test track)
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        baseLon = temp;
    end
end

baseAlt = 344.189;% default
% Default base location coordinates (PSU test track)
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        baseAlt = temp;
    end
end

laneWidth = 3.6;% default
% Default LaneWidth (3.6 meter)
if 5 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        laneWidth = temp;
    end
end


left_color = [0 0 1]; % default
if 6 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        left_color = temp;
    end
end

right_color = [0 1 1]; % default
if 7 <= nargin
    temp = varargin{6};
    if ~isempty(temp)
        right_color = temp;
    end
end

center_color = [1 0 0]; % default
if 8 <= nargin
    temp = varargin{7};
    if ~isempty(temp)
        center_color = temp;
    end
end

lane_color = [1 0 1]; % default
if 9 <= nargin
    temp = varargin{8};
    if ~isempty(temp)
        lane_color = temp;
    end
end

% fig_num
fig_num = 100; % Default
if 10 <= nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (10<= nargin)
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



[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_CenterLaneX, ENU_CenterLaneY] ...
    = fcn_PlotTestTrack_calculateLaneLines(csvFile, ...
    baseLat,baseLon,baseAlt,laneWidth);

ENU_RightLane = [ENU_RightLaneX ENU_RightLaneY (ENU_RightLaneX*0)];
ENU_LeftLane = [ENU_LeftLaneX ENU_LeftLaneY (ENU_LeftLaneX*0)];
ENU_CenterLane = [ENU_CenterLaneX ENU_CenterLaneY (ENU_CenterLaneX*0)];

gps_object = GPS(baseLat,baseLon,baseAlt);

LLA_leftLane = gps_object.ENU2WGSLLA(ENU_LeftLane);
LLA_rightLane = gps_object.ENU2WGSLLA(ENU_RightLane);
LLA_centerLane = gps_object.ENU2WGSLLA(ENU_CenterLane);



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
    figure (fig_num);
    clf;

    h_geoplot = geoplot(baseLat, baseLon, '*','Color',lane_color,'Linewidth',3,'Markersize',10);
    h_parent = get(h_geoplot,'Parent');
    set(h_parent,'ZoomLevel',17);
    set(h_parent,'MapCenter',[baseLat baseLon]);

    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end
    geotickformat -dd;

    hold on
    prevIdx= 0;
    for ith_data = 1:length(LLA_leftLane)
        if ~isnan(LLA_leftLane(ith_data,1)) %finds indexes of coordinates that exist
            if prevIdx > 0 %plots the bounding box if there are 2 unique indexes of coordinates that contain different lats and longs.
                if ~(all(LLA_rightLane(prevIdx,:) == LLA_rightLane(ith_data,:)) || all(LLA_rightLane(prevIdx,:)==LLA_leftLane(ith_data,:)) )
                    fcn_INTERNAL_plotOneLane(LLA_rightLane(prevIdx,:),LLA_rightLane(ith_data,:), LLA_leftLane(prevIdx,:),LLA_leftLane(ith_data,:),lane_color,left_color,right_color)

                end
            end
            prevIdx = ith_data;
        end

    end

    %sets up variables for legend
    qw{1} = geoplot(LLA_centerLane(1,1),LLA_centerLane(1,2), 'Color',lane_color,'LineWidth',1); % lane color
    qw{2} = geoplot(LLA_leftLane(prevIdx,1), LLA_leftLane(prevIdx,2), 'Color',left_color,'LineWidth',1); %left lane color
    qw{3} = geoplot(LLA_rightLane(prevIdx,1), LLA_rightLane(prevIdx,2), 'Color',right_color,'LineWidth',1); % right lane color

    %Also plots the center of the lane.
    qw{4} = geoplot(LLA_centerLane(:,1),LLA_centerLane(:,2),'Color',center_color,'LineWidth',1); %center lane color

    legend([qw{:}], {'Lane Box', 'Left Lane', 'Right Lane', 'Center Lane'}, 'location', 'best');

    hold off

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
%% fcn_INTERNAL_plotOneLane
function fcn_INTERNAL_plotOneLane(LLA_right1, LLA_right2, LLA_left1, LLA_left2, plot_color,left_color,right_color)

% Calculate the box to plot?
if ~isempty(LLA_right1) && ~isempty(LLA_left1)
    %corners of box
    boundaryLLA = [LLA_right1; LLA_right2; LLA_left2; LLA_left1; LLA_right1;];

    %sides of the lane
    right = [LLA_right1; LLA_right2;LLA_right1;];
    left = [LLA_left1; LLA_left2; LLA_left1;];

    LLA_data_to_plot = boundaryLLA;

    % Create the geoshapes
    laneShape = geopolyshape(LLA_data_to_plot(:,1),LLA_data_to_plot(:,2));
    leftLane = geopolyshape(left(:,1),left(:,2));
    rightLane = geopolyshape(right(:,1),right(:,2));

    %plot the slightly transparent background of lane
    gp = geoplot(laneShape,'FaceColor',plot_color,'EdgeColor',plot_color,'Linewidth',1,'FaceAlpha',1);
    gp.EdgeAlpha = 0;
    gp.FaceAlpha = .35;

    %plot the sides of the lane
    geoplot(leftLane, 'EdgeColor',left_color,'LineWidth',1);
    geoplot(rightLane,'EdgeColor',right_color,'LineWidth',1);
end
end

