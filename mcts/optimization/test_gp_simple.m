%% Test GP update
% create "dataset"

x = gpml_randn(0.8, 20, 1);                 % 20 training inputs
y = sin(3*x) + 0.1*gpml_randn(0.9, 20, 1);  % 20 noisy training targets
xs = linspace(-3, 3, 61)';                  % 61 test inputs

% set up the mean
meanfunc = [];
covfunc = @covSEiso;
likfunc = @likGauss;
hyp = struct('mean', [], 'cov', [0 0], 'lik', -1);

% new params
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

%% Inference
figure(1);
[mu, s2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);
plot_gp(mu, s2, x, y, xs);