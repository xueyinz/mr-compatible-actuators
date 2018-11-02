%% AMME4112
% Xue Yin Zhang
% 2018

clearvars;
close all;

%% data

pressure = 1:1/4:3;                                 % bar

additional_mass = [0 33 44 66 77 99 132 143 165];   % grams
n_points = numel(additional_mass);
error_mass = 11*ones(1, n_points);                  % grams
g = 9.80665;                                        % m/s^2

delay = [0 66 40 32 30 28 28 28 28];                % milliseconds
error_delay = 2;                  % milliseconds

%% processing

bandwidth = zeros(1, n_points);
error_bandwidth = zeros(1, n_points);
for ii = 2:n_points
    bandwidth(ii) = 1e3./delay(ii);
    error_bandwidth(ii) = (1e3./(delay(ii) - error_delay) - bandwidth(ii))/2;
    bandwidth(ii) = bandwidth(ii) + error_bandwidth(ii);
end

additional_load = additional_mass*g*1e-3;
error_load = (error_mass*g*1e-3)/2;
error_load(1) = 0;
additional_load = additional_load - error_load;

%% plotting

h = figure;
plot(pressure, bandwidth, 'o-', 'LineWidth', 1.5);
hold on;
errorbar(pressure, bandwidth, error_bandwidth);
grid on;
xlabel('Pressure (bar)');
ylabel('Bandwidth (Hz)');
title('Achievable bandwidth at various pressures');
legend('Load', 'Measurement error', 'Location', 'southeast');
xlim([0 3]);

set(h,'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
print(h, 'bandwidth', '-dpdf', '-r0');

h = figure;
plot(pressure, additional_load, 'o-', 'LineWidth', 1.5);
hold on;
errorbar(pressure, additional_load, error_load);
grid on;
xlabel('Pressure (bar)');
ylabel('Load (N)');
title('Additional load at which motor stalls at various pressures');
legend('Load', 'Measurement error', 'Location', 'southeast' );
xlim([0 3]);

set(h,'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
print(h, 'torque', '-dpdf', '-r0');
