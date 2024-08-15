function h_plot = fcn_plotRoad_plotTraceXY(XYdata, varargin)
%fcn_plotRoad_plotTraceXY     plots EN components of ENU data as a trace
%
% FORMAT:
%
%      h_plot = fcn_plotRoad_plotTraceXY(XYdata, (plotFormat), (flag_plot_headers_and_tailers), (fig_num))
%
% INPUTS:  
%
%      XYdata: an [Nx2+] vector data to plot where N is the number of
%      points, and there are 2 or more columns. Each row of data correspond
%      to the [X Y] coordinate of the point to plot in the 1st and 2nd
%      column.
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
%      flag_plot_headers_and_tailers: set to 1 to plot a green bar at the
%      "head" of the plot, red bar at the "tail of the plot. For plots with
%      4 points or less, the head and tail is created via vector
%      projections. For plots with more than 4, the segments at start and
%      end define the head and tail (default is 1)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      h_plot: the handle to the plotting result
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotRoad_plotTraceXY
% 
%       for a full test suite.
%
% This function was written on 2023_08_14 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_08_14 - S. Brennan
% -- first write of the code

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
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(1,4);

    end
end


% Check to see if user specifies plotFormat?
% Set defaults
plotFormat.Color = [1 0 1]; % Default is cyan
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 2;
if 2 <= nargin
    input = varargin{1};
    if ~isempty(input)
        plotFormat = input;
    end
end

% Does user want to specify flag_plot_headers_and_tailers?
flag_plot_headers_and_tailers = 1;
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        flag_plot_headers_and_tailers = temp;
    end
end


% Does user want to specify fig_num?
flag_do_plots = 1;
flag_make_new_plot = 1; % Default to make a new plot, which will clear the plot and start a new plot
fig_num = []; % Initialize the figure number to be empty
if 4 <= nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;

    else % An empty figure number is given by user, so we have to make one
        temp = figure;
        fig_num = temp.Number;
        flag_make_new_plot = 1;
    end
end


% Is the figure number still empty? If so, then we need to open a new
% figure
if flag_make_new_plot && isempty(fig_num)
    temp = figure;
    fig_num = temp.Number;
    flag_make_new_plot = 1;
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

% Initialize the output
h_plot = 0;

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
    % check whether the figure already has data
    temp_h = figure(fig_num);
    flag_rescale_axis = 0;
    if isempty(get(temp_h,'Children'))
        flag_rescale_axis = 1;
    end      


    % Set background to near-black?
    h_axis = gca;
    if isempty(h_axis.Children)
        set(gca,'Color',[1 1 1]*0.4);
        grid on;
        set(gca,'GridColor', [1 1 1]*0.85);
    end

    axis equal
    hold on;

    % Plot ENU results as cell? or as an array?
    if iscell(XYdata)
        h_plot = nan(length(XYdata),1);
        for ith_data = 1:length(XYdata)
            XYdata_to_plot = XYdata{ith_data};
            h_plot(ith_data) = fcn_INTERNAL_plotData(XYdata_to_plot, plotFormat, flag_plot_headers_and_tailers, fig_num);
        end
    else
        h_plot = fcn_INTERNAL_plotData(XYdata, plotFormat, flag_plot_headers_and_tailers, fig_num);
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

%% fcn_INTERNAL_plotData
function h_plot = fcn_INTERNAL_plotData(XYdata_to_plot, plotFormat, flag_plot_headers_and_tailers, fig_num)

if ~isempty(XYdata_to_plot)
    h_plot = fcn_plotRoad_plotXY(XYdata_to_plot, (plotFormat), (fig_num));

    % Plot headers and tailers?
    if flag_plot_headers_and_tailers
        fcn_plotRoad_plotHeadTailXY(XYdata_to_plot, fig_num, plotFormat);
    end
end
end % Ends fcn_INTERNAL_plotData
