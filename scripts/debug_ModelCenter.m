clc; close all;
%% Conversion
toM = 0.3048;
toM2 = 0.09290304;

%% Set boat parameters
% taken from PYD YD-40
B.name = "1";
%B.Loa = 0;
B.Lwl = 26.90 * toM;
B.Bmax = 7.15 * toM;
B.Bwl = 6.12 * toM;
B.Tc = 0.99 * toM;
B.T = 6.19 * toM;
B.Vol = 12.8;
%B.mc = 7820;
B.Sc = 45.969; % <---------------
B.S = 45.969; % <---------------
B.Aw = 15.0; % <---------------
%B.m = 8120;
B.disp = B.Vol*1025*9.81;

B.VCG = 2.07 * toM;
B.LCBfpp =  14.48 * toM;
B.LCFfpp = 14.88 * toM;

B.Cp = 0.56;
B.Cm = 0.53;

B.Tkeel = (B.T - B.Tc);
B.Lkeel = 0; %Length of keel
B.Akeel = B.Tkeel*B.Lkeel;
B.Skeel = 3.90;

B.Trud = 1.47*B.Tc/0.57;
B.Lrud = 0.5*B.Tc/0.57;
B.Arud = B.Lrud*B.Trud;
B.Srud = 2*B.Arud; 

%% Set sail parameters
S.E = 20.81 * toM;
S.P = 54.14 * toM;
S.J = 12.18 * toM;
S.I = 40.60 * toM;
S.LPG = 6.45 * toM;
S.SL = 16.6 * toM;
S.PY = 0 * toM;
S.EY = 0 * toM;
S.YSD = 0 * toM;
S.YSMG = 0 * toM;
S.YSF = 0 * toM;
S.BMAX = B.Bmax * toM;
S.FA = 3.46 * toM;
S.EHM = 16.9 * toM;
S.EMDC = 0.173 * toM;
S.BAD = 0 * toM;
S.BADY = 0 * toM;

%% ---- RUN VPP ----
dps = 10;
thetas = linspace(0, 180, dps);

Resistance = zeros(length(thetas), 1);
Lift = zeros(length(thetas), 1);
Drag = zeros(length(thetas), 1);
SideForce = zeros(length(thetas), 1);
Drivingforce = zeros(length(thetas), 1);
Heel = zeros(length(thetas), 1);
boatspeeds = zeros(length(thetas), 1);

for i = 1:length(thetas)
    theta = thetas(i);
    Bn = VPP_03(5, theta, B, S);
    
    Resistance(i) = Bn.Rt;
    Lift(i) = Bn.L;
    Drag(i) = Bn.D;
    SideForce(i) = Bn.As;
    Drivingforce(i) = Bn.Ar;
    Heel(i) = Bn.heel;
    boatspeeds(i) = Bn.V;
end

% Resistance = Bn.Rt;
% Lift = Bn.L;
% Drag = Bn.D;
% SideForce = Bn.As;
% Drivingforce = Bn.Ar;
% Heel = Bn.heel;
% boatspeeds = Bn.V;
Convergence = 0;
SpeedfactorB = 0;
SpeedfactorC = 0;