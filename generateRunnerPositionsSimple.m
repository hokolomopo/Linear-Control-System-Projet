function coureur = generateRunnerPositionsSimple(timeStep)
init_dist = 0;
speed = 3 * timeStep;
start = 1/timeStep; 
stop = 4 /timeStep;

for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 8 /timeStep;
speed = 5 * timeStep;
for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 12 /timeStep;
speed = 1 * timeStep;
for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end
end

