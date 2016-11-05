%% Test GP update
% create "dataset"

[traj, nodes] = run_mcts_test(envs{4}, models);
x = nodes(2).traj_params';
y = log(nodes(2).traj_p);
min_xs = nodes(2).Z.mu(1) - 2 * nodes(2).Z.sigma(1,1);
max_xs = nodes(2).Z.mu(1) + 2 * nodes(2).Z.sigma(1,1);
xs = nodes(2).traj_params'; %linspace(min_xs, max_xs, 101)';                  % 61 test inputs

% set up the mean
meanfunc = [];
covfunc = @covSEiso;
covfunc = @covSEard;
likfunc = @likGauss;
%hyp = struct('mean', [], 'cov', [0 0], 'lik', 0.0);
hyp = struct('mean', [], 'cov', zeros(13,1), 'lik', 0.0);

% new params
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

START_T = 0;
local_env = nodes(2).local_env;
model = nodes(2).models{nodes(2).action_idx};
for iter = 1:3
    figure(1);
    draw_environment(envs{4});
    Z = nodes(2).Z;
    
    %% Run for N iterations
    % GP/cross entropy optimization
    N_ITER = 5;
    N_GEN_SAMPLES = 500;
    for i = 1:N_ITER
        samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES)';
        %samples = x';
        [p, sp] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, samples);
        x0 = [190; 1000; 0; 0; 0];
        [pmax, idx] = max(p);
        traj = sample_seq(x0,samples(idx,:)');
        plot(traj(1,:),traj(2,:),'b*');
        
        Z = traj_update(samples', exp(p), Z);
    end
    
    
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
    p_action = mean(p_action_traj);
    fprintf('actual: %f, expected: %f\n', p_action, pmax);
    
    x = [x; samples(idx,:)];
    y = [y; p_action];
    
end
