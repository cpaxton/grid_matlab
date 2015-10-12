function [ traj, Z ] = prob_planning( x0, model, next_model, local_env, next_env, obstacles, Z)
%UNTITLED Summary of this function goes here
%   model is the skill we are using
%   next_model is the following skill
%   env is a representation of the local environment
%   Z is the initial distribution we will refine


STEP_SIZE = 0.75;
N_SAMPLES = 100;
N_ITER = 10;
N_PRIMITIVES = 4;
N_Z_DIM = 2*N_PRIMITIVES;
N_STEPS = 10;
N_GEN_SAMPLES = 50*N_SAMPLES;

max_p = 1;

if nargin < 6
    obstacles = {};
end
if nargin < 7
    if model.in_gate
        xg = local_env.prev_gate.width;
    elseif model.use_gate
        xg = x0(1:2)' - [(local_env.gate.x-(cos(local_env.gate.w)*local_env.gate.width)) local_env.gate.y];
    else
        xg = x0(1) - local_env.exit(1);
    end
    %movement_guess = norm(xg) / (N_PRIMITIVES * N_STEPS);
    %norm(xg(1:2)) / N_PRIMITIVES
    %fprintf('====%f===%f\n',movement_guess,norm(xg(1:2)) / N_PRIMITIVES);
    movement_guess = 15;
    N_STEPS = ceil(norm(xg) / N_PRIMITIVES / movement_guess);
    
    mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([0;movement_guess],N_PRIMITIVES,1);
    %cv = 0.01*cov([trials{1}{1}.rotation;trials{1}{1}.movement]');
    cv = [10 0; 0 5];
    sigma = eye(N_Z_DIM);
    for i=1:2:N_Z_DIM
        sigma(i:(i+1),i:(i+1)) = cv;
    end
    Z  = struct('mu',mu,'sigma',sigma);
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
        traj = sample_seq(x0,samples(:,i),N_STEPS);
        
        if check_collisions(traj,obstacles) == 0
            
            sample = sample + 1;
            
            trajs{sample} = traj;
            params(:,sample) = samples(:,i);
            
            fa = traj_get_reproduction_features(traj(:,1:end-1),model,local_env);
            fg = traj_get_reproduction_features(traj(:,end),next_model,next_env);
            len = size(fa,2);
            fa = [1000 * (1:len) / len; fa];
            fg = [0;fg];
            
            %ps = mvnpdf(f(1:(end),:),model.Mu,model.Sigma);

            %% THIS BLOCK IS WHERE WE COMPUTE THE LIKELIHOODS
            p_action = log(mean(exp(compute_loglik(fa,model.Mu,model.Sigma,model,model.in))));%/len;
            %p_action = sum(compute_loglik(fa,model.Mu,model.Sigma,model,model.in))/len;
            p_goal = compute_loglik(fg,next_model.Mu,(next_model.Sigma),next_model,next_model.in); %fg,next_model.Mu,next_model.Sigma);
            
            %fprintf('%f / %f\n',p_action,p_goal);
            
            p(sample) =  exp((p_action + p_goal) - p_z);
            pg(sample) = exp(p_action + p_goal);
            
            %if p_goal > -700
            %    ok = true;
            %end
            
            %r = p(sample) / 2 / max_p;
            %if r > 1
            %  r = 1;
            %end
            %plot(traj(1,:),traj(2,:),'color',[r,0,0]);
            
            if sample == N_SAMPLES
                break
            end
        end
    end
    
    if sum(p) == 0
        continue
    %elseif ok == false
    %    fprintf (' ... did not reach goal!\n');
    %    continue;
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
    if any(inpolygon(traj(1,:),traj(2,:),obstacles{i}.bounds(1,:),obstacles{i}.bounds(2,:)))
        obs = i;
        break;
    end
end
end
