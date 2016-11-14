%% Test GP update
% create "dataset"

ENV = 2;
figure(1); clf; hold on;
[traj, nodes] = run_mcts_test(envs{ENV}, models);
x = nodes(2).traj_params';
y = log(nodes(2).traj_p);
min_xs = nodes(2).Z.mu(1) - 2 * nodes(2).Z.sigma(1,1);
max_xs = nodes(2).Z.mu(1) + 2 * nodes(2).Z.sigma(1,1);
xs = nodes(2).traj_params'; %linspace(min_xs, max_xs, 101)';                  % 61 test inputs

% set up the mean
meanfunc = [];
covfunc = @covSEiso;
%covfunc = @covSEard;
likfunc = @likGauss;
hyp = struct('mean', [], 'cov', [1 1], 'lik', 0.1);
%hyp = struct('mean', [], 'cov', zeros(13,1), 'lik', 0.0);

% new params
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

START_T = 0;
local_env = nodes(2).local_env;
model = nodes(2).models{nodes(2).action_idx};
goal_node = nodes(nodes(2).goals(1));
goal_model = goal_node.models{goal_node.action_idx};
figure(1); draw_environment(envs{ENV});

N_ITER = 30;
gamma = zeros(N_ITER+1,1);
delta = 1e-6;
alpha = log(2/delta);

for iter = 1:N_ITER
    Z = nodes(2).Z;
    
    %% Run for N iterations
    % GP/cross entropy optimization
    N_ITER = 5;
    N_GEN_SAMPLES = 100;
    for i = 1:N_ITER
        samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES)';
        %samples = x';
        [p, sp] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, samples);
        
        x0 = [190; 1000; 0; 0; 0];
        
        phi = alpha*sqrt(sp + gamma(iter)) - sqrt(gamma(iter));
        
        [pmax, idx] = max(p + phi);
        
        [p (p + phi) exp(p + phi)]
        
        Z = traj_update(samples', exp(p + phi), Z);
    end
    
    % variance of the selected value
    spmax = sp(idx);
    gamma(iter + 1) = gamma(iter) + sqrt(spmax)
    
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
