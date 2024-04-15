function [x,y,sol] = RB_model_eval_function(obj,tspan,dose_info)
% Eval function for lymphatic transport model with receptor upregultaion
% via STAT4 signaling and subcutaneous administration.

    k = obj.parameters;
    Jls = k.Jls;
    Jbs = k.Jbs;
    Jbl = k.Jbl;
    kon = k.kon;
    kcr = k.kcr;
    kint = k.kint;
    kcb = k.kcb;
    R0 = k.R0;
    alpha = k.alpha;
    Vs = k.Vs;
    Vl = k.Vl;
    Vb = k.Vb;
    F = k.F;
    N_cells = k.N_cells;
    IC_pstat = k.IC_pstat;

    % Calculating constrained parameters and other initial condition
    kr = kcr*R0;
    
    % Setting initial conditions, assuming no basal stat4 activation.
    obj.y0 = [0,0,N_cells*R0/Vl,0,0];
    
    if length(dose_info.dose_days) > 1
        [y,sol] = simulate_multiple_doses(obj,tspan,dose_info);
    else
        obj.y0(1) = dose_info.dose_amounts;
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
    
    y = [y (6.023e11*y(:,4)*Vl/N_cells)./(IC_pstat+6.023e11*y(:,4)*Vl/N_cells)];
end  
%     else
%         
%         obj.y0(1) = dose_info.dose_amounts/Vs;
%         options = odeset('NonNegative',1);
%         dydx = @(x,y) obj.rate_laws(x,y,obj.parameters);
%         sol = ode15s(dydx,tspan,obj.y0,options);
%         
%         y = deval(sol,tspan)';
%         x = tspan;
%     end
%  



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
        obj.y0(1) = obj.y0(1) + dose_amounts(ii)/Vs;
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