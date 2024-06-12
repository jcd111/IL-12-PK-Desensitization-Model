function experimental_data = initialize_Motzer_PK_data
    % Importing Motzer data from excel file and putting into format
    % compatible with modeling.
    
    addpath(genpath('Motzer Data'));
    % Loading Fixed Cycle 1.0 ug/kg data
    F_10ugkg_timepoints = xlsread('Motzer Data Combined.xlsx','A3:A11');
    F_10ugkg_conc = xlsread('Motzer Data Combined.xlsx','C3:C11');
    F_10ugkg = {1+F_10ugkg_timepoints'/24, F_10ugkg_conc'};
    
    % Loading Esc Cycle 0.5 ug/kg data
    E_05ugkg_timepoints = xlsread('Motzer Data Combined.xlsx','D3:D8');
    E_05ugkg_conc = xlsread('Motzer Data Combined.xlsx','F3:F8');
    E_05ugkg = {15+E_05ugkg_timepoints'/24, E_05ugkg_conc'};
    
    % Loading Esc Cycle 1.0 ug/kg data
    E_10ugkg_timepoints = xlsread('Motzer Data Combined.xlsx','G3:G11');
    E_10ugkg_conc = xlsread('Motzer Data Combined.xlsx','I3:I11');
    E_10ugkg = {15+E_10ugkg_timepoints'/24, E_10ugkg_conc'};
    
    
    % Loading Esc Cycle 1.25 ug/kg data
    E_125ugkg_timepoints = xlsread('Motzer Data Combined.xlsx','J3:J11');
    E_125ugkg_conc = xlsread('Motzer Data Combined.xlsx','L3:L11');
    E_125ugkg = {15+E_125ugkg_timepoints'/24, E_125ugkg_conc'};
    
    % Loading Esc Cycle 1.5 ug/kg dat
    E_150ugkg_timepoints = xlsread('Motzer Data Combined.xlsx','M3:M11');
    E_150ugkg_conc = xlsread('Motzer Data Combined.xlsx','O3:O11');
    E_150ugkg = {15+E_150ugkg_timepoints'/24, E_150ugkg_conc'};
    
    experimental_data = cell(5,1);
    experimental_data{1}{1} = F_10ugkg;
    experimental_data{2}{1} = E_05ugkg;
    experimental_data{3}{1} = E_10ugkg;
    experimental_data{4}{1} = E_125ugkg;
    experimental_data{5}{1} = E_150ugkg;
    
    
    
end