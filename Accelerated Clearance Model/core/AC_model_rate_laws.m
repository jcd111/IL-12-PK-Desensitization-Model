function dydt = SU_model_rate_laws(t,y,k)
% Rate laws for simple receptor FB model with linear FB and i.v. dosing


% initializing species
IL12s = y(1);
IL12b = y(2);
R = y(3);
C = y(4);

% initializing parameters
Jbs = k.Jbs;
F = k.F;
kon = k.kon;
kcb = k.kcb;
R0 = k.R0;
alpha = k.alpha;
kcr = k.kcr;
kint = k.kint;
Vb = k.Vb;
Vs = k.Vs;
IC_pstat = k.IC_pstat;
N_cells = k.N_cells;

% Calculating constrained parameters and other initial conditions
kr = kcr*R0;
kdg = (1-F)*Jbs/F;

% Calculating number of complexes per cell.
C_per_cell = 6.023e11*Vb*C/N_cells;

% Calculating pSTAT activation
pSTAT = C_per_cell/(C_per_cell+IC_pstat);

dydt = zeros(size(y));

% Subcutaneous IL12
dydt(1) = -Jbs*IL12s - kdg*IL12s;

% Serum IL12
dydt(2) = Jbs*IL12s*Vs/Vb - kon*IL12b*R - kcb*IL12b;

% Serum IL12 Receptor
dydt(3) = N_cells*kr/Vb + N_cells*alpha*pSTAT/Vb - kon*IL12b*R - kcr*R;

% Serum IL12 Receptor Complex
dydt(4) = kon*IL12b*R - kint*C;




end