%% Script for Constructing Accelerated Clearance Model for Fitting Portielje Data

% Adding accelerated clerance folder to workspace
addpath(genpath('Accelerated Clearance Model'));
% Adding functions folder to workspace
addpath(genpath('Functions'));
% Addpath Motzer data folder to workspace
addpath(genpath('Portielje Data'));

%% Gathering Relevant Model Information

% importing parameters, boundaries for optimization, and parameter names
[parameters,bounds,parameter_names] = initialize_AC_model_parameters();

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
y0 = [0;0;0;parameters.R0*parameters.N_cells/parameters.Vb;0];

% setting rate laws
rate_laws = @(t,y,k) AC_model_rate_laws(t,y,k);

% setting evaluation function
eval_function = @(obj,tspan,dose_info) AC_model_eval_function(obj,tspan,dose_info);

% setting species name
species_names = ["IL12s","Il12l","IL12b","R","C","pSTAT"];

% loading experimental data
metric_data = initialize_Portielje_data();

% setting species index that corresponds to data
data_species = 3;

%% Creating modelstructure object with above fields


model = modelstructure('parameters',parameters,'bounds',bounds,'parameter_names',...
    parameter_names,'dose_schedules',dose_schedules,'y0',y0,'rate_laws',rate_laws,...
    'eval_function',eval_function,'metric_data',metric_data,'data_species',data_species,...
    'species_names',species_names);

% Saving in Acclerated Clearance Model Folder
save('Accelerated Clearance Model/AC_Portielje_model','model')











% 
% %% Importing Parameter Values, Setting Up Dose Schedules, and 
% addpath(genpath('Models/Systemic Upregulation Model'));
% % importing parameters from optimized Motzer Model
% Motzer_model = load('01_04_2024_SU_Motzer_psw_se_V1');
% Motzer_model = Motzer_model.outstruct.model;
% parameters = Motzer_model.parameters;
% parameter_names = Motzer_model.parameter_names;
% bounds = Motzer_model.bounds;
% % Setting up Dose Schedules.
% % 0.1 ugkg repeat doses.
% repeat_doses_05_ugkg = struct();
% repeat_doses_05_ugkg.dose_days = [1 8 10 12 15 17 19];
% repeat_doses_05_ugkg.dose_amounts = 0.5*1000*ones(1,7);
% 
% repeat_doses_1_ugkg = struct();
% repeat_doses_1_ugkg.dose_days = [1 8 10 12 15 17 19];
% repeat_doses_1_ugkg.dose_amounts = 1.0*1000*ones(1,7);
% 
% dose_schedules = {repeat_doses_05_ugkg, repeat_doses_05_ugkg, repeat_doses_1_ugkg, repeat_doses_1_ugkg};
% 
%     
% 
% 
% 
% %% Setting up intitial conditions, rate laws, and eval function.
% 
% y0 = [0;0;parameters.R0*parameter.N_cells/parameters.Vb;0];
% 
% rate_laws = @(t,y,k) SU_model_rate_laws(t,y,k);
% 
% eval_function = @(obj,tspan,dose_info) SU_model_eval_function(obj,tspan,dose_info);
% %% Loading Experimental Data
% addpath(genpath('Portielje Data'))
% metric_data = initialize_Portielje_PK_data();
% data_species = 2;
% %% Creating Model
% species_names = ["IL12s","IL12b","R","C","pSTAT"];
% model = modelstructure('parameters',parameters,'bounds',bounds,'parameter_names',...
%     parameter_names,'dose_schedules',dose_schedules,'y0',y0,'rate_laws',rate_laws,...
%     'eval_function',eval_function,'metric_data',metric_data,'data_species',data_species,...
%     'species_names',species_names);
% 
% save('Models/Systemic Upregulation Model/SU_Portielje_model','model')
% 
% 
% 
% 
