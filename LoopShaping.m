close all;
clear all;

define_consts()

% Gain of controller : 
h_num = 1;
h_denum = 1;

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
sim('loopShaping', [0,10],opt);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
positions = figure('Name','Positions');
bodePlt = figure('Name','Bode Plot');
nyquistPlt = figure('Name','Nyquist Plot');


acc = dx.data(:,2);

figure(acceleration);
plot(dx.time, acc);hold on;

figure(positions);
plot(x_camera); hold on;
plot(x_runner);hold on;

figure(difference);
plot(diff);hold on;

figure(acceleration);
xlabel('Time(s)');
ylabel('Acceleration (m/s^2)');
title('Accelaration of camera');

figure(positions);
xlabel('Time(s)');
ylabel('Position (m)');
title('Positions');
legend('Position of runner', 'Position of camera', 'Location', 'southeast');
print(positions, 'positionsRunnerAndCameraStateFeedback', '-depsc2');

figure(difference);
xlabel('Time(s)');
ylabel('Difference (m)');
title('Difference of positions');

figure(bodePlt)
bode(sys.values, options); hold on;

figure(nyquistPlt)
nyquist(sys.values)

print(acceleration, 'graphs/accLS', '-depsc2');
print(difference, 'graphs/diffLS', '-depsc2');
print(bodePlt, 'graphs/bodeLS', '-depsc2');
print(nyquistPlt, 'graphs/nyquistLS', '-depsc2');