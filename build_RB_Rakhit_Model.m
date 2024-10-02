%% Script for Constructing Accelerated Clearance Model for Fitting Rakhit Data

% Adding accelerated clerance folder to workspace
addpath(genpath('Reduced Bioavailabiligy Model'));
% Adding functions folder to workspace
addpath(genpath('Functions'));
% Addpath Motzer data folder to workspace
addpath(genpath('Rakhit Data'));

%% Gathering Relevant Model Information

% importing parameters, boundaries for optimization, and parameter names
[parameters,bounds,parameter_names] = initialize_RB_model_parameters();

% Setting up doses for Motzer Clinical Trial
% Assuming body weight of 70 kg in all cases.


% 0.1 ugkg repeat doses.
dose_info_01_ugkg = struct();
dose_info_01_ugkg.dose_amounts = ones(1,6)*0.1*70*1e6/70000;
dose_info_01_ugkg.dose_days = [1 8 15 29 36 43];
dose_info_01_ugkg.dose_compartment = [1 1 1 1 1 1];
dose_info_01_ugkg.dose_compartment_volume = ["Vs","Vs","Vs","Vs","Vs","Vs"];
% 0.5 ugkg repeat doses.
dose_info_05_ugkg = struct();
dose_info_05_ugkg.dose_amounts = ones(1,6)*0.5*70*1e6/70000;
dose_info_05_ugkg.dose_days = [1 8 15 29 36 43];
dose_info_05_ugkg.dose_compartment = [1 1 1 1 1 1];
dose_info_05_ugkg.dose_compartment_volume = ["Vs","Vs","Vs","Vs","Vs","Vs"];
% 1.0 ugkg repeat doses.
dose_info_1_ugkg = struct();
dose_info_1_ugkg.dose_amounts = ones(1,6)*1.0*70*1e6/70000;
dose_info_1_ugkg.dose_days = [1 8 15 29 36 43];
dose_info_1_ugkg.dose_compartment = [1 1 1 1 1 1];
dose_info_1_ugkg.dose_compartment_volume = ["Vs","Vs","Vs","Vs","Vs","Vs"];

% consolidating
dose_schedules = {dose_info_01_ugkg; dose_info_05_ugkg; dose_info_1_ugkg};

% Setting initial condition
y0 = [0;0;parameters.R0*parameters.N_cells/parameters.Vb;0];

% setting rate laws
rate_laws = @(t,y,k) RB_model_rate_laws(t,y,k);

% setting evaluation function
eval_function = @(obj,tspan,dose_info) RB_model_eval_function(obj,tspan,dose_info);

% setting species name
species_names = ["S","L","R","C","B","pSTAT"];

% loading experimental data
experimental_data = initialize_Rakhit_data();

% setting species index that corresponds to data
data_species = 2;

%% Creating modelstructure object with above fields


model = modelstructure('parameters',parameters,'bounds',bounds,'parameter_names',...
    parameter_names,'dose_schedules',dose_schedules,'y0',y0,'rate_laws',rate_laws,...
    'eval_function',eval_function,'experimental_data',experimental_data,'data_species',data_species,...
    'species_names',species_names);

% Saving in Acclerated Clearance Model Folder
save('Reduced Bioavailability Model/RB_Rakhit_model','model')













