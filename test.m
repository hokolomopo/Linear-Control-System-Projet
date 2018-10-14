m = 10;
k = 3;
c = 2;

% A = [0 1; 0 0];
% B = [0 0; 1/m 0];
% C = [-1 0];
% D = [0 1];

A = [0 1; -k/m -c/m];
B = [0; 1/m];
C = [1 0];
D = [0];

poles = eig(A);

t = 0:0.01:100;
u = zeros(size(t));
x0 = [0.01 0];

sys = ss(A,B,C,0);

[y,t,x] = lsim(sys,u,t,x0);
plot(t,y)
title('Open-Loop Response to Non-Zero Initial Condition')
xlabel('Time (sec)')
ylabel('Camera Position (m)')
