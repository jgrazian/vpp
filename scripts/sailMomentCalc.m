function [Msail] = sailMomentCalc(S, As, BS, heel)
% Calcuate heeling moment of sails
% S is sail struct
% As is aerodynamic side force (N)
% BS is distance from VCG to sheer (m)
% heel is heel angle (deg)

A = S.A;
CE = S.CE;
p = As.*(A./S.An);

Msail = sum(p.*(CE + BS).*cosd(heel).^2);
end