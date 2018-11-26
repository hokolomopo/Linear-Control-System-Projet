step = 0.01;

x = 0:step:(12-step);
runner = generateRunnerPositionsSimple(step);

pl = figure;
plot(x, runner);
xlabel('Time (s)');
ylabel('Distance (m)');
print(pl, 'graphs/loopShapingRunner', '-depsc2');
