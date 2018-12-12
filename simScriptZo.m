close all;
clear all;

define_consts()

zeta_c = 0.7;
omega_c = 4;
omega_o = 10 * omega_c;
zo = [0.9, 0.75, 0.5];

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

for i = 1 : length(zo)
    zeta_o = zo(i);
    
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
ylabel('Acceleration (m/s^2)');
legend(sprintf('\\zeta_o = %.2f', zo(1)), sprintf('\\zeta_o = %.2f', zo(2)), sprintf('\\zeta_o = %.2f', zo(3)),'Location', 'northeast');

figure(difference);
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('\\zeta_o = %.2f', zo(1)), sprintf('\\zeta_o = %.2f', zo(2)), sprintf('\\zeta_o = %.2f', zo(3)),'Location', 'southeast');

figure(stabilisation);
xlabel('Time (s)')
ylabel('Position (m)');
legend(sprintf('\\zeta_o = %.2f', zo(1)), sprintf('\\zeta_o = %.2f', zo(2)), sprintf('\\zeta_o = %.2f', zo(3)),'Location', 'northeast');

print(acceleration, 'graphs/accelerationDifferentszo', '-depsc2');
print(difference, 'graphs/differenceDifferentszo', '-depsc2');
print(stabilisation, 'graphs/stabilisationDifferentszo', '-depsc2');

figure(acceleration);
title('Accelaration of camera');

figure(difference);
title('Difference of positions');

figure(stabilisation);
title('Stability');

print(acceleration, 'graphs/accelerationDifferentszo', '-dpng', '-r500');
print(difference, 'graphs/differenceDifferentszo', '-dpng', '-r500');
print(stabilisation, 'graphs/stabilisationDifferentszo', '-dpng', '-r500');