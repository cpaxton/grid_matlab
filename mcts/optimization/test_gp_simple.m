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
figure(1); clf; hold on;
[mu, s2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);
plot_gp(mu, s2, x, y, xs);

Z = [];
Z.mu = mean(x);
Z.sigma = std(x);
N_GEN_SAMPLES = 100;
for i = 1:10
   x2 = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES)';
   [y2, sy2] = gp(hyp, @infGaussLik, meanfunc, covfunc, likfunc, x, y, x2);
   [ymax,idx] = max(y2);
   plot(x2(idx),ymax,'b*');
end