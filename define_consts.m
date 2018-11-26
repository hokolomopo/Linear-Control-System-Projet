clear all
close all

c = 0.25;
m = 10;

A = [0 1; 0 -c/m];
B = [0;1/m];
C = [1 0];
D = 0;
x0 = [0 0];

step = 0.01;
endTime = 2;
t = 0:step:endTime;


t = step * [0:49]';
u = zeros(size(t, 1), 1);
for i=100:200
    u(i) = 10;
end

% y = 10*sin(t);
sig.time = [];
sig.signals.values = [u];
sig.signals.dimensions =1;

zeta_c = 0.75;
omega_c = 5;
zeta_o = zeta_c;
omega_o = 10 * omega_c;

K = zeros(1, 2);
K(1) = omega_c^2 * m;
K(2) = zeta_c*2*m*omega_c - c;

% p1(1) = -5 + 5i;
% p2(1) = -5 - 5i;
% K = place(A,B,[p1 p2]);
% sys = ss(A-B*K,B,C,D);
% damp(sys)

k_r = K(1);

L = zeros(2, 1);
L(1) = 2* zeta_o * omega_o - c / m;
L(2) = omega_o^2 -2 * zeta_o * omega_o * c /m + c^2/m^2;

t = 0:step:10;
t = t';


coureur = generateRunnerPositionsSimple(step);
coureur = coureur';

% x_usain = [0 1.89 2.88 3.78 4.64 5.47 6.29 7.1 7.92 8.75 9.58];
% y_usain = [0 10 20 30 40 50 60 70 80 90 100];
% f = polyfit(x_usain,y_usain ,3);
% coureur =polyval(f, t);
% coureur = coureur(1:1000);

ref.time = [];
ref.signals.values = [coureur];
ref.signals.dimensions =1;
