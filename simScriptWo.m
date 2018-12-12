close all;
clear all;

define_consts()

zeta_c =0.7;
omega_c = 4;
zeta_o = zeta_c;
wo = [1,3,5];

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

for i = 1 : length(wo)
    omega_o = wo(i);
    
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
xlabel('Time (s)')
ylabel('Acceleration (m/s^2');
% title('Accelaration of camera');
legend(sprintf('\\omega_o = %.2f', wo(1)), sprintf('\\omega_o = %.2f', wo(2)), sprintf('\\omega_o = %.2f', wo(3)) ,'Location', 'southeast');

figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
% title('Difference of positions');
legend(sprintf('\\omega_o = %.2f', wo(1)), sprintf('\\omega_o = %.2f', wo(2)), sprintf('\\omega_o = %.2f', wo(3)) ,'Location', 'southeast');

figure(stabilisation);
ylabel('Position (m)');
xlabel('Time (s)')
% title('Stability?');
legend(sprintf('\\omega_o = %.2f', wo(1)), sprintf('\\omega_o = %.2f', wo(2)), sprintf('\\omega_o = %.2f', wo(3)) ,'Location', 'southeast');

print(acceleration, 'graphs/accelerationDifferentswo', '-depsc2');
print(difference, 'graphs/differenceDifferentswo', '-depsc2');
print(stabilisation, 'graphs/stabilisationDifferentswo', '-depsc2');

figure(acceleration);
title('Accelaration of camera');

figure(difference);
title('Difference of positions');

figure(stabilisation);
title('Stability');

print(acceleration, 'graphs/accelerationDifferentswo', '-dpng', '-r500');
print(difference, 'graphs/differenceDifferentswo', '-dpng', '-r500');
print(stabilisation, 'graphs/stabilisationDifferentswo', '-dpng', '-r500');
