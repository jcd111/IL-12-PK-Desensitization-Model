classdef modelstructure
   properties
       rate_laws {mustBeA(rate_laws,'function_handle')} = @(x,y,k) x
       parameters {mustBeA(parameters,'struct')} = struct()
       parameter_names {mustBeA(parameter_names,["cell","string"])} = {}
       bounds {mustBeA(bounds,'struct')} = struct()
       experimental_data {mustBeA(experimental_data,'cell')} = {}
       metric_data {mustBeA(metric_data,'cell')} = {};
       data_species{mustBeNumeric} = []
       species_names{mustBeA(species_names,["cell","string"])} = {};
       y0 {mustBeNumeric} = 0
       eval_function {mustBeA(eval_function,'function_handle')} = @(obj,tspan) normal_eval(obj,tspan)
       dose_schedules {mustBeA(dose_schedules,'cell')} = {};

   end
   
   
   methods

       function obj = modelstructure(varargin)
           p = inputParser;
           checkName = @(x) ischar(x) || isstring(x) || iscell(x);
           checkNameOrCell = @(x) ischar(x) || isstring(x) || ...
               (iscell(x) && ( ischar(x{1}) || isstring(x{1}) ) );
           checkBool = @(x) islogical(x) || isnumeric(x);
           checkFunction = @(x)isa(x,'function_handle');
           checkNumOrCell = @(x) isnumeric(x) || iscell(x);
           checkStruct = @(x) isa(x,'struct');
           
           addParameter(p,'rate_laws',@(x,y,k) x,checkFunction);
           addParameter(p,'parameters',struct(),checkStruct);
           addParameter(p,'parameter_names',{},checkName);
           addParameter(p,'bounds',struct(),checkStruct);
           addParameter(p,'experimental_data',{},@iscell);
           addParameter(p,'metric_data',{},@iscell);
           addParameter(p,'y0',0,@isnumeric);
           addParameter(p,'eval_function',@(obj,tspan) normal_eval(obj,tspan), checkFunction);
           addParameter(p,'data_species',[],@isnumeric);
           addParameter(p,'species_names',{},checkNameOrCell);
           addParameter(p,'dose_schedules',{},@iscell);
           p.KeepUnmatched = false;
           p.CaseSensitive = false;
           
           parse(p,varargin{:});
           
           obj.rate_laws = p.Results.rate_laws;
           obj.y0 = p.Results.y0;
           obj.parameter_names = p.Results.parameter_names;
           obj.parameters = p.Results.parameters;
           obj.bounds = p.Results.bounds;
           obj.experimental_data = p.Results.experimental_data;
           obj.metric_data = p.Results.metric_data;
           obj.eval_function = p.Results.eval_function;
           obj.data_species = p.Results.data_species;
           obj.species_names = p.Results.species_names;
           obj.dose_schedules = p.Results.dose_schedules;
           
       end
       
       function [x,y,sol] = evaluate(obj,tspan,condition)
           
           dose_info = obj.dose_schedules{condition};
           [x,y,sol] = obj.eval_function(obj,tspan,dose_info);

       end

       
       
       function plot_experimental_data(obj,conditions,species,titles,y_label,figure_number)
           count = 1;
           for ii = 1:length(conditions)
               for jj = 1:length(species)
                   x_plot = obj.experimental_data{conditions(ii)}{jj}{1};
                   y_plot = obj.experimental_data{conditions(ii)}{jj}{2};
                   f = figure(figure_number);
                   subplot(length(conditions),length(species),count);

                   plot(x_plot,y_plot,'o-','LineWidth',1.5)
                   title(titles(count));
                   count = count+1;
               end
           end
           han = axes(f,'visible','off');
           han.Title.Visible = 'on';
           han.XLabel.Visible = 'on';
           han.YLabel.Visible = 'on';
           xlabel(han,'Time (days)')
           ylabel(han,y_label);
       end
   end
end