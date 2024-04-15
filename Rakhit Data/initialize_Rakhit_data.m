function experimental_data = initialize_Rakhit_PK_data()
% Imports Rakhit et al. data from excel file and formats it to required
% format for modeling.

    addpath(genpath('Rakhit Data'));
    
    % Loading 0.1 ug/kg data.
    dose_1_01_ugkg_timepoints = xlsread('IL12 PK.xlsx','A4:A8')';
    dose_1_01_ugkg_timepoints = 1+dose_1_01_ugkg_timepoints./24;
    dose_1_01_ugkg = xlsread('IL12 PK.xlsx','C4:C8')';
    
    dose_6_01_ugkg_timepoints = xlsread('IL12 PK.xlsx','A19:A24')';
    dose_6_01_ugkg_timepoints = 43 + dose_6_01_ugkg_timepoints./24;
    dose_6_01_ugkg = xlsread('IL12 PK.xlsx','C19:C24')';
    
    combined_01_ugkg_timepoints = [dose_1_01_ugkg_timepoints, dose_6_01_ugkg_timepoints];
    combined_01_ugkg_PK = [dose_1_01_ugkg,dose_6_01_ugkg];
    
    combined_01_ugkg = {combined_01_ugkg_timepoints, combined_01_ugkg_PK};
    
    
    % Loading 0.5 ug/kg data.
    dose_1_05_ugkg_timepoints = xlsread('IL12 PK.xlsx','E4:E13')';
    dose_1_05_ugkg_timepoints = 1+dose_1_05_ugkg_timepoints./24;
    dose_1_05_ugkg = xlsread('IL12 PK.xlsx','G4:G13')';
    
    dose_6_05_ugkg_timepoints = xlsread('IL12 PK.xlsx','E19:E27')';
    dose_6_05_ugkg_timepoints = 43 + dose_6_05_ugkg_timepoints./24;
    dose_6_05_ugkg = xlsread('IL12 PK.xlsx','G19:G27')';
    
    combined_05_ugkg_timepoints = [dose_1_05_ugkg_timepoints, dose_6_05_ugkg_timepoints];
    combined_05_ugkg_PK = [dose_1_05_ugkg,dose_6_05_ugkg];
    
    combined_05_ugkg = {combined_05_ugkg_timepoints, combined_05_ugkg_PK};
    
    % Loading 1.0 ug/kg data.
    dose_1_1_ugkg_timepoints = xlsread('IL12 PK.xlsx','I4:I13')';
    dose_1_1_ugkg_timepoints = 1+dose_1_1_ugkg_timepoints./24;
    dose_1_1_ugkg = xlsread('IL12 PK.xlsx','K4:K13')';
    
    dose_6_1_ugkg_timepoints = xlsread('IL12 PK.xlsx','I19:I27')';
    dose_6_1_ugkg_timepoints = 43 + dose_6_1_ugkg_timepoints./24;
    dose_6_1_ugkg = xlsread('IL12 PK.xlsx','K19:K27')';
    
    combined_1_ugkg_timepoints = [dose_1_1_ugkg_timepoints, dose_6_1_ugkg_timepoints];
    combined_1_ugkg_PK = [dose_1_1_ugkg,dose_6_1_ugkg];
    
    combined_1_ugkg = {combined_1_ugkg_timepoints, combined_1_ugkg_PK};
   
    
    % Putting into cell format
    
    experimental_data = cell(3,1);
    experimental_data{1}{1} = combined_01_ugkg;
    experimental_data{2}{1} = combined_05_ugkg;
    experimental_data{3}{1} = combined_1_ugkg;


end