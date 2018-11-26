close all;
clear all;

define_consts()

% Gain of controller : 
C_Gain = 1;
wz = 0.5;
Ratio = [0.1, 0.5,1,2,10];
wp = 1;
h_num = 1;
h_denum = 1;

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

for i=1:size(Ratio,2)
    wp = Ratio(i) * wz;
    h_num = [1/wz, 1];
    h_denum = [1/wp, 1];
    
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
legend(sprintf('Ratio = %.2f', Ratio(1)),sprintf('Ratio = %.2f', Ratio(2)),sprintf('Ratio = %.2f', Ratio(3)), sprintf('Ratio = %.2f', Ratio(4)), sprintf('Ratio = %.2f', Ratio(5)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('Ratio = %.2f', Ratio(1)),sprintf('Ratio = %.2f', Ratio(2)),sprintf('Ratio = %.2f', Ratio(3)), sprintf('Ratio = %.2f', Ratio(4)), sprintf('Ratio = %.2f', Ratio(5)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('Ratio = %.2f', Ratio(1)),sprintf('Ratio = %.2f', Ratio(2)),sprintf('Ratio = %.2f', Ratio(3)), sprintf('Ratio = %.2f', Ratio(4)), sprintf('Ratio = %.2f', Ratio(5)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('Ratio = %.2f', Ratio(1)),sprintf('Ratio = %.2f', Ratio(2)),sprintf('Ratio = %.2f', Ratio(3)), sprintf('Ratio = %.2f', Ratio(4)), sprintf('Ratio = %.2f', Ratio(5)),'Location', 'southeast');

print(acceleration, 'graphs/accLSLead', '-depsc2');
print(difference, 'graphs/diffLSLead', '-depsc2');
print(bodePlot, 'graphs/bodeLSLead', '-depsc2');
print(nsqPlot, 'graphs/nyquistLSLead', '-depsc2');