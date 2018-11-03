close all
clear all

c = 0.25;
m = 10;

A = [0 1; 0 -c/m];
B = [0;1/m];
C = [1 0];
D = 0;

step = 0.01;
endTime = 2;
t = 0:step:endTime;

u = zeros(1, size(t, 2));
x0 = [1 0];

speed = 1;
% for i=1000:2000
%     u(i) =(i-1000)*step*speed;
% end
% for i=2001:size(t, 2)
%         u(i) =1000*step*speed;
% end

%Creating the system
sys = ss(A,B,C,D);

controlability_matrix = ctrb(sys);
rank(controlability_matrix);

u = zeros(1, size(t, 2));
% for i=100:200
%     u(1, i) = 10;
% end

p1(1) = -10 + 5i;
p2(1) = -10 - 5i;

p1(2) = -10 + 10i;
p2(2) = -10 - 10i;

p1(3) = -10 + 15i;
p2(3) = -10 - 15i;

p1(4) = -5 + 5i;
p2(4) = -5 - 5i;

p1(4) = -150 + i;
p2(4) = -150 - i;

%K = acker(A,B,[p1 p2])
fig2 = figure;
for i=1:4
    K = place(A,B,[p1(i) p2(i)]);
    sys = ss(A-B*K,B,C,D);
    [y,t,~] = lsim(sys,u,t,x0);
    

    k_r = -1/(C*(A-B*K)^-1 *B);
    plot(t,y);hold on;
end
legend(num2str(p1(1)), num2str(p1(2)), num2str(p1(3)), num2str(p1(4)));
title('Distance between Camera and Runner (Output y)')
ylabel('Distance (m)')
xlabel('Time (sec)')
% 
% print(fig2, 'openLoopMotor', '-deps');
