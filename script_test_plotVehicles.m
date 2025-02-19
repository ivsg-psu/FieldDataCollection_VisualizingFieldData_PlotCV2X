%% Introduction to and Purpose of the plotCV2X codes
% This is a strter script to show the primary functionality of the
% plotRoad library.
%
% This is the explanation of the code that can be found by running
%
%       script_demo_plotCV2X
%
% This is a script to demonstrate the functions within the PlotCV2X code
% library. This code repo is typically located at:
%
%   https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotCV2X
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu



%% Revision History:
% 2023_08_15 - sbrennan@psu.edu and vbw5054@psu.edu
% -- First write of code using PlotROad code as starter
% 2024_09_26 - sbrennan@psu.edu
% -- Updated function fcn_INTERNAL_clearUtilitiesFromPathAndFolders

%% To-Do list
% 2024_08_15 - S. Brennan
% -- Fix gca versus gcf in the plotRoad library, under the LL plot function

%% Prep the workspace
close all
clc

%% Dependencies and Setup of the Code
% The code requires several other libraries to work, namely the following
%
% * DebugTools - used for debugging prints
% * GPS - this is the library that converts from ENU to/from LLA
% List what libraries we need, and where to find the codes for each
clear library_name library_folders library_url

ith_library = 1;
library_name{ith_library}    = 'DebugTools_v2023_04_22';
library_folders{ith_library} = {'Functions','Data'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/Errata_Tutorials_DebugTools/archive/refs/tags/DebugTools_v2023_04_22.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'GeometryClass_v2024_08_28';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary/archive/refs/tags/GeometryClass_v2024_08_28.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'PlotRoad_v2024_08_19';
library_folders{ith_library} = {'Functions', 'Data'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad/archive/refs/tags/PlotRoad_v2024_08_19.zip'; 

ith_library = ith_library+1;
library_name{ith_library}    = 'PathClass_v2024_03_14';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary/archive/refs/tags/PathClass_v2024_03_14.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'GPSClass_v2023_06_29';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass/archive/refs/tags/GPSClass_v2023_06_29.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'LineFitting_v2023_07_24';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FeatureExtraction_Association_LineFitting/archive/refs/tags/LineFitting_v2023_07_24.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'FindCircleRadius_v2023_08_02';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_FindCircleRadius/archive/refs/tags/FindCircleRadius_v2023_08_02.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'BreakDataIntoLaps_v2023_08_25';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps/archive/refs/tags/BreakDataIntoLaps_v2023_08_25.zip';


%% Clear paths and folders, if needed
if 1==0
    clear flag_plotCV2X_Folders_Initialized;
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;

    % Clean up data files
    traces_mat_filename = fullfile(cd,'Data','AllTracesData.mat'); %%%% not loading centerline data
    if exist(traces_mat_filename,'file')
        delete(traces_mat_filename);
    end
    marker_clusters_mat_filename = fullfile(cd,'Data','AllMarkerClusterData.mat'); %%%% not loading centerline data
    if exist(marker_clusters_mat_filename,'file')

        delete(marker_clusters_mat_filename);
    end

end


%% Do we need to set up the work space?
if ~exist('flag_plotCV2X_Folders_Initialized','var')
    this_project_folders = {'Functions','Data'};
    fcn_INTERNAL_initializeUtilities(library_name,library_folders,library_url,this_project_folders);
    flag_plotCV2X_Folders_Initialized = 1;
end

%% Load hard-coded vectors
% These are used to align key data to a local coordinate system wherein
% that data is axis-aligned.

hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];

%% Set environment flags that define the ENU origin
% This sets the "center" of the ENU coordinate system for all plotting
% functions

% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');

% % Location for Pittsburgh, site 1
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.43073');
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.87261');
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');

% % Location for Site 2, Falling water
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','39.995339');
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.445472');
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%% Set environment flags for plotting
% These are values to set if we are forcing image alignment via Lat and Lon
% shifting, when doing geoplot. This is added because the geoplot images
% are very, very slightly off at the test track, which is confusing when
% plotting data above them.
setenv('MATLABFLAG_PLOTCV2X_ALIGNMATLABLLAPLOTTINGIMAGES_LAT','-0.0000008');
setenv('MATLABFLAG_PLOTCV2X_ALIGNMATLABLLAPLOTTINGIMAGES_LON','0.0000054');


%% Set environment flags for input checking
% These are values to set if we want to check inputs or do debugging
% setenv('MATLABFLAG_FINDEDGE_FLAG_CHECK_INPUTS','1');
% setenv('MATLABFLAG_FINDEDGE_FLAG_DO_DEBUG','1');
setenv('MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS','1');
setenv('MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG','0');


%% Core Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                  ______                _   _
%  / ____|                |  ____|              | | (_)
% | |     ___  _ __ ___   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
% | |    / _ \| '__/ _ \  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
% | |___| (_) | | |  __/  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  \_____\___/|_|  \___|  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
%
% See:
% https://patorjk.com/software/taag/#p=display&f=Big&t=Core%20%20Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% fcn_plotCV2X_loadDataFromFile
% loads time+ENU and time+LLA data from file
% [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num))

fig_num = 1;
figure(fig_num);
clf;

csvFile = 'TestTrack_RSU1_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'; % Path to your CSV file

[tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num));
sgtitle({sprintf('Example %.0d: fcn_plotCV2X_loadDataFromFile',fig_num),'Showing TestTrack_RSU1_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'}, 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 4 columns?
assert(length(tLLA(1,:))== 4)
assert(length(tENU(1,:))== 4)

% Does the data have many rows
Nrows_expected = 1688;
assert(length(tLLA(:,1))== Nrows_expected)
assert(length(tENU(:,1))== Nrows_expected)

%% fcn_plotCV2X_loadDataFromFile_OBUID
% loads time+ENU and time+LLA data from file
% [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (fig_num))

fig_num = 111;
figure(fig_num);
clf;

csvFile = '2OBU_FollowEachOther_TestTrack_RSU1_PendulumRSU_2025_02_11.csv'; % Path to your CSV file

[tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile_OBUID(csvFile, (fig_num));
sgtitle({sprintf('Example %.0d: fcn_plotCV2X_loadDataFromFile',fig_num),'Showing 2OBU_FollowEachOther_TestTrack_RSU1_PendulumRSU_2025_02_11.csv'}, 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));



%% fcn_plotCV2X_plotRSURangeCircle  
% given a RSU ID, plots range circles
% 
% FORMAT:
%
%      [h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotCV2X_plotRSURangeCircle(RSUid, (plotFormat), (fig_num))

fig_num = 2;
figure(fig_num);
clf;

% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


RSUsiteString = 'TestTrack';

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 50;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(RSUsiteString, (plotFormat), (-1));
N_RSUs = length(numericRSUids(:,1));


% Initialize variables where we save all data for animations
h_geoplots{N_RSUs} = [];
AllLatDatas{N_RSUs} = [];
AllLonDatas{N_RSUs} = [];

% Test the function
for ith_RSU = 1:N_RSUs
    thisRSUnumber = numericRSUids(ith_RSU);

    color_vector = fcn_geometry_fillColorFromNumberOrName(thisRSUnumber);

    clear plotFormat
    plotFormat.Color = color_vector;
    plotFormat.LineStyle = '-';
    plotFormat.LineWidth = 1;
    plotFormat.Marker = 'none';  % '.';
    plotFormat.MarkerSize = 10;

    [h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotCV2X_plotRSURangeCircle(thisRSUnumber, (plotFormat), (fig_num));

    % Check results
    % Was a figure created?
    assert(all(ishandle(fig_num)));

    % Were plot handles returned?
    assert(all(ishandle(h_geoplot(:))));

    Ncolors = 64;
    Nangles = 91;

    % Are the dimensions of Lat Long data correct?
    assert(Ncolors==length(AllLatData(:,1)));
    assert(Ncolors==length(AllLonData(:,1)));
    assert(Nangles==length(AllLonData(1,:)));
    assert(length(AllLatData(1,:))==length(AllLonData(1,:)));

    % Are the dimension of X Y data correct?
    assert(Ncolors==length(AllXData(:,1)));
    assert(Ncolors==length(AllYData(:,1)));
    assert(length(AllXData(1,:))==length(AllYData(1,:)));
    assert(length(AllXData(1,:))==length(AllLatData(1,:)));

    % Are the dimensions of the ringColors correct?
    assert(isequal(size(ringColors),[Ncolors 3]));

    % Save data for animations
    h_geoplots{ith_RSU} = h_geoplot;
    AllLatDatas{ith_RSU} = AllLatData;
    AllLonDatas{ith_RSU} = AllLonData;

end

% Put BIG dots on top of the RSU "pole" locations
for ith_RSU = 1:N_RSUs

    % Plot the results
    color_vector = fcn_geometry_fillColorFromNumberOrName(ith_RSU);

    clear plotFormat
    plotFormat.Color = color_vector;
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 50;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 5;


    % Plot the RSU locations
    fcn_plotRoad_plotLL((LLAsOfRSUs(ith_RSU,1:2)), (plotFormat), (fig_num));

end

%%%% Do the animation 

% Set viewable area:
set(gca,'MapCenterMode','auto','ZoomLevelMode','auto');

title(sprintf('Example %.0d: fcn_plotCV2X_plotRSURangeCircle',fig_num), 'Interpreter','none');
subtitle('Showing animation of results');

% Set the ring interval
Nrings = length(AllLatData(:,1));
skipInterval = Nrings/4;

% Prep for animation file creation
filename = 'fcn_plotCV2X_rangeRSU_circle.gif';
flagFirstTime = 1;

% Clear the plot by animating it for one ring cycle
for timeIndex = 1:skipInterval+1
    for ith_RSU = 1:N_RSUs
        fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplots{ith_RSU}(1:end-1), AllLatDatas{ith_RSU}, AllLonDatas{ith_RSU}, skipInterval,-1);
        % pause(0.02);
    end
end

% Create the animation file
for timeIndex = 1:skipInterval
    for ith_RSU = 1:N_RSUs
        fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplots{ith_RSU}(1:end-1), AllLatDatas{ith_RSU}, AllLonDatas{ith_RSU}, skipInterval,-1);
    end

    % Create an animated gif?
    if 1==0
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.1);
        end
    end

    pause(0.02);
end


%% fcn_plotCV2X_assessTime
% classifies the time vector of the data for errors
%
% given the tENU data from a CV2X radio, this function assesses whether the
% data contain common errors. The time differences between sequential data
% are analyzed. 
% 
% Common errors include the following:
%
%       * modeJumps - the time suddenly has a different zero intercept
%       * offsets - at each individual time sample, for a given intercept,
%       the data comes in early, on time, or late. This difference creates
%       an offset.
%
% FORMAT:
%
%       [modeIndex, modeJumps, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tENU, (fig_num))

%
fig_num = 3;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_RSU1_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
[modeIndex, modeJumps, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tLLA, tENU, (fig_num));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_assessTime',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right number of columns?
assert(length(modeIndex(1,:))== 1)
assert(length(modeJumps(1,:))== 1)
assert(length(offsetCentisecondsToMode(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(modeIndex(:,1))== Nrows_expected)
assert(length(modeJumps(:,1))== Nrows_expected)
assert(length(offsetCentisecondsToMode(:,1))== Nrows_expected)


% Set plot
subplot(1,2,2);
title('LLA plot');
set(gca,'MapCenter',[40.863982311180450 -77.834147911147213],'ZoomLevel', 15.375);


%% fcn_plotCV2X_calcVelocity
%   calculates velocity given tENU coordinates
%
% this function calculates the apparent velocity of the data given tENU
% coordinate inputs. 
%
% FORMAT:
%
%       velocity = fcn_plotCV2X_calcVelocity(tENU, (fig_num))
%

fig_num = 4;
figure(fig_num);
clf;

% Load the data
dirname = cat(2,'Data',filesep,'TestTrack*');
dirList = dir(dirname);
allVelocities = [];
allLLAs = [];
allENUs = [];
for ith_file = 1:length(dirList)
    csvFile = dirList(ith_file).name;
    % csvFile = 'TestTrack_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'; % Path to your CSV file
    [tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

    % Plot the results
    color_vector = fcn_geometry_fillColorFromNumberOrName(ith_file);

    clear plotFormat
    plotFormat.Color = color_vector;
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 10;
    plotFormat.LineStyle = '-';
    plotFormat.LineWidth = 5;
    h_geoplot = fcn_plotRoad_plotLL(tLLA(:,2:3), (plotFormat), (5555));


    [modeIndex, ~, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tLLA, tENU, (-1));

    % Test the function
    velocity = fcn_plotCV2X_calcVelocity(tLLA, tENU, modeIndex, offsetCentisecondsToMode, fig_num);
    sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcVelocity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);
    allVelocities = [allVelocities; velocity]; %#ok<AGROW>
    allLLAs = [allLLAs; tLLA]; %#ok<AGROW>
    allENUs = [allENUs; tENU]; %#ok<AGROW>
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right number of columns?
assert(length(velocity(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(velocity(:,1))== Nrows_expected)

% Set GPS coordinates of RSU
RSU_LLA = [40.86486, -77.83050];

% Plot the RSU positions
subplot(1,2,2);
title('LLA plot');
% set(gca,'MapCenter',[40.863982311180450 -77.834147911147213],'ZoomLevel', 15.375);
plotFormat = [0 1 0];
fcn_plotRoad_plotLL(RSU_LLA(1,1:2), (plotFormat), (fig_num));

%%% Plot all the data together
fig_num = 111111;
figure(fig_num);
clf;

% Prep the data
goodPlottingIndicies = ~isnan(allVelocities);

rawXYIData = [allENUs(:,2:3) allVelocities];
plotXYData = rawXYIData(goodPlottingIndicies,:);

rawLLIData = [allLLAs(:,2:3) allVelocities];
plotLLData = rawLLIData(goodPlottingIndicies,:);




clear plotFormat
plotFormat.LineStyle = 'none';
plotFormat.LineWidth = 5;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
colorMapMatrixOrString = colormap('turbo');
Ncolors = 16;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrixOrString, Ncolors, -1);


subplot(1,2,1);
fcn_plotRoad_plotXYI(plotXYData, (plotFormat), (reducedColorMap), (fig_num));


subplot(1,2,2);
fcn_plotRoad_plotLLI(plotLLData, (plotFormat), (reducedColorMap), (fig_num));

h_colorbar = colorbar;
h_colorbar.Ticks = linspace(0, 1, Ncolors) ; %Create ticks from zero to 1
% There are 2.23694 mph in 1 m/s
colorbarValues   = round(2.23694 * linspace(min(allVelocities), max(allVelocities), Ncolors));
h_colorbar.TickLabels = num2cell(colorbarValues) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
h_colorbar.Label.String = 'Speed (mph)';

%% fcn_plotCV2X_calcSpeedDisparity  
% calculates the difference in velocity between each point and nearby points
%
% FORMAT:
%
%       speedDisparity = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num))

fig_num = 5;
figure(fig_num);
clf;

% Load the data
csvFile = 'TestTrack_RSU1_PendulumRSU_InstallTest_InnerLane1_2024_08_09.csv'; % Path to your CSV file
[tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 20;
speedDisparity = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (fig_num));
sgtitle({sprintf('Example %.0d: showing fcn_plotCV2X_calcSpeedDisparity',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right number of columns?
assert(length(speedDisparity(1,:))== 1)

% Does the data have right number of rows?
Nrows_expected = length(tLLA(:,1));
assert(length(speedDisparity(:,1))== Nrows_expected)


%% Supporting functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              _   _                 ______                _   _
%  / ____|                            | | (_)               |  ____|              | | (_)
% | (___  _   _ _ __  _ __   ___  _ __| |_ _ _ __   __ _    | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  \___ \| | | | '_ \| '_ \ / _ \| '__| __| | '_ \ / _` |   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  ____) | |_| | |_) | |_) | (_) | |  | |_| | | | | (_| |   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% |_____/ \__,_| .__/| .__/ \___/|_|   \__|_|_| |_|\__, |   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%              | |   | |                            __/ |
%              |_|   |_|                           |___/
% See:
% https://patorjk.com/software/taag/#p=display&f=Big&t=Supporting%20%20%20Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% fcn_plotCV2X_findNearPoints  
% for each point, lists nearby indicies
%
% FORMAT:
%
%       nearbyIndicies = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (fig_num))

fig_num = 11;
figure(fig_num);
clf;

% Load the data
csvFile = '2OBU_FollowEachOther_TestTrack_RSU1_PendulumRSU_2025_02_11.csv'; % Path to your CSV file
[tLLA, tENU, OBUID] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

% Test the function
searchRadiusAndAngles = 50;
nearbyIndicies  = fcn_plotCV2X_findNearPoints(tENU, searchRadiusAndAngles, (fig_num));
title({sprintf('Example %.0d: showing fcn_plotCV2X_findNearPoints',fig_num), sprintf('File: %s',csvFile)}, 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have right size?
Nrows_expected = length(tLLA(:,1));
assert(length(nearbyIndicies(1,:))== Nrows_expected)


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

%% function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
% Clear out the variables
clear global flag* FLAG*
clear flag*
clear path

% Clear out any path directories under Utilities
if ispc
    path_dirs = regexp(path,'[;]','split');
elseif ismac
    path_dirs = regexp(path,'[:]','split');
elseif isunix
    path_dirs = regexp(path,'[;]','split');
else
    error('Unknown operating system. Unable to continue.');
end

utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir})
    end
end

% Delete the Utilities folder, to be extra clean!
if  exist(utilities_dir,'dir')
    [status,message,message_ID] = rmdir(utilities_dir,'s');
    if 0==status
        error('Unable remove directory: %s \nReason message: %s \nand message_ID: %s\n',utilities_dir, message,message_ID);
    end
end

end % Ends fcn_INTERNAL_clearUtilitiesFromPathAndFolders

%% fcn_INTERNAL_initializeUtilities
function  fcn_INTERNAL_initializeUtilities(library_name,library_folders,library_url,this_project_folders)
% Reset all flags for installs to empty
clear global FLAG*

fprintf(1,'Installing utilities necessary for code ...\n');

% Dependencies and Setup of the Code
% This code depends on several other libraries of codes that contain
% commonly used functions. We check to see if these libraries are installed
% into our "Utilities" folder, and if not, we install them and then set a
% flag to not install them again.

% Set up libraries
for ith_library = 1:length(library_name)
    dependency_name = library_name{ith_library};
    dependency_subfolders = library_folders{ith_library};
    dependency_url = library_url{ith_library};

    fprintf(1,'\tAdding library: %s ...',dependency_name);
    fcn_INTERNAL_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url);
    clear dependency_name dependency_subfolders dependency_url
    fprintf(1,'Done.\n');
end

% Set dependencies for this project specifically
fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders);

disp('Done setting up libraries, adding each to MATLAB path, and adding current repo folders to path.');
end % Ends fcn_INTERNAL_initializeUtilities


function fcn_INTERNAL_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url, varargin)
%% FCN_DEBUGTOOLS_INSTALLDEPENDENCIES - MATLAB package installer from URL
%
% FCN_DEBUGTOOLS_INSTALLDEPENDENCIES installs code packages that are
% specified by a URL pointing to a zip file into a default local subfolder,
% "Utilities", under the root folder. It also adds either the package
% subfoder or any specified sub-subfolders to the MATLAB path.
%
% If the Utilities folder does not exist, it is created.
%
% If the specified code package folder and all subfolders already exist,
% the package is not installed. Otherwise, the folders are created as
% needed, and the package is installed.
%
% If one does not wish to put these codes in different directories, the
% function can be easily modified with strings specifying the
% desired install location.
%
% For path creation, if the "DebugTools" package is being installed, the
% code installs the package, then shifts temporarily into the package to
% complete the path definitions for MATLAB. If the DebugTools is not
% already installed, an error is thrown as these tools are needed for the
% path creation.
%
% Finally, the code sets a global flag to indicate that the folders are
% initialized so that, in this session, if the code is called again the
% folders will not be installed. This global flag can be overwritten by an
% optional flag input.
%
% FORMAT:
%
%      fcn_DebugTools_installDependencies(...
%           dependency_name, ...
%           dependency_subfolders, ...
%           dependency_url)
%
% INPUTS:
%
%      dependency_name: the name given to the subfolder in the Utilities
%      directory for the package install
%
%      dependency_subfolders: in addition to the package subfoder, a list
%      of any specified sub-subfolders to the MATLAB path. Leave blank to
%      add only the package subfolder to the path. See the example below.
%
%      dependency_url: the URL pointing to the code package.
%
%      (OPTIONAL INPUTS)
%      flag_force_creation: if any value other than zero, forces the
%      install to occur even if the global flag is set.
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      This code will automatically get dependent files from the internet,
%      but of course this requires an internet connection. If the
%      DebugTools are being installed, it does not require any other
%      functions. But for other packages, it uses the following from the
%      DebugTools library: fcn_DebugTools_addSubdirectoriesToPath
%
% EXAMPLES:
%
% % Define the name of subfolder to be created in "Utilities" subfolder
% dependency_name = 'DebugTools_v2023_01_18';
%
% % Define sub-subfolders that are in the code package that also need to be
% % added to the MATLAB path after install; the package install subfolder
% % is NOT added to path. OR: Leave empty ({}) to only add
% % the subfolder path without any sub-subfolder path additions.
% dependency_subfolders = {'Functions','Data'};
%
% % Define a universal resource locator (URL) pointing to the zip file to
% % install. For example, here is the zip file location to the Debugtools
% % package on GitHub:
% dependency_url = 'https://github.com/ivsg-psu/Errata_Tutorials_DebugTools/blob/main/Releases/DebugTools_v2023_01_18.zip?raw=true';
%
% % Call the function to do the install
% fcn_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url)
%
% This function was written on 2023_01_23 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_01_23:
% -- wrote the code originally
% 2023_04_20:
% -- improved error handling
% -- fixes nested installs automatically

% TO DO
% -- Add input argument checking

flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
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

if flag_check_inputs
    % Are there the right number of inputs?
    narginchk(3,4);
end

%% Set the global variable - need this for input checking
% Create a variable name for our flag. Stylistically, global variables are
% usually all caps.
flag_varname = upper(cat(2,'flag_',dependency_name,'_Folders_Initialized'));

% Make the variable global
eval(sprintf('global %s',flag_varname));

if nargin==4
    if varargin{1}
        eval(sprintf('clear global %s',flag_varname));
    end
end

%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ~exist(flag_varname,'var') || isempty(eval(flag_varname))
    % Save the root directory, so we can get back to it after some of the
    % operations below. We use the Print Working Directory command (pwd) to
    % do this. Note: this command is from Unix/Linux world, but is so
    % useful that MATLAB made their own!
    root_directory_name = pwd;

    % Does the directory "Utilities" exist?
    utilities_folder_name = fullfile(root_directory_name,'Utilities');
    if ~exist(utilities_folder_name,'dir')
        % If we are in here, the directory does not exist. So create it
        % using mkdir
        [success_flag,error_message,message_ID] = mkdir(root_directory_name,'Utilities');

        % Did it work?
        if ~success_flag
            error('Unable to make the Utilities directory. Reason: %s with message ID: %s\n',error_message,message_ID);
        elseif ~isempty(error_message)
            warning('The Utilities directory was created, but with a warning: %s\n and message ID: %s\n(continuing)\n',error_message, message_ID);
        end

    end

    % Does the directory for the dependency folder exist?
    dependency_folder_name = fullfile(root_directory_name,'Utilities',dependency_name);
    if ~exist(dependency_folder_name,'dir')
        % If we are in here, the directory does not exist. So create it
        % using mkdir
        [success_flag,error_message,message_ID] = mkdir(utilities_folder_name,dependency_name);

        % Did it work?
        if ~success_flag
            error('Unable to make the dependency directory: %s. Reason: %s with message ID: %s\n',dependency_name, error_message,message_ID);
        elseif ~isempty(error_message)
            warning('The %s directory was created, but with a warning: %s\n and message ID: %s\n(continuing)\n',dependency_name, error_message, message_ID);
        end

    end

    % Do the subfolders exist?
    flag_allFoldersThere = 1;
    if isempty(dependency_subfolders{1})
        flag_allFoldersThere = 0;
    else
        for ith_folder = 1:length(dependency_subfolders)
            subfolder_name = dependency_subfolders{ith_folder};

            % Create the entire path
            subfunction_folder = fullfile(root_directory_name, 'Utilities', dependency_name,subfolder_name);

            % Check if the folder and file exists that is typically created when
            % unzipping.
            if ~exist(subfunction_folder,'dir')
                flag_allFoldersThere = 0;
            end
        end
    end

    % Do we need to unzip the files?
    if flag_allFoldersThere==0
        % Files do not exist yet - try unzipping them.
        save_file_name = tempname(root_directory_name);
        zip_file_name = websave(save_file_name,dependency_url);
        % CANT GET THIS TO WORK --> unzip(zip_file_url, debugTools_folder_name);

        % Is the file there?
        if ~exist(zip_file_name,'file')
            error(['The zip file: %s for dependency: %s did not download correctly.\n' ...
                'This is usually because permissions are restricted on ' ...
                'the current directory. Check the code install ' ...
                '(see README.md) and try again.\n'],zip_file_name, dependency_name);
        end

        % Try unzipping
        unzip(zip_file_name, dependency_folder_name);

        % Did this work? If so, directory should not be empty
        directory_contents = dir(dependency_folder_name);
        if isempty(directory_contents)
            error(['The necessary dependency: %s has an error in install ' ...
                'where the zip file downloaded correctly, ' ...
                'but the unzip operation did not put any content ' ...
                'into the correct folder. ' ...
                'This suggests a bad zip file or permissions error ' ...
                'on the local computer.\n'],dependency_name);
        end

        % Check if is a nested install (for example, installing a folder
        % "Toolsets" under a folder called "Toolsets"). This can be found
        % if there's a folder whose name contains the dependency_name
        flag_is_nested_install = 0;
        for ith_entry = 1:length(directory_contents)
            if contains(directory_contents(ith_entry).name,dependency_name)
                if directory_contents(ith_entry).isdir
                    flag_is_nested_install = 1;
                    install_directory_from = fullfile(directory_contents(ith_entry).folder,directory_contents(ith_entry).name);
                    install_files_from = fullfile(directory_contents(ith_entry).folder,directory_contents(ith_entry).name,'*'); % BUG FIX - For Macs, must be *, not *.*
                    install_location_to = fullfile(directory_contents(ith_entry).folder);
                end
            end
        end

        if flag_is_nested_install
            [status,message,message_ID] = movefile(install_files_from,install_location_to);
            if 0==status
                error(['Unable to move files from directory: %s\n ' ...
                    'To: %s \n' ...
                    'Reason message: %s\n' ...
                    'And message_ID: %s\n'],install_files_from,install_location_to, message,message_ID);
            end
            [status,message,message_ID] = rmdir(install_directory_from);
            if 0==status
                error(['Unable remove directory: %s \n' ...
                    'Reason message: %s \n' ...
                    'And message_ID: %s\n'],install_directory_from,message,message_ID);
            end
        end

        % Make sure the subfolders were created
        flag_allFoldersThere = 1;
        if ~isempty(dependency_subfolders{1})
            for ith_folder = 1:length(dependency_subfolders)
                subfolder_name = dependency_subfolders{ith_folder};

                % Create the entire path
                subfunction_folder = fullfile(root_directory_name, 'Utilities', dependency_name,subfolder_name);

                % Check if the folder and file exists that is typically created when
                % unzipping.
                if ~exist(subfunction_folder,'dir')
                    flag_allFoldersThere = 0;
                end
            end
        end
        % If any are not there, then throw an error
        if flag_allFoldersThere==0
            error(['The necessary dependency: %s has an error in install, ' ...
                'or error performing an unzip operation. The subfolders ' ...
                'requested by the code were not found after the unzip ' ...
                'operation. This suggests a bad zip file, or a permissions ' ...
                'error on the local computer, or that folders are ' ...
                'specified that are not present on the remote code ' ...
                'repository.\n'],dependency_name);
        else
            % Clean up the zip file
            delete(zip_file_name);
        end

    end


    % For path creation, if the "DebugTools" package is being installed, the
    % code installs the package, then shifts temporarily into the package to
    % complete the path definitions for MATLAB. If the DebugTools is not
    % already installed, an error is thrown as these tools are needed for the
    % path creation.
    %
    % In other words: DebugTools is a special case because folders not
    % added yet, and we use DebugTools for adding the other directories
    if strcmp(dependency_name(1:10),'DebugTools')
        debugTools_function_folder = fullfile(root_directory_name, 'Utilities', dependency_name,'Functions');

        % Move into the folder, run the function, and move back
        cd(debugTools_function_folder);
        fcn_DebugTools_addSubdirectoriesToPath(dependency_folder_name,dependency_subfolders);
        cd(root_directory_name);
    else
        try
            fcn_DebugTools_addSubdirectoriesToPath(dependency_folder_name,dependency_subfolders);
        catch
            error(['Package installer requires DebugTools package to be ' ...
                'installed first. Please install that before ' ...
                'installing this package']);
        end
    end


    % Finally, the code sets a global flag to indicate that the folders are
    % initialized.  Check this using a command "exist", which takes a
    % character string (the name inside the '' marks, and a type string -
    % in this case 'var') and checks if a variable ('var') exists in matlab
    % that has the same name as the string. The ~ in front of exist says to
    % do the opposite. So the following command basically means: if the
    % variable named 'flag_CodeX_Folders_Initialized' does NOT exist in the
    % workspace, run the code in the if statement. If we look at the bottom
    % of the if statement, we fill in that variable. That way, the next
    % time the code is run - assuming the if statement ran to the end -
    % this section of code will NOT be run twice.

    eval(sprintf('%s = 1;',flag_varname));
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

    % Nothing to do!



end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends function fcn_DebugTools_installDependencies

