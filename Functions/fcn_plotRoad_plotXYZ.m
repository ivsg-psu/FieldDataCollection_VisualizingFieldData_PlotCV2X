function h_plot = fcn_plotRoad_plotXYZ(XYZdata, varargin)
%fcn_plotRoad_plotXYZ    plots XYZ data with user-defined formatting strings
% 
% FORMAT:
%
%      h_plot = fcn_plotRoad_plotXYZ(XYZdata, (plotFormat), (fig_num))
%
% INPUTS:  
%
%      h_plot = XYZdata: an [Nx3+] vector data to plot where N is the
%      number of points, and there are 3 or more columns. Each row of data
%      correspond to the [X Y Z] coordinate of the point to plot in the
%      1st, 2nd, and 3rd column.
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
%       script_test_fcn_plotRoad_plotXYZ.m 
%  
%       for a full test suite.
%
% This function was written on 2024_08_05 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_08_05 - Sean Brennan
% -- Created function by copying out of load script in Geometry library
% 2024_08_09 - Jiabao Zhao
% -- Added format string as a optional input
% 2024_08_12 - Sean Brennan
% -- Added structure rather than string type for plotFormat, especially as
% this structure is already auto-generated in MATLAB

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
        narginchk(1,3);

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

% 
% % Does user want to specify station_tolerance?
% test_date_string = '2024_06_28'; % The date of testing. This defines the folder where the data should be found within LargeData main folder
% if (1<=nargin)
%     temp = varargin{1};
%     if ~isempty(temp)
%         test_date_string = temp;
%     end
% end
% 
% % Does user want to specify station_tolerance?
% vehicle_pose_string = 'VehiclePose_ENU.mat'; % The name of the file containing VehiclePose
% if (2<=nargin)
%     temp = varargin{2};
%     if ~isempty(temp)
%         vehicle_pose_string = temp;
%     end
% end
% 
% % Does user want to specify station_tolerance?
% LIDAR_file_string   = 'Velodyne_LiDAR_Scan_ENU.mat'; % The name of the file containing the LIDAR data
% if (3<=nargin)
%     temp = varargin{3};
%     if ~isempty(temp)
%         LIDAR_file_string = temp;
%     end
% end
% 
% % Does user want to specify flag_load_all_data?
% flag_load_all_data = 0; % FORCE LOAD? Set this manually to 1 to FORCE load
% if (4<=nargin)
%     temp = varargin{4};
%     if ~isempty(temp)
%         flag_load_all_data = temp;
%     end
% end

% Set plotting defaults
plotFormat = 'k';
formatting_type = 1;  % Plot type in an integer to save the type of formatting. The numbers refer to 1: a string is given or 2: a color is given, or 3: a structure is given

% Check to see if user specifies plotFormat?
if 2 <= nargin
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
flag_do_plots = 0;
if (0==flag_max_speed) &&  (2<=nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
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


% Initialize the output
h_plot = 0;

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
    temp_h = figure(fig_num);
    flag_rescale_axis = 0;
    if isempty(get(temp_h,'Children'))
        flag_rescale_axis = 1;
    end        

    hold on;
    grid on;
    axis equal

    title('XY plot');
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');

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
    h_plot = plot3(XYZdata(:,1),XYZdata(:,2),XYZdata(:,3));
    list_fieldNames = fieldnames(finalPlotFormat);
    for ith_field = 1:length(list_fieldNames)
        thisField = list_fieldNames{ith_field};
        h_plot.(thisField) = finalPlotFormat.(thisField);
    end

    view(3);


    % Make axis slightly larger?
    if flag_rescale_axis
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_x = temp(2)-temp(1);
        axis_range_y = temp(4)-temp(3);
        axis_range_z = temp(6)-temp(5);
        percent_larger = 0.3;
        axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y,  temp(5)-percent_larger*axis_range_z, temp(6)+percent_larger*axis_range_z]);
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



