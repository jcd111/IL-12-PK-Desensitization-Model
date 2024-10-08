%% Script for Constructing Accelerated Clearance Model for Fitting Portielje Data

% Adding accelerated clerance folder to workspace
addpath(genpath('Reduced Bioavailability Model'));
% Adding functions folder to workspace
addpath(genpath('Functions'));
% Addpath Motzer data folder to workspace
addpath(genpath('Portielje Data'));

%% Gathering Relevant Model Information

% importing parameters, boundaries for optimization, and parameter names
[parameters,bounds,parameter_names] = initialize_RB_model_parameters();

% Setting up doses for Portielje Clinical Trial
% 0.5 ugkg doses
repeat_doses_05_ugkg = struct();
repeat_doses_05_ugkg.dose_days = [1 8 10 12 15 17 19];
repeat_doses_05_ugkg.dose_amounts = 0.5*1000*ones(1,7);
repeat_doses_05_ugkg.dose_compartment = [1 1 1 1 1 1 1];
repeat_doses_05_ugkg.dose_compartment_volume = ["Vs","Vs","Vs","Vs","Vs","Vs","Vs"];
% 1.0 ugkg doses
repeat_doses_1_ugkg = struct();
repeat_doses_1_ugkg.dose_days = [1 8 10 12 15 17 19];
repeat_doses_1_ugkg.dose_amounts = 1.0*1000*ones(1,7);
repeat_doses_1_ugkg.dose_compartment = [1 1 1 1 1 1 1];
repeat_doses_1_ugkg.dose_compartment_volume = ["Vs","Vs","Vs","Vs","Vs","Vs","Vs"];

% Putting each dose schedule twice because PK metric data is reported twice
% for each schedule, matching dose schedules to data.
dose_schedules = {repeat_doses_05_ugkg, repeat_doses_05_ugkg, repeat_doses_1_ugkg, repeat_doses_1_ugkg};

% Setting initial condition
y0 = [0;0;parameters.R0*parameters.N_cells/parameters.Vb;0];

% setting rate laws
rate_laws = @(t,y,k) RB_model_rate_laws(t,y,k);

% setting evaluation function
eval_function = @(obj,tspan,dose_info) RB_model_eval_function(obj,tspan,dose_info);

% setting species name
species_names = ["S","L","R","C","B","pSTAT"];

% loading experimental data
metric_data = initialize_Portielje_data();

% setting species index that corresponds to data
data_species = 2;

%% Creating modelstructure object with above fields


model = modelstructure('parameters',parameters,'bounds',bounds,'parameter_names',...
    parameter_names,'dose_schedules',dose_schedules,'y0',y0,'rate_laws',rate_laws,...
    'eval_function',eval_function,'metric_data',metric_data,'data_species',data_species,...
    'species_names',species_names);

% Saving in Acclerated Clearance Model Folder
save('Reduced Bioavailability Model/RB_Portielje_model','model')
