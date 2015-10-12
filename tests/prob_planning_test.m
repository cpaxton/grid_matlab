% prob_planning

N_SAMPLES = 250;
N_ITER = 40;
N_PRIMITIVES = 4;
N_ELITE = 240;
N_Z_DIM = 2*N_PRIMITIVES;
N_STEPS = 10;
MOVE_X = -10;
MOVE_Y = -100;

FIG_SAMPLES = 1;

x0 = [190,1000,0,0,0]'; 
local_env = [];
local_env.exit = [env.width;env.height / 2; 0];
local_env.gate = move_gate(MOVE_X,MOVE_Y,envs{2}.gates{1});
next_env = [];
next_env.exit = local_env.exit;
next_env.prev_gate = local_env.gate;

xg = x(1:2) - [local_env.gate.x local_env.gate.y];
movement_guess = norm(xg) / (N_PRIMITIVES * N_STEPS);

mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([0.0;movement_guess],N_PRIMITIVES,1);
%cv = 0.01*cov([trials{1}{1}.rotation;trials{1}{1}.movement]');
cv = [1 0; 0 25];
sigma = eye(N_Z_DIM);
for i=1:2:N_Z_DIM
    sigma(i:(i+1),i:(i+1)) = cv;
end
Z  = struct('mu',mu,'sigma',sigma);

current = models{3};
goal = models{2};

max_p = 1;
last_avg_p = 0;
for iter = 1:N_ITER
    samples = mvnsample(Z.mu,Z.sigma,N_SAMPLES);
    
    figure(iter);clf;hold on;
    axis([0 envs{2}.width 0 envs{2}.height]);
    draw_gates({local_env.gate});
    plot(trials{2}{1}.x,trials{2}{1}.y);
    
    p = zeros(N_SAMPLES,1);
    pg = zeros(N_SAMPLES,1);
    
    for sample=1:N_SAMPLES
        p_z = mvnpdf(samples(:,sample),Z.mu,10*Z.sigma);
        traj = sample_seq(x0,samples(:,sample),N_STEPS);
        fa = traj_get_reproduction_features(traj(:,1:end-1),current,local_env);
        fg = traj_get_reproduction_features(traj(:,end),goal,next_env);
        len = size(fa,2);
        fa = [1000 * (1:len) / len; fa]';
        fg = [0;fg]';
        
        %ps = mvnpdf(f(1:(end),:),current.Mu,current.Sigma);
        p_action = sum(mvnpdf(fa,current.Mu,current.Sigma))/len;
        p_goal = mvnpdf(fg,goal.Mu,goal.Sigma);
        
        p(sample) =  (p_action + p_goal) / p_z;
        pg(sample) = (p_action + p_goal);
        
        r = p(sample) / 2 / max_p;
        if r > 1
            r = 1;
        end
        plot(traj(1,:),traj(2,:),'color',[r,0,0]);
    end
    
    % update z
    max_p = max(p);
    
    [sorted,idx] = sort(p);
    elite_idx = idx(end-N_ELITE+1:end);
    p = p(elite_idx);
    pg = pg(elite_idx);
    samples = samples(:,elite_idx);
    
    avg_p = mean(p);
    avg_pg = mean(pg);
    
    if avg_pg < last_avg_p
        fprintf('skipping: %f < %f\n',log(avg_pg),log(last_avg_p));
        continue;
    end
    last_avg_p = avg_pg;
    p = p / sum(p);
    
    mu = zeros(size(Z.mu));
    sigma = zeros(size(Z.sigma));
    for sample=1:N_ELITE
        mu = mu + (p(sample) * samples(:,sample));
    end
    for sample=1:N_ELITE
        ds = samples(:,sample)-mu;
        sigma = sigma + (p(sample) * (ds * ds'));
    end
    sigma = sigma + (1e-10*eye(N_Z_DIM));
    
    Z  = struct('mu',mu,'sigma',sigma);
    
    fprintf('... done iter %d. avg p = %f, avg obj = %f\n',iter,log(avg_p),log(avg_pg));
    
end