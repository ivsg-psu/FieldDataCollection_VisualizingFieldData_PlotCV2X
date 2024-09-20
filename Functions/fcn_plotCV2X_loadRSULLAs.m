function [LLAsOfRSUs, numericRSUids] = fcn_plotCV2X_loadRSULLAs(RSUid, varargin)
%fcn_plotCV2X_loadRSULLAs   given a RSU ID, loads its LLA coordinates
% 
% FORMAT:
%
%      [LLAsOfRSUs, numericRSUids] = fcn_plotCV2X_loadRSULLAs(RSUid, (plotFormat), (fig_num))
%
% INPUTS:
%
%      RSUid: the ID number of the RSU, or a string that specifies the RSU
%      site. Allowable strings include:
%
%          'TestTrack': the RSUs at the PSU test track.
%
%          'Site1': the RSUs at the ADS site 1 area along I-376, Pittsburgh
%
%          'Site2': the RSUs at the ADS site 2 area near Falling Water
%
%          'Site3': the RSUs at the ADS site 3 area, for line-painting
%
%      (OPTIONAL INPUTS)
%
%      plotFormat: one of the following:
%      
%          * a format string, e.g. 'b-', that dictates the plot style.
%          a colormap is created using this color value as 100%, with only
%          one color output, and one plot at the radius specified.
%          * a [1x3] color vector specifying the [R G B] ratios from 0 to 1
%          * a structure whose subfields for the plot properties to change, for example:
%            plotFormat.LineWideth = 3;
%            plotFormat.MarkerSize = 10;
%            plotFormat.Color = [1 0.5 0.5];
%            A full list of properties can be found by examining the plot
%            handle, for example: h_geoplot = plot(1:10); get(h_geoplot)
%          If a color is specified, a colormap is created with the
%          specified [1x3] color vector - this supercedes any colormap.  If
%          no color or colormap is specified, then the default current
%          colormap color is used. If no color is specified, but a colormap
%          is given, the colormap is used.
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      LLAsOfRSUs: a [Rx3] matrix of [Latitude Longitude Altitude] for each
%      of the RSU sites.
%
%      numericRSUids: a [Rx1] matrix of integers listing the RSU numbers
%      for the given RSUid input.
%     
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotCV2X_loadRSULLAs
%
%       for a full test suite.
%
% This function was written on 2024_07_10 by A. Kim
% Questions or comments? sbrennan@psu.edu % Abel's email

% 2024_08_25 - S. Brennan
% -- first write of the code

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
        narginchk(1,3);
    end
end

% Does user want to specify plotFormat?
plotFormat = [];
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        plotFormat = temp;
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) &&  (3<=nargin)
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

if ~isnumeric(RSUid)
    switch RSUid
        case 'TestTrack' % PSU test track, Pendulum
            N_RSUs = 3;
            LLAsOfRSUs = zeros(N_RSUs,3);
            numericRSUids = zeros(N_RSUs,1);
            for ith_RSU = 1:3
                LLAsOfRSUs(ith_RSU,:) = fcn_plotCV2X_loadRSULLAs(ith_RSU, [],-1);
                numericRSUids(ith_RSU) = ith_RSU;
            end

        case 'Site1' % ADS Site 1, Pittsburgh
            N_RSUs = 6;
            LLAsOfRSUs = zeros(N_RSUs,3);
            numericRSUids = zeros(N_RSUs,1);
            siteOffset = 200;
            for ith_RSU = 1:N_RSUs
                LLAsOfRSUs(ith_RSU,:) = fcn_plotCV2X_loadRSULLAs(siteOffset + ith_RSU, [],-1);
                numericRSUids(ith_RSU) = siteOffset + ith_RSU;
            end

            
        case 'Site2' % ADS Site 2, Falling Water
            N_RSUs = 4;
            LLAsOfRSUs = zeros(N_RSUs,3);
            numericRSUids = zeros(N_RSUs,1);
            siteOffset = 300;
            for ith_RSU = 1:N_RSUs
                LLAsOfRSUs(ith_RSU,:) = fcn_plotCV2X_loadRSULLAs(siteOffset + ith_RSU, [],-1);
                numericRSUids(ith_RSU) = siteOffset + ith_RSU;
            end


        otherwise
            warning('on','backtrace');
            warning('An unkown RSUid is detected - throwing an error.')
            error('Unknown RSUid input detected')
    end

else
    numericRSUids = RSUid;
    switch RSUid
        case 1 % PSU test track, Pendulum
            LLAsOfRSUs = [40.86488, -77.83035, 0];
        case 2 % PSU test track, pole by bridge
            LLAsOfRSUs = [40.863873, -77.837215, 0];
        case 3 % PSU test track, pole by handling area
            LLAsOfRSUs = [40.863145, -77.83499, 0];
        case 201
            % Pittsburgh site 1
            LLAsOfRSUs = [40.43072, -79.87313, 0];
        case 202
            % Pittsburgh site 1
            LLAsOfRSUs = [40.43567, -79.86666, 0];
        case 203
            % Pittsburgh site 1
            LLAsOfRSUs = [40.44158, -79.85775, 0];
        case 204
            % Pittsburgh site 1
            LLAsOfRSUs = [40.44499, -79.85104, 0];
        case 205
            % Pittsburgh site 1
            LLAsOfRSUs = [40.44526, -79.84611, 0];
        case 206
            % Pittsburgh site 1
            LLAsOfRSUs = [40.44144, -79.83609, 0];
        case 301
            % Pittsburgh site 2, top of the hill mounted to speed limit sign,
            % adjacent to the lighted sign which is first work-zone ahead.
            LLAsOfRSUs = [39.995339, -79.445472, 0];
        case 302
            % Pittsburgh site 2, middle of first hill
            LLAsOfRSUs = [39.99561, -79.43974, 0];
        case 303
            % Pittsburgh site 2, near bridge
            LLAsOfRSUs = [39.994869, -79.432986, 0];
        case 304
            % Pittsburgh site 2, middle of 2nd hill
            LLAsOfRSUs = [39.990297, -79.424686, 0];
        otherwise
            warning('on','backtrace');
            warning('An unkown RSUid is detected - throwing an error.')
            error('Unknown RSUid input detected')
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
    for ith_RSU = 1:length(LLAsOfRSUs(:,1))
        % Center plot on circle center
        fcn_plotRoad_plotLL((LLAsOfRSUs(ith_RSU,1:2)), (plotFormat), (fig_num));
        set(gca,'MapCenter',LLAsOfRSUs(ith_RSU,1:2));
    end
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end