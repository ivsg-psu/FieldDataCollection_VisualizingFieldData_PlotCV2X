%% script_test_fcn_plotRoad_breakArrayByNans
% Tests fcn_plotRoad_breakArrayByNans

% Revision history:
%      2023_07_14 - S. Brennan
%      -- first write of the code

%% Basic test case - no Nans
test_data = rand(10,2);
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},(1:10)'));

%% Basic test case - all Nans
test_data = nan(10,2);
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[]));

%% Basic test case - all but 1 value is Nan
test_data = [nan(10,1); 2; nan(4,1)];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},11));

%% Basic test case - one nan inside
test_data = [2; 3; 4; nan; 6; 7];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[5; 6]));

%% Basic test case - one nan sequence inside
test_data = [2; 3; 4; nan; nan; nan; 6; 7];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[7; 8]));

%% Basic test case - one nan sequence inside, with one nan at end
test_data = [2; 3; 4; nan; nan; nan; 6; 7; nan];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[7; 8]));

%% Basic test case - one nan sequence inside, with many nan at end
test_data = [2; 3; 4; nan; nan; nan; 6; 7; nan(3,1)];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[7; 8]));

%% Basic test case - many nan sequences inside, with many nan at end
test_data = [1; 2; 3; 4; nan; 6; nan; 8; 9; nan(3,1)];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3; 4]));
assert(isequal(indicies_cell_array{2},6));
assert(isequal(indicies_cell_array{3},[8; 9]));

%% testing speed of function

test_data = [2; 3; 4; nan; nan; nan; 6; 7];

REPS=5; minTimeSlow=Inf;
% Slow mode calculation - code copied from plotVehicleXYZ
tic;
for i=1:REPS
    tstart=tic;
    indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
% Slow mode END

% Fast Mode Calculation
minTimeFast = Inf;
tic;
for i=1:REPS
    tstart = tic;
    indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotRoad_breakArrayByNans without speed setting (slow) and with speed setting (fast):\n');
    fprintf(1,'N repetitions: %.0d\n',REPS);
    fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
    fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
    fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
    fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
    fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
end

assert(averageTimeSlow*2>averageTimeFast);
