function [Cl, Cd, An, CEt] = sailCalc(C, S, theta)
% Sail calculations from PYD Fig 7.19

% Assigning Variables
Clm = C(1); Clj = C(2); Cls = C(3); Cly = C(4); Clys = C(5);
Cdm = C(6); Cdj = C(7); Cds = C(8); Cdy = C(9); Cdys = C(10);

P = S.P; E = S.E; I = S.I; J = S.J;
LPG = S.LPG; SL = S.SL; PY = S.PY; EY = S.EY;
YSD = S.YSD; YSMG = S.YSMG; YSF = S.YSF; BMAX = S.BMAX;
FA = S.FA; EHM = S.EHM; EMDC = S.EMDC; BAD = S.BAD; BADY = S.BADY;

% Areas
Am = 0.5*P*E; %Mainsail
Aj = 0.5*sqrt(I^2 + J^2)*LPG; %Jib
As = 1.15*SL*J; %Spinnaker
Ay = 0.5*PY*EY; %Mizzen
Ays = 0.5*YSD*(YSMG+YSF); %Mizzen staysail
Af = 0.5*I*J; %Foretriangle
An = Af + Am + Ay; %Nominal area

% Center of efforts
CEm = (0.39*P + BAD)*S.R; %Mainsail
CEj = (0.39*I)*S.R; %Jib
CEs = (0.59*I)*S.R; %Spinnaker
CEy = (0.39*PY + BADY)*S.R; %Mizzen
CEys = (0.39*PY + BADY)*S.R; %Mizzen staysail
CEt = (CEm*Am + CEj*Aj + CEs*As + CEy*Ay + CEys*Ays)/(Am + Aj + As + Ay + Ays);

% Coeff of Lift
Cl = (Clm*Am + Clj*Aj + Cls*As + Cly*Ay + Clys*Ays)/An;
Cl = Cl*S.F*S.R^2; %Applying reefing and flattening

% Coeff of Drag
Cdp = (Cdm*Am + Cdj*Aj + Cds*As + Cdy*Ay + Cdys*Ays)/An;
Cdp = Cdp*S.R^2;

% If close hauled, else other courses
if theta < 45
    AR = (1.1*(EHM+FA))^2/An;
else
    AR = (1.1*(EHM))^2/An; 
end

Cdi = Cl^2 * (1/(pi*AR) + 0.005);
Cdo = 1.13 * (BMAX*FA + EHM*EMDC)/An;
Cd = Cdp + Cdi + Cdo;
end