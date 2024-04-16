# IL-12-PK-Desensitization-Model
MATLAB code used in "Uncovering the Interleukin-12 Pharmacokinetic Desensitization Mechanism and Its Consequences with Mathematical Modeling" by Jonathon DeBonis, Omid Veiseh, and Oleg Igoshin.

Includes modelstructure class object used for model simulation, example scripts for creating models, simulating models, and optimizing parameters using global optimization or local ensemble-based optimization.

Guide:
build_XX_model -- scripts containing examples for how to build modelstructure class object with experimental data and dose schedules for a specific clinical trial.
example_simulation_script -- example script for simulating model.
example_global_optimization_script -- example script for estimating model parameters via global optimization to clinical trial data.
example_ensemble_optimization_script -- example script for estimating model parameters via local ensemble optimization to clinical trial data.
Functions -- folder containg all functions needed for model simulation and optimization.
