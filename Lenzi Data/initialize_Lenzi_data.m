function experimental_data = initialize_Lenzi_data()
% Function for loading Lenzi IL-12 IP administration data

    addpath(genpath('Lenzi Data'))
    
    
    
    % Loading IP Datapoints.
    IP_timepoints = xlsread('Lenzi Data.xlsx','A3:A15');
    IP_conc = xlsread('Lenzi Data.xlsx','B3:B15');
    IP_err = xlsread('Lenzi Data.xlsx','B19:B31');
    
    IP = {IP_timepoints'/24,IP_conc'/70000,(IP_err-IP_conc)'/70000};
    
    % Loading BS Datapoints.
    BS_timepoints = xlsread('Lenzi Data.xlsx','A35:A48');
    BS_conc = xlsread('Lenzi Data.xlsx','B35:B48');
    BS_err = xlsread('Lenzi Data.xlsx','B52:B65');
    BS = {BS_timepoints'/24,BS_conc'/70000,(BS_conc-BS_err)'/70000};
    
    
    % Combining IP and BS data
    experimental_data = cell(1,1);
    experimental_data{1} = cell(2,1);
    experimental_data{1}{1} = IP;
    experimental_data{1}{2} = BS;
    
    

    
    
end