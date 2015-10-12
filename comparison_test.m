NTESTS = 10;
NX = 4;
NY = 3;
x0 = [150,950,-0.060]';

%% generate all those new levels
test1_envs = cell(16,1);
for i = 1:16
    env = generate_environment(1920,1080,2,2);
    test1_envs{i} = env;
end

test2_envs = cell(16,1);
for i = 1:16
    env = generate_environment(1920,1080,2,0);
    test2_envs{i} = env;
end

%% run old algorithm
figure(1);
for i = 1:NTESTS
    subplot(NX,NY,i);
    fprintf('[NAIVE/OBS] Plotting for level %d...\n',i);
    evaluate(x0,test1_envs{i},bmm,models)
    axis([0 2500 0 1500]);
end
figure(2);
for i = 1:NTESTS
    subplot(NX,NY,i);
    fprintf('[NAIVE/NONE] Plotting for level %d...\n',i);
    evaluate(x0,test2_envs{i},bmm,models)
    axis([0 2500 0 1500]);
end

%% run new algorithm, no goals
figure(3);
for i = 1:NTESTS
    subplot(NX,NY,i);
    fprintf('[BLIND/OBS] Plotting for level %d...\n',i);
    prob_plan_for_environment(x0,test1_envs{i},bmm,models,false);
    axis([0 2500 0 1500]);
end
figure(4);
for i = 1:NTESTS
    subplot(NX,NY,i);
    fprintf('[BLIND/NONE] Plotting for level %d...\n',i);
    prob_plan_for_environment(x0,test2_envs{i},bmm,models,false);
    axis([0 2500 0 1500]);
end

%% run new algorithm
figure(5);
for i = 1:NTESTS
    subplot(NX,NY,i);
    fprintf('[GOAL/OBS] Plotting for level %d...\n',i);
    prob_plan_for_environment(x0,test1_envs{i},bmm,models,true);
    axis([0 2500 0 1500]);
end
figure(6);
for i = 1:NTESTS
    subplot(NX,NY,i);
    fprintf('[GOAL/NONE] Plotting for level %d...\n',i);
    prob_plan_for_environment(x0,test2_envs{i},bmm,models,true);
    axis([0 2500 0 1500]);
end