function h_geoplot = fcn_plotRoad_plotLL(varargin)
%fcn_plotRoad_plotLL   geoplots Latitude and Longitude data with user-defined formatting strings
%
% FORMAT:
%
%       h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num))
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      LLdata: an [Nx2+] vector data to plot where N is the number of
%      points, and there are 2 or more columns. Each row of data correspond
%      to the [Latitude Longitude] coordinate of the point to plot in the
%      1st and 2nd column.
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
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      h_geoplot: the handle to the geoplot result
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotRoad_plotLL.m 
%
%       for a full test suite.
%
% This function was written on 2024_08_13 by S. Brennan
% Questions or comments? snb10@psu.edu

% Revision history:
% 2024_08_13 by S. Brennan
% -- Created function by copying out of load script in Geometry library and
% merging with similar code in PlotTestTrack library


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

if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(0,3);


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
else
    fig_num = [];
end

% Check for empty inputs - this just initializes the plot
% Default is to NOT make a new plot, which will clear the plot and start a new plot
flag_make_new_plot = 0; 
if 0 == nargin || 1==flag_max_speed
    flag_make_new_plot = 1;
end

% Check the data input
flag_plot_data = 0; % Default is not to plot the data
if 1 <= nargin
    temp = varargin{1};

    % Check to see if data is being plotting. If it is not, then we
    % need to replot the figure
    if ~isempty(temp)
        dataToPlot = temp;
        flag_plot_data = 1;
    else
        % No data is given - must be a new plot
        flag_make_new_plot = 1;
    end
end


% Set plotting defaults
plotFormat = 'k';
formatting_type = 1;  % Plot type in an integer to save the type of formatting. The numbers refer to 1: a string is given or 2: a color is given, or 3: a structure is given

% Check to see if user specifies plotFormat?
if 2 <= nargin
    input = varargin{2};
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


% Default is to make a plot - this starts the plotting process
flag_do_plots = 1;
fig_num = []; % Initialize the figure number to be empty
if (0==flag_max_speed) && (3<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
    else % An empty figure number is given by user, so we have to open a new one
        % create new figure with next default index
        fig_num = figure;
        flag_make_new_plot = 1;
    end
end

% Is the figure number still empty? If so, then we need to open a new
% figure
if flag_make_new_plot && isempty(fig_num)
    % create new figure with next default index
    fig_num = figure;
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
h_geoplot = 0;

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
    figure(fig_num);
    temp_fig_handle = gcf;
    if isempty(temp_fig_handle.Children)
        flag_make_new_plot = 1;
    end

    % Check to see if we are forcing image alignment via Lat and Lon shifting,
    % when doing geoplot. This is added because the geoplot images are very, very
    % slightly off at the test track, which is confusing when plotting data
    % above them.
    offset_Lat = 0; % Default offset
    offset_Lon = 0; % Default offset
    MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT = getenv("MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT");
    MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON = getenv("MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON");
    if ~isempty(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT) && ~isempty(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON)
        offset_Lat = str2double(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT);
        offset_Lon  = str2double(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON);
    end

    if flag_make_new_plot
        %clf;
        % set up new plot, clear the figure, and initialize the


        % Plot the base station with a green star. This sets up the figure for
        % the first time, including the zoom into the test track area.

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


        h_geoplot = geoplot(reference_latitude+offset_Lat, reference_longitude+offset_Lon, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
        h_parent =  get(h_geoplot,'Parent');
        set(h_parent,'ZoomLevel',16.375);
        try
            geobasemap satellite

        catch
            warning('Unable to load satellite view. Defaulting to OpenStreetMap view.')
            geobasemap openstreetmap
        end
        geotickformat -dd
        hold on
    end

    if flag_plot_data
        % make plots
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

        % Do plot
        h_plot = geoplot(dataToPlot(:,1)+offset_Lat,dataToPlot(:,2)+offset_Lon);

        % Fix attributes
        list_fieldNames = fieldnames(finalPlotFormat);
        for ith_field = 1:length(list_fieldNames)
            thisField = list_fieldNames{ith_field};
            h_plot.(thisField) = finalPlotFormat.(thisField);
        end
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

