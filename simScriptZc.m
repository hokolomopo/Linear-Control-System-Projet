close all;
clear all;

define_consts()

zc = [0.9, 0.75,0.5,0.3];
omega_c = 5;
omega_o = 10 * omega_c;

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');

acceleration = figure('Name','Acceleration');
xlabel('time(s)');
ylabel('Acceleration (m/s^2)');
title('Accelaration of camera');

difference = figure('Name','Difference');
xlabel('time(s)');
ylabel('Difference (m)');
title('Difference of positions');

stabilisation = figure('Name','stabilisation');
xlabel('time(s)');
ylabel('Position (m)');
title('Position of camera');

for i = 1 : length(zc)
    zeta_c = zc(i);
    zeta_o = zeta_c;
    
    createKL()
    sim('observer', [0,10],opt);
    acc = dx.data(:,2);
    
    figure(acceleration);
    plot(dx.time, acc);hold on;

    figure(difference);
    plot(diff);hold on;
    
    sim('observer_noref', [0,10],opt);
    figure(stabilisation)
    plot(x_camera);hold on;

end


figure(acceleration);
% xlabel(sprintf('Time(s) , \\omega_c = %.2f \\zeta_o = \\zeta_c, \\omega_o = 2*\\omega_c', omega_c));
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)');
% title('Accelaration of camera');
legend(sprintf('\\zeta_c = %.2f', zc(1)), sprintf('\\zeta_c = %.2f', zc(2)), sprintf('\\zeta_c = %.2f', zc(3)) ,sprintf('\\zeta_c = %.2f', zc(4)),'Location', 'southeast');

figure(difference);
% xlabel(sprintf('Time(s) , \\omega_c = %.2f \\zeta_o = \\zeta_c, \\omega_o = 2*\\omega_c', omega_c));
xlabel('Time (s)')
ylabel('Difference (m)');
% title('Difference of positions');
legend(sprintf('\\zeta_c = %.2f', zc(1)), sprintf('\\zeta_c = %.2f', zc(2)), sprintf('\\zeta_c = %.2f', zc(3)) ,sprintf('\\zeta_c = %.2f', zc(4)) ,'Location', 'northwest');

figure(stabilisation);
% xlabel(sprintf('Time(s) , \\omega_c = %.2f \\zeta_o = \\zeta_c, \\omega_o = 2*\\omega_c', omega_c));
xlabel('Time (s)')
ylabel('Position (m)');
% title('Stability?');
legend(sprintf('\\zeta_c = %.2f', zc(1)), sprintf('\\zeta_c = %.2f', zc(2)), sprintf('\\zeta_c = %.2f', zc(3)) ,sprintf('\\zeta_c = %.2f', zc(4)),'Location', 'southeast');

print(acceleration, 'accelerationDifferentsZc', '-depsc2');
print(difference, 'differenceDifferentsZc', '-depsc2');
print(stabilisation, 'stabilisationDifferentsZc', '-depsc2');