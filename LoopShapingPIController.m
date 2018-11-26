close all;
clear all;

define_consts()

% Gain of controller : 
h_num = 1;
h_denum = [1, 0];
kis = [0, 1, 2];
kp = 1;

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

for i=1:size(kis,2)
    ki = kis(i);
    h_num = [kp ki]*defaultGain;

    opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
    sim('loopShaping', [0,10],opt);

    acc = dx.data(:,2);

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