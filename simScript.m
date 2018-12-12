close all;
clear all;

define_consts()

zeta_c =0.65;
omega_c = 4;
zeta_o = zeta_c;
omega_o = 10 * omega_c;

createKL()

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
sim('observer', [0,10],opt);

acceleration = figure('Name','Acceleration');
xlabel('time(s)');
ylabel('Acceleration (m/s^2)');
title('Accelaration of camera');

difference = figure('Name','Difference');
xlabel('time(s)');
ylabel('Difference (m)');
title('Difference of positions');

positions = figure('Name','Positions');
xlabel('time(s)');
ylabel('Position (m)');
title('Positions');


% omega_c = 5;
% zeta_o = zeta_c;
% omega_o = 10 * omega_c;

    
acc = dx.data(:,2);

figure(acceleration);
plot(dx.time, acc);hold on;

figure(positions);
plot(x_camera); hold on;
plot(x_runner);hold on;

figure(difference);
plot(diff.Time, diff.data);hold on;


figure(acceleration);
xlabel('Time(s)');
ylabel('Acceleration (m/s^2)');
% title('Accelaration of camera');

figure(positions);
xlabel('Time(s)');
ylabel('Position (m)');
% title('Positions');
legend('Position of runner', 'Position of camera', 'Location', 'southeast');

figure(difference);
xlabel('Time(s)');
ylabel('Difference (m)');
% title('Difference of positions');

print(positions, 'graphs/positionsRunnerAndCameraStateFeedback', '-depsc2');
print(acceleration, 'graphs/accelerationRunnerAndCameraStateFeedback', '-depsc2');
print(difference, 'graphs/differencenRunnerAndCameraStateFeedback', '-depsc2');

figure(acceleration);
title('Accelaration of camera');

figure(difference);
title('Difference of positions');

figure(positions);
title('Positon for camera and runner');

print(positions, 'graphs/stateFeedbackpositions', '-dpng', '-r500');
print(acceleration, 'graphs/stateFeedbackacceleration', '-dpng', '-r500');
print(difference, 'graphs/stateFeedbackdifferencen', '-dpng', '-r500');
