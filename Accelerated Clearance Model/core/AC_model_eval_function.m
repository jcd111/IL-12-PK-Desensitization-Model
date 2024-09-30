function [x,y,sol] = AC_model_eval_function(obj,tspan,dose_info)
% Eval function for simple FB model with linear FB and i.v. dosing

    % Getting params
    k = obj.parameters;
    Jls = k.Jls;
    Jbl = k.Jbl;
    F = k.F;
    kon = k.kon;
    kcb = k.kcb;
    R0 = k.R0;
    alpha = k.alpha;
    kcr = k.kcr;
    kint = k.kint;
    Vb = k.Vb;
    Vl = k.Vl;
    Vs = k.Vs;
    IC_pstat = k.IC_pstat;
    N_cells = k.N_cells;
    % Calculating constrained parameters and other initial condition
    kr = kcr*R0;
    kdg = (1-F)*Jls/F;
    
    obj.y0 = [0,0,0,N_cells*R0/Vb,0];
    
    
    if length(dose_info.dose_days) > 1
        [y,sol] = simulate_multiple_doses(obj,tspan,dose_info);
    else
        obj.y0(dose_info.dose_compartment) = dose_info.dose_amounts./obj.parameters.(dose_info.dose_compartment_volume);
        options = odeset('NonNegative',1,'AbsTol',1e-20);
        dydx = @(x,y) obj.rate_laws(x,y,obj.parameters);
        sol = ode15s(dydx,tspan,obj.y0,options);
        if sol.x(end) < tspan(end)
            tspan = sol.x;
            y = deval(sol,tspan)';
        else
            y = deval(sol,tspan)';
            
        end
    end
 
    x = tspan;
    C_per_cell = 6.023e11*y(:,5)*Vb/N_cells;
    pSTAT = C_per_cell./(C_per_cell + IC_pstat);
    y = [y pSTAT];

end


function [y,sol] = simulate_multiple_doses(obj,tspan,dose_info)
% Simulates multiple s.c. doses as specified by dose_info.  Must be changed
% for other dose types. No fixed bioavailability.
    dose_amounts = dose_info.dose_amounts;
    dose_days = dose_info.dose_days;
    n_doses = length(dose_amounts);
    n_species = length(obj.y0);
    t_keep = tspan;
%     tspan = sort(unique([tspan, dose_days, dose_days(end) + (dose_days(end) - dose_days(end-1))]));
    tspan = sort(unique([tspan, dose_days, dose_days(end) + 1]));
    y = obj.y0.*ones(length(tspan),n_species);
    Vs = obj.parameters.Vs;
    for ii = 1:n_doses
        if ii == n_doses
          timepoints = tspan(tspan >= dose_days(ii));
        else
          timepoints = [tspan(tspan >= dose_days(ii) & tspan <= dose_days(ii+1))];
        end
%         time_beginning = timepoints(1);
%         timepoints = timepoints - time_beginning;      
        obj.y0(dose_info.dose_compartment(ii)) = obj.y0(dose_info.dose_compartment(ii)) + dose_amounts(ii)/obj.parameters.(dose_info.dose_compartment_volume(ii));
        options = odeset('NonNegative',1,'AbsTol',1e-20);
        dydx = @(x,y) obj.rate_laws(x,y,obj.parameters);
        sol = ode15s(dydx,timepoints,obj.y0,options);
        y_tmp = deval(sol,timepoints)';   
        if ii == n_doses
            y(tspan >= dose_days(ii),:) = y_tmp;
        else
            y(tspan >= dose_days(ii) & tspan < dose_days(ii+1),:) = y_tmp(1:end-1,:);
        end
        obj.y0 = y_tmp(end,:)';
    end
    
    y = y(ismember(tspan,t_keep),:);
end