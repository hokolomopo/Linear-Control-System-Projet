close all;
clear all;

define_consts()

% Gain of controller : 
h_num = defaultGain;
h_denum = 1;
cutoffs = [1, 10, 100];

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

for i=1:size(cutoffs,2)
    cutoff = cutoffs(i);
    h_denum = [1/cutoff, 1];

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