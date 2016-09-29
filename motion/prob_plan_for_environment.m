function trajs = prob_plan_for_environment(x0,env,bmm,models,use_goal)

colors = 'rgbmcy';

if nargin < 2
    use_goal = true;
end

%% solve level one thing at a time

if bmm.k <= 3
    plan = [1];
    next_gate = [];
    prev_gate = [length(env.gates)];
    
    for i = 1:length(env.gates)
        plan = [3 2 plan];
        next_gate = [next_gate i i+1];
        prev_gate = [length(env.gates)-i length(env.gates)-(i-1) prev_gate];
    end
else
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
end

disp('here')
%% create options for gates
% note that these are definitely temporary placeholders
next_opt = ones(size(next_gate));
prev_opt = ones(size(prev_gate));

%% run

trajs = cell(length(plan),1);

hold on;
draw_environment(env,false,true);

fprintf('==============\n');
fprintf('==============\n');

x = x0;

% for each step in plan
for i = 1:length(plan)-1

    fprintf('--------------\n');
    fprintf('ACTION: %d, model=%d, gate=%d, prev_gate=%d\n',i,plan(i),next_gate(i),prev_gate(i));
    
    current = models{plan(i)};
    goal = models{plan(i+1)};
    
    local_env = [];
    local_env.gates = env.gates;
    local_env.obstacles = env.surfaces;
    local_env.exit = [env.width;env.height / 2; 0];
    if next_gate(i) <= length(env.gates)
        local_env.gate = env.gates{next_gate(i)}{next_opt(i)};
    end
    if prev_gate(i) > 0
        local_env.prev_gate = env.gates{prev_gate(i)}{prev_opt(i)};
    end
    next_env = [];
    next_env.gates = env.gates;
    next_env.obstacles = env.surfaces;
    next_env.exit = local_env.exit;
    if next_gate(i+1) <= length(env.gates)
        next_env.gate = env.gates{next_gate(i+1)}{next_opt(i)};
    end
    if prev_gate(i+1) > 0
        next_env.prev_gate = env.gates{prev_gate(i+1)}{prev_opt(i)};
    end
    
    if use_goal
        traj = prob_planning(x,current,goal,local_env,next_env);
    else
        traj = prob_planning_no_goal(x,current,local_env);
    end
    
    plot(traj(1,:),traj(2,:),colors(plan(i)));
    
    x = traj(:,end);
    
    trajs{i} = traj;
end

if bmm.k <= 3
    fprintf('==============\n');
    fprintf('ACTION: %d, model=%d, going to exit\n',i+1,plan(i+1));
    
    traj = prob_planning_no_goal(x0,goal,next_env,env.surfaces);
    plot(traj(1,:),traj(2,:));
    
    trajs{i+1} = traj;
end