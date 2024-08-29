%% script_test_fcn_plotCV2X_plotRSURangeCircle
% This is a script to exercise the function: fcn_plotCV2X_plotRSURangeCircle
% This function was written on 2024_08_21 by S. Brennan, sbrennan@psu.edu

% Revision history:
% 2024_08_21
% -- first write of the code

close all;

%% PSU Test Track Coordinates


fig_num = 1;
figure(fig_num);
clf;

% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


RSUsiteString = 'TestTrack';
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
    if 1==1
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



%% Pittsburg Site Coordinates
fig_num = 21;
figure(fig_num);
clf;

% Test the function
thisRSUnumber = 21;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [0 0 1];

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

%%%% Do the animation 
Nrings = length(AllLatData(:,1));
skipInterval = Nrings/4;

% Prep for animation
filename = 'fcn_plotRoad_animateHandlesOnOff.gif';
flagFirstTime = 1;

for timeIndex = 1:200
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot(1:end-1), AllLatData, AllLonData, skipInterval,-1);

    % Create an animated gif?
    if 1==0
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.02);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.02);
        end
    end

    pause(0.1);
end