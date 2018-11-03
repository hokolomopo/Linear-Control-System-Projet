fName = 'figDist.fig';

fig = openfig(fName);

title('Distance between camera and runner');
xlabel('Time (s)');
ylabel('Distance (m)');

saveas(fig, fName);
