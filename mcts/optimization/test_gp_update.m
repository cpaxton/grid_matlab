%% Test GP update
% create "dataset"

[traj, nodes] = run_mcts_test(envs{4}, models);
x = nodes(2).traj_params(:,1:10)';
y = log(nodes(2).traj_p(1:10));
min_xs = nodes(2).Z.mu(1) - 2 * nodes(2).Z.sigma(1,1);
max_xs = nodes(2).Z.mu(1) + 2 * nodes(2).Z.sigma(1,1);
xs = nodes(2).traj_params'; %linspace(min_xs, max_xs, 101)';                  % 61 test inputs

% set up the mean
meanfunc = [];
covfunc = @covSEiso;
likfunc = @likGauss;
hyp = struct('mean', [], 'cov', [0 0], 'lik', -1);

% new params
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

%% Run for N iterations

% inference

figure(2);
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);
plot_gp(mu, s2, x(:,1), y, xs(:,1));

for i = 1:1
    
end