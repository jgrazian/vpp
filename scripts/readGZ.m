function GZs = readGZ(filename)
try
    data = csvread(filename, 1, 0);
catch
    data = csvread(filename, 1, 0);
end

deg = data(:, 1);
arm = data(:, 3);

GZs = [deg, arm];
end