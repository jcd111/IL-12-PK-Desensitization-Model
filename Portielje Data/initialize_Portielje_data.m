function metric_data = initialize_Portielje_PK_data()
    

    % 4 separate conditions, days 1 and 19 for doses of 0.1 and 0.5 ug/kg.
    metric_data = cell(4,1);
    
    
    % Day 1 0.5 ug/kg data.
    d1_05ugkg = struct();
    
    d1_05ugkg.Cmax = 362/70000;
    d1_05ugkg.Cmax_sd = 214/70000;
    d1_05ugkg.AUC = 1000*7.4/(24*70000);
    d1_05ugkg.AUC_sd = 1000*5.4/(70000*24);
    d1_05ugkg.Tmax = 1+9.7/24;
    d1_05ugkg.Tmax_sd = 5/24;
    d1_05ugkg.dose_window = [1 8];
    
    metric_data{1} = d1_05ugkg;
    
    % Day 19 0.5 ug/kg data.
    d19_05ugkg = struct();
    
    d19_05ugkg.Cmax = 255/70000;
    d19_05ugkg.Cmax_sd = 200/70000;
    d19_05ugkg.AUC = 1000*3.3/(24*70000);
    d19_05ugkg.AUC_sd = 1000*1.6/(24*70000);
    d19_05ugkg.Tmax = 19+9.5/24;
    d19_05ugkg.Tmax_sd = 2.2/24;
    d19_05ugkg.dose_window = [19,26];
    
    metric_data{2} = d19_05ugkg;
    
    % Day 1 1.0 ug/kg data
    
    d1_1ugkg = struct();
    
    d1_1ugkg.Cmax = 1131/70000;
    d1_1ugkg.Cmax_sd = 1051/70000;
    d1_1ugkg.AUC = 1000*31.8/(24*70000);
    d1_1ugkg.AUC_sd = 1000*22.3/(24*70000);
    d1_1ugkg.Tmax = 1+17/24;
    d1_1ugkg.Tmax_sd = 7/24;
    d1_1ugkg.dose_window = [1 8];
    
    metric_data{3} = d1_1ugkg;
    
    % Day 19 1.0 ug/kg data
    
    d19_1ugkg = struct();
    
    d19_1ugkg.Cmax = 376/70000;
    d19_1ugkg.Cmax_sd = 49/70000;
    d19_1ugkg.AUC = 1000*6/(24*70000);
    d19_1ugkg.AUC_sd = 1000*2.4/(24*70000);
    d19_1ugkg.Tmax = 19+4/24;
    d19_1ugkg.Tmax_sd = 0/24;
    d19_1ugkg.dose_window = [19 26];
    
    metric_data{4} = d19_1ugkg;
end