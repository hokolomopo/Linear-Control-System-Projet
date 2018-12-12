close all;
clear all;

define_consts()

s = ss(A,B,C,D);
P = tf(s);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

% Low pass : 
cutoff = 100;
Hcutoff = tf([1],[1/cutoff 1]);

% Lead-Lag compensator
ratio = 10;
Hlead = tf([1 1],[1/(1*ratio) 1]);

Hcontroller = Hcutoff*Hlead*30;

h_num = cell2mat(Hcontroller.num);
h_denum = cell2mat(Hcontroller.den);

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
sim('loopShapingNoise', [0,10],opt);

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
positions = figure('Name','Positions');

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

figure(positions);
xlabel('Time(s)');
ylabel('Position (m)');
title('Positions');

figure(difference);
xlabel('Time(s)');
ylabel('Difference (m)');

print(acceleration, 'graphs/accLSNoise', '-depsc2');
print(difference, 'graphs/diffLSNoise', '-depsc2');
