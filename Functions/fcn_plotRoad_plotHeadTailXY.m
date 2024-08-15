function fcn_plotRoad_plotHeadTailXY(XYdata, fig_num, varargin)
%fcn_plotRoad_plotHeadTailXY    plots XY data with user-defined formatting strings
% 
% FORMAT:
%
%      fcn_plotRoad_plotHeadTailXY(XYdata, fig_num, (plotFormat))
%
% INPUTS:  
%
%      XYdata: an [Nx2+] vector data to plot where N is the number of
%      points, and there are 2 or more columns. Each row of data
%      corresponds to the [X Y] coordinate of the point to plot in the 1st
%      and 2nd column.
%      
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
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
% OUTPUTS:
%
%      none
%
% DEPENDENCIES:
%
%      none
%
% EXAMPLES:
%
%       See the script:
% 
%       script_test_fcn_plotRoad_plotHeadTailXY 
%  
%       for a full test suite.
%
% This function was written on 2024_08_14 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_08_14 - Sean Brennan
% -- Created function by copying out of plotTrace

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

if 0==flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(2,3);

        % % Check the points input to be length greater than or equal to 2
        % fcn_DebugTools_checkInputsToFunctions(...
        %     points, '2column_of_numbers',[2 3]);
        %
        % % Check the transverse_tolerance input is a positive single number
        % fcn_DebugTools_checkInputsToFunctions(transverse_tolerance, 'positive_1column_of_numbers',1);
        %
        % % Check the station_tolerance input is a positive single number
        % if ~isempty(station_tolerance)
        %     fcn_DebugTools_checkInputsToFunctions(station_tolerance, 'positive_1column_of_numbers',1);
        % end
    end
end

% Set default plotFormat
formatting_type = 3;
plotFormat.Color = [1 0 1]; % Default is cyan
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;

% Check to see if user specifies plotFormat?
if 3 <= nargin
    input = varargin{1};
    if ~isempty(input)
        plotFormat = input;
        if ischar(plotFormat) && length(plotFormat)<=4
            formatting_type = 1;
        elseif isnumeric(plotFormat)  % Numbers are a color style
            formatting_type = 2;
        elseif isstruct(plotFormat)  % Structures give properties
            formatting_type = 3;
        else
            warning('on','backtrace');
            warning('An unkown input format is detected - throwing an error.')
            error('Unknown plotFormat input detected')
        end
    end
end

% Does user want to specify fig_num?
flag_do_plots = 1;

% if (0==flag_max_speed) &&  (2<=nargin)
%     temp = varargin{end};
%     if ~isempty(temp)
%         fig_num = temp;
%         flag_do_plots = 1;
%     end
% end


%% Solve for the Maxs and Mins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert user inputs into formats
if formatting_type==1
    finalPlotFormat = fcn_plotRoad_extractFormatFromString(plotFormat, (-1));
elseif formatting_type==2
    finalPlotFormat.Color = plotFormat;
elseif formatting_type==3
    finalPlotFormat = plotFormat;
else
    warning('on','backtrace');
    warning('An unkown input format is detected in the main code - throwing an error.')
    error('Unknown plot type')
end

%% Plot the results (for debugging)?
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
if flag_do_plots
    % Plot green point
    tempPlotFormat = finalPlotFormat;
    tempPlotFormat.Color = [0 1 0]; % Green
    tempPlotFormat.Marker = 'o';
    tempPlotFormat.LineStyle = 'none';
    fcn_plotRoad_plotXY(XYdata(1,:), (tempPlotFormat), (fig_num));

    % Plot red point
    tempPlotFormat = finalPlotFormat;
    tempPlotFormat.Color = [1 0 0]; % Red
    tempPlotFormat.Marker = 'x';
    tempPlotFormat.LineStyle = 'none';
    fcn_plotRoad_plotXY(XYdata(end,:), (tempPlotFormat), (fig_num));

    if length(XYdata(:,1))>4

        % Plot green headers
        tempPlotFormat = finalPlotFormat;
        tempPlotFormat.Color = [0 1 0]; % Green
        tempPlotFormat.Marker = 'none';
        tempPlotFormat.LineStyle = '-';
        fcn_plotRoad_plotXY(XYdata(1:2,:), (tempPlotFormat), (fig_num));


        % Plot red tailers
        tempPlotFormat = finalPlotFormat;
        tempPlotFormat.Color = [1 0 0]; % Red
        tempPlotFormat.Marker = 'none';
        tempPlotFormat.LineStyle = '-';
        fcn_plotRoad_plotXY(XYdata(end-1:end,:), (tempPlotFormat), (fig_num));

    else

        % Plot green headers - calculated from vector direction
        vector_direction_start = XYdata(2,1:2) - XYdata(1,1:2);
        start_length = sum(vector_direction_start.^2,2).^0.5;
        unit_vector_direction_start = vector_direction_start./start_length;
        max_length = min(10,start_length*0.2);
        offset_start = XYdata(1,1:2) + max_length*unit_vector_direction_start;
        ENU_vector = [XYdata(1,1:2); offset_start];

        % Plot green headers
        tempPlotFormat = finalPlotFormat;
        tempPlotFormat.Color = [0 1 0]; % Green
        tempPlotFormat.Marker = 'none';
        tempPlotFormat.LineStyle = '-';
        fcn_plotRoad_plotXY(ENU_vector, (tempPlotFormat), (fig_num));

        % Plot red tailers - calculated from vector direction
        vector_direction_end = (XYdata(end,1:2) - XYdata(end-1,1:2));
        end_length = sum(vector_direction_end.^2,2).^0.5;
        unit_vector_direction_end = vector_direction_end./end_length;
        max_length = min(10,end_length*0.2);
        offset_end = XYdata(end,1:2) - max_length*unit_vector_direction_end;
        ENU_vector = [offset_end; XYdata(end,1:2)];

        % Plot red tailers
        tempPlotFormat = finalPlotFormat;
        tempPlotFormat.Color = [1 0 0]; % Red
        tempPlotFormat.Marker = 'none';
        tempPlotFormat.LineStyle = '-';
        fcn_plotRoad_plotXY(ENU_vector, (tempPlotFormat), (fig_num));
    end

    
end % Ends check if plotting

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



