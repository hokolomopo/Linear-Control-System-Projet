close all;
clear all;

define_consts()

zeta_c =0.75;
omega_c = 5;
zeta_o = zeta_c;
omega_o = 10 * omega_c;

createKL()

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
sim('observer_noise', [0,10],opt);

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
u = figure('Name','Input');
    
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
ylabel('Input (m/s^2)');
legend('Position of runner', 'Position of camera', 'Location', 'southeast');
print(positions, 'positionsRunnerAndCameraStateFeedback', '-depsc2');

figure(difference);
xlabel('Time(s)');
ylabel('Difference (m)');
title('Difference of positions');

