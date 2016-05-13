function [probabilities,chosen_trajs,labels] = prob_plan_for_environment_hsmm(x0,env,models,T,T0,max_actions)
% PROB_PLAN_FOR_ENVIRONMENT with transition probabilities
%   x0: start pt
%   env: environment
%   models: set of all actions
%   T: transition matrix
%   T0: initial transition matrix

colors = 'rgbmcy';

N_ITER = 10;
STEP_SIZE = 0.5;
N_SAMPLES = 200;
N_GEN_SAMPLES = 50*N_SAMPLES;
MAX_OPTIONS = 5;
MAX_PRIMITIVES = 5;
nprimitives = ones(MAX_PRIMITIVES,1) / MAX_PRIMITIVES;

if nargin < 2
    use_goal = true;
end

%% solve level one thing at a time

if nargin >= 6
    MAX_ACTIONS = max_actions;
else
    MAX_ACTIONS = 3;
end
NUM_ACTIONS = length(models);

%% create options for gates
% note that these are definitely temporary placeholders
% ideally we would sample this as well
NEXT_OPT = 1;
PREV_OPT = 1;

%% run

trajs = cell(MAX_ACTIONS,NUM_ACTIONS);
chosen_trajs = cell(MAX_ACTIONS,1);
labels = zeros(MAX_ACTIONS,1);
probabilites = zeros(MAX_ACTIONS,1);

hold on;
env
draw_environment(env,false,true);

action_probabilities = zeros(MAX_ACTIONS,NUM_ACTIONS);
Zs= cell(MAX_ACTIONS,NUM_ACTIONS);

fprintf('==============\n');
fprintf('==============\n');

x = x0;
curT = T0;

state = [];
state.gates_done = 0;
state.next_gate = 1;

next_gate = state.next_gate;
prev_gate = state.next_gate - 1;
% for each step in plan
for i = 1:MAX_ACTIONS
    
    for iter = 1:N_ITER
        
        x = x0;
        param_p = zeros(1,NUM_ACTIONS);
        
        for j = 1:NUM_ACTIONS
            
            config = struct('n_iter',1, ...
                'start_iter',iter, ...
                'n_primitives',3, ...
                'n_samples',N_SAMPLES*curT(j));
            
            %fprintf('--------------\n');
            
            current = models{j};
            
            local_env = [];
            local_env.gates = env.gates;
            local_env.obstacles = env.surfaces;
            local_env.exit = [env.width;env.height / 2; 0];
            if next_gate <= length(env.gates)
                local_env.gate = env.gates{next_gate}{NEXT_OPT};
            elseif isfield(models{j},'use_gate') && models{j}.use_gate
                continue
            end
            if prev_gate > 0
                local_env.prev_gate = env.gates{prev_gate}{PREV_OPT};
            elseif isfield(models{j},'use_prev_gate') && models{j}.use_prev_gate
                continue
            end
            fprintf('STEP: %d, model=%d, gate=%d, prev_gate=%d\n',i,j,next_gate,prev_gate);
            
            [traj,Z,p,~] = prob_planning_hsmm(x,current,0,local_env,0,env.surfaces,Zs{i,j},config);
            %[traj,Z,p,pg] = prob_planning(x,current,goal,local_env,next_env,env.surfaces,Zs{i,j},config);
            Zs{i,j} = Z;
            param_p(j) = p;
            
            plot(traj(1,:),traj(2,:),colors(j));
            
            %x = traj(:,end);
            
            trajs{i,j} = traj;
        end
        param_p = param_p / sum(param_p) * curT(j);
        action_probabilities(i,:) = ((1-(STEP_SIZE))*action_probabilities(i,:)) + ((STEP_SIZE)*param_p);
        
    end
    
    % move on
    [~,idx] = max(action_probabilities(i,:));
    probabilities(i) = idx;
    chosen_trajs{i} = trajs{i,idx};
    labels(i) = idx;
    x0 = trajs{i,idx}(:,end);
    curT = T(idx,:);
    
    % update state
    % trajs{i,idx} --- this is the trajectory we just executed
    [~,state] = compute_predicates( trajs{i,idx}, env, state );
    state = state(end); % this is the termination state after the trajectory
    % it determines which gates are next
end

end