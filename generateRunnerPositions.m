function coureur = generateRunnerPositions(timeStep)
init_dist = 0;
speed = 3 * timeStep;
start = 1/timeStep; 
stop = 3 /timeStep;

for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 6 /timeStep;
speed = 5 * timeStep;
for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 9 /timeStep;
speed = 10 * timeStep;
for i=start:stop
    coureur(i) =(i-start)*speed + init_dist;
end

init_dist = coureur(stop);
start = stop + 1; 
stop = 10 /timeStep;
for i=start:stop
    coureur(i) =init_dist;
end

end

