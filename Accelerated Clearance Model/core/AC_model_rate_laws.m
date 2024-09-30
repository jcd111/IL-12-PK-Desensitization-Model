function dydt = AC_model_rate_laws(t,y,k)
% Rate laws for simple receptor FB model with linear FB and i.v. dosing


% initializing species
IL12s = y(1);
IL12l = y(2);
IL12b = y(3);
R = y(4);
C = y(5);

% initializing parameters
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

% Calculating constrained parameters and other initial conditions
kr = kcr*R0;
kdg = (1-F)*Jls/F;

% Calculating number of complexes per cell.
C_per_cell = 6.023e11*Vb*C/N_cells;

% Calculating pSTAT activation
pSTAT = C_per_cell/(C_per_cell+IC_pstat);

dydt = zeros(size(y));

% Subcutaneous IL12
dydt(1) = -Jls*IL12s - kdg*IL12s;

% Lymphatic IL12
dydt(2) = Jls*IL12s*Vs/Vl - Jbl*IL12l;

% Serum IL12
dydt(3) = Jbl*IL12l*Vl/Vb - kon*IL12b*R - kcb*IL12b;

% Serum IL12 Receptor
dydt(4) = N_cells*kr/Vb + N_cells*alpha*pSTAT/Vb - kon*IL12b*R - kcr*R;

% Serum IL12 Receptor Complex
dydt(5) = kon*IL12b*R - kint*C;




end