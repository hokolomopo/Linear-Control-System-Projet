define_consts()

sys = ss(A,B,C,D);
P = tf(sys);

C = tf([4, 1],[0, 2]);

S = 1/(1+P*C); % Sensitivity function
T = P*C / (1 + P*C); %Complementary sensitivity function
PS = P / (1 +  P*C); %Load sensitivity function
CS = C / (1 +  P*C); %Noise sensitivity 

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
bode(sys,options);
