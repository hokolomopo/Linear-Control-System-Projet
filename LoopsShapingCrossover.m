close all;
clear all;

define_consts()

s = ss(A,B,C,D);
P = tf(s);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
 
crossovers = [0.001 0.01 0.1 1 10];
gains = zeros(5);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.


acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

for i=1:size(crossovers,2)
    
    crossover = crossovers(i) * 2 * pi;
    Wcp = 500000;%RAndom valeur pour rentrer dans al boucle
    limits = [0, 500000];
    while abs(crossover - Wcp) > 0.1
        gain = mean(limits);
        [~,~,~,Wcp] = margin(P*gain);
        if Wcp > crossover
            limits(2) = gain;
        else
            limits(1) = gain;
        end
    end
    gains(i) = gain;
    h_denum = 1;
    h_num = gain;

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
legend(sprintf('Crossover = %.2f, gain=%.2f', crossovers(1), gains(1)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(2), gains(2)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(3), gains(3)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(4), gains(4)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(5), gains(5)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('Crossover = %.2f, gain=%.2f', crossovers(1), gains(1)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(2), gains(2)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(3), gains(3)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(4), gains(4)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(5), gains(5)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('Crossover = %.2f, gain=%.2f', crossovers(1), gains(1)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(2), gains(2)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(3), gains(3)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(4), gains(4)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(5), gains(5)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('Crossover = %.2f, gain=%.2f', crossovers(1), gains(1)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(2), gains(2)),sprintf('Crossover = %.2f, gain=%.2f', crossovers(3), gains(3)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(4), gains(4)), sprintf('Crossover = %.2f, gain=%.2f', crossovers(5), gains(5)),'Location', 'southeast');

print(acceleration, 'graphs/accLSCrossover', '-depsc2');
print(difference, 'graphs/diffLSCrossover', '-depsc2');
print(bodePlot, 'graphs/bodeLSCrossover', '-depsc2');
print(bodePlot, 'graphs/nyquistLSCrossover', '-depsc2');