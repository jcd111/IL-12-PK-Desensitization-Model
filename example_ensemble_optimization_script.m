%% Example script for local ensemble optimization
% Optimizing reduced-bioavailability model to dataset presented by Motzer
% and colleages as example.  First, generates 1000 parameter sets by
% randomly sampling pararameters within the optimization boundaries.
% Following initial ensemble generation, the top 25 parameter sets are each
% locally optimized to the dataset using MATLAB's patternsearch algorithm.
% Both steps are implemented using the optimize_fit() function with
% different name-value inputs.

%% Adding folders containing functions and model to path.

addpath(genpath('Functions'))
addpath(genpath('Reduced Bioavailability Model'))

%% Loading unoptimized reduced-bioavailability set up to fit Motzer data

load('RB_Motzer_model')

%% First generating initial ensemble using optimize_fit()

% initializing inputs.

% opt_method -- 'ensemble_generation' for randomly sampled sets
opt_method = 'ensemble_generation';
% params_to_opt -- indices for parameters to be optimizd
params_to_opt = [1 2 3 4 5 6 7 8 10 15];
% conditions_to_opt -- indices for datasets to fit model to
conditions_to_opt = [1 2 3 4 5];
% n_sets -- total number of parameter sets to generate
n_sets = 1000;
% best_n_sets -- top number of parameter sets to save in output.
best_n_sets = 25;
% tspan -- timepoints to simulate parameter sets.
tspan = linspace(0,22,1000);
% error_limit -- minimum limit of detection for assay used to measure
% concentrations
error_limit = 3/70000;
% fit_func -- error function to use for optimization.  Using se() for
% standard squared error.
fit_function = @(t,e) se(t,e);
% savename -- path for optimization results to be saved.
savename = 'RB_model_Motzer_ensemble_generation_example';

% combining into cell array

varargin = {'opt_method',opt_method,'params_to_opt',...
    params_to_opt,'conditions_to_opt',conditions_to_opt,'n_sets',...
    n_sets','best_n_sets',best_n_sets,'tspan',tspan,'error_limit',...
    error_limit,'fit_function',fit_function,'savename',savename};

% generating ensemble
outstruct = optimize_fit(model,varargin{:});

%%  Now loading ensemble generated above and locally optimizing each set.

% loading ensemble
load('RB_model_Motzer_ensemble_generation')
model = oustruct.model;

% setting optimization inputs.

% opt_method -- use 'patternsearch' to locally optimize ensemble
opt_method = 'patternsearch';
% params_to_opt -- indices for parameters to be optimizd
params_to_opt = [1 2 3 4 5 6 7 8 10 15];
% conditions_to_opt -- indices for datasets to fit model to
conditions_to_opt = [1 2 3 4 5];
% n_sets -- number of parameter sets to optimize.
n_sets = 25;
% StartingPoints -- matrix of parameter sets to optimize.  If not given,
% random parameter sets will be generated before patternsearch is
% implemented.
StartingPoints = outstruct.ensemble;
% tspan -- timepoints to simulate parameter sets.
tspan = linspace(0,22,1000);
% error_limit -- minimum limit of detection for assay used to measure
% concentrations
error_limit = 3/70000;
% fit_func -- error function to use for optimization.  Using se() for
% standard squared error.
fit_function = @(t,e) se(t,e);
% MaxIterations -- using 1000 for patternsearch
MaxIterations = 1000;
% savename -- path for optimization results to be saved.
savename = 'RB_model_Motzer_patternsearch_example';


varargin = {'opt_method',opt_method,'params_to_opt',params_to_opt,...
    'conditions_to_opt',conditions_to_opt,'n_sets',n_sets,...
    'StartingPoints',StartingPoints,'tspan',tspan,'error_limit',...
    error_limit,'fit_function',fit_function,'MaxIterations',...
    MaxIterations,'savename',savename};

outstruct = optimize_fit(model,varargin{:});


