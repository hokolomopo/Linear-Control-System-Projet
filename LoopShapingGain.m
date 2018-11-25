close all;
clear all;

define_consts()

% Gain of controller : 
C_Gains = [1, 4,10,15,20];
h_num = 1;
h_denum = 1;


zeta_c =0.75;
omega_c = 5;
zeta_o = zeta_c;
omega_o = 10 * omega_c;

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

for i=1:size(C_Gains,2)
    C_Gain = C_Gains(i);
    h_num = C_Gain;
    
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
legend(sprintf('Gain = %.2f', C_Gains(1)),sprintf('Gain = %.2f', C_Gains(2)),sprintf('Gain = %.2f', C_Gains(3)), sprintf('Gain = %.2f', C_Gains(4)), sprintf('Gain = %.2f', C_Gains(5)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('Gain = %.2f', C_Gains(1)),sprintf('Gain = %.2f', C_Gains(2)),sprintf('Gain = %.2f', C_Gains(3)), sprintf('Gain = %.2f', C_Gains(4)), sprintf('Gain = %.2f', C_Gains(5)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('Gain = %.2f', C_Gains(1)),sprintf('Gain = %.2f', C_Gains(2)),sprintf('Gain = %.2f', C_Gains(3)), sprintf('Gain = %.2f', C_Gains(4)), sprintf('Gain = %.2f', C_Gains(5)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('Gain = %.2f', C_Gains(1)),sprintf('Gain = %.2f', C_Gains(2)),sprintf('Gain = %.2f', C_Gains(3)), sprintf('Gain = %.2f', C_Gains(4)), sprintf('Gain = %.2f', C_Gains(5)),'Location', 'southeast');

print(acceleration, 'graphs/accLSGain', '-depsc2');
print(difference, 'graphs/diffLSGain', '-depsc2');
print(bodePlot, 'graphs/bodeLSGain', '-depsc2');
print(bodePlot, 'graphs/nyquistLSGain', '-depsc2');