[lC, lA] = createLookup();

% figure
% for i = 0:100/180:180
%     C = sailLookup(i); %Get Cl and Cd values
%     [S.Cl, S.Cd, S.An, S.CEt] = sailCalc(C, S); %Get total Cl, Cd, Sail area and Center of effort
%     
%     hold on
%     plot(i, S.Cl, '.k')
%     plot(i, S.Cd, '.r')
% end

figure
for i = 1:.01:8
    B.V = i;
    [Rw, Rwc, Rwk] = waveLookup(B, lA);
    
    Rf = frictionCalc(B.V, 0.7*B.Lwl, B.Sc) + frictionCalc(B.V, B.Lkeel, B.Skeel) + frictionCalc(B.V, B.Lrud, B.Srud); %N
    % Roughness Resistance
    Rr = Rf * 0.1; %N
    % Viscous Pressure Resistance
    Rv = Rf * 0.1; %N
    
    Rt = Rf + Rr + Rv + Rw;
    
    Fn = B.V/sqrt(9.81*B.Lwl);
    hold on
    plot(Fn, Rw, '.r', Fn, Rf, '.b', Fn, Rt, '.k', Fn, Rwc, '.g', Fn, Rwk, '.m')
end