step = 0.01;
x = 0:step:(12-step);
runner = generateRunnerPositionsSimple(step);

% x_usain = [0 1.89 2.88 3.78 4.64 5.47 6.29 7.1 7.92 8.75 9.58];
% y_usain = [0 10 20 30 40 50 60 70 80 90 100];
% f = polyfit(x_usain,y_usain ,5);
% runner =polyval(f, x);

pl = figure;
plot(x, runner);
grid on;
xlabel('Time (s)');
ylabel('Distance (m)');
print(pl, 'graphs/Runner', '-depsc2');

pl = figure;
plot(x, runner);
grid on;
xlabel('Time (s)');
ylabel('Distance (m)');
title('Simple runner simulation');
print(pl, 'graphs/Runner', '-dpng', '-r500');
