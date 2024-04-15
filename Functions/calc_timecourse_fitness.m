function [err] = calc_timecourse_fitness(model,k_opt, varargin)

    % creating input parser and parsing functions
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
    addParameter(p,'error_limit',[],@isnumeric)
    addParameter(p,'func',@(x) x, checkFunction)
    addParameter(p,'conditions_to_opt',[],@isnumeric)
    addParameter(p,'species_to_opt',[],@isnumeric)
    addParameter(p,'condition_weights',[],@isnumeric);
    
    p.KeepUnmatched = false;
    p.CaseSensitive = false;
    
    parse(p, model,k_opt, varargin{:});
    
    model = p.Results.model;
    k_opt = p.Results.k_opt;
    params_to_opt = p.Results.params_to_opt;
    error_limit = p.Results.error_limit;
    func = p.Results.func;
    conditions_to_opt = p.Results.conditions_to_opt;
    species_to_opt = p.Results.species_to_opt;
    condition_weights = p.Results.condition_weights;

    experimental_data = model.experimental_data(conditions_to_opt);
    %intializing error
    err = 0;
    %iterating through each physiological condition
    for condition = 1:length(experimental_data)
        condition_data = experimental_data{condition};
        %getting parameters for this condition
        model = set_model_parameters(model,params_to_opt,k_opt);
        % temporary error matrix corresponding to each species
        err_temp = zeros(1,length(condition_data));
        % iterating through each species
        for ii = 1:length(species_to_opt)
            % if there is data for the compartment, calculating error
                % getting data corresponding to the compartment and
                % physiological condition
                c_exp = condition_data{species_to_opt(ii)}{2};
                t_exp = condition_data{species_to_opt(ii)}{1};
  
                % predicted concentrations at experimental time points.
                % can probably make this faster just get it working for now
                [x,model_predictions] = model.evaluate(t_exp,conditions_to_opt(condition));
                if x(end) ~=  t_exp(end)
                    err = 1000000;
                    return
                end
                model_predictions = model_predictions(:,model.data_species(species_to_opt(ii)));
               % iterating through each experimental point.
                for jj = 1:length(model_predictions)
                    if c_exp(jj) >= error_limit
                        err_temp(ii) = err_temp(ii) + func(model_predictions(jj),c_exp(jj));
                    else
                        if model_predictions(jj) < error_limit && c_exp(jj) < error_limit
                            continue
                        else              
                            err_temp(ii) = err_temp(ii) + heaviside(model_predictions(jj) - error_limit) * func(model_predictions(jj),error_limit);

                        end
                    end
                end
        end
        err = err +  condition_weights(conditions_to_opt(condition))*mean(err_temp);
    end
end
    

    
    

function y = heaviside(x)
% heaviside: custom implementation of the Heaviside step function
% y = heaviside(x)
% inputs:
%   x = input value
% outputs:
%   y = output value
if x < 0
    y = 0;
else
    y = 1;
end
end


function model_out = set_model_parameters(model,params_to_opt,k)
        for ii = 1:length(params_to_opt)
            model.parameters.(params_to_opt{ii}) = k(ii);
        end
        
        model_out = model;
end



