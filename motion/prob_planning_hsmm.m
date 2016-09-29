function [ traj, Z, avg_p, avg_pg ] = prob_planning_hsmm( x0, model, next_model, local_env, next_env, Z, config)
%UNTITLED Summary of this function goes here
%   model is the skill we are using
%   next_model is the following skill
%   env is a representation of the local environment
%   Z is the initial distribution we will refine

USE_GOAL = true;
if ~isstruct(next_model)
    %fprintf('NOTE: Not using goal.\n');
    USE_GOAL = false;
end
if nargin < 6
    obstacles = {};
end

%% set number of iterations to run and other options
if nargin < 8
    N_ITER = 10;
    N_SAMPLES = 100;
        config = struct('n_iter',1, ...
        'start_iter',1, ...
        'n_primitives',model.num_primitives, ...
        'n_samples',100, ...
        'step_size',0.75, ...
        'good',1, ...
        'show_figures',false);
else
    N_ITER = config.n_iter;
    start_iter = config.start_iter;
    config.n_primitives = config.n_primitives;
    N_SAMPLES = config.n_samples;
end
N_Z_DIM = 3*config.n_primitives;

%% setup Z
if nargin < 7 || ~isstruct(Z)
    movement_guess = model.movement_mean;
    rotation_guess = model.rotation_mean;
    N_STEPS = 10;
    
    mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([rotation_guess;movement_guess;N_STEPS],config.n_primitives,1);
    cv = [model.movement_dev 0 0; 0 model.rotation_dev 0; 0 0 1];
    sigma = eye(N_Z_DIM);
    for i=1:3:N_Z_DIM
        sigma(i:(i+2),i:(i+2)) = cv;
    end
    Z  = struct('mu',mu,'sigma',sigma);
end

%% run
iter = config.start_iter;
while iter < config.start_iter + N_ITER
    
    [~,traj_params,Z,p,pa,pg,idx] = traj_forward(x0,1,...
        model,next_model,...
        local_env,next_env,...
        Z,config);
    
    if (USE_GOAL)
       p = p .* pg;
    end
    
    [Z,good] = traj_update(traj_params,p,Z,config);
    config.good = good;
    
    fprintf('... done iter %d. avg p = %f, avg obj = %f\n',iter,log(mean(p)),log(mean(pg)));
    iter = iter + 1;
    
    traj = sample_seq(x0,Z.mu);
end

plot(traj(1,:),traj(2,:),'color',model.color);
