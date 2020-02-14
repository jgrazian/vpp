function GZ = createGZ(GZs)
% Creates GZ curve

theta = GZs(:, 1);
arm = GZs(:, 2);

GZ = pchip(theta, arm);

x = linspace(min(theta), max(theta));
%plot(x, ppval(GZ, x))
end