function [ avg_p, avg_pg, sigma ] = prob_planning_iter( x0, model, next_model, local_env, next_env, obstacles, Z )
%PROB_PLANNING_ITER Runs one iteration of the probabilistic planning
%algorithm
%   Samples trajectories forward, returns probability and update stuff I
%   guess

SHOW_FIGURES = true;
N_SAMPLES = 50;
N_STEPS = 10;
N_GEN_SAMPLES = 50*N_SAMPLES;

max_p = 1;

samples = mvnsample(Z.mu,Z.sigma,N_GEN_SAMPLES);
params = zeros(size(samples,1),N_SAMPLES);

if SHOW_FIGURES
    figure(1+iter);clf;hold on;
    if model.use_gate
        draw_gates({local_env.gate});
    end
    if model.use_prev_gate
        draw_gates({local_env.prev_gate});
    end
    draw_surfaces(obstacles);
end

p = zeros(N_SAMPLES,1);
pg = zeros(N_SAMPLES,1);

sample = 0;
for i = 1:N_GEN_SAMPLES
    p_z = log(mvnpdf(samples(:,i),Z.mu,Z.sigma));
    %traj = sample_seq(x0,samples(:,i),N_STEPS);
    traj = sample_seq(x0,samples(:,i));
    
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
        
        p(sample) =  exp(p_action + p_goal);
        pg(sample) = exp(p_goal);
        
        if p_goal > -700
            ok = true;
        end
        
        if SHOW_FIGURES
            r = p(sample) / 2 / max_p;
            if r > 1
                r = 1;
            end
            plot(traj(1,:),traj(2,:),'color',[r,0,0]);
        end
        
        if sample == N_SAMPLES
            break
        end
    end
end

% update z
max_p = max(p(1:sample));

avg_p = mean(p(1:sample));
avg_pg = mean(pg(1:sample));

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

