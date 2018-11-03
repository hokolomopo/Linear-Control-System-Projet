define_consts()

opt = simset('solver','ode45','SrcWorkspace','Current','AbsTol','1e-3');
sim('observer', [0,10],opt)

acc = figure;
xlabel('time(s)');