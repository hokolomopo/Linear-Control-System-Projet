close all
clear all

c = 0.25;
m = 10;

A = [0 1; 0 -c/m];
B = [0 0;1/m 0];
C = [1 0];
D = [0 -1];

step = 0.01;
endTime = 40;

t = 0:step:endTime;
u = zeros(2, size(t, 2));
x0 = [0 0];

speed = 1;
for i=1000:2000
    u(2, i) =(i-1000)*step*speed;
end
for i=2001:size(t, 2)
        u(2, i) =1000*step*speed;
end

%Creating the system
sys = ss(A,B,C,D);

controlability_matrix = ctrb(sys)
rank(controlability_matrix);

fig = figure;

[y,t,~] = lsim(sys,u,t,x0);

subplot(3,1,1);
plot(t, u(1, :));
title('Force exerted by the actuator (u1)');
xlabel('Time (sec)')
ylabel('Force (N)')

subplot(3,1, 2);
plot(t, u(2, :));
title('Position of Runner (u2)');
xlabel('Time (sec)')
ylim([-2 12])
ylabel('Position (m)')

subplot(3,1,3);
plot(t,y)
title('Distance between Camera and Runner (Output y)')
ylabel('Distance (m)')
ylim([-12, 2])
xlabel('Time (sec)')

print(fig, 'openLoopRunner', '-deps');

endTime = 80;
t = 0:step:endTime;

u = zeros(2, size(t, 2));

for i=100:200
    u(1, i) = 10;
end

[y,t,~] = lsim(sys,u,t,x0);

fig2 = figure;
subplot(3,1,1);
plot(t, u(1, :));
title('Force exerted by the actuator (u1)');
xlabel('Time (sec)')
ylim([-2 12])
ylabel('Force (N)')

subplot(3,1, 2);
plot(t, u(2, :));
title('Position of Runner (u2)');
xlabel('Time (sec)')
ylabel('Position (m)')

subplot(3,1,3);
plot(t,y)
title('Distance between Camera and Runner (Output y)')
ylabel('Distance (m)')
xlabel('Time (sec)')

print(fig2, 'openLoopMotor', '-deps');




% m = 10;
% k = 3;
% c = 2;
% 
% A = [0 1; -k/m -c/m];
% B = [0; 1/m];
% C = [1 0];
% D = [0];
% 
% step = 0.01;
% t = 0:step:100;
% u = zeros(size(t));
% for i=1000:2000
%     u(i) = u(i) + sin(i*step);
% end
% 
% x0 = [0 0];
% 
