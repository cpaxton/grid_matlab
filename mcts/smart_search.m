% Search Version 2
% - Initialize search by drawing a large number of samples recursively
% through the tree.
env = envs{4};

%% Create environment and set up
rng(101);
w0 = NeedleMasterWorld(env);

%x0 = [650; 700; 0; 0; 0];
%x0 = [600; 800; 0; 0; 0];
x0 = [190; 1000; 0; 0; 0];
config = make_default_mcts_config();
action_config = make_default_action_config();
%action_config = make_fixed_action_config();

%% get a  list of nodes
[plan, prev_gate, next_gate] = get_symbolic_plan(w0.env);
nodes = nodes_from_plan(plan, prev_gate, next_gate, w0, models, action_config);

%% start search
% initialize the tree
nodes = initialize_tree(nodes, x0, w0, config); % draw 100 samples and send them down the tree
% note: extra branches aren't "dead", they just have a heuristic associated
% with them.

count = 1;

xs = zeros(5, nodes(1).config.max_depth);

figure(1); clf; hold on;
draw_environment(w0.env);
draw_nodes(nodes);

%% GP setup

x = nodes(2).traj_params';
y = log(nodes(2).traj_p);

meanfunc = [];
covfunc = @covSEiso;
%covfunc = @covSEard;
likfunc = @likGauss;
hyp = struct('mean', [], 'cov', [1 1], 'lik', 0.1);
%hyp = struct('mean', [], 'cov', zeros(13,1), 'lik', 0.0);

START_T = 0;
local_env = nodes(2).local_env;
model = nodes(2).models{nodes(2).action_idx};
for iter = 1:30
    Z = nodes(2).Z;
    
    %% Run for N iterations
    % GP/cross entropy optimization
    N_ITER = 5;
    N_GEN_SAMPLES = 100;
    for i = 1:N_ITER
        samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES)';
        %samples = x';
        [p, ~] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, samples);
        x0 = [190; 1000; 0; 0; 0];
        [pmax, idx] = max(p);
        
        Z = traj_update(samples', exp(p), Z);
    end
    traj = sample_seq(x0,samples(idx,:)');
    plot(traj(1,:),traj(2,:),'b.');
    
    
    fa = traj_get_reproduction_features(traj(:,1:end-1),model,local_env);
    len = size(fa,2);
    if model.use_avg_len
        max_t = ceil(model.len_mean);
    else
        max_t = len;
    end
    if model.use_time
        fa = [1000 * ((START_T):(START_T+len-1)) / max_t; fa];
        %fprintf('WARNING: time wrong');
    end
    p_action_traj = compute_loglik(fa,model.Mu,model.Sigma,model,model.in);
    p_action_traj;
    p_action = (mean(p_action_traj));
    fprintf('actual: %f, expected: %f\n', p_action, pmax);
    
    x = [x; samples(idx,:)];
    y = [y; p_action];
    
end
[p, sp] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, x);
[maxp, idx] = max(y);

%% actually show the current best
traj = sample_seq(x0,samples(idx,:)');
    plot(traj(1,:),traj(2,:),'g*');

%% Main loop: iterate until budget is exhausted
% while not done
while count <= config.num_iter
   
    %% FORWARD: trace down the tree
    % chose either one of:
    % - draw each sample from GP distribution
    % - explore an existing sample (based on how good our existing samples
    % are)
    
    %% BACKWARD: trace back up the tree
    % back up expected values of explored branches
    % assign values to unexplored branches based on our estimates of how
    % goo they might be
    
    count = count + 1;
end
    