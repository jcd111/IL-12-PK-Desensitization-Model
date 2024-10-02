%% Script for Constructing Accelerated Clearance Model for Fitting Motzer Data

% Adding accelerated clerance folder to workspace
addpath(genpath('Accelerated Clearance Model'));
% Adding functions folder to workspace
addpath(genpath('Functions'));
% Addpath Motzer data folder to workspace
addpath(genpath('Motzer Data'));

%% Gathering Relevant Model Information

% importing parameters, boundaries for optimization, and parameter names
[parameters,bounds,parameter_names] = initialize_AC_model_parameters();

% Setting up doses for Motzer Clinical Trial
% Assuming body weight of 70 kg in all cases.
% Info for fixed cycle with 1.0 ug/kg dose.
fixed_1ugkg = struct();
fixed_1ugkg.dose_amounts = ones(1,3)*1.0*70*1e6/70000;
fixed_1ugkg.dose_days = [1 8 15];
fixed_1ugkg.dose_compartment = [1 1 1];
fixed_1ugkg.dose_compartment_volume = ["Vs","Vs","Vs"];

% Info for escalating cycle with 0.5 ug/kg target dose.
esc_05ugkg = struct();
esc_05ugkg.dose_amounts = [0.1 0.25 0.5].*70.*1e6./70000;
esc_05ugkg.dose_days = [1 8 15];
esc_05ugkg.dose_compartment = [1 1 1];
esc_05ugkg.dose_compartment_volume = ["Vs","Vs","Vs"];

% Info for escalating cycke with 1.0 ug/kg target dose.
esc_1ugkg = struct();
esc_1ugkg.dose_amounts = [0.1 0.5 1.0].*70.*1e6./70000;
esc_1ugkg.dose_days = [1 8 15];
esc_1ugkg.dose_compartment = [1 1 1];
esc_1ugkg.dose_compartment_volume = ["Vs","Vs","Vs"];

% info for escalating cycle with 1.25 ug/kg target dose.
esc_125ugkg = struct();
esc_125ugkg.dose_amounts = [0.1 0.5 1.25].*70.*1e6./70000;
esc_125ugkg.dose_days = [1 8 15];
esc_125ugkg.dose_compartment = [1 1 1];
esc_125ugkg.dose_compartment_volume = ["Vs","Vs","Vs"];

% info for escalating cycle with 1.5 ug/kg target dose.
esc_150ugkg = struct();
esc_150ugkg.dose_amounts = [0.1 0.5 1.5].*70.*1e6./70000;
esc_150ugkg.dose_days = [1 8 15];
esc_150ugkg.dose_compartment = [1 1 1];
esc_150ugkg.dose_compartment_volume = ["Vs","Vs","Vs"];

dose_schedules = {fixed_1ugkg; esc_05ugkg; esc_1ugkg; esc_125ugkg; esc_150ugkg};

% Setting initial condition
y0 = [0;0;0;parameters.R0*parameters.N_cells/parameters.Vb;0];

% setting rate laws
rate_laws = @(t,y,k) AC_model_rate_laws(t,y,k);

% setting evaluation function
eval_function = @(obj,tspan,dose_info) AC_model_eval_function(obj,tspan,dose_info);

% setting species name
species_names = ["IL12s","IL12l","IL12b","R","C","pSTAT"];
% loading experimental data
experimental_data = initialize_Motzer_data();

% setting species index that corresponds to data
data_species = 3;

%% Creating modelstructure object with above fields


model = modelstructure('parameters',parameters,'bounds',bounds,'parameter_names',...
    parameter_names,'dose_schedules',dose_schedules,'y0',y0,'rate_laws',rate_laws,...
    'eval_function',eval_function,'experimental_data',experimental_data,'data_species',data_species,...
    'species_names',species_names);

% Saving in Acclerated Clearance Model Folder
save('Accelerated Clearance Model/AC_Motzer_model','model')




