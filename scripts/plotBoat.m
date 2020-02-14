function plotBoat(B, S)
% Draws a rough picture of the sailboat
% Inputs: B - Boat Struct
%         S - Sail Struct

%% Assigning Variables
% Boat
Loa = B.Loa; %Length overall
Lwl = B.Lwl; %Length waterline
Fb = B.Fave; %freeboard

%Sail
E = S.E; %Foot of mainsail
P = S.P; %Mainsail hoist
EY = S.EY; %Foot of mizzen
PY = S.PY; %Mizzen Hoist
I = S.I; %Heigth of foretriangle
J = S.J; %Base of foretriangle
BAD = S.BAD; %Boom above sheer

%% Drawing Boat
figure
hold on

sternRake = 15; %deg
bowRake = 30; %deg

bp1 = [0; Fb]; %top teft
bp2 = [Fb*sind(sternRake); 0]; %bottom left
bp3 = [Fb*sind(sternRake) + Lwl; 0]; %bottom right
bp4 = [Loa; Fb]; %top right

bX = [bp1(1); bp2(1); bp3(1); bp4(1); bp1(1)];
bY = [bp1(2); bp2(2); bp3(2); bp4(2); bp1(2)];
plot(bX, bY);

%% Drawing Mizzen
yp1 = [0; Fb + BAD]; %Bottom left
yp2 = [EY; Fb + BAD]; %Bottom right
yp3 = [EY; Fb + BAD + PY]; %Top rigth

yX = [yp1(1); yp2(1); yp3(1); yp1(1)];
yY = [yp1(2); yp2(2); yp3(2); yp1(2)];
plot(yX, yY , 'k');

%% Drawing Foretriangle
fp1 = [EY + E + J; Fb + 0.5*BAD]; %bottom right
fp2 = [EY + E; Fb + 0.5*BAD + I]; %top left
fp3 = [EY + E; Fb + 0.5*BAD]; %bottom left

fX = [fp1(1); fp2(1); fp3(1); fp1(1)];
fY = [fp1(2); fp2(2); fp3(2); fp1(2)];
plot(fX, fY, 'k');

%% Drawing Main
mp1 = [EY + E; Fb + BAD]; %bottom right
mp2 = [EY + E; Fb + BAD + P]; %top right
mp3 = [EY; Fb + BAD]; %bottom left

mX = [mp1(1); mp2(1); mp3(1); mp1(1)];
mY = [mp1(2); mp2(2); mp3(2); mp1(2)];
plot(mX, mY, 'k');
end