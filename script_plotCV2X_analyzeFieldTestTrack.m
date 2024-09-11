%% script_plotCV2X_analyzeFieldTestTrack
% This is an analysis script for the Test Track location near Falling Water
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu

close all

%% Revision History:
% 2023_08_25 - sbrennan@psu.edu
% -- Started writing the function


%% To-Do list
% 2024_08_15 - S. Brennan
% -- Nothing yet!

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

%% Load all the site RSU locations
fig_num = 1;
figure(fig_num);
clf;

SiteStringIdentifier = 'TestTrack';

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 50;
plotFormat.Color = [1 0 1];

[LLAsOfRSUs, numericRSUids] =fcn_plotCV2X_loadRSULLAs(SiteStringIdentifier, (plotFormat), (fig_num));
title(sprintf('Figure %.0d: RSU locations for Test Track',fig_num), 'Interpreter','none');

%% Load all the site data

% What files are in the data directory that start with the name 'TestTrack'?
dirname = cat(2,'Data',filesep,'TestTrack*');
dirList = dir(dirname);
Nfiles = length(dirList);

% Initialize arrays
fnames{Nfiles} = '';
tLLAs{Nfiles} = [];
tENUs{Nfiles} = [];
velocities{Nfiles} = [];
anglesENU{Nfiles} = [];
compassHeadings{Nfiles} = [];

alltLLAs = [];
alltENUs = [];
allRSUs = [];
allVelocities = [];
allVelocityDisparities = [];
allVelocityDisparitiesSameHeading = [];
allCompassHeadings = [];

for ith_file = 1:Nfiles
    % Get current filename
    csvFile = dirList(ith_file).name;

    fprintf(1,'Loading data from file: %s ...',csvFile);

    % Load the data
    [tLLA, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));

    % Determine which RSU this belongs to. The number is in the 10th digit
    RSUcharacter = csvFile(14);
    RSUdigit = str2double(RSUcharacter);


    % Group the data into continuous "modes", e.g. data sets that have the
    % same intercept when plotting time versus index
    [modeIndex, ~, offsetCentisecondsToMode] = fcn_plotCV2X_assessTime(tLLA, tENU, (-1));

    % Calculate the velocities
    [velocity, angleENUradians, compassHeadingDegrees] = fcn_plotCV2X_calcVelocity(tLLA, tENU, modeIndex, offsetCentisecondsToMode, -1);

    % Calculate the velocity disparity
    searchRadiusAndAngles = 20;
    speedDisparity = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (-1));

    searchRadiusAndAngles = [20 15*pi/180];
    speedDisparitySameHeading = fcn_plotCV2X_calcSpeedDisparity(tLLA, tENU, searchRadiusAndAngles, (-1));

    % Save results
    fnames{ith_file} = csvFile;
    tLLAs{ith_file} = tLLA;
    tENUs{ith_file} = tENU;
    velocities{ith_file} = velocity;
    anglesENU{Nfiles} = angleENUradians;
    compassHeadings{Nfiles} = compassHeadingDegrees;

    allRSUs = [allRSUs; RSUdigit*ones(length(tLLA(:,1)),1)]; %#ok<AGROW>
    allVelocities = [allVelocities; velocity]; %#ok<AGROW>
    allVelocityDisparities = [allVelocityDisparities; speedDisparity]; %#ok<AGROW>
    allVelocityDisparitiesSameHeading = [allVelocityDisparitiesSameHeading; speedDisparitySameHeading]; %#ok<AGROW>

    alltLLAs = [alltLLAs; tLLA]; %#ok<AGROW>
    alltENUs = [alltENUs; tENU]; %#ok<AGROW>
    allCompassHeadings = [allCompassHeadings; compassHeadingDegrees]; %#ok<AGROW>

    fprintf(1,'done.\n');
end

%% Plot each of the RSU coverages
figure(1111);
clf;

N_RSUs = length(numericRSUids(:,1));

h_geoplots{N_RSUs} = [];
AllLatDatas{N_RSUs} = [];
AllLonDatas{N_RSUs} = [];

for ith_RSU = 1:N_RSUs
    thisRSUnumber = numericRSUids(ith_RSU);

    % Set up the figure
    fig_num = thisRSUnumber;
    figure(fig_num);
    clf;

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
    set(gca,'MapCenter',LLAsOfRSUs(ith_RSU,1:2));

    % Plot the RSU data
    plotFormat.MarkerSize = 10;

    thisRSU_indicies = find(allRSUs==ith_RSU);
    plotData = alltLLAs(thisRSU_indicies,:);

    fcn_plotRoad_plotLL(plotData(:,2:3), (plotFormat), (fig_num));
    title(sprintf('RSU %.0d: showing coverage range',fig_num), 'Interpreter','none','FontSize',12);

    % Plot the RSU rings?
    clear plotFormat
    plotFormat.LineStyle = '-';
    plotFormat.LineWidth = 1;
    plotFormat.Marker = 'none';
    plotFormat.Color = color_vector;

    fcn_plotCV2X_plotRSURangeCircle(thisRSUnumber, (plotFormat), (fig_num));


    % Add data to plot of all RSU's together
    clear plotFormat
    plotFormat.Color = color_vector;
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 5;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 5;

    % Plot the data
    fcn_plotRoad_plotLL(plotData(:,2:3), (plotFormat), (1111));

    % Plot each RSU's "broadcast" rings
    clear plotFormat
    plotFormat.LineStyle = '-';
    plotFormat.LineWidth = 1;
    plotFormat.Marker = 'none';
    plotFormat.Color = color_vector;

    [this_h_geoplot, this_AllLatData, this_AllLonData] = fcn_plotCV2X_plotRSURangeCircle(thisRSUnumber, (plotFormat), (1111));
    h_geoplots{ith_RSU} = this_h_geoplot;
    AllLatDatas{ith_RSU} = this_AllLatData;
    AllLonDatas{ith_RSU} = this_AllLonData;

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
    fcn_plotRoad_plotLL((LLAsOfRSUs(ith_RSU,1:2)), (plotFormat), (1111));

end


figure(1111);
set(gca,'MapCenterMode','auto','ZoomLevelMode','auto');
title('Test Track RSU coverage zones');

%% Animate RSU plot?
Nrings = length(AllLonDatas{1}(:,1));
skipInterval = Nrings/4;


% Clear the plot
for timeIndex = 1:skipInterval+1
    for ith_RSU = 1:N_RSUs
        fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplots{ith_RSU}(1:end-1), AllLatDatas{ith_RSU}, AllLonDatas{ith_RSU}, skipInterval,-1);
        % pause(0.02);
    end
end

%% Animate the plot and save to file
% Prep for animation
filename = 'fcn_plotCV2X_TestTrackRSUs.gif';
flagFirstTime = 1;

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

%% Plot velocities for each RSU

close all;

% Set all the plotting defaults
clear plotFormat
plotFormat.LineStyle = 'none';
plotFormat.LineWidth = 5;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
colorMapMatrixOrString = colormap('turbo');
Ncolors = 16;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrixOrString, Ncolors, -1);
fullWrapAroundColorMap = hsv2rgb([linspace(0,1,256)',ones(256,2)]);
reducedWrapAroundColorMap = hsv2rgb([linspace(0,1,Ncolors)',ones(Ncolors,2)]);

goodVelocityIndicies = ~isnan(allVelocities);
goodVelocities = allVelocities(goodVelocityIndicies,:);

goodVelocityDisparityIndicies = ~isnan(allVelocityDisparities);
goodVelocityDisparities = allVelocityDisparities(goodVelocityDisparityIndicies);

goodVelocityDisparitySameHeadingIndicies = ~isnan(allVelocityDisparitiesSameHeading);
goodVelocityDisparitiesSameHeading = allVelocityDisparitiesSameHeading(goodVelocityDisparitySameHeadingIndicies);



velocityAxes = [min(goodVelocities); max(goodVelocities)];
velocityDisparityAxes = [0; max(goodVelocityDisparities)];
velocityDisparitySameHeadingAxes = [0; max(goodVelocityDisparitiesSameHeading)];
heightAxes = [min(alltLLAs(:,4)) max(alltLLAs(:,4))];

flag_combine_all = 1; % Set to 1 to plot all together, or 0 to plot each RSU separately
for ith_RSU = 1:N_RSUs
    thisRSUnumber = numericRSUids(ith_RSU);


    % Isolate the data for this RSU
    thisRSU_indicies = find(allRSUs==ith_RSU);
    thisRSU_LLA = alltLLAs(thisRSU_indicies,:);
    thisRSU_ENU = alltENUs(thisRSU_indicies,:);
    thisRSU_velocities = allVelocities(thisRSU_indicies,:);
    thisRSU_velocityDisparities = allVelocityDisparities(thisRSU_indicies,:);
    thisRSU_velocityDisparitiesSameHeading = allVelocityDisparitiesSameHeading(thisRSU_indicies,:);
    thisRSU_compassHeadings = allCompassHeadings(thisRSU_indicies,:);

    % Keep only the good data for plotting
    goodPlottingIndicies = ~isnan(thisRSU_velocities);
    goodTime = nan(size(thisRSU_velocities));
    goodTime(goodPlottingIndicies,1) = thisRSU_ENU(goodPlottingIndicies,1);

    rawXYVData = [thisRSU_ENU(:,2:3) thisRSU_velocities];
    rawXYVeldisparityData = [thisRSU_ENU(:,2:3) thisRSU_velocityDisparities];
    rawXYVeldisparitysameheadingData = [thisRSU_ENU(:,2:3) thisRSU_velocityDisparitiesSameHeading];
    rawXYHData = [thisRSU_ENU(:,2:3) thisRSU_compassHeadings/360];
    plotXYVData = rawXYVData(goodPlottingIndicies,:);
    plotXYVeldisparityData = rawXYVeldisparityData(goodPlottingIndicies,:);
    plotXYVeldisparitysameheadingData = rawXYVeldisparitysameheadingData(goodPlottingIndicies,:);
    plotXYHData = rawXYHData(goodPlottingIndicies,:);

    rawLLVData = [thisRSU_LLA(:,2:3) thisRSU_velocities];
    rawLLVeldisparityData = [thisRSU_LLA(:,2:3) thisRSU_velocityDisparities];
    rawLLVeldisparitysameheadingData = [thisRSU_LLA(:,2:3) thisRSU_velocityDisparitiesSameHeading];
    rawLLHData = [thisRSU_LLA(:,2:3) thisRSU_compassHeadings/360];
    rawLLheightData = [thisRSU_LLA(:,2:3) thisRSU_LLA(:,4)];
    plotLLVData = rawLLVData(goodPlottingIndicies,:);
    plotLLVeldisparityData = rawLLVeldisparityData(goodPlottingIndicies,:);
    plotLLVeldisparitysameheadingData = rawLLVeldisparitysameheadingData(goodPlottingIndicies,:);
    plotLLHData = rawLLHData(goodPlottingIndicies,:);
    plotLLheightData = rawLLheightData(goodPlottingIndicies,:);

    % Rescale them all to same axes (note: heading is already rescaled)
    plotXYVData = fcn_INTERNAL_rescaleAxis(plotXYVData,velocityAxes);
    plotXYVeldisparityData = fcn_INTERNAL_rescaleAxis(plotXYVeldisparityData,velocityDisparityAxes);
    plotXYVeldisparitysameheadingData = fcn_INTERNAL_rescaleAxis(plotXYVeldisparitysameheadingData,velocityDisparitySameHeadingAxes);
    % plotXYheightData = fcn_INTERNAL_rescaleAxis(plotXYheightData,heightAxes);
    plotLLVData = fcn_INTERNAL_rescaleAxis(plotLLVData,velocityAxes);
    plotLLVeldisparityData = fcn_INTERNAL_rescaleAxis(plotLLVeldisparityData,velocityDisparityAxes);
    plotLLVeldisparitysameheadingData = fcn_INTERNAL_rescaleAxis(plotLLVeldisparitysameheadingData,velocityDisparitySameHeadingAxes);
    plotLLheightData = fcn_INTERNAL_rescaleAxis(plotLLheightData,heightAxes);

    % Set up the time vs velocity figure
    if 1==flag_combine_all
        fig_num = 10000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+1000;
        figure(fig_num);
        clf;
    end

    fcn_plotRoad_plotXYI([goodTime thisRSU_velocities thisRSU_velocities], (plotFormat), (reducedColorMap), (fig_num));
    axis('normal');
    colormap(gca,colorMapMatrixOrString);
    title('Velocity')
    xlabel('Time [s]')
    ylabel('Velocity [m/s]')
    fcn_INTERNAL_addTitle(flag_combine_all,'velocity versus time', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setSpeedColorBar(velocityAxes,Ncolors)


    % Set up the time vs heading figure
    if 1==flag_combine_all
        fig_num = 20000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+2000;
        figure(fig_num);
        clf;
    end


    fcn_plotRoad_plotXYI([goodTime thisRSU_compassHeadings thisRSU_velocities], (plotFormat), (reducedColorMap), (fig_num));
    axis("normal");
    colormap(gca,colorMapMatrixOrString);
    title('Compass Heading')
    xlabel('Time [s]')
    ylabel('Heading [deg]')
    fcn_INTERNAL_addTitle(flag_combine_all,'heading versus time', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setSpeedColorBar(velocityAxes,Ncolors)

    % Set up the ENU velocity figure
    if 1==flag_combine_all
        fig_num = 30000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+3000;
        figure(fig_num);
        clf;
    end


    fcn_plotRoad_plotXYI(plotXYVData, (plotFormat), (reducedColorMap), (fig_num));
    colormap(gca,colorMapMatrixOrString);
    title('ENU velocities')
    xlabel('East [m]')
    ylabel('North [m]')
    fcn_INTERNAL_addTitle(flag_combine_all,'ENU velocities', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setSpeedColorBar(velocityAxes,Ncolors)

    % Set up the LLA velocity figure
    if 1==flag_combine_all
        fig_num = 40000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+4000;
        figure(fig_num);
        clf;
    end


    fcn_plotRoad_plotLLI(plotLLVData, (plotFormat), (reducedColorMap), (fig_num));
    colormap(gca,colorMapMatrixOrString);
    fcn_INTERNAL_addTitle(flag_combine_all,'LLA velocities', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setSpeedColorBar(velocityAxes,Ncolors)

    % Set up the ENU heading figure
    if 1==flag_combine_all
        fig_num = 50000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+5000;
        figure(fig_num);
        clf;
    end


    fcn_plotRoad_plotXYI(plotXYHData, (plotFormat), (reducedWrapAroundColorMap), (fig_num));
    colormap(gca,fullWrapAroundColorMap);
    xlabel('East [m]')
    ylabel('North [m]')
    fcn_INTERNAL_addTitle(flag_combine_all,'ENU heading', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setHeadingColorBar(Ncolors)


    % Set up the LLA heading figure
    if 1==flag_combine_all
        fig_num = 60000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+6000;
        figure(fig_num);
        clf;
    end


    fcn_plotRoad_plotLLI(plotLLHData, (plotFormat), (reducedWrapAroundColorMap), (fig_num));
    colormap(gca,fullWrapAroundColorMap);
    fcn_INTERNAL_addTitle(flag_combine_all,'LLA heading', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setHeadingColorBar(Ncolors)

    % Set up the LLA height figure
    if 1==flag_combine_all
        fig_num = 70000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+7000;
        figure(fig_num);
        clf;
    end


    fcn_plotRoad_plotLLI(plotLLheightData, (plotFormat), (reducedColorMap), (fig_num));
    colormap(gca,colorMapMatrixOrString);
    fcn_INTERNAL_addTitle(flag_combine_all,'LLA height', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setHeightColorBar(heightAxes,Ncolors)


    % Set up the LLA speed disparity figure
    if 1==flag_combine_all
        fig_num = 80000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+8000;
        figure(fig_num);
        clf;
    end

    fcn_plotRoad_plotLLI(plotLLVeldisparityData, (plotFormat), (reducedColorMap), (fig_num));
    colormap(gca,colorMapMatrixOrString);
    fcn_INTERNAL_addTitle(flag_combine_all,'LLA velocity disparity', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setSpeedColorBar(velocityDisparityAxes,Ncolors)


    % Set up the LLA speed disparity same heading figure
    if 1==flag_combine_all
        fig_num = 90000;
        figure(fig_num);
    else
        fig_num = thisRSUnumber+9000;
        figure(fig_num);
        clf;
    end

    fcn_plotRoad_plotLLI(plotLLVeldisparitysameheadingData, (plotFormat), (reducedColorMap), (fig_num));
    colormap(gca,colorMapMatrixOrString);
    fcn_INTERNAL_addTitle(flag_combine_all,'LLA velocity disparity, same heading', SiteStringIdentifier, thisRSUnumber);
    fcn_INTERNAL_setSpeedColorBar(velocityDisparitySameHeadingAxes,Ncolors)

end

%%% Recenter the plots

if 1==flag_combine_all
    figs_to_update = 10000*(1:9);
else
    figs_to_update = 1000*(1:9);
end
for ith_figure = 1:length(figs_to_update)
    current_fig = figs_to_update(ith_figure);
    figure(current_fig);
    try
        set(gca,'MapCenterMode','auto','ZoomLevelMode','auto');
    catch
    end
end

%% Check velocity variance?
if 1==0
    % The following code performs AVAR analysis on the data to see how the mean
    % values change as we include larger/larger amounts of data around each
    % point to calculate the mean. There are two competing effects: as more
    % data is added, the variance decreases by the square-root of the count.
    % However, as more data is added around the point, the speed will change
    % from the average due to the speed actually changing. These effects
    % "fight" each other. The minimum variance result gives the "best" mean
    % velocity estimate we can find, and as well tells us the best uncertainty
    % we should expect.
    %
    % This shows that ~6 meters is the variance-minimizing search distance, and
    % the best variance we will see is about 0.1 m/s.

    % Test the function across a large range
    rangesToTest = (0.01*2.^(2:11))';
    % rangesToTest = logspace(-1,2,50)';
    Npoints = length(alltLLAs(:,1));
    Nranges = length(rangesToTest);

    % Initialize storage arrays
    AllMeanVelocities = zeros(Npoints,Nranges);
    AllStdsVelocities = zeros(Npoints,Nranges);
    AllMvalVelocities = zeros(Npoints,Nranges);

    % For each range, do calculations
    fprintf(1,'\n\nTesting different ranges for data groupings to find range that minimizes uncertainty in mean velocity.\n')
    for ith_range = 1:Nranges
        searchRadiusAndAngles = rangesToTest(ith_range,1);
        fprintf(1,'Testing range: %.2f meters\n',searchRadiusAndAngles(1));
        [speedDisparity, meanVelocityVector, stdVelocityVector, Mspeeds] = fcn_plotCV2X_calcSpeedDisparity(alltLLAs, alltENUs, searchRadiusAndAngles, (-1));
        AllMeanVelocities(:,ith_range) = real(sum(meanVelocityVector.^2,2).^0.5);
        AllStdsVelocities(:,ith_range) = real(sum(stdVelocityVector.^2,2).^0.5);
        AllMvalVelocities(:,ith_range) = Mspeeds;
    end

    % Remove bad values
    goodIndicies = ~isnan(AllMeanVelocities(:,end));
    goodAllMeanVelocities = AllMeanVelocities(goodIndicies,:);
    goodAllStdsVelocities = AllStdsVelocities(goodIndicies,:);
    goodAllMvalVelocities = AllMvalVelocities(goodIndicies,:);

    % Standard deviations of infinity and less than 0.0001 are not possible.
    maxStd = max(goodAllStdsVelocities(~isinf(goodAllStdsVelocities)),[],'all');
    goodAllStdsVelocities(isinf(goodAllStdsVelocities)) = nan;
    goodAllStdsVelocities(0.0001>=goodAllStdsVelocities) = nan;

    meanStds = goodAllStdsVelocities./(goodAllMvalVelocities.^0.5);

    meanOfMeanStds = mean(meanStds,1,'omitnan')';

    %%%%
    % Check results with plotting
    figure(345);
    clf;
    for ith_point = 1:10:length(meanStds(:,1))
        loglog(rangesToTest,meanStds(ith_point,:),'.','MarkerSize',20)
        if ith_point==1
            hold on;
            grid on;
            xlabel('Search range');
            ylabel('Variance in mean');
        end
        pause(0.02);
    end
    loglog(rangesToTest,meanOfMeanStds,'b-','LineWidth',5);

    %%%%
    % Check the weird pattern where the variances are grouping
    figure(23445);
    for ith_range = 1:length(rangesToTest(:,1))
        histogram(log10(meanStds(:,ith_range)),100);
        title(sprintf('Range = %.2f meters',rangesToTest(ith_range,1)));
        xlim([-4 2]);
        pause(0.2)
    end

end

%% Calcualte velocity disparity across entire Site
figure(2345); clf;
searchRadiusAndAngles = 6;
fcn_plotCV2X_calcSpeedDisparity(alltLLAs, alltENUs, searchRadiusAndAngles, (2345));
sgtitle('Test Track velocity summaries, range averaged')

figure(3456); clf;
searchRadiusAndAngles = [1.4 15*pi/180];
fcn_plotCV2X_calcSpeedDisparity(alltLLAs, alltENUs, searchRadiusAndAngles, (3456));
sgtitle('Test Track velocity summaries, range and heading averaged')

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
path_dirs = regexp(path,'[;]','split');
utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
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

function fcn_INTERNAL_setSpeedColorBar(velocity,Ncolors)
h_colorbar = colorbar;
h_colorbar.Ticks = linspace(0, 1, Ncolors) ; %Create ticks from zero to 1
% There are 2.23694 mph in 1 m/s
colorbarValues   = round(2.23694 * linspace(min(velocity), max(velocity), Ncolors));
h_colorbar.TickLabels = num2cell(colorbarValues) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
h_colorbar.Label.String = 'Speed (mph)';
end

function fcn_INTERNAL_setHeadingColorBar(Ncolors)
h_colorbar = colorbar;
h_colorbar.Ticks = linspace(0, 1, Ncolors) ; %Create ticks from zero to 1
colorbarValues   = round(linspace(0,360, Ncolors),-1);
h_colorbar.TickLabels = num2cell(colorbarValues) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
h_colorbar.Label.String = 'Heading (deg)';
end


function fcn_INTERNAL_setHeightColorBar(height,Ncolors)
h_colorbar = colorbar;
h_colorbar.Ticks = linspace(0, 1, Ncolors) ; %Create ticks from zero to 1
colorbarValues   = round(linspace(min(height), max(height), Ncolors),-1);
h_colorbar.TickLabels = num2cell(colorbarValues) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
h_colorbar.Label.String = 'Height (meters)';
end

function outputData = fcn_INTERNAL_rescaleAxis(inputData,rangeData)
outputData = inputData;
maxValue  = max(rangeData);
minValue = min(rangeData);
outputData(:,3) = (inputData(:,3)-minValue)/(maxValue - minValue);
end

function fcn_INTERNAL_addTitle(flag_combine_all,text_to_list, SiteStringIdentifier, thisRSUnumber)
if 1==flag_combine_all
    title(sprintf('Site: %s, %s',SiteStringIdentifier, text_to_list), 'Interpreter','none','FontSize',12);
else
    title(sprintf('RSU %.0d, %s',thisRSUnumber, text_to_list), 'Interpreter','none','FontSize',12);
end
end

