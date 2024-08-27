function nearbyIndicies = fcn_plotCV2X_findNearbyIndicies(tENU, searchRadiusAndAngles, varargin)
%fcn_plotCV2X_findNearbyIndicies  for each point, lists nearby indicies
%
% FORMAT:
%
%       nearbyIndicies = fcn_plotCV2X_findNearbyIndicies(tENU, searchRadiusAndAngles, (fig_num))
%
% INPUTS:
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
%      nearbyIndicies: an N-length cell array, with each cell corresponding
%      to the nth point in the tENU input. The cell array contains, in each
%      element, a vector [kx1] that lists the k indicies near to the given
%      point. If no point is within the searchRadius, an empty matrix is
%      given.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotCV2X_findNearbyIndicies
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

% Initialize the output
Ndata = length(tENU(:,1));
nearbyIndicies{Ndata} = [];

% Check the inputs in searchRadiusAndAngles
flag_check_angles = 0;
if length(searchRadiusAndAngles)==2
    searchRadius = searchRadiusAndAngles(1);
    searchAngles = searchRadiusAndAngles(2);
    flag_check_angles = 1;
elseif length(searchRadiusAndAngles)==1
    searchRadius = searchRadiusAndAngles(1);
else
    warning('on','backtrace');
    warning('A poorly defined searchRadiusAndAngles was encountered. Expecting a [1x2] vector - throwing an error.')
    error('Error in searchRadiusAndAngles encountered. Cannot continue.');
end


% Precalculate items
if 1==flag_check_angles
    % Grab the time values
    [modeIndex, ~, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tLLA, tENU, (-1));

    % Calculate the velocities, angles, and heading
    [~, angleENUradians, ~]  = fcn_plotCV2X_calcVelocity(tLLA, tENU, modeIndex, offsetCentisecondsToMode, -1);

    % Find the unit vectors for all the angles
    unit_vectors = [cos(angleENUradians) sin(angleENUradians)];    
end

% Loop through all the points, finding qualifying agreement indicies
allXY = tENU(:,2:3);
for ith_point = 1:Ndata
    this_pointXY = tENU(ith_point,2:3);
    allDistances = real(sum((ones(Ndata,1)*this_pointXY - allXY).^2,2).^0.5);
    closeIndicies = find(allDistances<=searchRadius);
    nearbyIndicies{ith_point} = closeIndicies(closeIndicies~=ith_point);

    if 1==flag_check_angles
  
        current_angle = angleENUradians(ith_point);
        this_vector = [cos(current_angle) sin(current_angle)];
        
        Nnearby = length(nearbyIndicies{ith_point});

        if ~isnan(current_angle) && Nnearby>0
            % Find the vectors nearby            
            vectors_nearby = unit_vectors(nearbyIndicies{ith_point},:);

            % Find dot products
            dot_products = sum((ones(Nnearby,1)*this_vector).*vectors_nearby,2);
            % full_cross_products = cross([(ones(Nnearby,1)*this_vector) zeros(Nnearby,1)],[vectors_nearby zeros(Nnearby,1)]);
            % cross_products = full_cross_products(:,3);

            % Find angles in agreement - these are ones whose dot products
            % are aligned, e.g. less than or equal to the cosine of the
            % angle between the vectors
            in_agreement = dot_products<=cos(current_angle);

            nearbyIndicies{ith_point} = nearbyIndicies{ith_point}(in_agreement);
        else
            nearbyIndicies{ith_point} = [];
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

% before opeaning up a figure, lets start to capture the frames for an
% animation if the user has entered a name for the mov file
if flag_do_plots == 1

    figure(fig_num);
    
    % Pick a random value to plot
    randomIndex = round(rand*(Ndata-1))+1;
    randomIndex = min(Ndata,max(1,randomIndex));

    
    % Plot the input data
    clear plotFormat
    plotFormat.Color = [0 0 0];
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 10;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 3;
    fcn_plotRoad_plotXY((tENU(:,2:3)), (plotFormat), (fig_num));

    % Plot the test point
    plotFormat.Color = [0 0 1];
    plotFormat.MarkerSize = 50;
    fcn_plotRoad_plotXY((tENU(randomIndex,2:3)), (plotFormat), (fig_num));

    % Plot the bounding circle
    Nangles = 45;
    theta = linspace(0, 2*pi, Nangles)'; 
    CircleXData = ones(Nangles,1)*tENU(randomIndex,2) + searchRadiusAndAngles*cos(theta);
    CircleYData = ones(Nangles,1)*tENU(randomIndex,3) + searchRadiusAndAngles*sin(theta);
    plotFormat.Marker = 'none';
    plotFormat.Color = [1 0 1];
    plotFormat.MarkerSize = 10;
    plotFormat.LineStyle = '-';
    plotFormat.LineWidth = 3;
    fcn_plotRoad_plotXY([CircleXData CircleYData], (plotFormat), (fig_num));

    % Plot the points inside the bounding circle
    indicesNearby = nearbyIndicies{randomIndex};
    plotFormat.Color = [1 0 1];
    plotFormat.Marker = 'o';
    plotFormat.MarkerSize = 10;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 1;
    fcn_plotRoad_plotXY((tENU(indicesNearby,2:3)), (plotFormat), (fig_num));
    

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
