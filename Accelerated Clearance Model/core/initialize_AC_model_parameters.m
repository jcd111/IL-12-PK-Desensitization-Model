function [parameters, bounds, parameter_names] = initialize_SU_model_parameters()
% Function for initializing parameters for linear FB model with i.v. dose.

    parameters = struct();
    bounds = struct();


    % IL-12 (S) clerance rate. Units: 1/day
    % Taken from ranges found in clincial trials (Motzer, Rakhit, Portielje);
    thalf_il12 = [21,7]./ 24;
    bounds.kcb_bounds = log(2)./thalf_il12;
    parameters.kcb = mean(bounds.kcb_bounds);
    
   
    % IL-12 Receptor (R) clearance/unbound internalization rate. Units: 1/day
    % Estimated, difficulty finding information in literature.
    thalf_R = [36, 15]./ 24;
    bounds.kcr_bounds = log(2)./thalf_R;
    parameters.kcr = mean(bounds.kcr_bounds);
    
    % IL-12-IL12 Receptor binding rate. Units mL/pmol*day
    % Taken from Chizzonite et al.
    bounds.kon_bounds = 1440*[1.93-0.92 1.93+0.92]./1000;
    parameters.kon = mean(bounds.kon_bounds);
    bounds.kon_bounds(2) = 50*bounds.kon_bounds(2);
    
    
    
    
    % IL-12 Receptor bound internalization rate. Units: 1/day
    % Estimate, same range as unbound internalization rate
    parameters.kint = parameters.kcr;
    bounds.kint_bounds = bounds.kcr_bounds;
    
    % Receptor feedback linear coefficient.  Units: pmol/day/cell
    % Arbitrary.  Testing large value
    bounds.alpha_bounds = [1e-8,1e-5];
    parameters.alpha = 1e-5;
    
    % Bioavailability.  Units: Unitless
    % Low bioavailability seen in data, giving low bounds
    bounds.F_bounds = [1e-2, 1];
    parameters.F = 1;
    
    % SQ transport rate.  Units:  1/day
    % Estimating
    bounds.Jbs_bounds = [1e-4 5];
    parameters.Jbs = mean(bounds.Jbs_bounds);
    
    % Initial concentration of IL-12 receptor in blood. Units: pmol/cell
    % Source: Number of T-cells in blood from Sender et al., Binding sites
    % per cell from chizzonite et al.
   
    sites_per_cell = [1000 9000]/6.023e11;
    bounds.R0_bounds = sites_per_cell;
    parameters.R0 = mean(bounds.R0_bounds);
    
    % Number of IL12R+ cells in the blood. Units: cells
    % Source: Sender et al.
    parameters.N_cells = 8e9;
    bounds.N_cells_bounds = [0.1 10]*parameters.N_cells;
    
    % Receptor per cell fo rhalf maximum activation.  Untis: #/cell
    % Source: Estiamted based on fitness from old model and varying above
    % and below
    parameters.IC_pstat = 1.3763e3/0.0076;
    bounds.IC_pstat_bounds = [0.005 10]*parameters.IC_pstat;
    
    % Blood Volume.  Units: mL
    % Fixed, no boundaries
    parameters.Vb = 5100;
    bounds.Vb_bounds = nan(1,2);
    
    % SQ Volume.  Units.mL
    % Fixed, taken from Motzer et al paper.
    parameters.Vs = 1;
    bounds.Vs_bounds = nan(1,2);
    
    
    % Making array of parameter names
    parameter_names = fieldnames(parameters);
    
    


end