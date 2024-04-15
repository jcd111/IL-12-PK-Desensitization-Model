function dydt = RB_model_rate_laws(t,y,k)
% Rate laws for simple receptor FB model with linear FB and i.v. dosing


% initializing species
S = y(1);
L = y(2);
R = y(3);
C = y(4);
B = y(5);

% initializing parameters
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

% Calculating constrained parameters and other initial conditions
kr = kcr*R0;
kdg = (1-F)*Jls/F;
dydt = zeros(size(y));

% Calculating pSTAT activation based on Q.S.S.
pSTAT = (6.023e11*C*Vl/N_cells)/(IC_pstat+6.023e11*C*Vl/N_cells);

% Subcutaneous IL12
dydt(1) = -Jls*S - Jbs*S - kdg*S;

% Lymphatic IL-12
dydt(2) = Jls*S*(Vs/Vl) - kon*L*R - Jbl*L;

% Lymphatic IL12 Receptor
f = alpha*pSTAT;
dydt(3) = kr*N_cells/Vl + N_cells*f/Vl - kon*R*L - kcr*R;

% Lymphatic IL-12 Receptor Complex
dydt(4) = kon*L*R - kint*C;

% Serum IL-12
dydt(5) = Jbl*L*(Vl/Vb) - kcb*B;






end