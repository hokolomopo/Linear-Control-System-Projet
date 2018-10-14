m = 10;
k = 3;
c = 2;

% A = [0 1; 0 0];
% B = [0 0; 1/m 0];
% C = [-1 0];
% D = [0 1];
% 
% t = 0:0.01:100;
% u = zeros(size(t, 2), 2);
% x0 = [0.01 0];

A = [0 1; -k/m -c/m];
B = [0; 1/m];
C = [1 0];
D = [0];

step = 0.01;
t = 0:step:100;
u = zeros(size(t));
for i=1000:2000
    u(i) = u(i) + sin(i*step);
end

x0 = [0 0];

sys = ss(A,B,C,D);
% step(sys)
controlability_matrix = ctrb(sys);
rank(controlability_matrix);

figure
subplot(2,1,1);
plot(t, u);
title('Input');

subplot(2,1,2);
[y,t,x] = lsim(sys,u,t,x0);
plot(t,y)
title('Open-Loop Response to Non-Zero Initial Condition')
ylabel('Camera Position (m)')

xlabel('Time (sec)')
