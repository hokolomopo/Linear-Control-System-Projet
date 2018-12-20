close all

c = 0.2;
m = 7;

A = [0 1; 0 -c/m];
B = [0;1/m];
C = [1 0];
D = 0;
sys = ss(A,B,C,D);
tfsys=tf(sys);
wco=7.246377;
a=0.1;
tflead=tf([1, (wco*sqrt(a))],[1, wco/sqrt(a)]);
GL0=getGain(tflead * tfsys, wco);

opt = bodeoptions('cstprefs');
opt.FreqUnits='rad/s';
opt.XLim=[1E-4, 1E3];
opt.Ylim{1}= [-200, 200];
opt.Ylim{2}= [-270, 0];

bodeplot(GL0*tflead*tfsys, opt);hold on;

GL0=getGain(tfsys, wco);
bodeplot(GL0 * tfsys, opt);
