function cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, varargin)
%fcn_plotRoad_calcRectangleXYZ  finds the XY(Z) corners of a rectangle
%
% FORMAT:
%
%       cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num))
%
% INPUTS:
%
%      centerPointXYZ: a [1X3] or a [1X2] vector containing the [X Y Z]
%      coordinate or the [X Y] coordinate of the center of the rectangle
%
%      LWH: a [1X3] or [1x2] vector containing the [Length Width Height] or
%      the [Length Width] of the rectangle
%
%      (OPTIONAL INPUTS)
%
%      yawAngle: the angle of the rectagle relative to the Z-axis (yaw),
%      measured in radians
%
%      centerOffsetLWH: the offset of the rectangle's centerPointXYZ
%      relative to the rectangle's exact geometric center, as measured in a
%      coordinate system attached to the LWH directions. In LWH
%      coordinates, if the centerPointXYZ is at the origin, then the
%      rectangle's geometric center will be at centerOffsetLWH.
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%       cornersXYZ: the XYZ coordinates of the corner points of the
%       rectangle. Note: in 2D, the points are traced counterclockwise with
%       the first point repeated, so that the plot of the points is closed.
%       In XYZ coordinates, the points are ordered to cover the XY, YZ, XZ
%       planes, and then the negative planes. Points are ordered such that
%       they are always clockwise relative to each face such that the
%       normal vector out of the rectangle points outward, e.g.
%       counter-clockwise when "looking" at the face.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotRoad_calcRectangleXYZ.m 
% 
%       for a full test suite
%
% This function was written on 2024_08_13 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_08_13 by S. Brennan, sbrennan@psu.edu
% -- start writing function by heavily modifying version from PlotTestTrack



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
        narginchk(2,5);
    end
end

% Check to see if user specifies yawAngle?
yawAngle = 0; % default
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        yawAngle = temp;
    end
end

% Check to see if user specifies centerOffsetLWH?
centerOffsetLWH = 0*centerPointXYZ; % default
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        centerOffsetLWH = temp;
    end
end

% Check to see if user specifies fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) && (5<= nargin)
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

if 2==length(centerPointXYZ(1,:))
    initial_square = [0 0; 1 0; 1 1; 0 1; 0 0];
    shifted_initial_square = initial_square - 1/2*ones(length(initial_square(:,1)),2); 
    initial_rectangle = shifted_initial_square*diag(LWH);
    rotated_rectangle = (initial_rectangle + centerOffsetLWH)*[cos(yawAngle) sin(yawAngle); -sin(yawAngle) cos(yawAngle)];
    cornersXYZ =  centerPointXYZ + rotated_rectangle;
elseif 3==length(centerPointXYZ(1,:))
    % Construct the plane rotation point sequences in each of the planes
    XY0_plane = [0 0 0; 0 1 0; 1 1 0; 1 0 0; 0 0 0];
    YZ0_plane = [0 0 0; 0 0 1; 0 1 1; 0 1 0; 0 0 0];
    XZ0_plane = [0 0 0; 1 0 0; 1 0 1; 0 0 1; 0 0 0];
    XY1_plane = [0 0 1; 1 0 1; 1 1 1; 0 1 1; 0 0 1];
    YZ1_plane = [1 0 1; 1 0 0; 1 1 0; 1 1 1; 1 0 1];
    XZ1_plane = [1 1 1; 0 1 1; 0 1 0; 1 1 0; 1 1 1];

    % Create the initial square
    initial_square = [...
        XY0_plane; 
        YZ0_plane; 
        XZ0_plane; 
        XY1_plane; 
        YZ1_plane; 
        XZ1_plane]; 
    shifted_initial_square = initial_square - 1/2*ones(length(initial_square(:,1)),3); 
    initial_rectangle = shifted_initial_square*diag(LWH);
    rotated_rectangle = (initial_rectangle + centerOffsetLWH)*[cos(yawAngle) sin(yawAngle) 0; -sin(yawAngle) cos(yawAngle) 0; 0 0 1];
    cornersXYZ =  centerPointXYZ + rotated_rectangle;
else
    warning('on','backtrace');
    warning('An unkown dimension detected for the centerPointXYZ - throwing an error.');
    error('Unknown centerPointXYZ dimension. Expecting a 1x2 or 1x3 vector. ');
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

% Plot rectangle in LLA
if flag_do_plots == 1
    % check whether the figure already has data
    temp_h = figure(fig_num);
    flag_rescale_axis = 0;
    if isempty(get(temp_h,'Children'))
        flag_rescale_axis = 1;
    end

    hold on;
    grid on;
    axis equal

    xlabel('X [m]');
    ylabel('Y [m]');

    % Do plot
    if 2==length(centerPointXYZ(1,:))
        plot(cornersXYZ(:,1), cornersXYZ(:,2),'b.-');

    elseif 3==length(centerPointXYZ(1,:))
        plot3(cornersXYZ(:,1), cornersXYZ(:,2), cornersXYZ(:,3), 'b.-');
        zlabel('Z [m]');
        view(3);
    end


    % Make axis slightly larger?
    if flag_rescale_axis
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_x = temp(2)-temp(1);
        axis_range_y = temp(4)-temp(3);
        percent_larger = 0.3;
        axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    end

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



