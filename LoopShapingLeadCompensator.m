close all;
clear all;

define_consts()
 
% Gain of controller : 
C_Gain = 30;
wz = 6;
Ratio = [1.2, 1.5, 1.9];
Pm = [30,40,50];

wp = 1;
h_num = 1;
h_denum = 1;

sys = ss(A,B,C,D);
crossover = getGainCrossover(sys,C_Gain);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');

for i=1:size(Ratio,2)
%     wp = Ratio(i) * wz;
%     h_num = [1/wz, 1]*C_Gain;
%     h_denum = [1/wp, 1];
      
    b = sind(Pm(i));
    a = (1-b)/(1+b);
    T = 1/(a^(0.5) * crossover);
    h_num = [T, 1]*C_Gain* a;
    h_denum = [T*a, 1];
    
    opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
    sim('loopShaping', [0,10],opt);

    acc = dx.data(:,2);

    figure(acceleration);
    plot(dx.time, acc);hold on;

    figure(difference);
    plot(diff.Time, diff.data);hold on;

    figure(bodePlot);
    bode(sys.values, options); hold on;

    figure (nsqPlot);
    nyquist(sys.values); hold on;

end

figure(acceleration);
xlabel('Time (s)')
ylabel('Acceleration (m/s^2');
legend(sprintf('Pm = %.2f', Pm(1)),sprintf('Pm = %.2f', Pm(2)),sprintf('Pm = %.2f', Pm(3)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('Pm = %.2f', Pm(1)),sprintf('Pm = %.2f', Pm(2)),sprintf('Pm = %.2f', Pm(3)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('Pm = %.2f', Pm(1)),sprintf('Pm = %.2f', Pm(2)),sprintf('Pm = %.2f', Pm(3)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('Pm = %.2f', Pm(1)),sprintf('Pm = %.2f', Pm(2)),sprintf('Pm = %.2f', Pm(3)),'Location', 'southeast');

print(acceleration, 'graphs/accLSLead', '-depsc2');
print(difference, 'graphs/diffLSLead', '-depsc2');
print(bodePlot, 'graphs/bodeLSLead', '-depsc2');
print(nsqPlot, 'graphs/nyquistLSLead', '-depsc2');