# IL-12-PK-Desensitization-Model
MATLAB code used in "Uncovering the Interleukin-12 Pharmacokinetic Desensitization Mechanism and Its Consequences with Mathematical Modeling" by Jonathon DeBonis, Omid Veiseh, and Oleg Igoshin.

Includes modelstructure class object used for model simulation, example scripts for creating models, simulating models, and optimizing parameters using global optimization or local ensemble-based optimization.

Guide:

build_XX_model -- scripts containing examples for how to build modelstructure class object with experimental data and dose schedules for a specific clinical trial.

example_simulation_script -- example script for simulating model.

example_global_optimization_script -- example script for estimating model parameters via global optimization to clinical trial data.

example_ensemble_optimization_script -- example script for estimating model parameters via local ensemble optimization to clinical trial data.

Functions -- folder containg all functions needed for model simulation and optimization:

modelstructure -- class object used to store model information and simulate models.

calc_metric_fitness() -- error function for fitting model predictions to PK metric data.

calculate_PK_metrics() -- function for calculating PK metrics given a model including Cmax, Tmax, and AUC.

calc_timecourse_fitness() -- error function for fitting model predictions to PK timecourse data.

se() -- function used to calculate standard square error.

nse() -- function used to calculate normalized squared error.

optimize_fit() -- function used to implement global optimization with MATLAB's particleswarm algorithm, initial ensemble generation, and local optimziation with MATLAB's patternsearch algorithm.

