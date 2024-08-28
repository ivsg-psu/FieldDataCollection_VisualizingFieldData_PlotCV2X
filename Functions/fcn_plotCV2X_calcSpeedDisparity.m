function speedDisparity = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, varargin)
%fcn_plotCV2X_calcSpeedDisparity  calculates the difference in velocity
%between each point and nearby points
%
% FORMAT:
%
%       speedDisparity = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num))
%
% INPUTS:
%
%      tLLA: the [time Latitude Longitude Altitude] data as an [Nx4] vector
%
%      tENU: the [time East North Up] data as an [Nx4] vector, using the
%      origin as set in the main demo script
%
%      searchRadiusAndAngles: a [1x1] or [1x2] vector of [searchRadius] or
%      [searchRadius angleRange] where searchRadius is the query distance
%      that determines search criteria for "nearby", in meters and
%      angleRange specifies the absolute difference in angle allowable (in
%      radians) for this position to be considered for calculations, e.g
%      all angles that are within [-angleRange, angleRange] are considered
%      for the search
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      speedDisparity: an [Nx1] vector of the speed disparity between the
%      current point and all other points near to the nth point, within the
%      searchRadius, and if specified, within the differences in headings.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotCV2X_calcSpeedDisparity
%
% This function was written on 2024_08_26 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision History
% 2024_08_26 S. Brennan
% -- started writing function

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==4 && isequal(varargin{end},-1))
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
    debug_fig_num = 999978; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
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
        narginchk(3,4);

    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
fig_num = []; % Initialize the figure number to be empty
if (0==flag_max_speed) && (4 <= nargin)
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

% Grab the time values
[modeIndex, ~, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tLLA, tENU, (-1));

% Calculate the velocities, angles, and heading
[velocity, angleENUradians, ~]  = fcn_plotCV2X_calcVelocity(tLLA, tENU, modeIndex, offsetCentisecondsToMode, -1);

% Find the nearest neighbors
nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (-1));

% Initialize the output
Ndata = length(tENU(:,1));
speedDisparity = nan(Ndata,1);

% Loop through each point
for ith_point = 1:Ndata
    this_point_nearbyIndicies = nearbyIndicies{ith_point};

    if ~isempty(this_point_nearbyIndicies)
        % How many neighbors are there?
        Nnearby = length(this_point_nearbyIndicies);

        % Get a neighbor point's angles and velocities
        nearby_angles = angleENUradians(this_point_nearbyIndicies,1);
        nearby_velocity_magnitudes = velocity(this_point_nearbyIndicies,1);

        % Calculate the velocity vectors for all neighbor points
        nearby_velocities = nearby_velocity_magnitudes.*[cos(nearby_angles) sin(nearby_angles)];

        % Get this point's angle and velocity
        this_angle = angleENUradians(ith_point,1);
        this_velocity_magnitude = velocity(ith_point,1);

        % Make sure this point is defined - it might be nan values!
        if ~isnan(this_angle) && ~isnan(this_velocity_magnitude)

            % Calculate the velocity vector for this point
            this_pointVelocity = this_velocity_magnitude*[cos(this_angle) sin(this_angle)];

            % Find the difference in the velocities as the distance between
            % the ends of the velocity vectors
            allDifferences= real(sum((ones(Nnearby,1)*this_pointVelocity - nearby_velocities).^2,2).^0.5);

            % Keep the maximum velocity difference
            speedDisparity(ith_point,1) = max(allDifferences);
        end
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
    % Prep the data for plotting
    goodPlottingIndicies = ~isnan(speedDisparity);

    rawXYVData = [tENU(:,2:3) speedDisparity];    
    plotXYVData = rawXYVData(goodPlottingIndicies,:);

    if ~isempty(tLLA)
        rawLLVData = [tLLA(:,2:3) speedDisparity];
        plotLLVData = rawLLVData(goodPlottingIndicies,:);
    end

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
    colormap(gca,colorMapMatrixOrString);
    fcn_plotRoad_plotXYI(plotXYVData, (plotFormat), (reducedColorMap), (fig_num));    
    title('ENU velocities')
    xlabel('East [m]')
    ylabel('North [m]')


    h_colorbar = colorbar;
    h_colorbar.Ticks = linspace(0, 1, Ncolors) ; %Create ticks from zero to 1
    % There are 2.23694 mph in 1 m/s
    colorbarValues   = round(2.23694 * linspace(min(speedDisparity), max(speedDisparity), Ncolors));
    h_colorbar.TickLabels = num2cell(colorbarValues) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    h_colorbar.Label.String = 'Speed (mph)';


    if ~isempty(tLLA)
        subplot(1,2,2);
        fcn_plotRoad_plotLLI(plotLLVData, (plotFormat), (reducedColorMap), (fig_num));
        colormap(gca,colorMapMatrixOrString);
        title('LLA velocities')

        h_colorbar = colorbar;
        h_colorbar.Ticks = linspace(0, 1, Ncolors) ; %Create ticks from zero to 1
        % There are 2.23694 mph in 1 m/s
        colorbarValues   = round(2.23694 * linspace(min(speedDisparity), max(speedDisparity), Ncolors));
        h_colorbar.TickLabels = num2cell(colorbarValues) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
        h_colorbar.Label.String = 'Speed (mph)';
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
