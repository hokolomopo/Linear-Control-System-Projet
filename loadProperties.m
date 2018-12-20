clear all
close all
opengl hardware

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Properties of the camera %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 0.2;
m = 7;

A = [0 1; 0 -c/m];
B = [0;1/m];
C = [1 0];
D = 0;
sys = ss(A,B,C,D);
tfsys=tf(sys);
%figure;
%bodeplot(tfsys);
%print -depsc2 tfPhysSystem.eps
x0 = [0 0];

% step = 0.01;
% t = 0:step:(12-step);
% runner = generateRunnerPositionsSimple(step);
% plot(t,runner);
% 
% ref.time = [t];
% ref.signals.values = [coureur];
% ref.signals.dimensions =1;

%%%%%%%%%%%%%%%%%%%%%%
% Usain Bolt Profile %
%%%%%%%%%%%%%%%%%%%%%%
step=0.01;
t = 0:step:10;
t = t';
t_usain = [0 1.89 2.88 3.78 4.64 5.47 6.29 7.1 7.92 8.75 9.58];
y_usain = [0 10 20 30 40 50 60 70 80 90 100];
f = polyfit(t_usain,y_usain ,5);
k=polyder(f);
m=polyder(k);
coureur =polyval(f, t);
v_coureur =polyval(k, t);
a_coureur =polyval(m, t);
v_max=1.38;%max(v_coureur);
a_max=10;%max(a_coureur);
wco=a_max/v_max;
disp(sprintf('Maximum speed: %d m/s.', v_max));
disp(sprintf('Maximum acceleration: %d m/s^2.', a_max));
disp(sprintf('Cutoff frequency = %d rad/s, %d Hz', wco, wco/(2*pi)));
% 
% % figure;
% % plot(t_usain,y_usain,'o');
% % hold on;
% % plot(t,coureur);
% % legend('Experimental','polynomial n=5', 'location', 'southeast');
% % ylabel('Position [m]');
% % xlabel('Time [s]');
% % 
% % figure;
% % plot(t,v_coureur);
% % legend('polynomial n=5', 'location', 'southeast');
% % ylabel('Speed [m/s]');
% % xlabel('Time [s]');
% % 
% % figure;
% % plot(t,a_coureur);
% % legend('polynomial n=5', 'location', 'southeast');
% % ylabel('Acceleration [m/s^2]');
% % xlabel('Time [s]');
% 
x_usain = [0 1.89 2.88 3.78 4.64 5.47 6.29 7.1 7.92 8.75 9.58];
y_usain = [0 10 20 30 40 50 60 70 80 90 100];
f = polyfit(x_usain,y_usain ,3);
coureur =polyval(f, t);

ref.time = [t];
ref.signals.values = [coureur];
ref.signals.dimensions =1;

% noise and distrubance
n=0;
d=0;

G0=75;

whf=9.4;
tflowpass=tf([1],[1/whf, 1]);

wco=7.246377;
a=25;
tflead=1*tf([sqrt(a)/wco, 1],[1/(wco*sqrt(a)), 1]);

wp1 = 0.;
wz1 = 0.1;
tflag = tf([1, wz1],[1, wp1]);

opt = bodeoptions('cstprefs');
opt.FreqUnits='rad/s';
opt.XLim=[1E-4, 1E3];
opt.Ylim{1}= [-200, 200];
opt.Ylim{2}= [-270, 0];

% figure;
% grid on;
% bodeplot(tfsys, opt);hold on;
% bodeplot(tflead*tfsys, opt); hold on;
% bodeplot(tflead*tflowpass*tfsys, opt);hold on;
% bodeplot(1*tflead*tflowpass*tfsys*tflag, opt);hold on;
% bodeplot(tf([1],[1]), opt);
% legend('Uncontrolled system', 'Controlled system (lead)',  'Controlled system (lead+lowpass)',  'Controlled system (lead+lowpass+lag)', 'location', 'southwest');
% title('Transfer function');

% figure;
% bodeplot(1/(1+tfsys)); hold on;
% bodeplot(1/(1+tflead*tfsys)); hold on;
% bodeplot(1/(1+tflead*tflowpass*tfsys)); hold on;
% bodeplot(1/(1+600*tflead*tflowpass*tfsys*tflag)); hold on;
% legend('Uncontrolled system', 'Controlled system (lead)',  'Controlled system (lead+lowpass)',  'Controlled system (lead+lowpass+lag)', 'location', 'southwest');
% title('Sensitivity function');
% 
% figure;
% bodeplot(tfsys/(1+tfsys)); hold on;
% bodeplot(tflead*tfsys/(1+tflead*tfsys)); hold on;
% bodeplot(tflead*tflowpass*tfsys/(1+tflead*tflowpass*tfsys)); hold on;
% bodeplot(600*tflead*tflowpass*tfsys*tflag/(1+600*tflead*tflowpass*tfsys*tflag)); hold on;
% legend('Uncontrolled system', 'Controlled system (lead)',  'Controlled system (lead+lowpass)',  'Controlled system (lead+lowpass+lag)', 'location', 'southwest');
% title('Complementary Sensitivity function');

%%%%%%%%%%%%%%%%%%%%
% Wco testing area %
%%%%%%%%%%%%%%%%%%%

wco=7.246377;
a=0.1;
GL0=1/a;%%% gain to only see the differences
tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
whf=10;
tflowpass=tf([1],[1/whf, 1]);
wpi=0.1;
tfint=tf([1, wpi],[1, 0]);
[G0, Wcp]=findGain(tflead*tfsys*tflowpass*tfint, 0.3798)
[~,~,~,Wcp] = margin(GL0*tflead*tfsys*tflowpass)
X=['Fco of the controlled system :', num2str(Wcp), ' rad/s, ', num2str(Wcp/(2*pi)), 'Hz'];
disp(X);

% P=nyquistoptions();
% P.XLim=[-3.5, 0.5];
% P.YLim=[-2, 2];
% figure;
% wco=7.246377;
% a=0.1;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% whf=10;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass, wco);
% nyquist(G0*tflead*tfsys*tflowpass,P);hold on;
% wpi=0.01;
% tfint=tf([1, wpi],[1, 0]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass*tfint, wco);
% nyquist(G0*tflead*tfsys*tflowpass*tfint,P);hold on;
% wpi=0.1;
% tfint=tf([1, wpi],[1, 0]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass*tfint, wco);
% nyquist(G0*tflead*tfsys*tflowpass*tfint,P);hold on;
% wpi=wco;
% tfint=tf([1, wpi],[1, 0]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass*tfint, wco);
% nyquist(G0*tflead*tfsys*tflowpass*tfint,P);hold on;
% legend('No PI', 'wpi=0.01', 'wpi=0.1', 'wpi=wco', 'location', 'northeast');
% print -depsc2 NyquistPlotLeadLowPassIntG0.eps
% 
%%%%%%%%%%%%%%%%%%%%%%%%%
% Print those Bode Plot %
%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% a=0.1;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% bodeplot(G0*tflead*tfsys, opt); hold on;
% wco=7.246377;
% whf=100;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% bodeplot(G0*tflead*tfsys*tflowpass, opt); hold on;
% whf=50;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% bodeplot(G0*tflead*tfsys*tflowpass, opt); hold on;
% whf=10;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% bodeplot(G0*tflead*tfsys*tflowpass, opt); hold on;
% bodeplot(tf([1],[1]), opt); hold on;
% legend('No filter', 'whf=100 rad/s', 'whf=50 rad/s', 'whf=10 rad/s', 'location', 'southwest');
% print -depsc2 BodePlotLeadLowPassGL0noG0.eps
% 
% figure;
% grid on;
% [G0, Wcp]=findGain(tfsys, wco);
% bodeplot(G0*tfsys, opt);hold on;
% a=0.5;
% GL0=1/a;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% bodeplot(G0*tflead*tfsys, opt); hold on;
% a=0.1;
% GL0=1/a;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% bodeplot(G0*tflead*tfsys, opt); hold on;
% a=0.01;
% GL0=1/a;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% bodeplot(G0*tflead*tfsys, opt); hold on;
% bodeplot(tf([1],[1]), opt);
% legend('G0 P(s)', 'a=0.5', 'a=0.1', 'a=0.01', 'location', 'southwest')
% title('Transfer function');
% print -depsc2 BodePlotLeadGL0noG0.eps
% 
% figure;
% wco=7.246377;
% a=0.1;
% GL0=1/a;%%% gain to only see the differences
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% whf=10;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% bodeplot(G0*tfsys*tflead*tflowpass, opt); hold on;
% wpi=0.01;
% tfint=tf([1, wpi],[1, 0]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass*tfint, wco);
% bodeplot(G0*tfsys*tflead*tflowpass*tfint, opt); hold on;
% wpi=0.1;
% tfint=tf([1, wpi],[1, 0]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass*tfint, wco);
% bodeplot(G0*tfsys*tflead*tflowpass*tfint, opt); hold on;
% wpi=wco;
% tfint=tf([1, wpi],[1, 0]);
% [G0, ~]=findGain(tflead*tfsys*tflowpass*tfint, wco);
% bodeplot(G0*tfsys*tflead*tflowpass*tfint, opt); hold on;
% bodeplot(tf([1], [1]), opt); hold on;
% legend('No PI', 'wpi=0.01', 'wpi=0.1', 'wpi=wco');
% print -depsc2 BodePlotLeadLowPassIntGL0noG0.eps
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print those Nyquist Plot %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% [G0, Wcp]=findGain(tfsys, wco);
% nyquist(tfsys);hold on;
% a=0.5;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% nyquist(G0*tflead*tfsys);hold on;
% a=0.1;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% nyquist(G0*tflead*tfsys);hold on;
% a=0.01;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% nyquist(G0*tflead*tfsys);hold on;
% legend('G0 P(s)', 'a=0.5', 'a=0.1', 'a=0.01', 'location', 'southwest');
% print -depsc2 NyquistPlotLeadG0.eps
% 
% P=nyquistoptions();
% P.XLim=[-3.5, 0.5];
% P.YLim=[-2, 2];
% figure;
% [G0, Wcp]=findGain(tfsys, wco);
% nyquist(G0*tfsys, P);hold on;
% a=0.5;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% nyquist(G0*tflead*tfsys, P);hold on;
% a=0.1;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% nyquist(G0*tflead*tfsys, P);hold on;
% a=0.01;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% nyquist(G0*tflead*tfsys, P);hold on;
% legend('G0 P(s)', 'a=0.5', 'a=0.1', 'a=0.01', 'location', 'southwest');
% print -depsc2 NyquistPlotLeadG0Zoom.eps
% 
% P=nyquistoptions();
% P.XLim=[-3.5, 0.5];
% P.YLim=[-2, 2];
% a=0.1;
% tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
% [G0, Wcp]=findGain(tfsys*tflead, wco);
% figure;
% nyquist(G0*tflead*tfsys,P);hold on;
% whf=100;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% nyquist(G0*tflead*tfsys*tflowpass);hold on;
% whf=50;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% nyquist(G0*tflead*tfsys*tflowpass);hold on;
% whf=10;
% tflowpass=tf([1],[1/whf, 1]);
% [G0, Wcp]=findGain(tfsys*tflead*tflowpass, wco);
% nyquist(G0*tflead*tfsys*tflowpass);hold on;
% legend('No Filter', 'whf=100', 'whf=50', 'whf=10', 'location', 'northeast');
% print -depsc2 NyquistPlotLeadLowPassG0.eps
% 
% figure;
% nyquist(tfsys,P);hold on;
% print -depsc2 NyquistPlotSyst.eps
% 

%%%%%%%%%%%%%%%%
% Testing Area %
%%%%%%%%%%%%%%%%
a=0.1;
whf=50;
n=0.05;
d=0;
G0=1172;






% [~,~,~,Wcp] = margin(G0*tflead*tflowpass*tfsys);
% X=['Fco of the cotrolled system :', num2str(Wcp), ' rad/s, ', num2str(Wcp/(2*pi)), 'Hz'];
% disp(X);

% [~,~,~,Wcp] = margin(G0*tflead*tflowpass*tfsys*tflag);
% X=['Fco of the cotrolled system (lag) :', num2str(Wcp), ' rad/s, ', num2str(Wcp/(2*pi)), 'Hz'];
% disp(X);
% figure;
% bodeplot(tflag);
% title('Lag Compensator');
% 
% figure;
% bodeplot(tflowpass);
% title('Low-Pass Filter');
% 
% figure;
% bodeplot(tflead, opt);
% title('Lead Compensator');

[~,~,~,Wphys] = margin(sys);
X=['Fco of the physical system :', num2str(Wcp), ' rad/s, ', num2str(Wcp/(2*pi)), 'Hz'];
disp(X); 

% opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-5');
% sim('loopShapingNoise', [t(1), t(end)],opt);
% 
% figure;
% plot(t, coureur); hold on;
% plot(y_LSNoise_m_n.time, y_LSNoise_m_n.data);
% legend('Runner position', 'Camera position', 'location', 'southeast');
% xlabel('Time [s]');
% ylabel('Distance [m]');
% print -depsc2 runnerCameraPosLSNoise.eps
% 
% ts1 = timeseries(y_LSNoise_m_n.data,y_LSNoise_m_n.time);
% ts2 = timeseries(coureur,t);
% 
% [ts1_sync, ts2_sync] = synchronize(ts1,ts2,'Union');
%  
% figure;
% plot(ts1_sync.time, ts2_sync.data-ts1_sync.data);
% xlabel('Time [s]');
% ylabel('Distance [m]');
% print -depsc2 diffPosLSNoise.eps
% 
% figure;
% plot(u_LSNoise_p_d.time, u_LSNoise_p_d.data);
% xlabel('Time [s]');
% ylabel('Force [N]');
% print -depsc2 ForceLSNoise.eps

% open('CameraNoController.fig');
% hold on;
% plot(t, coureur,'color','r');
% grid on;
% xlabel('Time [s]');
% ylabel('Postion [m]');
% legend('Camera', 'Runner', 'location', 'southeast');
% print -depsc2 CameraRunnerNoController.eps
% 

% y_to_plot= squeeze(y_LSNoise_m_n.signals.values(1,1,:));
% figure;
% plot(y_LSNoise_m_n.time, y_to_plot); hold on;
% plot(t, coureur); hold on;
% grid on;
% xlabel('Time [s]');
% ylabel('Postion [m]');
% legend('Camera', 'Runner', 'location', 'southeast');
% print -depsc2 CameraRunnerNoControllerFreq.eps
% 
% d_to_plot= squeeze(distance_LS.signals.values(1,1,:));
% figure;
% plot(distance_LS.time, d_to_plot); hold on;
% grid on;
% xlabel('Time [s]');
% ylabel('Distance [m]');
% print -depsc2 DistanceNoControllerFreq.eps

% figure;
% %d_to_plot= squeeze(distance_alone.signals.values(1,1,:));
% %plot(distance_alone.time, d_to_plot); hold on;
% d_to_plot_0= squeeze(distance_alone_G0.signals.values(1,1,:));
% plot(distance_alone_G0.time, d_to_plot_0); hold on;
% d_to_plot_1= squeeze(distance_lead_0_5.signals.values(1,1,:));
% plot(distance_lead_0_5.time, d_to_plot_1); hold on;
% d_to_plot_2= squeeze(distance_lead_0_1.signals.values(1,1,:));
% plot(distance_lead_0_1.time, d_to_plot_2); hold on;
% d_to_plot_3= squeeze(distance_lead_0_01.signals.values(1,1,:));
% plot(distance_lead_0_01.time, d_to_plot_3); hold on;
% grid on;
% legend('G0 only','a=0.5', 'a=0.1', 'a=0.01', 'location', 'southwest');
% xlabel('Time [s]');
% ylabel('Distance [m]');
% print -depsc2 DistanceLeadOnlyFreq.eps
% 
figure;
%d_to_plot= squeeze(distance_alone.signals.values(1,1,:));
%plot(distance_alone.time, d_to_plot); hold on;
% u_to_plot_0= squeeze(u_alone_G0.signals.values(1,1,:));
% plot(u_alone_G0.time, u_to_plot_0); hold on;
% u_to_plot_1= squeeze(u_lead_0_5.signals.values(1,1,:));
% plot(u_lead_0_5.time, u_to_plot_1); hold on;
% u_to_plot_2= squeeze(u_lead_0_1.signals.values(1,1,:));
% plot(u_lead_0_1.time, u_to_plot_2); hold on;
% u_to_plot_3= squeeze(u_lead_0_01.signals.values(1,1,:));
% plot(u_lead_0_01.time, u_to_plot_3); hold on;

as = [1, 0.5, 0.1, 0.01];
d = 0;
n = 0;
for i = 1:size(as,2)
    a = as(i);
    
        Co = tf([1, (wco*sqrt(a))], [1, wco/sqrt(a)]);
    H = tfsys * Co;
    G0 = getGain(H, wco);

    opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-5');
    sim('simon', [0,10],opt);

%     u_to_plot_0= squeeze(u_alone_G0.signals.values(1,1,:));
    plot(u_alone_G0.time, u_alone_G0.data(1, :)); hold on;
end
grid on;
legend('G0 only', 'a=0.5', 'a=0.1', 'a=0.01');
xlabel('Time [s]');
ylabel('Force [N]');
print -depsc2 ForceLeadOnlyFreq.eps

figure
as = [1, 0.5, 0.1, 0.01];
d = 0;
n = 0;
for i = 1:size(as,2)
    a = as(i);
    
    Co = tf([1, (wco*sqrt(a))], [1, wco/sqrt(a)]);
    H = tfsys * Co;
    G0 = getGain(H, wco);

    opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-5');
    sim('simon', [0,10],opt);

    d_to_plot= squeeze(diff.signals.values(1,1,:));

%     u_to_plot_0= squeeze(u_alone_G0.signals.values(1,1,:));
    plot(diff.time,d_to_plot); hold on;
end
grid on;
legend('G0 only', 'a=0.5', 'a=0.1', 'a=0.01');
xlabel('Time [s]');
ylabel('Distance [m]');
print -depsc2 DistLeadOnlyFreq.eps


figure;
d_to_plot= squeeze(distance_lead_lowpass_PI_lead_only.signals.values(1,1,:));
plot(distance_lead_lowpass_PI_lead_only.time, d_to_plot); hold on;
d_to_plot_1= squeeze(distance_lead_lowpass_PI_wpi_0_01.signals.values(1,1,:));
plot(distance_lead_lowpass_PI_wpi_0_01.time, d_to_plot_1); hold on;
d_to_plot_2= squeeze(distance_lead_lowpass_PI_wpi_0_1.signals.values(1,1,:));
plot(distance_lead_lowpass_PI_wpi_0_1.time, d_to_plot_2); hold on;
d_to_plot_3= squeeze(distance_lead_lowpass_PI_wpi_wco.signals.values(1,1,:));
plot(distance_lead_lowpass_PI_wpi_wco.time, d_to_plot_3); hold on;
grid on;
legend('No PI', 'wpi=0.01', 'wpi=0.1');
xlabel('Time [s]');
ylabel('Distance [m]');
print -depsc2 DistanceLeadLowPassPIFreq.eps
print -depsc2 DistanceLeadLowPassPIFreq_wpi_wco.eps
legend('wpi=wco', 'location', 'southeast')

figure;
u_to_plot= squeeze(u_lead_lowpass_PI_lead_only.signals.values(1,1,:));
plot(u_lead_lowpass_PI_lead_only.time, u_to_plot); hold on;
u_to_plot_1= squeeze(u_lead_lowpass_PI_wpi_0_01.signals.values(1,1,:));
plot(u_lead_lowpass_PI_wpi_0_01.time, u_to_plot_1); hold on;
u_to_plot_2= squeeze(u_lead_lowpass_PI_wpi_0_1.signals.values(1,1,:));
plot(u_lead_lowpass_PI_wpi_0_1.time, u_to_plot_2); hold on;
%u_to_plot_3= squeeze(u_lead_lowpass_PI_wpi_wco.signals.values(1,1,:));
%plot(u_lead_lowpass_PI_wpi_wco.time, u_to_plot_3); hold on;
grid on;
legend('No PI', 'wpi=0.01', 'wpi=0.1');
xlabel('Time [s]');
ylabel('Force [N]');
print -depsc2 ForceLeadLowPassPIFreq.eps
print -depsc2 ForceLeadLowPassPIFreqwpi_wco.eps
legend('wpi=wco', 'location', 'southeast')

% figure;
% %d_to_plot= squeeze(distance_alone.signals.values(1,1,:));
% %plot(distance_alone.time, d_to_plot); hold on;
% d_to_plot_0= squeeze(distance_lead_0_1.signals.values(1,1,:));
% plot(distance_lead_0_1.time, d_to_plot_0); hold on;
% d_to_plot_1= squeeze(distance_lead_lowpass_whf_100.signals.values(1,1,:));
% plot(distance_lead_lowpass_whf_100.time, d_to_plot_1); hold on;
% d_to_plot_2= squeeze(distance_lead_lowpass_whf_50.signals.values(1,1,:));
% plot(distance_lead_lowpass_whf_50.time, d_to_plot_2); hold on;
% d_to_plot_3= squeeze(distance_lead_lowpass_whf_10.signals.values(1,1,:));
% plot(distance_lead_lowpass_whf_10.time, d_to_plot_3); hold on;
% grid on;
% legend('Lead only','whf=100', 'whf=50', 'whf=10', 'location', 'northeast');
% xlabel('Time [s]');
% ylabel('Distance [m]');
% print -depsc2 DistanceLeadLowpassFreq.eps
% 
figure;
%d_to_plot= squeeze(distance_alone.signals.values(1,1,:));
%plot(distance_alone.time, d_to_plot); hold on;
u_to_plot_0= squeeze(u_lead_0_1.signals.values(1,1,:));
plot(u_lead_0_1.time, u_to_plot_0); hold on;
u_to_plot_1= squeeze(u_lead_lowpass_whf_100.signals.values(1,1,:));
plot(u_lead_lowpass_whf_100.time, u_to_plot_1); hold on;
u_to_plot_2= squeeze(u_lead_lowpass_whf_50.signals.values(1,1,:));
plot(u_lead_lowpass_whf_50.time, u_to_plot_2); hold on;
u_to_plot_3= squeeze(u_lead_lowpass_whf_10.signals.values(1,1,:));
plot(u_lead_lowpass_whf_10.time, u_to_plot_3); hold on;
grid on;
legend('Lead only', 'whf=100', 'whf=50', 'whf=10');
xlabel('Time [s]');
ylabel('Force [N]');
print -depsc2 ForceLeadLowpassFreq.eps


P=nyquistoptions();
P.XLim=[-4.5, 0.5];
P.YLim=[-2.5, 2.5];
num=1;
den=[m, c, 0];
figure;
nyquist(tfsys, P); hold on;
nyquist(tf(num, den, 'InputDelay', 0.2), P); hold on;
nyquist(tf(num, den, 'InputDelay', 0.4), P); hold on;
legend('No delay', '0.2 s', '0.4 s');
print -depsc2 NysquistDelaySystem.eps

figure;
bodeplot(tfsys, opt);  hold on;
bodeplot(tf(num, den, 'InputDelay', 0.2), opt); hold on;
bodeplot(tf(num, den, 'InputDelay', 0.4), opt); hold on;
bodeplot(tf([1], [1]), opt); hold on;
legend('No delay', '0.2 s', '0.4 s');
print -depsc2 BodeplotDelaySystem.eps


%%%%%%%%%
% Final %
%%%%%%%%%
a=0.1;
whf=15;
tflead=1*tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
tflowpass=tf([1],[1/whf, 1]);
[G0, ~]=findGain(tflead*tfsys*tflowpass, wco);
figure;
bodeplot(G0*tflead*tflowpass*tfsys, opt);hold on;
bodeplot(tf([1], [1]), opt);
print -depsc2 BodeFinal.eps;
figure;
nyquist(G0*tflead*tflowpass*tfsys, P);hold on;
nyquist(tf([1], [1]), P);
print -depsc2 NyquistFinal.eps;

figure;
bodeplot(1/(1+G0*tflead*tflowpass*tfsys), opt); hold on; %S
bodeplot(tf([1], [1]), opt);
print -depsc2 Sfinal.eps;
figure;
bodeplot(tfsys/(1+G0*tflead*tflowpass*tfsys), opt); hold on; %PS
bodeplot(tf([1], [1]), opt);
print -depsc2 PSfinal.eps;
figure;
bodeplot(G0*tflead*tflowpass*tfsys/(1+G0*tflead*tflowpass*tfsys), opt); hold on; %T
bodeplot(tf([1], [1]), opt);
print -depsc2 Tfinal.eps;
figure;
bodeplot(G0*tflead*tflowpass/(1+G0*tflead*tflowpass*tfsys), opt); hold on; %CS
bodeplot(tf([1], [1]), opt);
print -depsc2 CSfinal.eps;

figure;
%d_to_plot= squeeze(distance_alone.signals.values(1,1,:));
%plot(distance_alone.time, d_to_plot); hold on;
u_to_plot_0= squeeze(u_test.signals.values(1,1,:));
plot(u_test.time, u_to_plot_0); hold on;
grid on;
xlabel('Time [s]');
ylabel('Force [N]');
print -depsc2 ForceFinal.eps

figure;
d_to_plot= squeeze(distance_test.signals.values(1,1,:));
plot(distance_test.time, d_to_plot); hold on;
grid on;
xlabel('Time [s]');
ylabel('Distance [m]');
print -depsc2 DistanceFinal.eps


