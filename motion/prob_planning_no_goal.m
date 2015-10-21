function [ traj, Z ] = prob_planning_no_goal( x0, model, local_env, obstacles, Z)
%UNTITLED Summary of this function goes here
%   model is the skill we are using
%   next_model is the following skill
%   env is a representation of the local environment
%   Z is the initial distribution we will refine

SHOW_FIGURES = false;
STEP_SIZE = 0.55;
N_SAMPLES = 75;
N_ITER = 10;
N_PRIMITIVES = model.num_primitives;
N_Z_DIM = 3*N_PRIMITIVES;
N_STEPS = 10;
N_GEN_SAMPLES = 50*N_SAMPLES;

max_p = 1;

if nargin < 4
    obstacles = {};
end
if nargin < 5
    if model.in_gate
        xg = local_env.prev_gate.width;
        local_env.prev_gate.corners
    elseif model.use_gate
        %xg = x0(1:2)' - [(local_env.gate.x-(cos(local_env.gate.w)*local_env.gate.width)) local_env.gate.y];
        xg = x0(1:2)' - [local_env.gate.x local_env.gate.y];
    else
        xg = x0(1) - local_env.exit(1);
    end
    movement_guess = model.movement_mean;
    N_STEPS = ceil(norm(xg) / N_PRIMITIVES / movement_guess);
    
    mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([0;movement_guess;N_STEPS],N_PRIMITIVES,1);
    cv = [model.movement_dev 0 0; 0 model.rotation_dev 0; 0 0 1];
    sigma = eye(N_Z_DIM);
    for i=1:3:N_Z_DIM
        sigma(i:(i+2),i:(i+2)) = cv;
    end
    Z  = struct('mu',mu,'sigma',sigma);
end
if nargin < 6
    
end

trajs = cell(N_SAMPLES,1);

iter = 1;
while iter < N_ITER
    
    samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES);
    params = zeros(size(samples,1),N_SAMPLES);
    
    %figure(1+iter);clf;hold on;
    %draw_gates({local_env.gate});
    %draw_surfaces(obstacles);
    
    p = zeros(N_SAMPLES,1);
    pg = zeros(N_SAMPLES,1);
    
    sample = 0;
    for i = 1:N_GEN_SAMPLES
        p_z = log(mvnpdf(samples(:,i),Z.mu,Z.sigma));
        traj = sample_seq(x0,samples(:,i));
        
        if check_collisions(traj,obstacles) == 0
            
            sample = sample + 1;
            
            trajs{sample} = traj;
            params(:,sample) = samples(:,i);
            
            fa = traj_get_reproduction_features(traj(:,1:end-1),model,local_env);
            len = size(fa,2);
            fa = [1000 * (1:len) / len; fa];
            
            %ps = mvnpdf(f(1:(end),:),model.Mu,model.Sigma);

            %% THIS BLOCK IS WHERE WE COMPUTE THE LIKELIHOODS
            p_action = log(mean(exp(compute_loglik(fa,model.Mu,model.Sigma,model,model.in))));
            
            p(sample) =  exp(p_action);
            pg(sample) = exp(p_action);
            
            if sample == N_SAMPLES
                break
            end
        end
    end
    
    if sum(p) == 0
        continue
    end
    
    % update z
    max_p = max(p(1:sample));
    
    avg_p = mean(p(1:sample));
    avg_pg = mean(pg(1:sample));
    
    if 0; %avg_pg < last_avg_p
        fprintf('skipping: %f < %f\n',log(avg_pg),log(last_avg_p));
        continue;
    end
    p = p / sum(p);
    
    mu = zeros(size(Z.mu));
    sigma = zeros(size(Z.sigma));
    for i=1:sample
        mu = mu + (p(i) * params(:,i));
    end
    for i=1:sample
        ds = params(:,i)-mu;
        sigma = sigma + (p(i) * (ds * ds'));
    end
    
    dsigma = STEP_SIZE*(Z.sigma - sigma);
    
    Z  = struct('mu',mu,'sigma',Z.sigma-dsigma);
    Z.sigma = Z.sigma + (1e-10*eye(N_Z_DIM));
    
    fprintf('... done iter %d. avg p = %f, avg obj = %f\n',iter,log(avg_p),log(avg_pg));
    iter = iter + 1;
end

[~,idx] = max(pg);
traj = trajs{idx};

end

% detect a "bad" trajectory
% these are trajectories that lead to an immediate failure, such as hitting
% an obstacle
function obs = check_collisions(traj,obstacles)
obs = 0;
for i = 1:length(obstacles)
    if ~obstacles{i}.isDeepTissue
        continue
    elseif any(inpolygon(traj(1,:),traj(2,:),obstacles{i}.bounds(1,:),obstacles{i}.bounds(2,:)))
        obs = i;
        break;
    end
end
end
