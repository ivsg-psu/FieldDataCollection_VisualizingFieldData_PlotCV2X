function [LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
    csv_filenames, varargin)
%% fcn_PlotTestTrack_plotBSMfromOBUtoRSU
% Creates a plot of entered traces in either LLA, ENU, or STH-linear
% formats.
%
% FORMAT:
%
%       [LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
%       csv_filenames, (flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color,fig_num))
% INPUTS:
%
%      csv_filenames: The name of the .csv file that contains the latitude,
%                    longitude and optionally the altitude of the location
%                    at which the OBU sent out the BSM message to the RSU
%                    that was in range
%
%      (OPTIONAL INPUTS)
%
%       flag_plot_spokes: true of false for plotting the Spokes (towers on
%       the test track that will hold one RSU, one Wave-Long Range and
%       one computer box along with the Camera and LIDAR sensor.
%       Values of 1 or 0 for true and false respectively.
%       Default is 1.
%
%       flag_plot_hubs: true of false for plotting the Gateways (towers on
%       the test track that will hold one RSU, 4 Wave Micros and
%       one computer box, may or may not have the CAmera and LIDAR sensor.
%       Values of 1 or 0 for true and false respectively.Default is 1.
%
%       flag_plot_LLA: true (1) or false (0) to plot in LLA. Default is 1.
%
%       flag_plot_ENU: true (1) or false (0) to plot in ENU. Default is 1
%
%       flag_plot_STH: true (1) or false (0) to plot in STH. Default is 1.
%
%       plot_color: a color specifier such as [1 0 0] or 'r' indicating
%       what color the traces should be plotted
%
%       fig_num: figure numer for the plot, in case of ENU or STH being
%       plotted in addition to the LLA plot, the figue number will just be
%       LLA figure number +1 or LLA figure number + 2. Default figure
%       number is 100.
%
% OUTPUTS:
%
%       LLA_BSM_coordinates: Array of LLA coordinates of BSM locations
%
%       ENU_BSM_coordinates: Array of ENU coordinates of BSM locations
%
%       STH_BSM_coordinates: Array of STH coordinates of BSM locations
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotBSMfromOBUtoRSU.m for a full
%       test suite.
%
% This function was written on 2024_05_29 by V. Wagh
% Questions or comments? vbw5054@psu.edu

% Revision history:
% 2024_03_23 by V. Wagh
% -- start writing function from fcn_PlotTestTrack_plot

% To Do:
% 2024_06_12
% -- Functionalize the code. Use geoPlotData to plot initial location 
% ---- Need to change THAT function to allow user-defined ref location
% ---- Pass in the hub/spoke locations (these change at each site)
% ---- All plotting commands should be in Debug area. 
% ---- Main is only used for calculations and conversions of data

% 2024_05_31
% have a boundry to the regions
% plot the towers, make it the same color but different shade as the BSM points(dark green
% and light green)
%
% if we are getting continuous data (10Hz), then from the tower, the slice
% from point 1 i.e tower to point 2 i.e OBU location is covered. So the
% whole slice has coverage
% so if we create a toll that checks if data is continuous, then we can
% define boundary edges to be placed for the wedge.
% so a wedge should have atleast 3 points that are continuous
% no wedges for dis-continuous points
%
% plot steps
% 1. find wedges
% 2. plot Wedge
%
% max range plot (for each angle, find the maximum radius that we can
% detect from the data collected in one test)
%
% steps
% 0. assign color to each tower
% 1. plot the towers
% 2. plot data for each tower in same color but diffrent shade (make it the same color but different shade as the BSM points(dark green
% and light green))
% 3. check if data is continuous for each region of tower (will need time
% for checking this)
% 4. plot wedges for continuous data and only dots for discontinuous data
%
% change x and y axis from deg-min to decimals

% start of code

% load('pole_coordinates.mat');
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
        narginchk(1,8);
    end
end

% (flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
%       flag_plot_ENU,flag_plot_STH,plot_color,fig_num))

% does the user want to plot the spokes on the track?
flag_plot_spokes = 1; % default
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        flag_plot_spokes = temp;
    end
end

% does the user want to plot the hubs on the track?
flag_plot_hubs = 1; % default
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        flag_plot_hubs = temp;
    end
end

% does the user want to plot in LLA?
flag_plot_LLA = 1; % default
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        flag_plot_LLA = temp;
    end
end

% does the user want to plot in ENU?
flag_plot_ENU = 1; % default
if 5 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        flag_plot_ENU = temp;
    end
end

% does the user want to plot in STH?
flag_plot_STH = 1; % default
if 6 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        flag_plot_STH = temp;
    end
end

% Does user want to specify plot_color?
plot_color = [0 0 1]; % Default
if 7 <= nargin
    temp = varargin{6};
    if ~isempty(temp)
        plot_color = temp;
    end
end

% Does user want to specify fig_num?
fig_num = 100; % Default
if 8 <= nargin
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
if (0==flag_max_speed) && (8<= nargin)
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

% load all variables needed

% unit vectors for STH
hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];
reference_unit_tangent_vector = hard_coded_reference_unit_tangent_vector_LC_south_lane; % Initialize the reference vector

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

% Read csv file containing LLA coordinates of the OBU when the BSM
% message was sent out to the RSU
BSM_LLA = csvread(csv_filenames, 1); %#ok<*CSVRD>

% LLA is collected as an integer X 10^4, so convert back to standard
% decimal format for LLA
BSMs_LLA_corrected = [BSM_LLA(:,1)/10000000 BSM_LLA(:,2)/10000000 BSM_LLA(:,3)];

% setting up for output of function
LLA_BSM_coordinates = BSMs_LLA_corrected;
ENU_BSM_coordinates =[];
STH_BSM_coordinates = [];

% convert LLA to ENU
ENU_data_with_nan = [];
[ENU_positions_cell_array, ~] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,BSMs_LLA_corrected);

ENU_BSM_coordinates = ENU_positions_cell_array{1};

% convert ENU to STH
for ith_array = 1:length(ENU_positions_cell_array)
    if ~isempty(ENU_positions_cell_array{ith_array})
        ST_positions = fcn_PlotTestTrack_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
        STH_BSM_coordinates = ST_positions;
    end
end

% now that we have all the coordinates in all 3 formats, we can go ahead
% and plot the needed BSM locations


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
% Plot the inputs?
if flag_do_plots

    % if user wants to plot in LLA
if flag_plot_LLA == 1

    % set up new plot, clear the figure, and initialize the coordinates
    figure(fig_num);

    % Plot the base station with a green star. This sets up the figure for
    % the first time, including the zoom into the test track area.
    if flag_plot_spokes == 1
        h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);

        h_parent =  get(h_geoplot,'Parent');
        set(h_parent,'ZoomLevel',16.375);
    end
    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end
    geotickformat -dd;
    hold on;

    % plot the location of the BSM message received
    geoplot(LLA_BSM_coordinates(:,1), LLA_BSM_coordinates(:,2), '.','Color',plot_color,'Markersize',10);
%     geoplot(LLA_BSM_coordinates(1,1), LLA_BSM_coordinates(1,2), 'o','Color',[0 1 0],'Markersize',10,'LineWidth',2);
%     geoplot(LLA_BSM_coordinates(end,1), LLA_BSM_coordinates(end,2), 'x','Color',[1 0 0],'Markersize',10,'LineWidth',2);

    % if the user wants to plot the spokes
    if flag_plot_spokes == 1 % save all the pole locations in a .mat file

        % do nothing, use function rangeRCUcircle to plot RSUs
    end
end

if flag_plot_ENU == 1
    % for now do nothing
end

if flag_plot_STH == 1
    % for now do nothing
end

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
