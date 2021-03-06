function [ trajs, params, Z, p, pa, pg, idx ] = traj_forward( x0, px0, model, next_model, local_env, next_env, Z, config, N_SAMPLES, START_T)
%TRAJ_FORWARD Generate forward samples of an action
%   model is the skill we are using
%   next_model is the following skill
%   env is a representation of the local environment
%   Z is the initial distribution we will refine

%% set up
USE_GOAL = true;
if ~isstruct(next_model)
    %fprintf('NOTE: Not using goal.\n');
    USE_GOAL = false;
end

%% set number of iterations to run and other options
if nargin < 8
    start_iter = 1;
    N_PRIMITIVES = model.num_primitives;
    N_SAMPLES = 100;
    good = 1;
    WEIGHTED_SAMPLE_STARTS = true;
else
    start_iter = config.start_iter;
    N_PRIMITIVES = config.n_primitives;
    good = config.good;
    WEIGHTED_SAMPLE_STARTS = config.weighted_sample_starts;
    
    if nargin < 9
        N_SAMPLES = config.n_samples;
    end
    if nargin < 10
        START_T = 1;
    end
end

%% make sure this is a valid probability distribution

if any(isnan(px0))
    fprintf('WARNING: invalid probabilities. This branch is dead.\n');
    p = zeros(N_SAMPLES, 1);
    pa = zeros(N_SAMPLES, 1);
    pg = zeros(N_SAMPLES, 1);
    trajs = {};
    params = [];
    idx = (1:N_SAMPLES)';
    return
end

assert(abs(sum(px0) - 1) < 1e-8);

N_Z_DIM = 3*N_PRIMITIVES;
N_GEN_SAMPLES = 5*N_SAMPLES;
next_sample = 1;

idx = zeros(N_SAMPLES,1);

%% setup Z
if nargin < 7 || ~isstruct(Z)
    if model.in_gate
        xg = local_env.prev_gate.width;
        local_env.prev_gate.corners
        rg = 0;
    elseif model.use_gate
        mx0 = weighted_ends_mean(x0, px0);
        %xg = x0(1:2)' - [(local_env.gate.x-(cos(local_env.gate.w)*local_env.gate.width)) local_env.gate.y];
        xg = mx0(1:2)' - [local_env.gate.x local_env.gate.y];
        rg = atan2(local_env.gate.y-x0(2),local_env.gate.x-x0(1));
        if rg < -pi
            rg = rg + pi;
        elseif rg > pi
            rg = rg - pi;
        end
    else
        xg = x0(1) - local_env.exit(1);
        rg = 0;
    end
    movement_guess = model.movement_mean;
    N_STEPS = ceil(norm(xg) / config.n_primitives / movement_guess);
    
    rg = rg / (config.n_primitives*N_STEPS) * 20;
    mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([rg;movement_guess;N_STEPS],config.n_primitives,1);
    cv = [model.movement_dev 0 0; 0 model.rotation_dev 0; 0 0 1];
    sigma = eye(N_Z_DIM);
    for i=1:3:N_Z_DIM
        sigma(i:(i+2),i:(i+2)) = cv * 1e-1;
    end
    Z  = struct('mu',mu,'sigma',sigma);
end


%% run
trajs = cell(N_SAMPLES,1);

iter = start_iter;

if strcmp(config.draw,'mvn')
    samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES);
elseif strcmp(config.draw,'uniform')
    samples = uniform_sample(Z.mu,Z.sigma,N_GEN_SAMPLES);
else
    fprintf('Draw option not recognized.\n');
    assert(false);
end

params = zeros(size(samples,1),N_SAMPLES);

%% INITIALIZE EMPTY VARIABLES
p = zeros(N_SAMPLES,1);
pa = zeros(N_SAMPLES,1);
pg = zeros(N_SAMPLES,1);

%% GENERATE SAMPLES AND COMPUTE PROBABILITIES
cpx0 = cumsum(px0);
sample = 0;
for i = 1:N_GEN_SAMPLES
    
    if WEIGHTED_SAMPLE_STARTS
        x_idx = min(find(rand() < cpx0));
    else
        x_idx = mod(i-1, length(cpx0))+1;
    end
    x = x0(:,x_idx);
    traj = sample_seq(x,samples(:,i));
    
    %if check_collisions(traj,local_env.obstacles) == 0
        [obs, colliding] = check_collisions(traj,local_env.obstacles);
        
        sample = sample + 1;
        idx(sample) = x_idx;
        
        trajs{sample} = traj;
        params(:,sample) = samples(:,i);
        
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
        
        if USE_GOAL
            fg = traj_get_reproduction_features(traj(:,end),next_model,next_env);
            if next_model.use_time
                fg = [0;fg];
                %fprintf('WARNING: time wrong');
            end
        end
        
        %% THIS BLOCK IS WHERE WE COMPUTE THE LIKELIHOODS
        
        p_action_traj = compute_loglik(fa,model.Mu,model.Sigma,model,model.in);
        if obs > 0
            p_action_traj(colliding) =  -1000;
        end
        p_action = mean(p_action_traj);
        
        if USE_GOAL
            p_goal = compute_loglik(fg,next_model.Mu,(next_model.Sigma),next_model,next_model.in);
            p(sample) =  exp(p_action);
            
            pa(sample) = exp(p_action);
            pg(sample) = exp(p_goal);
        else
            p(sample) =  exp(p_action);
            pa(sample) =  exp(p_action);
            pg(sample) = exp(p_action);
        end
        
        if config.show_figures
            plot(traj(1,:),traj(2,:),'color',model.color);
        end
        
        if sample == N_SAMPLES
            break
        end
    %end
end
end


% detect a "bad" trajectory
% these are trajectories that lead to an immediate failure, such as hitting
% an obstacle
function [obs, colliding] = check_collisions(traj,obstacles)
obs = 0;
colliding = zeros(1, length(traj));
for i = 1:length(obstacles)
    if ~obstacles{i}.isDeepTissue
        continue
    else
        colliding = colliding | inpolygon(traj(1,:),traj(2,:),obstacles{i}.bounds(1,:),obstacles{i}.bounds(2,:));
        if any(colliding)
            obs = i;
            break;
        end
    end
end    
end

