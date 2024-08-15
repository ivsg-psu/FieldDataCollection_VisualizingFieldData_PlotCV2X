function plotFormat = fcn_plotRoad_extractFormatFromString(formatString, varargin)
%fcn_plotRoad_extractFormatFromString    plots XY data with user-defined formatting strings
%
% FORMAT:
%
%      plotFormat = fcn_plotRoad_extractFormatFromString(formatString, (fig_num))
%
% INPUTS:
%
%      formatString: a format string, e.g. 'b-', that dictates the plot
%      style, following MATLAB's convention
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      plotFormat: a structure containing the Color, LineStyle, and
%      MarkerType that matches the formatString specifications
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotRoad_extractFormatFromString
%
%       for a full test suite.
%
% This function was written on 2024_08_12 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_08_12 - Sean Brennan
% -- Created function

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
        narginchk(1,2);

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

% % Set plotting defaults
% plotFormat = 'k';
% formatting_type = 1;  % Plot type in an integer to save the type of formatting. The numbers refer to 1: a string is given or 2: a color is given, or 3: a structure is given
%
% % Check to see if user specifies plotFormat?
% if 2 <= nargin
%     input = varargin{1};
%     if ~isempty(input)
%         plotFormat = input;
%         if ischar(plotFormat) && length(plotFormat)==3
%             formatting_type = 1;
%         elseif isnumeric(plotFormat)  % Numbers are a color style
%             formatting_type = 2;
%         elseif isstruct(plotFormat)  % Structures give properties
%             formatting_type = 3;
%         else
%             warning('on','backtrace');
%             warning('An unkown input format is detected - throwing an error.')
%             error('Unknown plotFormat input detected')
%         end
%     end
% end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) &&  (2<=nargin)
    temp = varargin{end};
    if ~isempty(temp)
        % fig_num = temp;
        flag_do_plots = 1;
    end
end


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


% Initialize the outputs
formatColor = [];
formatMarkerStyle = [];
formatLineStyle = [];
plotFormat = [];

formatStringRemainder = formatString;

% Get the lineStyle
lineTypes = {'--','-.','-',':'};
for ith_lineType = 1:length(lineTypes)
    thisType = lineTypes{ith_lineType};
    [outputString, flag_matchFound] = fcn_INTERNAL_findResults(formatStringRemainder,thisType);
    if 1==flag_matchFound
        formatStringRemainder = outputString;
        plotFormat.LineStyle = thisType;
        formatLineStyle = thisType;
    end
end


% Get the color
colorTypes = {'b','g','r','c','m','y','k','w'};
for ith_lineType = 1:length(colorTypes)
    thisType = colorTypes{ith_lineType};
    [outputString, flag_matchFound] = fcn_INTERNAL_findResults(formatStringRemainder,thisType);
    if 1==flag_matchFound
        formatStringRemainder = outputString;
        switch thisType
            case 'b'
                plotFormat.Color = [0 0 1];
            case 'g'
                plotFormat.Color = [0 1 0];
            case 'r'
                plotFormat.Color = [1 0 0];
            case 'c'
                plotFormat.Color = [0 1 1];
            case 'm'
                plotFormat.Color = [1 0 1];
            case 'y'
                plotFormat.Color = [1 1 0];
            case 'k'
                plotFormat.Color = [0 0 0];
            case 'w'
                plotFormat.Color = [1 1 1];
            otherwise
                warning('on','backtrace');
                warning('An unkown input format is detected - throwing an error.')
                error('Unknown plotFormat input detected')
        end
        formatColor = plotFormat.Color;
    end
end

% Get the markerType
markerTypes = {'.','o.','x','+','*','s','d','v','^','<','>','p','h'};
for ith_lineType = 1:length(markerTypes)
    thisType = markerTypes{ith_lineType};
    [outputString, flag_matchFound] = fcn_INTERNAL_findResults(formatStringRemainder,thisType);
    if 1==flag_matchFound
        formatStringRemainder = outputString;
        plotFormat.Marker = thisType;
        formatMarkerStyle = thisType;
    end
end

if ~isempty(outputString)
    warning('on','backtrace');
    warning('Additional formatting characters detected - throwing an error.')
    error('Unknown formatting input detected')
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

    fprintf(1,'\n\nRESULTS:\n');
    fprintf(1,'\tInput string: \t%s\n', formatString);
    if ~isempty(formatColor)
        fprintf(1,'\tColor: \t%.0f %.0f %.0f\n', formatColor(1),  formatColor(2), formatColor(3));
    end
    if ~isempty(formatMarkerStyle)
        fprintf(1,'\tMarker: \t%s\n', formatMarkerStyle);
    end
    if ~isempty(formatLineStyle)
        fprintf(1,'\tLineStyle: \t%s\n', formatLineStyle);
    end

    % temp_h = figure(fig_num);
    % flag_rescale_axis = 0;
    % if isempty(get(temp_h,'Children'))
    %     flag_rescale_axis = 1;
    % end
    %
    % hold on;
    % grid on;
    % axis equal
    %
    % title('XY plot');
    % xlabel('X [m]');
    % ylabel('Y [m]');
    %
    % % make plots
    % if formatting_type==1
    %     h_plot = plot(formatString(:,1),formatString(:,2),plotFormat);
    % elseif formatting_type==2
    %     h_plot = plot(formatString(:,1),formatString(:,2),'Color',plotFormat);
    % elseif formatting_type==3
    %     h_plot = plot(formatString(:,1),formatString(:,2));
    %     list_fieldNames = fieldnames(plotFormat);
    %     for ith_field = 1:length(list_fieldNames)
    %         thisField = list_fieldNames{ith_field};
    %         h_plot.(thisField) = plotFormat.(thisField);
    %     end
    %
    % else
    %     warning('on','backtrace');
    %     warning('An unkown input format is detected in the main code - throwing an error.')
    %     error('Unknown plot type')
    % end
    %
    % % Make axis slightly larger?
    % if flag_rescale_axis
    %     temp = axis;
    %     %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
    %     axis_range_x = temp(2)-temp(1);
    %     axis_range_y = temp(4)-temp(3);
    %     percent_larger = 0.3;
    %     axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    % end


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

function [outputString, flag_matchFound] = fcn_INTERNAL_findResults(str,expression)
flag_matchFound = 0;
outputString = [];
[matchResult, remainderCells] = regexp(str,expression,'match','split','forcecelloutput');
if ~isempty(matchResult{1})
    flag_matchFound = 1;
    outputString = '';
    remainderThisCell = remainderCells{1};
    for ith_cell = 1:length(remainderThisCell)

        outputString = cat(2,outputString, remainderThisCell{ith_cell});
    end
end

end

