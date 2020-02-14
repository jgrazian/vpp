function [Ut, thetat, Vs, heel, leeway, Rt, Rw, Rf, Re, Fn, Bn] = runVPP(U, theta, B, S)
% Run VPP function for every U and theta combination
% U is vector of true wind speeds in m/s
% theta is vector of true wind directions in deg
% B is vector of boat structs
% S is vector of sail structs

%% Initializing Arrays
Ut = zeros(length(theta), length(U), length(B), length(S));
thetat = zeros(length(theta), length(U), length(B), length(S));
Vs = zeros(length(theta), length(U), length(B), length(S));
heel = zeros(length(theta), length(U), length(B), length(S));
leeway = zeros(length(theta), length(U), length(B), length(S));
Rt = zeros(length(theta), length(U), length(B), length(S));
Rw = zeros(length(theta), length(U), length(B), length(S));
Rf = zeros(length(theta), length(U), length(B), length(S));
Re = zeros(length(theta), length(U), length(B), length(S));
Fn = zeros(length(theta), length(U), length(B), length(S));

Bn = B;

%% Looping VPP
for i = 1:length(B) %Loop through B vector
    for j = 1:length(S) %Loop through S vector
        for m = 1:length(U)
            for n = 1:length(theta)
                
                tic
                % Main VPP run -> New B struct
                Bn = VPP(U(m), theta(n), B(i), S(j));
                
                % Fill in arrays
                Ut(n,m,i,j) = U(m);
                thetat(n,m,i,j) = theta(n);
                Vs(n,m,i,j) = Bn.V;
                heel(n,m,i,j) = Bn.heel;
                leeway(n,m,i,j) = Bn.leeway;
                Rt(n,m,i,j) = Bn.Rt;
                Rw(n,m,i,j) = Bn.Rw;
                Rf(n,m,i,j) = Bn.Rf;
                Re(n,m,i,j) = Bn.Re;
                Fn(n,m,i,j) = Bn.Fn;
                
                runTime = toc;
                disp("B: " + string(i) + " S: " + string(j) + " U: " + string(U(m)) + " Theta: " + string(theta(n)) + " Time: " + string(runTime));
            end
        end
    end
end

end