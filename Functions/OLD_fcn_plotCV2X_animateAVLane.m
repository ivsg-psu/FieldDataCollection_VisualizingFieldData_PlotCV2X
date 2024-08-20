function [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY]...
    = fcn_plotCV2X_animateAVLane(tENU, varargin)
%fcn_plotCV2X_animateAVLane  creates an animated plot of tLL data
% 
% This creates an animated plot of [time, latitude, longitude] coordinates 
%
% FORMAT:
%
%       [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY]
%       = fcn_plotCV2X_animateAVLane(tENU, (fig_num))
%
% INPUTS:
%
%
%      tENU: the [time East North Up] data as an [Nx4] vector
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      [LeftLaneX, LeftLaneY, RightLaneX, RightLaneY]: XY coordinates of
%      the left and right lane boundaries
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_plotCV2X_animateAVLane.m
%
% This function was written on 2024_08_16 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision History
% 2024_08_16 V. Wagh
% -- started writing function from fcn_PlotTestTrack similar function

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
% Pull out data
XYdata = tENU(:,2:3);

%% Calculate lane locations of left and right side lanes
% Method: calculate perpendicular vector, project positive and negative
% distances
tangential_vectors = diff(XYdata,1,1);

% Repeat the last vector to make tangential vectors same length as input
% data
tangential_vectors = [tangential_vectors; tangential_vectors(end,:)];

% Find the normal vectors
unit_orthogonal_vectors = fcn_geometry_calcOrthogonalVector(tangential_vectors);

% Find the left and right lanes
laneHalfWidth_in_meters = (12/2)/3.281; % 12 feet is standard lane width, and there are 3.281 feet in a meter
rightLane = XYdata + unit_orthogonal_vectors*laneHalfWidth_in_meters;
leftLane  = XYdata - unit_orthogonal_vectors*laneHalfWidth_in_meters;


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
    if ~isempty(name_of_movfile)

        if isempty(path_to_save_video)
            error('Give a path to save the video');
        end
        % Define the number of frames for the video
        numFrames = Num_length;

        % Specify the folder where you want to save the video
        outputFolder = path_to_save_video; % Replace with your desired path

        % Create the full file path
        outputFileName = fullfile(outputFolder, sprintf('%s',name_of_movfile'));

        % Create a VideoWriter object
        video = VideoWriter(outputFileName, 'MPEG-4'); % Use 'Uncompressed AVI' for uncompressed format
        video.FrameRate = 30; % Set the frame rate

        % Open the video writer object to start writing
        open(video);

    end
    figure (fig_num); % Create a figure
    clf;

    % Plot the base station i.e the RSU in this case with the same colour as the AV.
    % This sets up the figure for
    % the first time, including the zoom into the test track area.
    h_geoplot = geoplot(baseLat, baseLon, '*','Color',AV_color,'Linewidth',3,'Markersize',10);
    h_parent = get(h_geoplot,'Parent');
    set(h_parent,'ZoomLevel',16.375);

    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end
    geotickformat -dd;

    % plot original data i.e centerline and rectangle of car
    hold on;
    h_center = geoplot(lat, lon, "Color",AV_color, "LineWidth", 3);
    h_left = geoplot(LLA_LeftLane(:, 1), LLA_LeftLane(:, 2), "Color",left_color, "LineWidth", 3);
    h_right = geoplot(LLA_RightLane(:, 1), LLA_RightLane(:, 2), "Color",right_color, "LineWidth", 3);
    h_rect = geoplot(nan, nan, "Color",AV_color, 'LineWidth', 2);

    % Conversion factors
    feet_per_degree_lat = 364567; % Approximate conversion factor for latitude
    feet_per_degree_lon = feet_per_degree_lat * cosd(mean(lat)); % Adjust for mid-latitude

    % Convert car dimensions to degrees
    car_length_deg = car_length / feet_per_degree_lat;
    car_width_deg = car_width / feet_per_degree_lon;

    % Animation loop
    for ith_coordinate = 1:Num_length
        % Update the data for center, left and right lane
        set(h_center, 'XData', lat(1:ith_coordinate), 'YData', lon(1:ith_coordinate), 'LineWidth', 3);
        set(h_left, 'XData', LLA_LeftLane(1:ith_coordinate, 1), 'YData', LLA_LeftLane(1:ith_coordinate, 2), 'LineWidth', 3);
        set(h_right, 'XData', LLA_RightLane(1:ith_coordinate, 1), 'YData', LLA_RightLane(1:ith_coordinate, 2), 'LineWidth', 3);

        % Update the data for the rectangle to represent the car
        % Calculate the unit vector where the car is heading to
        Vector = [lat(ith_coordinate+1)-lat(ith_coordinate), lon(ith_coordinate+1)-lon(ith_coordinate)];
        magnitude = sum(Vector.^2,2).^0.5;
        unitVtor = Vector./magnitude;
        %Calculate the unit vector that is perpendicular to the direction of
        % the car
        perpVector = [unitVtor(2), -unitVtor(1)];
        scaled_perpVector = perpVector * (car_width_deg/2);
        center = [lat(ith_coordinate) lon(ith_coordinate)];
        % Find center points of front, back, left and right of the lane
        New_point_left = center - scaled_perpVector;
        New_point_right = center + scaled_perpVector;
        New_point_front = center + unitVtor.*(car_length_deg/2);
        New_point_back = center - unitVtor.*(car_length_deg/2);
        % Find the points of the four corners of the car
        Left_bottom_corner = New_point_back - scaled_perpVector;
        Left_top_corner = New_point_front - scaled_perpVector;
        Right_bottom_corner = New_point_back + scaled_perpVector;
        Right_top_corner = New_point_front + scaled_perpVector;
        %Coordination of the rectangle
        x = [Left_bottom_corner(1),Right_bottom_corner(1),Right_top_corner(1),Left_top_corner(1),Left_bottom_corner(1)];
        y = [Left_bottom_corner(2),Right_bottom_corner(2),Right_top_corner(2),Left_top_corner(2),Left_bottom_corner(2)];
        set(h_rect,'XData',x,'YData',y)
        % Pause to control the speed of the animation
        pause(0.1);

        if ~isempty(name_of_movfile)
            % Get the current frame as an image
            frame = getframe(gcf);

            % Write the frame to the video
            writeVideo(video, frame);
        end

    end

    legend([h_center, h_left, h_right, h_rect], {'Center Lane', 'Left Lane', 'Right Lane', 'Car'}, 'Location', 'best');
    hold off;

    if ~isempty(name_of_movfile)
        % Close the video writer object
        close(video);

        % Close the figure
        close(gcf);

        fprintf('Video saved as %s\n',name_of_movfile);
    end

    if flag_do_debug
        fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
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
%% fcn_INTERNAL_calcPerpendicularPoint
function [X_new, Y_new] = fcn_INTERNAL_calcPerpendicularPoint(X1, Y1, X2, Y2, distance)

% Input points
point_start = [X1, Y1];
point_end = [X2, Y2];

% Compute the vector from point_start to point_end
vector_to_calculate = point_end - point_start;
magnitude_vector_to_calculate = sum(vector_to_calculate.^2,2).^0.5;

% Compute the unit vector
unit_vector = vector_to_calculate./magnitude_vector_to_calculate;

if ~isnan(unit_vector)

    % Find a vector perpendicular to the unit vector
    % Rotating 90 degrees clockwise: [x; y] -> [y; -x]
    perpendicular_vector = [unit_vector(2), -unit_vector(1)];

    % Scale the perpendicular vector by the desired distance
    scaled_perpendicular_vector = perpendicular_vector * distance;

    % Compute the new point by adding the scaled perpendicular vector to point_start
    new_point = point_start + scaled_perpendicular_vector;

    % Output the coordinates of the new point
    X_new = new_point(1);
    Y_new = new_point(2);
else
    X_new = NaN;
    Y_new = NaN;
end

end


