close all;
clear all;

define_consts()

% Gain of controller : 
h_num = 10;
h_denum = 1;
cutoffs = [10, 50 ,100];

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

a = 0.1;
wco = 5;

sys = ss(A,B,C,D);
P = tf(sys);

tflead=tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);

for i=1:size(cutoffs,2)
    cutoff = cutoffs(i);
%     h_denum = [1/cutoff, 1];

    tflowpass=tf(1,[1/cutoff, 1]);

    Hcontroller = tflead*tflowpass;
    
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
legend(sprintf('cutoff = %.2f', cutoffs(1)),sprintf('cutoff = %.2f', cutoffs(2)),sprintf('cutoff = %.2f', cutoffs(3)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('cutoff = %.2f', cutoffs(1)),sprintf('cutoff = %.2f', cutoffs(2)),sprintf('cutoff = %.2f', cutoffs(3)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('cutoff = %.2f', cutoffs(1)),sprintf('cutoff = %.2f', cutoffs(2)),sprintf('cutoff = %.2f', cutoffs(3)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('cutoff = %.2f', cutoffs(1)),sprintf('cutoff = %.2f', cutoffs(2)),sprintf('cutoff = %.2f', cutoffs(3)),'Location', 'southeast');

print(acceleration, 'graphs/accLSFilter', '-depsc2');
print(difference, 'graphs/diffLSFilter', '-depsc2');
print(bodePlot, 'graphs/bodeLSFilter', '-depsc2');
print(nsqPlot, 'graphs/nyquistLSFilter', '-depsc2');

figure(acceleration);
title('Accelaration of camera');
figure(difference);
title('Difference of positions');

print(acceleration, 'graphs/accLSFilter','-dpng', '-r500');
print(difference, 'graphs/diffLSFilter','-dpng', '-r500');
print(bodePlot, 'graphs/bodeLSFilter','-dpng', '-r500');
print(nsqPlot, 'graphs/nyquistLSFilter','-dpng', '-r500');


