function coureur = generateRunnerPositionsSimple(timeStep)
init_dist = 0;
speed = 5 * timeStep;
start = 1/timeStep; 
stop = 3 /timeStep;

for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 5 /timeStep;
speed = 8 * timeStep;
for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 12 /timeStep;
speed = 12 * timeStep;
for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end
end

