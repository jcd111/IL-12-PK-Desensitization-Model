%% Example script for global optimization
% Optimizing reduced bioavailability to dataset presented by Motzer and
% colleagues as example.  This script utlizes the function optimize_fit().

%% Adding folders containing functions and model to path.

addpath(genpath('Functions'))
addpath(genpath('Reduced Bioavailability Model'))

%% Loading unoptimized reduced-bioavailability set up to fit Motzer data

load('RB_Motzer_model')

%% Initializing optimization settings
% Setting up inputs to optimize_fit() to implement global optimization to
% estimate parameters via the particleswarm algorithm

% opt_method -- use 'particleswarm' for global optimization
opt_method = 'particleswarm';
% params_to_opt -- indices or names for parameters to optimize.
params_to_opt = [1 2 3 4 5 6 7 8 10 15];
% conditions_to_opt -- indices for datasets to fit model to
conditions_to_opt = [1 2 3 4 5];
% tspan -- timepoints to simulate optimized model at in output
tspan = linspace(0,22,1000);
% maxIterations -- maximum number of iterations for optimization method.
% For particleswarm using 200*number of parameters being optimized
maxIterations = 200*length(params_to_opt);
% error_limit -- minimum limit of detection for assay used.  In Motzer
% paper stated to be 3 pg/mL, converting to pmol/mL.
error_limit = 3/70000;
% fit_function -- fitness function to be used.  Using se() function for
% standard squared error
fit_function = @(y,e) se(y,e);
% savename -- path for optimization results to be saved.
savename = 'RB_model_Motzer_particleswarm_example';

% combining inputs into cell array.
varargin = {'Opt_method',opt_method,'params_to_opt',params_to_opt...
    'conditions_to_opt',conditions_to_opt,'tspan',tspan,'maxIterations',...
    maxIterations,'error_limit',error_limit,'fit_function',fit_function,...
    'savename',savename};

%% Running optimization using optimize_fit

% first input model, second input name-value pairs for optional inputs.
outstruct = optimize_fit(model,varargin{:});
