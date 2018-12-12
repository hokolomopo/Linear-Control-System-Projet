close all;
clear all;

define_consts()

zeta_c =0.65;
omega_c = 4;
zeta_o = zeta_c;
omega_o = 10 * omega_c;

createKL()

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
sim('observer_noise', [0,10],opt);
    
acc = dx.data(:,2);

acceleration = figure;
plot(dx.time, acc);hold on;
xlabel('Time(s)');
ylabel('Acceleration (m/s^2)');
% title('Accelaration of camera');
print(acceleration, 'graphs/accelerationRunnerAndCameraStateFeedbackNoisy', '-depsc2');

positions = figure;
plot(x_camera); hold on;
plot(x_runner);hold on;
xlabel('Time(s)');
ylabel('Input (m/s^2)');
legend('Position of runner', 'Position of camera', 'Location', 'southeast');
% print(positions, 'graphs/positionsRunnerAndCameraStateFeedbackNoisy', '-depsc2');

difference = figure;
plot(diff.Time, diff.data);hold on;
xlabel('Time(s)');
ylabel('Difference (m)');
print(difference, 'graphs/differenceRunnerAndCameraStateFeedbackNoisy', '-depsc2');

