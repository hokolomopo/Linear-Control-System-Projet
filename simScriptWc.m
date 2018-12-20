close all;
clear all;

define_consts()

zeta_c =0.75;
wc = [1,3,5];
zeta_o = zeta_c;

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');

force = figure('Name','Force');
difference = figure('Name','Difference');
stabilisation = figure('Name','stabilisation');

for i = 1 : length(wc)
    omega_c = wc(i);
    omega_o = 10 * omega_c;
    
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
% title('Accelaration of camera');
legend(sprintf('\\omega_c = %.2f', wc(1)), sprintf('\\omega_c = %.2f', wc(2)), sprintf('\\omega_c = %.2f', wc(3)) ,'Location', 'southeast');

figure(difference);
grid on;
xlabel('Time (s)');
ylabel('Difference (m)');
% title('Difference of positions');
legend(sprintf('\\omega_c = %.2f', wc(1)), sprintf('\\omega_c = %.2f', wc(2)), sprintf('\\omega_c = %.2f', wc(3)) ,'Location', 'southeast');

figure(stabilisation);
grid on;
ylabel('Position (m)');
xlabel('Time (s)')
% title('Stability?');
legend(sprintf('\\omega_c = %.2f', wc(1)), sprintf('\\omega_c = %.2f', wc(2)), sprintf('\\omega_c = %.2f', wc(3)) ,'Location', 'southeast');

print(force, 'graphs/forceDifferentsWc', '-depsc2');
print(difference, 'graphs/differenceDifferentsWc', '-depsc2');
print(stabilisation, 'graphs/stabilisationDifferentsWc', '-depsc2');

figure(force);
title('Force exerted on camera');

figure(difference);
title('Difference of positions');

figure(stabilisation);
title('Stability');

print(force, 'graphs/forceDifferentsWc', '-dpng', '-r500');
print(difference, 'graphs/differenceDifferentsWc', '-dpng', '-r500');
print(stabilisation, 'graphs/stabilisationDifferentsWc', '-dpng', '-r500');
