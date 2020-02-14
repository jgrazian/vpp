function [C, lC, Clm, Clj, Cls, Clmiz, Clmizs, Cdm, Cdj, Cds, Cdmiz, Cdmizs] = sailLookup(theta, lC)
% Lookup values from PYD Table 7.1 a&b

%     % Table a
%     Ta=[0.0, 1.5, 1.5, 0.0, 1.3, 0.0;...
%         27, 1.5, 1.5, 0.0, 1.3, 0.0;...
%         50, 1.5, 0.5, 1.5, 1.4, 0.75;...
%         80, 0.95, 0.3, 1.0, 1.0, 1.0;...
%         100, 0.85, 0.0, 0.85, 0.8, 0.8;...
%         180, 0.0, 0.0, 0.0, 0.0, 0.0];
%     % Table b
%     Tb=[0.0, 0.0, 0.0, 0.0, 0.0, 0.0;...
%         27, 0.02, 0.02, 0.0, 0.02, 0.0;...
%         50, 0.15, 0.25, 0.25, 0.15, 0.1;...
%         80, 0.8, 0.15, 0.9, 0.75, 0.75;...
%         100, 1.0, 0.0, 1.2, 1.0, 1.0;...
%         180, 0.9, 0.0, 0.66, 0.8, 0.0];
%     
%     x = Ta(:,1);
%     
%     % Spline interp values
%     lClm = pchip(x, Ta(:, 2));
%     lClj = pchip(x, Ta(:, 3));
%     lCls = pchip(x, Ta(:, 4));
%     lClmiz = pchip(x, Ta(:, 5));
%     lClmizs = pchip(x, Ta(:, 6));
%     
%     lCdm = pchip(x, Tb(:, 2));
%     lCdj = pchip(x, Tb(:, 3));
%     lCds = pchip(x, Tb(:, 4));
%     lCdmiz = pchip(x, Tb(:, 5));
%     lCdmizs = pchip(x, Tb(:, 6));
%     
%     lC = [lClm, lClj, lCls, lClmiz, lClmizs, lCdm, lCdj, lCds, lCdmiz, lCdmizs];

Clm = ppval(lC(1), theta);
Clj = ppval(lC(2), theta);
Cls = ppval(lC(3), theta);
Clmiz = ppval(lC(4), theta);
Clmizs = ppval(lC(5), theta);

Cdm = ppval(lC(6), theta);
Cdj = ppval(lC(7), theta);
Cds = ppval(lC(8), theta);
Cdmiz = ppval(lC(9), theta);
Cdmizs = ppval(lC(10), theta);

C = [Clm, Clj, Cls, Clmiz, Clmizs, Cdm, Cdj, Cds, Cdmiz, Cdmizs];
end