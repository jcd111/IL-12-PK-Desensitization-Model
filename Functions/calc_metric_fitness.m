function err = calc_metric_fitness(model,k_opt,varargin)
% Function for calculating model error in predicting species PK/PD metrics
% (Cmax, AUC, Tmax) given a set of parameters.

    p = inputParser;
    checkName = @(x) ischar(x) || isstring(x) || iscell(x);
    checkNameOrCell = @(x) ischar(x) || isstring(x) || ...
        (iscell(x) && ( ischar(x{1}) || isstring(x{1}) ) );
    checkBool = @(x) islogical(x) || isnumeric(x);
    checkFunction = @(x)isa(x,'function_handle');
    checkNumOrCell = @(x) isnumeric(x) || iscell(x);
    checkModel = @(x)isa(x,'modelstructure');
    
    addRequired(p,'model',checkModel)
    addRequired(p,'k_opt',@isnumeric)
    addParameter(p,'params_to_opt',{},checkName)
    addParameter(p,'conditions_to_opt',[],@isnumeric)
    addParameter(p,'species_to_opt',[],@isnumeric)
    addParameter(p,'condition_weights',[],@isnumeric);
    
    p.KeepUnmatched = false;
    p.CaseSensitive = false;
    
    parse(p, model,k_opt, varargin{:});
    
    model = p.Results.model;
    k_opt = p.Results.k_opt;
    params_to_opt = p.Results.params_to_opt;
    conditions_to_opt = p.Results.conditions_to_opt;
    species_to_opt = p.Results.species_to_opt;
    condition_weights = p.Results.condition_weights;
    
    
    err = 0;
    
    metric_data = model.metric_data(conditions_to_opt);
    
    for condition = 1:length(metric_data)
        % Getting Metric data for condition
        condition_data = metric_data(condition);
        % Setting model parameters
        model = set_model_parameters(model,params_to_opt,k_opt);
        % intializing error vector
        err_temp = zeros(1,length(condition_data));    
        for ii = 1:length(species_to_opt)
            % Getting metrics for this condition
            m_exp = condition_data{species_to_opt(ii)};
%             % Initializing each metric.
            Cmax = m_exp.Cmax;
            Cmax_sd = m_exp.Cmax_sd;
            Tmax = m_exp.Tmax;
            Tmax_sd = m_exp.Tmax;
            AUC = m_exp.AUC;
            AUC_sd = m_exp.AUC_sd;
            t = m_exp.dose_window;
            % Making model predictions of PK metrics
            
            model_predictions = calculate_PK_metrics(model,t,conditions_to_opt(condition),model.data_species(species_to_opt(ii)));
            
            Cmax_predicted = model_predictions.Cmax;
            Tmax_predicted = model_predictions.Tmax;
            AUC_predicted = model_predictions.AUC;
            % Calculating error if there is data for each of the three
            % measurements.
            tmp1 = 0;
            if ~isempty(Cmax)
                Cmax_error = ((Cmax_predicted/Cmax-1).^2)./(1+(Cmax_sd/Cmax)^2);
                tmp1 = tmp1 + Cmax_error;
            end
            if ~isempty(AUC)
                AUC_error = ((AUC_predicted/AUC-1).^2)./(1+(AUC_sd/AUC)^2);
                tmp1 = tmp1+AUC_error;
                  
            end
            if ~isempty(Tmax)
                Tmax_error = ((Tmax_predicted/Tmax-1).^2)./(1+(Tmax_sd/Tmax)^2);
                tmp1 = tmp1+Tmax_error;
            end
            
            err_temp(ii) = tmp1;      
        end
        
        err = err +  condition_weights(conditions_to_opt(condition))*mean(err_temp);
        
        
    end
    
end

function model_out = set_model_parameters(model,params_to_opt,k)
        for ii = 1:length(params_to_opt)
            model.parameters.(params_to_opt{ii}) = k(ii);
        end
        
        model_out = model;
end