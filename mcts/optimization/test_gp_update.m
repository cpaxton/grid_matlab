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
likfunc = @likGauss;
hyp = struct('mean', [], 'cov', [0 0], 'lik', 0.0);

% new params
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

Z = nodes(2).Z;
%% Run for N iterations
% GP/cross entropy optimization
N_ITER = 15;
N_GEN_SAMPLES = 50;
for i = 1:N_ITER
    samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES);
    %samples = x';
    [p, sp] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);
    x0 = [190; 1000; 0; 0; 0];
    [pmax, idx] = max(p);
    traj = sample_seq(x0,samples(:,idx));
    plot(traj(1,:),traj(2,:),'b*');
    
    Z = traj_update(samples, exp(p), Z); 
end
