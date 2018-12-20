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

force = figure('Name','force');
difference = figure('Name','Difference');
positions = figure('Name','Positions');
    
acc = dx.data(:,1);

figure(force);
plot(dx.time, acc);hold on;

figure(positions);
plot(x_camera); hold on;
plot(x_runner);hold on;

figure(difference);
plot(diff.Time, diff.data);hold on;


figure(force);
grid on;
xlabel('Time(s)');
ylabel('Force (N)');
% title('Accelaration of camera');

figure(positions);
grid on;
xlabel('Time(s)');
ylabel('Position (m)');
% title('Positions');
legend('Position of runner', 'Position of camera', 'Location', 'southeast');

figure(difference);
grid on;
xlabel('Time(s)');
ylabel('Difference (m)');
% title('Difference of positions');

print(positions, 'graphs/positionsRunnerAndCameraStateFeedback', '-depsc2');
print(force, 'graphs/forceRunnerAndCameraStateFeedback', '-depsc2');
print(difference, 'graphs/differencenRunnerAndCameraStateFeedback', '-depsc2');

figure(force);
title('Force exerted on camera');

figure(difference);
title('Difference of positions');

figure(positions);
title('Positon for camera and runner');

print(positions, 'graphs/stateFeedbackpositions', '-dpng', '-r500');
print(force, 'graphs/stateFeedbackforce', '-dpng', '-r500');
print(difference, 'graphs/stateFeedbackdifferencen', '-dpng', '-r500');
