function [LLA_trace, ENU_trace, STH_trace]  = fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type, varargin)
%fcn_plotRoad_plotTraces   plots traces in LLA, ENU, and/or STH coords
%
% FORMAT:
%
%       fcn_plotRoad_plotTraces(...
%          Trace_coordinates, input_coordinates_type,...
%          (plotFormat),...
%          (reference_unit_tangent_vector),...
%          (flag_plot_headers_and_tailers),...
%          (LLA_fig_num), (ENU_fig_num), (STH_fig_num));
%
% INPUTS:
%
%       Trace_coordinates: a matrix of Nx2 or Nx3 containing the LLA or ENU
%       or STH coordinates of the trace that is to be plotted
%
%       input_coordinates_type: a string stating the type of
%       Trace_coordinates that have been the input. String can be "LLA" or
%       "ENU" or "STH".
%
%      (OPTIONAL INPUTS)
%
%      plotFormat: one of the following:
%      
%          * a format string, e.g. 'b-', that dictates the plot style
%          * a [1x3] color vector specifying the RGB ratios from 0 to 1
%          * a structure whose subfields for the plot properties to change, for example:
%            plotFormat.LineWideth = 3;
%            plotFormat.MarkerSize = 10;
%            plotFormat.Color = [1 0.5 0.5];
%            A full list of properties can be found by examining the plot
%            handle, for example: h_plot = plot(1:10); get(h_plot)
%
%       reference_unit_tangent_vector: the reference vector for the STH
%       coordinate frame to use for STH plotting
%
%       flag_plot_headers_and_tailers: set to 1 to plot the head/tail of
%       the trace (default), and 0 to just plot the entire trace alone
%
%       LLA_fig_num: a figure number for the LLA plot
%
%       ENU_fig_num: a figure number for the ENU plot
%
%       STH_fig_num: a figure number for the STH plot
%
% OUTPUTS:
%
%       (none)
%
% DEPENDENCIES:
%
%      fcn_plotRoad_breakArrayByNans
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotRoad_plotTraces
%
%       test suite.
%
% This function was written on 2024_03_23 by V. Wagh
% Questions or comments? vbw5054@psu.edu

% Revision history:
% 2024_03_23 by V. Wagh
% -- start writing function from fcn_LoadWZ_plotTrace
% 2024_03_28 by V.Wagh
% -- added warning to ask user for unit vector for STH coordinates
% -- changed the name of the function and the script
% 2024_08_14 - S Brennan
% -- changed the argument input to allow variable plot styles
% -- fixed the argument listing in the header comments (wrong order?!)
% -- fixed where reference_unit_tangent_vector was not set correctly
% -- fixed bug where figure number inputs are set wrong
% -- fixed dependencies on plotTraceLL and plotTraceXY
% -- fixed bug where STH unit vectors never plotting

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
    MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS);
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
        narginchk(2,8);
    end
end

% Does user want to specify plotFormat?

% Set defaults
plotFormat.Color = [1 0 1]; % Default is cyan
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
if 3 <= nargin
    input = varargin{1};
    if ~isempty(input)
        plotFormat = input;
    end
end

hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];

% Does user want to specify reference_unit_tangent_vector?
reference_unit_tangent_vector = hard_coded_reference_unit_tangent_vector_LC_south_lane; % Initialize the reference vector
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        reference_unit_tangent_vector = temp;
    else
        reference_unit_tangent_vector = hard_coded_reference_unit_tangent_vector_LC_south_lane; % Initialize the reference vector
    end
end

% Does user want to specify flag_plot_headers_and_tailers?
flag_plot_headers_and_tailers   = 1;
if 5 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        flag_plot_headers_and_tailers = temp;
    end
end

flag_do_plots = 1;

% Does user want to specify LLA_fig_num?
LLA_fig_num = []; % Default
if 6<= nargin
    temp = varargin{4};
    if ~isempty(temp)
        LLA_fig_num = temp;
    end
end

% Does user want to specify ENU_fig_num?
ENU_fig_num = []; % Default is do not plot
if 7<= nargin
    temp = varargin{5};
    if ~isempty(temp)
        ENU_fig_num = temp;
    end
end

% Does user want to specify STH_fig_num?
STH_fig_num = []; % Default is do not plot
if 8<= nargin
    temp = varargin{6};
    if ~isempty(temp)
        STH_fig_num = temp;
    end
end


% If all are empty, default to LLA
if isempty(LLA_fig_num) && isempty(ENU_fig_num) && isempty(STH_fig_num)
    LLA_fig_num = 678532;
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

% steps
% 1. if given trace coordinates are in LLA, convert to ENU and STH
%    if given trace coordinates are in ENU, convert to LLA and STH
%    if given trace coordinates are in STH, convert to ENU and LLA

% initializing empty arrays
LLA_trace = [];
ENU_trace =[];
STH_trace = [];

% if given trace_coordinates are LLA coordinates
if input_coordinates_type == "LLA"

    LLA_trace = Trace_coordinates;

    % get ENU
    ENU_data_with_nan = [];
    [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,Trace_coordinates);

    ENU_trace = ENU_positions_cell_array{1};

    % get STH
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_INTERNAL_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            STH_trace = ST_positions;
        end
    end

elseif input_coordinates_type == "ENU"

    ENU_trace = Trace_coordinates;
    % get LLA
    LLA_data_with_nan = [];
    [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(Trace_coordinates,LLA_data_with_nan);

    LLA_trace = LLA_positions_cell_array;

    % get STH
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_INTERNAL_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            STH_trace = ST_positions;
        end
    end

elseif input_coordinates_type == "STH"

    STH_trace = Trace_coordinates;

    % find ENU coordinates from ST coordiantes
    ENU_trace = fcn_INTERNAL_convertSTtoXY(STH_trace(:,1:2),reference_unit_tangent_vector);

    % find LLA
    ENU_trace_3_cols = [ENU_trace ENU_trace(:,1)*0];
    LLA_data_with_nan = [];
    [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(ENU_trace_3_cols,LLA_data_with_nan);

    LLA_trace = LLA_positions_cell_array{1};

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
% % Plot the inputs?

if flag_do_plots == 1

    % call a function to plot the traces
    fcn_INTERNAL_plotSingleTrace(plotFormat, ...
        LLA_positions_cell_array, ENU_positions_cell_array, ...
        LLA_fig_num, ENU_fig_num, STH_fig_num, reference_unit_tangent_vector, flag_plot_headers_and_tailers);
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function for fcn_PLOTROAD_plotTraces

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

%% fcn_INTERNAL_plotSingleTrace
function fcn_INTERNAL_plotSingleTrace(plotFormat, ...
    LLA_positions_cell_array, ENU_positions_cell_array, ...
    LLA_fig_num, ENU_fig_num, STH_fig_num, reference_unit_tangent_vector, flag_plot_headers_and_tailers)

% LLA plot?
if exist('LLA_fig_num','var') && ~isempty(LLA_fig_num)
    if iscell(LLA_positions_cell_array)
        if ~isempty(LLA_positions_cell_array{1})
            fcn_plotRoad_plotTraceLL(LLA_positions_cell_array, (plotFormat), (flag_plot_headers_and_tailers), (LLA_fig_num));

            title(sprintf('LLA Trace geometry'));
        end
    else
        error('Expecting a cell array for LLA data')
    end
end

% ENU plot?
if exist('ENU_fig_num','var') && ~isempty(ENU_fig_num)
    if iscell(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{1})
            fcn_plotRoad_plotTraceXY(ENU_positions_cell_array, (plotFormat), (flag_plot_headers_and_tailers), (ENU_fig_num));
            title(sprintf('ENU Trace geometry'));
        end
    else
        error('Expecting a cell array for ENU data')
    end
end

% STH plot?

% tell the user that if they do not enter a reference_unit_tangent_vector
% then the default will be used
if exist('STH_fig_num','var') && ~isempty(STH_fig_num) && isempty(reference_unit_tangent_vector)
    warning(['Missing the unit vector for plotting the STH coordinates, ' ...
        'so the default unit_vector is used.' ...
        'The default unit vector is for the ' ...
        'hard_coded_reference_unit_tangent_vector_LC_south_lane ' ...
        '= [0.794630317120972   0.607093616431785];'])
end

if exist('STH_fig_num','var') && ~isempty(STH_fig_num) && exist('reference_unit_tangent_vector','var') && ~isempty(reference_unit_tangent_vector)
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_INTERNAL_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            fcn_plotRoad_plotTraceXY(ST_positions, (plotFormat), (flag_plot_headers_and_tailers), (STH_fig_num));
            title(sprintf('STH Trace geometry'));
            STH_trace = ST_positions;
        end
    end
end

end % Ends fcn_INTERNAL_plotSingleTrace

%% fcn_INTERNAL_prepDataForOutput
function [ENU_positions_cell_array, LLA_positions_cell_array] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,LLA_data_with_nan)
% This function breaks data into sub-arrays if separated by NaN, and as
% well fills in ENU data if this is empty via LLA data, or vice versa

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
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


function ENU_points = fcn_INTERNAL_convertSTtoXY(ST_points,v_unit,varargin)
%% %% fcn_INTERNAL_convertSTtoXY
% Takes ST_points that are [station, transverse] in ENU coordinates and uses them as an
% input to give the  xEast and yNorth points 
%
% FORMAT:
%
%      ENU_points = fcn_INTERNAL_convertSTtoXY(ST_points,v_unit,varargin)
%
% INPUTS:
%
%      ST_points : [station, transverse] ENU coordinates in [Nx2] format
% 
%      v_unit: unit vector in direction of travel 
%
%      (OPTIONAL INPUTS)
%     
%      fig_num: a figure number to plot result
%
% OUTPUTS:
%
%      ENU_points : [xEast, yNorth] X and Y ENU coordinates in [Nx2] format
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_INTERNAL_convertSTtoXY.m for a full
%       test suite.
%
% This function was written on 2023_07_11 by V. Wagh
% Questions or comments? vbw5054@psu.ed


% Revision history:
% 2023_07_11 by V. Wagh
% -- start writing function

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
    MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG); 
        flag_check_inputs  = str2double(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS);
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

if flag_max_speed == 1
    % Are there the right number of inputs?
    narginchk(2,3);

end

% Tell user where we are
if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


flag_do_plots = 0; % Default to not plot
fig_num = []; % Initialize the figure number to be empty
if 3 == nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    else 
        % An empty figure number is given by user, so do not plot anything
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999; 
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (3<= nargin)
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

rotation_matrix = [0 -1; 1 0];
v_orthogonal = (rotation_matrix *v_unit')';

% define the origin : origin of ENU coordinates

% what is the vector to roate the points?
Transform_point = [1  0]; % 90 degree line segment
v_unit2 = fcn_INTERNAL_convertXYtoST(Transform_point,v_unit,fig_num);

station = ST_points(:,1);
transverse = ST_points(:,2);
% get the ENU_points
ENU_points = fcn_INTERNAL_convertXYtoST(ST_points,v_unit2,fig_num);


xEast = ENU_points(:,1);
yNorth = ENU_points(:,2); 

% plot result
if flag_do_plots == 1
    station_vector = station * v_unit;
    transverse_vector = transverse* v_orthogonal;
    new_points_transverse = ENU_points + transverse_vector;
    new_points_station = ENU_points + station_vector;

    figure(fig_num);
    hold on;
    grid on;
    xlabel('xEast [m]');
    ylabel('yNorth [m]');
    axis equal;
    plot(X_recalc, Y_recalc,'y.','MarkerSize',20);
    quiver(0,0,X_recalc,Y_recalc,'Color','k','LineWidth',5);
    quiver(0,0,v_orthogonal(:,1),v_orthogonal(:,2),'Color','k','LineWidth',5);

    % Loop through each point, plotting their results
    for ith_point = 1:length(station)
        quiver(0,0,xEast(ith_point,1),yNorth(ith_point,1),'Color','g','LineWidth',3);
        quiver(0,0,station_vector(ith_point,1),station_vector(ith_point,2),'Color','b');
        quiver(station_vector(ith_point,1),station_vector(ith_point,2),transverse_vector(ith_point,1),transverse_vector(ith_point,2),'Color','r');
    end

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
end % Ends main function

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


function ST_points = fcn_INTERNAL_convertXYtoST(ENU_points,v_unit,varargin)
%% fcn_INTERNAL_convertXYtoST
% Takes xEast and yNorth points in the ENU coordinates and used them as an
% input to give the station ( distance from origin in the direction of
% travel) and transvers (distance from origin in the orthogonal direction) 
%
% FORMAT:
%
%       fcn_INTERNAL_convertXYtoST(ENU_points, v_unit,fig_num)
%
% INPUTS:
%      
%      ENU_points : [xEast, yNorth] X and Y ENU coordinates in [Nx2] format
% 
%      v_unit: unit vector in direction of travel 
%
%      (OPTIONAL INPUTS)
%     
%      fig_num: a figure number to plot result
%
% OUTPUTS:
%
%      ST_points : [station, transverse] ENU coordinates in [Nx2] format
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_INTERNAL_convertXYtoST.m for a full
%       test suite.
%
% This function was written on 2023_07_10 by V. Wagh
% Questions or comments? vbw5054@psu.ed


% Revision history:
% 2023_07_11 by V. Wagh
% -- start writing function

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==12 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG); 
        flag_check_inputs  = str2double(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS);
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

if flag_max_speed == 1
    % Are there the right number of inputs?
    narginchk(2,3);

end

% Tell user where we are
if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


flag_do_plots = 0; % Default to not plot
fig_num = []; % Initialize the figure number to be empty
if 3 == nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    else 
        % An empty figure number is given by user, so do not plot anything
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999; 
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (3<= nargin)
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

rotation_matrix = [0 -1; 1 0];
v_orthogonal = (rotation_matrix *v_unit')';

% define the origin : origin of ENU coordinates
xEast = ENU_points(:,1);
yNorth = ENU_points(:,2);

% if flag_make_new_plot == 1
%     % plot xEast and yNorth
%     figure(fig_num);
%     hold on;
%     grid on;
%     xlabel('xEast [m]')
%     ylabel('yNorth [m]');
%     axis equal
%     plot(xEast,yNorth,'r.','MarkerSize',20);
%     text(xEast,yNorth,'old points', 'Color','r');
% end

ones_vector = ones(length(ENU_points(:,1)),1);  
transverse = sum(ENU_points.*(ones_vector*v_orthogonal),2);
station = sum(ENU_points.*(ones_vector*v_unit),2);

% Push to the output
ST_points = [station, transverse];

% plot results?
if flag_do_plots == 1
    station_vector = station * v_unit;
    transverse_vector = transverse* v_orthogonal;
    new_points_transverse = ENU_points + transverse_vector;
    new_points_station = ENU_points + station_vector;

    figure(fig_num);
    hold on;
    grid on;
    xlabel('xEast [m]');
    ylabel('yNorth [m]');
    axis equal;
    plot(xEast, yNorth,'g.','MarkerSize',20);
    quiver(0,0,v_unit(:,1),v_unit(:,2),'Color','k','LineWidth',5);
    quiver(0,0,v_orthogonal(:,1),v_orthogonal(:,2),'Color','k','LineWidth',5);

    % Loop through each point, plotting their results
    for ith_point = 1:length(station)
        quiver(0,0,xEast(ith_point,1),yNorth(ith_point,1),'Color','g','LineWidth',3);
        quiver(0,0,station_vector(ith_point,1),station_vector(ith_point,2),'Color','b');
        quiver(station_vector(ith_point,1),station_vector(ith_point,2),transverse_vector(ith_point,1),transverse_vector(ith_point,2),'Color','r');
    end
    
    %plot(xEast,yNorth, v_unit(:,1),v_unit(:,2),'color','g','LineWidth',3);
   % plot([0; new_points_station(:,1)],[0;new_points_station(:,2)],'color','b','LineWidth',3);
   % plot(new_points_transverse(:,1),new_points_transverse(:,1),'b.','MarkerSize',20);
    %plot(new_points_station(:,1),new_points_station(:,1),'b.','MarkerSize',20);

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
end % Ends main function

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