clear all;
close all;

define_consts()
 
% Gain of controller : 
C_Gain = 30;
wz = 6;
% Ratio = [1.2, 1.5, 1.9];
Pm = [30,40,50];
as = [1, 0.5, 0.1, 0.01];
% wco = 7.246377;
wco = 7.24;
whf = 1;
d = 0;
n = 0;
wpi = 0;
wp = 1;
h_num = 1;
h_denum = 1;

sys = ss(A,B,C,D);
P = tf(sys);
crossover = getGainCrossover(sys,C_Gain);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.

acceleration = figure('Name','Acceleration');
difference = figure('Name','Difference');
bodePlot = figure('Name','Bode');
nsqPlot = figure('Name','Nyquist');


for i=1:size(as,2)
%     wp = Ratio(i) * wz;
%     h_num = [1/wz, 1]*C_Gain;
%     h_denum = [1/wp, 1];
      
%     b = sind(Pm(i));
%     a = (1-b)/(1+b);
%     T = 1/(a^(0.5) * wco);
%     
%     Co = tf([T, 1], [T*a, 1]);
%     H = P * Co;
%     G0 = getGain(H, wco);
% 
%     h_num = [T, 1]*G0;
%     h_denum = [T*a, 1];
    
    
    a = as(i);
    if a ==0
        G0 = getGain(P, wco);
        H = P;
        
        h_num = G0;
        h_denum = 1;
    else
        Co = tf([1, (wco*sqrt(a))], [1, wco/sqrt(a)]);
        H = P * Co;
        G0 = getGain(H, wco);
        

       h_num = cell2mat(Co.num) * G0;
       h_denum = cell2mat(Co.den);
    end
        
    opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-5');
    sim('loopShaping', [0,10],opt);

    acc = dx.data(:,1);
%     acc = dx.signals.values(1 ,:);
    figure(acceleration);
    plot(dx.time, acc);hold on;

    figure(difference);
    
%    dist = diff.signals.values(1 ,:);
%     plot(diff.time, dist);hold on;

    plot(diff);hold on;

    figure(bodePlot);
    bode(sys.values, options); hold on;
%     bode(H * G0, options);hold on;
    
    figure (nsqPlot);
    nyquist(sys.values); hold on;

end

figure(acceleration);
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)');
legend(sprintf('a = %.2f', as(1)),sprintf('a = %.2f', as(2)),sprintf('a = %.2f', as(3)), sprintf('a = %.2f', as(4)),'Location', 'southeast');


figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('a = %.2f', as(1)),sprintf('a = %.2f', as(2)),sprintf('a = %.2f', as(3)), sprintf('a = %.2f', as(4)),'Location', 'southeast');

figure(bodePlot);
legend(sprintf('a = %.2f', as(1)),sprintf('a = %.2f', as(2)),sprintf('a = %.2f', as(3)), sprintf('a = %.2f', as(4)),'Location', 'southeast');

figure(nsqPlot);
legend(sprintf('a = %.2f', as(1)),sprintf('a = %.2f', as(2)),sprintf('a = %.2f', as(3)), sprintf('a = %.2f', as(4)),'Location', 'southeast');

print(acceleration, 'graphs/accLSLead', '-depsc2');
print(difference, 'graphs/diffLSLead', '-depsc2');
print(bodePlot, 'graphs/bodeLSLead', '-depsc2');
print(nsqPlot, 'graphs/nyquistLSLead', '-depsc2');