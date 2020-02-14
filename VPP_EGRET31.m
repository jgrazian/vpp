clc; close all; clear;
% Add VPP path
addpath('scripts');

%% Set boat parameters
% taken from PYD YD-40
B = struct;
B.Loa = 9.466; %m
B.Lwl = 8.272; %m
B.Bmax = 2.408; %m
B.Bwl = 1.928; %m
B.Tc = 0.476; %m
B.T = 1.5; %m

B.Vol = 3.655; %m^3
B.mc = 3750; %kg
B.disp = B.mc + 105; %kg

B.Sc = 14.86; %m^2
B.S = B.Sc + 2.469; %m^2
B.Aw = 11.089; %m^2

B.Fave = 1.51 - B.Tc; %m
B.Depth = 1.514; %depth, m

B.VCG = 0; %m
B.LCBfpp = 4.116; %m
B.LCFfpp = 4.378; %m

B.Cp = 0.566;
B.Cm = 0.75;

GZs = readGZ("EGRET_GZ.csv");
B.GZ = createGZ(GZs);
B.GM = 0.48; %Metacentric height, m

B.Mkeel = 0.102*3250*9.81; %N
B.Tkeel = B.T - B.Tc; %m
B.Lkeel = 1.00; %m
B.Akeel = 2.496 / 2; %m^2 (one side area)
B.Skeel = 2*B.Akeel; %m^2 (2 sides area)

B.Trud = 1.47;
B.Lrud = 0.50;
B.Arud = B.Lrud*B.Trud;
B.Srud = 2*B.Arud; 

%% Set sail parameters
AR1 = 1.25;
AR2 = 1.5;
[S, SAtoSw] = calcSailParams([0.4, 0.4, 0.2], AR1, AR2, B.S, B.Vol, B.Loa); %Schooner Style
S.LPG = 1;
S.SL = 0;
S.YSD = 0;
S.YSMG = 0;
S.YSF = 0;
S.BMAX = B.Bmax;
S.FA = B.Fave;
S.BAD = 1;
S.EHM = S.P + S.BAD;
S.EMDC = 0.173;
S.BADY = 0.2;

%% Visualize boat
plotBoat(B, S);

%% Run VPP
U = [2 5 10 12]; %True wind speed (m/s)
theta = 0:10:180; %True wind direction (deg)

[Ut, thetat, Vs, heel, leeway, Rt, Rw, Rf, Re, Fn, Bn] = runVPP(U, theta, B, S); %Run VPP code
Vs_kt = Vs.*1.94384;

%% Polar Plot
U1 = Ut(:, :, 1, 1);
theta1 = thetat(:, :, 1, 1);
V1 = Vs(:, :, 1, 1);

figure
polarplot(theta1.*(pi/180), V1.*1.94384)
rticks([0 2 4 6 8 10 12])
hold on

%% Run Reggata
times = ttCalc(U, theta, Vs); %Run reggatas
times = times.*[0.094, 0.144, 0.021, 0.012]; %Multiply regatta time by the %chance of having that particular wind speed
timeTot = sum(sum(times)); %Sum all reggata times

%% Run STIX
% Characteristics Needed for STIX
Bn.hLP = 0.5*Bn.Tc; %Submerged center of pressure
Bn.GZ90 = ppval(B.GZ, 90); %Righting arm at 90deg heel
hc = 0.1; %Height of combing, m
bc = 0.33; %Offset of combing @ max beam, m
Bn.phiD = atand(((B.Depth - B.Tc) - hc)/(0.5*B.Bmax - bc)); %Downflooding angle
Bn.GZD = ppval(Bn.GZ, Bn.phiD); %Righting arm at downflooding angle
r = 50:130;
[~, ind] = min(abs(ppval(Bn.GZ, r)) - 0);
Bn.phiV = ppval(Bn.GZ, r(ind)); %Angle of vanishing stability
Bn.AGZ = integral(@(x) ppval(Bn.GZ, x), 0, Bn.phiV); %Area under positive GZ curve

STIX = stixCalc(Bn); %STIX Calculation
fprintf("The downflooding angle is %.3f deg.\n", Bn.phiD)
fprintf("The STIX index is %.3f.\n", STIX)

%% Calculate Delumbar
As = B.S*SAtoSw;
HA = 4.846 - 0.5*B.Tc; %Heeling arm, distance from sail CE to center of lateral resistance, m
Dell = 279 * (As*HA)/(B.disp*Bn.GM); %Dellenbaugh angle, deg
fprintf("The Dellenbaugh angle is %.3f deg.\n", Dell)