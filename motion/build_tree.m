function [ pts, parents, goal_probs, goal_met, goal_parents, goal_features] = build_tree( start_pt, start_probs, model, goal_model, env, conf, state, features)
%BUILD_TREE Create a tree of points.
%   start_pt: x,y,w of the needle at the start of the motion
%   model: model of the motion to perform
%   env: environment to work in
%   goal: function handle to sample goals for this
%   num_iter: number of iterations to perform
%   ll_threshold: when do we start treating unlikely features as obstacles?
%   (0 = never)
%
% This function builds a tree of motions, out from the start position, and
% attempts to plan a path to the goal. It continues until it reaches some
% maximum number of iterations, then stops and chooses the "best" path
% through the world.
%
% We do not place points in obstacles, and treat certain impossible feature
% results as obstacles as well. In the end, we want a map of points


fprintf('\tallocating\n')

goal_probs = [];
goal_parents = [];
probs = zeros(1,size(start_pt,2)); % track log likelihoods of different points
cprobs = start_probs; %zeros(1,size(start_pt,2));
pts = [start_pt;zeros(2,size(start_pt,2))]; % actual start point
parents = zeros(1,size(start_pt,2));
goal_met = [];
goal_features = [];
t = zeros(1,size(start_pt,2));

tmp_env = [];
tmp_env.exit = [env.width;env.height / 2; 0];
if model.use_gate
    tmp_env.gate = env.gates{conf.gate};
end
if model.use_prev_gate
    tmp_env.prev_gate = env.gates{conf.prev_gate};
end
if ~isempty(goal_model) && conf.bmm.coef(1,conf.goal_label) == 1
    goal_env = [];
    goal_env.exit = tmp_env.exit;
    if goal_model.use_gate
        goal_env.gate = env.gates{conf.gate + 1};
    end
    if goal_model.use_prev_gate
        goal_env.prev_gate = env.gates{conf.prev_gate + 1};
    end
else
    goal_env = tmp_env;
end

if isempty(features)
fprintf('\tfirst features for %d points\n',size(pts,2))
features = get_reproduction_features(pts,model,tmp_env);
end

% really need to revise this function; clean it up and make it more
% efficient
states = [];
for i = 1:length(start_pt)
    states = [states state];
end

fprintf('\tstarting\n')

% sample movement from the model
for i = 1:conf.num_iter
    
    if rand() < conf.goal_threshold
        goal_pt = conf.goal_sampler(1);
    else
        goal_pt = conf.valid_sampler(1);
    end
    
    % compute closest point
    pt_diff = pts(1:3,:) - repmat(goal_pt,1,size(pts,2));
    %pt_diff = [t;pts(1:3,:)] - repmat([1000;goal_pt],1,size(pts,2));
    pt_dist = sum(pt_diff .* pt_diff,1);
    [~,idx] = min(pt_dist);
    
    [out,dt] = sample_movement(model,conf.n_samples);
    x = pts(1,idx);
    y = pts(2,idx);
    w = pts(3,idx);
    [nx,ny,nw] = needle_update(x,y,w,out(1,:),out(2,:));
    new_pts = [nx;ny;nw;out];
    new_t = ones(1,conf.n_samples).*t(idx) + dt;
    
    % BRANCH HERE
    [np,ns] = compute_predicates(new_pts,env,states(idx));
    label = BernoulliAssign(conf.bmm, np');
    label(x > env.width) = 0;
    
    goal_pts = new_pts(:,label == conf.goal_label);
    new_pts = new_pts(:,label == conf.label);
    new_t = new_t(label == conf.label);
    new_states = ns(label == conf.label);
    
    %% EXPAND ACTION
    if ~isempty(new_pts)
        f = get_reproduction_features(new_pts,model,tmp_env,features(:,idx));
        new_prob = -1*compute_loglik([new_t;f],model.Mu,model.Sigma,model,model.in);
        %new_prob = -1*compute_loglik([new_t;f(model.in_naf,:)],model.Mu,model.Sigma,model,model.in_na);
        keep = find(new_prob < conf.ll_threshold);
        
        if ~isempty(keep)
            new_pts = new_pts(:,keep);
            new_prob = new_prob(keep);
            new_t = new_t(keep);
            f = f(:,keep);
            
            pts = [pts new_pts];
            t = [t new_t];
            features = [features f];
            
            new_cprob = (ones(1,length(keep))*cprobs(idx)) + new_prob';
            probs = [probs new_prob'];
            cprobs = [cprobs new_cprob];
            parents = [parents (ones(1,length(keep))*idx)];
            states = [states new_states];
        end
    end
    %% EXPAND GOALS
    if ~isempty(goal_pts)
        
        if ~conf.goal_label == 0
        f = get_reproduction_features(goal_pts,goal_model,goal_env);
        %fidx = [2 3 5 9 10 12 13 14 15 17 18 21 22 24 25];
        %fidx = [2 3 5 9 10 12:15 17:18 21:22 25];
        fidx = goal_model.in_na;
        new_prob = -1*compute_loglik([zeros(1,size(f,2));f(fidx(2:end)-1,:)],goal_model.Mu,goal_model.Sigma,goal_model,fidx);
%         [mu, Sig] = GMR(goal_model.Priors,goal_model.Mu,goal_model.Sigma,0,1,goal_model.in(2:end));
% 
%         [f(:,1) mu]
%         find(f(:,1) - mu > 50)
%         find(exp((f(:,1) - mu)\Sig.*(f(:,1) - mu)') > 200)
        
        keep = find(new_prob < conf.ll_threshold);
        else
            keep = 1:size(goal_pts,2);
        end
        
        if ~isempty(keep)
            new_prob = new_prob(keep);
            
            goal_met = [goal_met goal_pts(:,keep)];
            goal_probs = [goal_probs (ones(1,length(keep))*cprobs(idx))+new_prob'];
            goal_parents = [goal_parents idx];
            goal_features = [goal_features, f(:,keep)];
        end
    end
    
end
end