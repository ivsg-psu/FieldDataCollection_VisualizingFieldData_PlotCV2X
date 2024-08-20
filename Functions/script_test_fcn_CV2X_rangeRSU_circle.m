%% script_test_fcn_PlotTestTrack_rangeRSU_circle.m
% This is a script to exercise the function: fcn_PlotTestTrack_rangeRSU_circle.m
% This function was written on 2024_07_10 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_07_10
% -- first write of the code



%% PSU Test Track Coordinates
fig_num = 1;
figure(fig_num);
clf;

% Test the function
RSUid = 1;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [1 0 1];

[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotCV2X_plotRSURangeCircle(RSUid, (plotFormat), (fig_num));

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

% Test the function
RSUid = 2;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [0 1 0];

[h_geoplot2, AllLatData2, AllLonData2, AllXData2, AllYData2, ringColors2] = fcn_plotCV2X_plotRSURangeCircle(RSUid, (plotFormat), (fig_num));

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot2(:))));

Ncolors = 64;
Nangles = 91;

% Are the dimensions of Lat Long data correct?
assert(Ncolors==length(AllLatData2(:,1)));
assert(Ncolors==length(AllLonData2(:,1)));
assert(Nangles==length(AllLonData2(1,:)));
assert(length(AllLatData2(1,:))==length(AllLonData2(1,:)));

% Are the dimension of X Y data correct?
assert(Ncolors==length(AllXData2(:,1)));
assert(Ncolors==length(AllYData2(:,1)));
assert(length(AllXData2(1,:))==length(AllYData2(1,:)));
assert(length(AllXData2(1,:))==length(AllLatData2(1,:)));

% Are the dimensions of the ringColors correct?
assert(isequal(size(ringColors2),[Ncolors 3]));


% Test the function
RSUid = 3;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [0 1 1];

[h_geoplot3, AllLatData3, AllLonData3, AllXData3, AllYData3, ringColors3] = fcn_plotCV2X_plotRSURangeCircle(RSUid, (plotFormat), (fig_num));

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot3(:))));

Ncolors = 64;
Nangles = 91;

% Are the dimensions of Lat Long data correct?
assert(Ncolors==length(AllLatData3(:,1)));
assert(Ncolors==length(AllLonData3(:,1)));
assert(Nangles==length(AllLonData3(1,:)));
assert(length(AllLatData3(1,:))==length(AllLonData3(1,:)));

% Are the dimension of X Y data correct?
assert(Ncolors==length(AllXData3(:,1)));
assert(Ncolors==length(AllYData3(:,1)));
assert(length(AllXData3(1,:))==length(AllYData3(1,:)));
assert(length(AllXData3(1,:))==length(AllLatData3(1,:)));

% Are the dimensions of the ringColors correct?
assert(isequal(size(ringColors3),[Ncolors 3]));

% Set viewable area:
set(gca,'MapCenter',[40.864266781888709 -77.833965384489659],'ZoomLevel',16);

title(sprintf('Example %.0d: fcn_plotCV2X_plotRSURangeCircle',fig_num), 'Interpreter','none');
subtitle('Showing animation of results');

%%%% Do the animation 
Nrings = length(AllLatData(:,1));
skipInterval = Nrings/4;

% Prep for animation
filename = 'fcn_PlotTestTrack_rangeRSU_circle.gif';
flagFirstTime = 1;

% Clear the plot
for timeIndex = 1:100
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot(1:end-1), AllLatData, AllLonData, skipInterval,-1);
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot2(1:end-1), AllLatData2, AllLonData2, skipInterval,-1);
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot3(1:end-1), AllLatData3, AllLonData3, skipInterval,-1);
end

for timeIndex = 50:200
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot(1:end-1), AllLatData, AllLonData, skipInterval,-1);
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot2(1:end-1), AllLatData2, AllLonData2, skipInterval,-1);
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot3(1:end-1), AllLatData3, AllLonData3, skipInterval,-1);

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



%% Pittsburg Site Coordinates
fig_num = 21;
figure(fig_num);
clf;

% Test the function
RSUid = 21;

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = 'none';  % '.';
plotFormat.MarkerSize = 10;
plotFormat.Color = [0 0 1];

[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotCV2X_plotRSURangeCircle(RSUid, (plotFormat), (fig_num));

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