rng(100);
N_ITER = 20;
STEP_SIZE = 0.55;
N_SAMPLES = 100;
N_GEN_SAMPLES = 50*N_SAMPLES;

%% solve level one thing at a time
%env = envs{6};
%env = envs{7};
env = generate_environment(1920,1080,1,0);

% plan ends with an "exit" action and goes to the final exit state
plan = [1 5];
ngates = length(env.gates);

prev_gate = [];
next_gate = [];

if ngates > 0
    
    plan = [2 plan];
    
    prev_gate = ngates;
    next_gate = ngates+1;
    
    if ngates > 1
        for i = 1:(ngates-1)
            plan = [2 3 plan];
            ii = ngates - i;
            prev_gate = [ii ii prev_gate];
            next_gate = [ii+1 ii+1 next_gate ]
        end
    end
    
    % "approach" for the first gate
    plan = [4 plan];
    prev_gate = [0 prev_gate];
    next_gate = [1 next_gate];
end

prev_gate = [prev_gate ngates ngates];
next_gate = [next_gate ngates+1 ngates+1];

trajs = cell(length(plan),1);

%% setup vars for iteration
LEN = length(plan)-1;
ITER = 1;
Zs = cell(LEN,1);

%% LOOP
for iter = 1:N_ITER
figure(iter);clf;hold on;
draw_environment(env);
x = [190,1000,0,0,0]';
for i = 1:LEN
    
    fprintf('==============\n');
    fprintf('ACTION: %d, model=%d, gate=%d, prev_gate=%d\n',i,plan(i),next_gate(i),prev_gate(i));
    
    current = models{plan(i)};
    goal = models{plan(i+1)};
    
    local_env = [];
    local_env.exit = [env.width;env.height / 2; 0];
    local_env.obstacles = {};
    local_env.gates = env.gates;
    if next_gate(i) <= length(env.gates)
        local_env.gate = env.gates{next_gate(i)}{1};
    end
    if prev_gate(i) > 0
        local_env.prev_gate = env.gates{prev_gate(i)}{1};
    end
    next_env = [];
    next_env.exit = local_env.exit;
    next_env.obstacles = {};
    next_env.gates = env.gates;
    if next_gate(i+1) <= length(env.gates)
        next_env.gate = env.gates{next_gate(i+1)}{1};
    end
    if prev_gate(i+1) > 0
        next_env.prev_gate = env.gates{prev_gate(i+1)}{1};
    end
    
    [traj,Z] = prob_planning(x,current,goal,local_env,next_env,env.surfaces,Zs{i},1,iter);
    Zs{i} = Z;
    
    plot(traj(1,:),traj(2,:),colors(plan(i)));
    
    x = traj(:,end);
    
    trajs{i} = traj;
    
end
end

if bmm.k <= 3
    fprintf('==============\n');
    fprintf('ACTION: %d, model=%d, going to exit\n',i+1,plan(i+1));
    
    traj = prob_planning_no_goal(x,goal,next_env,env.surfaces);
    plot(traj(1,:),traj(2,:));
    
    trajs{i+1} = traj;
end