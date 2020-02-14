%% VPP
% Based off of Princibles of Yacht Design, Figure 16.1.
%
% Sailboat Design Group, 2018

%% VPP Function
function B = VPP(Ut, thetat, B, S)
% Ut, True wind velocity in m/s
% thetat, true wind angle in degree

maxIter = 30;
convTol = 0.05; %Convergence Tolerance (percent)

rhoa = 1.225; %Density of air, kg/m^3
rhow = 1025; %Density of water, kg/m^3

debug = 0;

% Correct for error at thetat = 180
if thetat == 180
    thetat = 179.99;
end

% -------- BEGIN SPEED LOOP --------
% Debug
if debug == 1
    speedConvergence = figure;
end

% Initalizing spline fits
% This is optimization
[lookup1, lookup2] = createLookup();

minSpeed = 0;
maxSpeed = 20;
iter1 = 0;
while abs((maxSpeed - minSpeed) / minSpeed)*100 > convTol && iter1 < maxIter
    % ----Block 3----
    % Guess Initital Ship Speed, B.V
    B.V = (maxSpeed + minSpeed) / 2; %m/s
    
    % ----Block 4----
    % Apparent Wind Velocity and Direction from Wind Triangle, Fig 5.2
    Ua = sqrt(Ut^2 + B.V^2 - 2*Ut*B.V*cosd(180 - thetat)); %m/s
    thetaa = acosd((B.V^2 - Ut^2 + Ua^2)/(2*B.V*Ua)); %degree
    
    % -------- BEGIN HEEL LOOP --------
    % ----Block 5----
    % Guess Heel Angle
    minHeel = 0; %degree
    maxHeel = 45; %degree
    iter2 = 0;
    S.F = 1; %Flattening Factor
    S.R = 1; %Reefing Factor
    
    % Debug
    if debug == 2
        figure
    end
    while abs((maxHeel - minHeel) / minHeel)*100 > convTol && iter2 < maxIter
        
        heel = (maxHeel + minHeel) / 2; %degree
        
        % Setting flattening and reefing
%         if heel > okHeel %If heeling more than XX deg
%             S.R = S.R - 0.05;
%         end
        
        % ----Block 6----
        % Calculate Uawe and Thetaawe, Fig. 7.22
        V1 = Ut + Ut.*cosd(thetat); %m/s
        V2 = Ut.*sind(thetat).*cosd(heel); %m/s
        Uaw = sqrt(V1.^2 + V2.^2); %m/s
        thetaaw = acosd(V1 ./ Uaw); %Degree
        
        % Aerodynamic Forces from Sail Model, dependent on heel angle
        C = sailLookup(thetaaw, lookup1); %Get Cl and Cd values
        [S.Cl, S.Cd, S.An, S.CEt] = sailCalc(C, S, thetat); %Get total Cl, Cd, Sail area and Center of effort
        S.L = 0.5*rhoa*S.Cl*S.An*Ua^2; %Sail lift force, N
        S.D = 0.5*rhoa*S.Cd*S.An*Ua^2; %Sail drag force, N
        
        % Fig 7.21
        As = S.L*cosd(thetaa) + S.D*sind(thetaa); %Aerodynamic side force, N
        Ar = S.L*sind(thetaa) - S.D*cosd(thetaa); %Aerodynamic driving force, N

        % ----Block 7----
        sailArm = S.CEt - (B.Tc + B.Fave - B.VCG);
        Msail = As*sailArm*cosd(heel); %Heeling moment from sail
        
        Mrestoring = B.disp .* ppval(B.GZ, heel); %Evaluate GZ at heel angle to get restoring arm
        
        keelArm = B.Tkeel*sind(heel);
        Mkeel = B.Mkeel*keelArm; %Restoring moment from keel weight
        
        %Sum of heeling moments
        dif0 = Msail - (Mrestoring + Mkeel);
        
        if dif0 > 0
            minHeel = heel;
        elseif dif0 < 0
            maxHeel = heel;
        end
        
        % Debug
        if debug == 2
            hold on
            plot(heel, Msail, '*k', heel, Mrestoring + Mkeel, 'or')
            xlim([0, 50])
        end
        
        iter2 = iter2 + 1;
    end
    B.heel = heel;
    B.F = S.F;
    B.R = S.R;
    % -------- END HEEL LOOP --------
    if debug == 2
        disp("Heel loop ended in " + string(iter2) + " iterations!");
        disp("Heel angle is " + string(B.heel) + "!");
        disp("Side force: " + string(As) + " N. Driving Force: " + string(Ar) + " N.")
    end

    % ----Block 8----
    % Change in surface area due to heel, PYD Fig 5.26
    B.Sh = heelareaLookup(B); %m^2
    % Frictional Resistances, ITTC 1957
    Rf = frictionCalc(B.V, 0.7*B.Lwl, B.Sh) + frictionCalc(B.V, B.Lkeel, B.Skeel) + frictionCalc(B.V, B.Lrud, B.Srud); %N
    % Roughness Resistance
    Rr = Rf * 0.1; %N
    % Viscous Pressure Resistance
    Rv = Rf * 0.1; %N
    % Residuary/wavemaking Resistance
    Rw = waveLookup(B, lookup2); %N
    % Total resistance
    Rt = Rf + Rr + Rv + Rw; %N
    
    
    % Convergence stuff
    dif1 = Rt - Ar;
    
    if dif1 > 0
        maxSpeed = B.V;
    elseif dif1 < 0
        minSpeed = B.V;
    end
    
    iter1 = iter1 + 1;
    
    % Debug
    if debug == 1
        figure(speedConvergence)
        hold on
        semilogy(B.V, Rt, '.k', B.V, Ar, '.r')
        xlabel("Boat Speed (m/s)")
        ylabel("Force (N)")
        xlim([0, 15])
    end
end

% -------- END SPEED LOOP --------
if iter1 == maxIter
    B.V = 0;
end

if debug == 1
    disp("Speed loop ended in " + string(iter1) + " iterations!")
    disp("Boat speed is " + string(B.V) + " m/s!")
end

% Setting output variables
B.Fn = B.V / sqrt(B.Lwl * 9.81);
B.Re = (B.V*B.Lwl)/(1.18831*10^-6);
B.thetaa = thetaa;
B.As = As;
B.Ar = Ar;
B.Rt = Rt;
B.L = S.L;
B.D = S.D;
B.An = S.An;
B.hCE = S.CEt;
B.Rw = Rw;
B.Rf = Rf;

% ----Block 9----
Ch = hydrosideLookup(B);
B.leeway = atand((As)/(0.5*Ch*rhow*B.V^2*B.Sc)); %Leeway angle, deg
end
