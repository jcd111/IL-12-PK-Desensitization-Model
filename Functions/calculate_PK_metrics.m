function outstruct = calculate_PK_metrics(model,dose_window,condition,species)

    tspan = linspace(dose_window(1),dose_window(2),1000);
    
    [tspan,model_predictions] = model.evaluate(tspan,condition);
    
    model_predictions = model_predictions(:,species);
    
    [outstruct.Cmax,ind] = max(model_predictions);
    
    outstruct.Tmax = tspan(ind);
    
    outstruct.AUC = trapz(tspan,model_predictions);
    
    
    



end