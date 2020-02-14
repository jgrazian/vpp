function STIX = stixCalc(B)

%STIX/Dellenbaugh

LH=B.Loa;
BH=B.Bmax;
BWL=B.Bwl;
m=B.disp;
mMO=B.disp;
mLA=B.disp;
hCE=B.hCE;
hLP=B.hLP;
GZ90=B.GZ90;
phiV=B.phiV;
phiD=B.phiD;
LWL=B.Lwl;
AS=B.An;
AGZ=B.AGZ;
GZD=B.GZD;



% LH=hull length (m) excluding bolted on extensions
% LWL=hull length (m) along wl
% BH=hull width (m)
% BWL=beam waterline (m)
% m=mass of boat (kg) where more than one loading is considered
% mMO=mass of the boat (kg) in minimum operating condition
% mLA=mass of the boat (kg) in loaded arrival condition
% hCE=height of cnetre of sail area above wl when boat is upright
% hLP=height of centre of lateral area below wl when boat is upright
% GZ90=righting arm at 90 degree heel
% GZD= righting arm at phiD
% phiV=angle of vanishing stability
% phiD=first occurring downflooding angle (ISO 12217-2 standard)
% LBS=base length factor

%%%Base Length Factor: [12.26]
LBS=(LH+(2*LWL))/3;

%%%%Displacement Length Factor: [.905]
FL=(LBS/11)^.2;

FDL=(.6+((15*m*FL)/(LBS^3*(333-8*LBS))))^.5;

%.75<FDL<1.25




%%%Beam Displacement Factor:[.831]
FB=(3.3*BH)/((.03*m)^(1/3));

if FB>2.2
    FBD=((13.31*BWL)/(BH*(FB^3)))^.5;
elseif FB<1.45
    FBD=((BWL*(FB^2)/(1.682*BH)))^.5;
elseif 1.45<=FB&&FB<=2.2
    FBD=1.118*((BWL/BH)^.5);
end



%%%Knockdown Recovery Factor:[1.216]
FR=(GZ90*m)/(2*AS*hCE);
%%%.5<FKR<1.5
if FR>=1.5
    FKR=.875+(.0883*FR);
elseif FR<1.5
    FKR=.5+(.333*FR);
elseif phiV<90
    FKR=.5;
end


%%%Inversion Recovery Factor:[1.090]
%%%.4<FIR<1.5
if m<40000
    FIR=phiV/(125-m/1600);
elseif m>=40000
    FIR=phiV/100;
end


%%%Dynamic Stability Factor:[1.183]
%%%.5<FDS<1.5

FDS=(AGZ/15.81*sqrt(LH))^.3;

%AGZ=the positive area under the GZ curve (m. deg.) as follows:...
%from upright to \_{V}, for the appropriate loading condition


%%%Wind Moment Factor:[1.00]
%%%.5<FWM<1.0

VAW=((13*m*GZD)/(AS*(hCE+hLP)*((cos(phiD))^1.3)))^.5;

if phiD>90
    FWM=1;
elseif phiD<90
    FWM=VAW/17;
end

%VAW=the steady apparent windspeed to heel the vessel to \_{D} when ...
%carrying full sail



%%%Downflooding Factor:[1.25]
%%%.5<FDF<1.25

FDF=phiD/90;
%
% Design Categories: A, B, C, D
% STIX Lower Limits: 32, 23, 14, 5

if FDL<.75
    %disp("FDL too low")
    FDL=.75;
elseif FDL>1.25
    %disp(["FDL too high",FDL])
    FDL=1.25;
end

if FBD<.75
    %disp(["FBD too low",FB])
    FBD=.75;
elseif FBD>1.25
    %disp("FBD too high")
    FBD=1.25;
end

if FKR<.5
    %disp("FKR too low")
    FKR=.5;
elseif FKR>1.5
    %disp("FKR too high")
    FKR=1.5;
end

if FIR<.4
    %disp("FIR too low")
    FIR=.4;
elseif FIR>1.5
    %disp("FIR too high")
    FIR=1.5;
end

if FDS<.5
    %disp("FDS too low")
    FDS=.5;
elseif FDS>1.5
    %disp("FDS too high")
    FDS=1.5;
end

if FWM<.5
    %disp("FWM too low")
    FWM=.5;
elseif FWM>1
    %disp("FWM too high")
    FWM=1;
end


if FDF<.5
    %disp("FDF too low")
    FDF=.5;
elseif FDF>1.25
    %disp("FDF too high")
    FDF=1.25;
end


STIX=(7+(2.25*LBS))*((FDL*FKR*FIR*FDS*FWM*FDF)^(.5));

end
