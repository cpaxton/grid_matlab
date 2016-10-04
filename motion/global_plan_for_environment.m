function trajs = global_plan_for_environment(x0,env,models)

%rng(100);
%rng(102);
N_ITER = 20;
STEP_SIZE = 0.85;
N_SAMPLES = 100;
N_GEN_SAMPLES = 50*N_SAMPLES;

%% solve level one thing at a time

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
            next_gate = [ii+1 ii+1 next_gate ];
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
last_avg_goal = 0;
good = 2;
last_reset = 0;
good_iters = 1;%ones(LEN,1);
actions = cell(LEN,1);
for iter = 1:N_ITER
    draw_environment(env);
    x = x0;
    px = 1;

    config = struct('n_iter',1, ...
        'start_iter',iter-last_reset, ...
        'n_primitives',3, ...
        'n_samples',N_SAMPLES, ...
        'step_size',STEP_SIZE, ...
        'good',good_iters, ...
        'show_figures',true, ...
        'weighted_sample_starts', true);
    
    fprintf('==============\n');
    %% forward pass
    for i = 1:good
        
        %fprintf('ACTION: %d, model=%d, gate=%d, prev_gate=%d\n',i,plan(i),next_gate(i),prev_gate(i));
        
        current = models{plan(i)};
        goal = models{plan(i+1)};
        config.num_primitives = current.num_primitives;
        config.good = good_iters;
        
        local_env = [];
        local_env.exit = [env.width;env.height / 2; 0];
        local_env.obstacles = env.surfaces;
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
        
        [trajs,traj_params,Z,p,pa,pg,idx] = traj_forward(x,px,current,goal,local_env,next_env,Zs{i},config);
        fprintf('... done action %d, iter %d. avg p = %f, avg obj = %f\n', i,iter,log(mean(p)),log(mean(pg)));
        Zs{i} = Z;
        
        action = [];
        %action = struct('test',{1},'trajs',trajs,'traj_params',traj_params,'p',p,'pa',pa,'pg',pg);
        action.trajs = trajs; %,'traj_params',traj_params,'p',p,'pa',pa,'pg',pg);
        action.traj_params = traj_params;
        action.idx = idx;
        action.p  = p;
        action.pg = pg;
        action.pa = pa;
        actions{i}=action;
        
        x = zeros(5,length(trajs));
        px = p / sum(p);
        %plot(trajs{1}(1,:),trajs{1}(2,:),colors(plan(i)));
        for j = 1:length(trajs)
            x(:,j) = trajs{j}(:,end);
        end
    end

    avg_goal = log(mean(actions{good}.pg));
    
    if abs(last_avg_goal - avg_goal) < 0.1 && good < LEN
        fprintf('EXPANDING HORIZON!\n');
        good = good + 1;
        last_reset = iter;
    else
        
        %% backward pass
        for i = good:-1:1
            
            % if good: update p appropriately
            if i == good
                p = actions{i}.pa .* actions{i}.pg;
                actions{i}.p = p;
                Z = traj_update(actions{i}.traj_params,p,Zs{i},config);
            else
                p = actions{i}.pa; % .* p; % assuming independent actions
                Z = traj_update_prev(actions{i}.traj_params,p,actions{i+1}.idx,actions{i+1}.p,Zs{i},config);
            end
            
            Zs{i} = Z;
        end
        
        
    end
    
    last_avg_goal = avg_goal; 
end
