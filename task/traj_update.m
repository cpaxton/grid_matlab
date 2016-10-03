function [ Z ] = traj_update( params, p, Z, config )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% set number of iterations to run and other options
if nargin < 4
    iter = 1;
    STEP_SIZE = 0.75;
    good = 1;
else
    iter = config.start_iter;
    STEP_SIZE = config.step_size;
    good = config.good;
end
N_Z_DIM = size(Z.mu,1);

%% update z

p = p / sum(p);

mu = zeros(size(Z.mu));
sigma = zeros(size(Z.sigma));
for i=1:config.n_samples
    mu = mu + (p(i) * params(:,i));
end
for i=1:config.n_samples
    ds = params(:,i)-mu;
    sigma = sigma + (p(i) * (ds * ds'));
end

dsigma = STEP_SIZE*(Z.sigma - sigma);

Z  = struct('mu',mu,'sigma',Z.sigma-dsigma);
noise = 0;%10^(-(good+iter));
%noise = 10^(-(iter));
Z.sigma = Z.sigma + (noise*eye(N_Z_DIM));

%fprintf('... done iter %d. avg p = %f\n',iter,log(avg_p));

end

