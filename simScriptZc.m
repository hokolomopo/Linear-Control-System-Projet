close all;
clear all;

define_consts()

zc = [0.9, 0.75, 0.5];
omega_c = 3;
omega_o = 10 * omega_c;

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');

force = figure('Name','force');
difference = figure('Name','Difference');
stabilisation = figure('Name','stabilisation');

for i = 1 : length(zc)
    zeta_c = zc(i);
    zeta_o = zeta_c;
    
    createKL()
    sim('observer', [0,10],opt);
    acc = dx.data(:,1);
    
    figure(force);
    plot(dx.time, acc);hold on;

    figure(difference);
    plot(diff);hold on;
    
    sim('observer_noref', [0,10],opt);
    figure(stabilisation)
    plot(x_camera);hold on;

end


figure(force);
grid on;
xlabel('Time (s)')
ylabel('Force (N)');
legend(sprintf('\\zeta_c = %.2f', zc(1)), sprintf('\\zeta_c = %.2f', zc(2)), sprintf('\\zeta_c = %.2f', zc(3)),'Location', 'northeast');

figure(difference);
grid on;
xlabel('Time (s)')
ylabel('Difference (m)');
legend(sprintf('\\zeta_c = %.2f', zc(1)), sprintf('\\zeta_c = %.2f', zc(2)), sprintf('\\zeta_c = %.2f', zc(3)),'Location', 'southeast');

figure(stabilisation);
grid on;
xlabel('Time (s)')
ylabel('Position (m)');
legend(sprintf('\\zeta_c = %.2f', zc(1)), sprintf('\\zeta_c = %.2f', zc(2)), sprintf('\\zeta_c = %.2f', zc(3)),'Location', 'northeast');

print(force, 'graphs/forceDifferentsZc', '-depsc2');
print(difference, 'graphs/differenceDifferentsZc', '-depsc2');
print(stabilisation, 'graphs/stabilisationDifferentsZc', '-depsc2');

figure(force);
title('Force exerted on camera');

figure(difference);
title('Difference of positions');

figure(stabilisation);
title('Stability');

print(force, 'graphs/forceDifferentsZc', '-dpng', '-r500');
print(difference, 'graphs/differenceDifferentsZc', '-dpng', '-r500');
print(stabilisation, 'graphs/stabilisationDifferentsZc', '-dpng', '-r500');