function Ch = hydrosideLookup(B)
% PYD Fig 6.12
T =[0, 2.025, 9.551, 0.631, -6.575;...
    10, 1.989, 6.729, 0.494, -4.745;...
    20, 1.980, 0.633, 0.194, -0.792;...
    30, 1.762, -4.957, -0.087, 2.766];

D = B.T;
Tc = B.Tc;
Sc = B.Sc;

X = T(:,1);
b1 = pchip(X, T(:,2), B.heel);
b2 = pchip(X, T(:,3), B.heel);
b3 = pchip(X, T(:,4), B.heel);
b4 = pchip(X, T(:,5), B.heel);

Ch = b1*(D^2/Sc) + b2*(D^2/Sc)^2 + b3*(Tc/D) + b4*(Tc/D)*(D^2/Sc);
end