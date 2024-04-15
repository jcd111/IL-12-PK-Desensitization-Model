%% Example script for simulating models
% Simulating reduced-bioavailability model with Motzer dose schedule as
% example.

%% Adding folders containing functions and models to path.


addpath(genpath('Functions'))
addpath(genpath('Reduced Bioavailability Model'))

%% Loading reduced-bioavailability model fit to Motzer data

load('RB_Motzer_Model_optimized')

%% Simulating

% specify timepoints here
timepoints = linspace(0,22,1000);

% specify which dose schedule
dose_schedule = 1;

% Simulating model at specified timepoints above for the first dose
% schedule
[~,y] = model.evaluate(timepoints,dose_schedule);

% first output is timepoints, ommitted because already specified.  Second
% output, y, is a matrix where the column indices represent the model
% species and the row indices represent timepoints.