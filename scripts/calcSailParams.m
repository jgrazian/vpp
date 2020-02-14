function [S, SAtoSw, SAtoVol] = calcSailParams(areaBreakdown, AR1, AR2, Sw, Vol, Loa)
% Calculates sail parameters based of of Sail Area to Wetted Surace Area
% and Sail Area to Vol^1/3 ratios
% Inputs: areaBreakdown - vector of % Area Main Mizzen and Jib
%         Sw - wetted surface area
%         Vol - Displacement volume
% example: [.4, .5,.1]

%% Setup
percentMain = areaBreakdown(1);
percentMizzen = areaBreakdown(2);
percentJib = areaBreakdown(3);

forestay = 1; % 1m forestay

%% Calculating corresponding parameters
L = Loa + forestay;

% Main
E = percentMain*L;
P = AR1*E;

% Mizzen
EY = percentMizzen*L;
PY = AR2*EY;

% Jib
I = P;
J = percentJib*L;

%% Assigning S values
S.E = E;
S.P = P;
S.EY = EY;
S.PY = PY;
S.J = J;
S.I = I;

%% Area Calc
areaMain = 0.5*E*P;
areaMizzen = 0.5*EY*PY;
areaJib = 0.5*I*J;
area = areaMain + areaMizzen + areaJib;

SAtoSw = area / Sw;
SAtoVol = area / Vol^(1/3);

end