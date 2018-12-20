close all;
clear all;

define_consts()

% Gain of controller : 
h_num = 1;
h_denum = [1, 0];
kis = [0, 0.1, 0.5];
kp = 1;

wco = 3;
a = 0.1;
cutoff = 10;

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

sys = ss(A,B,C,D);
P = tf(sys);
tflead=tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
tflowpass=tf(1,[1/cutoff, 1]);

for i=1:size(kis,2)
    ki = kis(i);
    tfPI = tf([kp ki], [1 0]);

    Hcontroller = tflead * tflowpass * tfPI;
    
    G0 = getGain(Hcontroller * P, wco);

    Hcontroller = Hcontroller * G0;
    
    h_num = cell2mat(Hcontroller.num);
    h_denum = cell2mat(Hcontroller.den);

    opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
    sim('loopShaping', [0,10],opt);

    acc = dx.data(:,1);

    figure(acceleration);
    plot(dx.time, acc);hold on;

    figure(difference);
    plot(diff);hold on;

    figure(bodePlot);
    bode(sys.values, options); hold on;

    figure (nsqPlot);
    nyquist(sys.values); hold on;

end

figure(acceleration);
xlabel('Time (s)')
ylabel('Acceleration (m/s^2');
legend(sprintf('ki = %.2f', kis(1)),sprintf('ki = %.2f', kis(2)),sprintf('ki = %.2f', kis(3)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('ki = %.2f', kis(1)),sprintf('ki = %.2f', kis(2)),sprintf('ki = %.2f', kis(3)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('ki = %.2f', kis(1)),sprintf('ki = %.2f', kis(2)),sprintf('ki = %.2f', kis(3)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('ki = %.2f', kis(1)),sprintf('ki = %.2f', kis(2)),sprintf('ki = %.2f', kis(3)),'Location', 'southeast');

print(acceleration, 'graphs/accLSPI', '-depsc2');
print(difference, 'graphs/diffLSPI', '-depsc2');
print(bodePlot, 'graphs/bodeLSPI', '-depsc2');
print(nsqPlot, 'graphs/nyquistLSPI', '-depsc2');