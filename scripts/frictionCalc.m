function R = frictionCalc(V, L, S)
% ITTC 1957 friction line
% V - Ship Speed
% L - LWL
% S - Surface Area

rho = 1025; %kg/m^3
% nu = 1.18831*10^-6; %m^2/s
nu = 0.000012254;

Re = (V*L)/nu; %Reynolds Number
Cf = 0.075/(log10(Re)-2)^2; %Coef of Friction (ITTC 1957)
R = 0.5*Cf*rho*S*V^2; %Resistance Force, N
end