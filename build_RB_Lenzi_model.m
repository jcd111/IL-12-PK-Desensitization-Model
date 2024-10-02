%% Script for Constructing Reduced Bioavailability Model for Fitting Motzer Data

% Adding accelerated clerance folder to workspace
addpath(genpath('Reduced Bioavailability Model'));
% Adding functions folder to workspace
addpath(genpath('Functions'));
% Addpath Motzer data folder to workspace
addpath(genpath('Lenzi Data'));

%% Gathering Relevant Model Information

% importing parameters, boundaries for optimization, and parameter names
[parameters,bounds,parameter_names] = initialize_RB_model_parameters();

% Setting up doses for Motzer Clinical Trial
% Changing volume of local compartment to represent i.p. volume + injection
% volume
parameters.Vs = 1020;
% setting up dose schedules.
% Assuming body weight of 70 kg in all cases.
% Info for fixed cycle with 1.0 ug/kg dose.
dose_info= struct();
dose_info.dose_amounts = 0.3*70*1e6/70000;
dose_info.dose_days = 0;
dose_info.dose_compartment = 1;
dose_info.dose_compartment_volume = "Vs";

dose_schedules = cell(1,1);
dose_schedules{1} = dose_info;

% Setting initial condition
y0 = [0;0;parameters.R0*parameters.N_cells/parameters.Vb;0];

% setting rate laws
rate_laws = @(t,y,k) RB_model_rate_laws(t,y,k);

% setting evaluation function
eval_function = @(obj,tspan,dose_info) RB_model_Lenzi_eval_function(obj,tspan,dose_info);

% setting species name
species_names = ["S","L","R","C","B","pSTAT"];

% loading experimental data
experimental_data = initialize_Lenzi_data();

% setting species index that corresponds to data
data_species = 2;

%% Creating modelstructure object with above fields


model = modelstructure('parameters',parameters,'bounds',bounds,'parameter_names',...
    parameter_names,'dose_schedules',dose_schedules,'y0',y0,'rate_laws',rate_laws,...
    'eval_function',eval_function,'experimental_data',experimental_data,'data_species',data_species,...
    'species_names',species_names);

% Saving in Acclerated Clearance Model Folder
save('Reduced Bioavailability Model/RB_Lenzi_model','model')








