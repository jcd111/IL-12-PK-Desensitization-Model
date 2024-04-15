function [parameters, bounds, parameter_names] = initialize_RB_parameters()
% Function for initializing parameters for linear FB model with i.v. dose.

    parameters = struct();
    bounds = struct();


    % IL-12 (S) clerance rate. Units: 1/day
    % Taken from ranges found in clincial trials;
    thalf_il12 = [21,7]./ 24;
    bounds.kcb_bounds = log(2)./thalf_il12;
    parameters.kcb = mean(bounds.kcb_bounds);
    
    
    
    % IL-12 Receptor (R) clearance/unbound internalization rate. Units: 1/day
    % Estimated, difficulty finding information in literature.
    thalf_R = [36, 10]./ 24;
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
    
    % Number of Cells in Lymphatic System.  Units: number
    % Source: Sender et al.
    bounds.N_cells_bounds = [1e9 5e11];
    parameters.N_cells = 1e9;
    
    
    % Receptor feedback linear coefficient.  Units: pmol/day*cell
    % Arbitrary.  Testing large range
    bounds.alpha_bounds = [1e-8,1e-5];
    parameters.alpha = 1e-5;
 
    % Baseline IL-12 Receptor (R).  Units: pmol/cell
    % Estimated using number of cites per cell from Chizzonite et al.
    bounds.R0_bounds = [1000 9000]/(6.023e11);
    parameters.R0 = mean(bounds.R0_bounds);
    
    % SQ to L normalized flow rate.  Units:  1/day
    % Taken from Milewski et al.
    bounds.Jls_bounds = [0.7821, 2.9083];
    parameters.Jls = mean(bounds.Jls_bounds);
    
    % SQ to B normalized flow rate. Units: 1/day
    % Assuming no transport directly to the blood, so set to zero
    parameters.Jbs = 0;
    bounds.Jbs_bounds = nan(1,2);
    
    % Receptor per cell for half maximum activation.  Units: #/cell
    % Source: Estimated based on fitness from old model and varying order
    % of magnitude above and below.
    parameters.IC_pstat = 1.3763e3/0.0076;
    bounds.IC_pstat_bounds = [0.005 10]*parameters.IC_pstat;
    
    
    % Lymphatic Bioavailabilty (fraction of IL-12 entering lymphatic
    % system).  Units: unitless
    % Assumed to always be one.
    parameters.F = 1;
    bounds.F_bounds = [0.01 1];
    

    % Blood Volume.  Units: mL
    % Fixed, no boundaries
    parameters.Vb = 5100;
    bounds.Vb_bounds = nan(1,2);
    
    % SQ Volume.  Units.mL
    % Fixed, taken from Motzer et al paper.
    parameters.Vs = 1;
    bounds.Vs_bounds = nan(1,2);
    
    % Lymphatic System Volume.  Units.mL
    % Taken from Varkhede et al.
    parameters.Vl = 8.88+8.84+0.5*(13.49+17.58);
    bounds.Vl_bounds = nan(1,2);
    
    % L to Blood normalized flow rate.  Units: 1/day
    % Calculated from Varkhede et al.
    flow_rate = 0.06*1000; %mL/hr;
    flow_rate = flow_rate*24; %mL/day;
    parameters.Jbl = flow_rate./parameters.Vl; %/day
    bounds.Jbl_bounds = [0.1*parameters.Jbl 10*parameters.Jbl];
    
    % Making array of parameter names
    parameter_names = fieldnames(parameters);
    
    


end