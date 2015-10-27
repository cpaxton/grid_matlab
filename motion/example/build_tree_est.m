function [ pts, t, probs, weights ] = build_tree( start_pt, model, env, conf)
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

probs = 1; % track log likelihoods of different points
pts = [start_pt;0;0]; % actual start point
parents = 0;
t = 0;


tmp_env = [];
tmp_env.exit = [env.width-pts(1);(env.height / 2)-pts(2);0];
tmp_env.exit = rotate_trajectory(tmp_env.exit,-pts(3));
if model.use_gate
    tmp_env.gate = relative_gate(pts(1),pts(2),-pts(3),env.gates{conf.gate});
end
if model.use_prev_gate
    tmp_env.prev_gate = relative_gate(pts(1),pts(2),-pts(3),env.gates{conf.prev_gate});
end


features = get_reproduction_features(pts,model,tmp_env);

% sample movement from the model
for i = 1:conf.num_iter
    
    weights = update_weights(probs,t);
    idx = choose_point(weights,conf.n_samples);
    
    [out,dt] = sample_movement(model,conf.n_samples);
    x = ones(1,conf.n_samples) .* pts(1,idx);
    y = ones(1,conf.n_samples) .* pts(2,idx);
    w = ones(1,conf.n_samples) .* pts(3,idx);
    [nx,ny,nw] = needle_update(x,y,w,out(1,:),out(2,:));
    new_pts = [nx;ny;nw;out];
    new_t = ones(1,conf.n_samples).*t(idx) + dt;
    f = get_reproduction_features([nx;ny;nw;out],model,tmp_env,features(:,idx));
    new_prob = -1*compute_loglik([new_t;f],model.Mu,model.Sigma,model,model.in);
    
    keep = find(new_prob < conf.ll_threshold);
    new_pts = new_pts(:,keep);
    new_prob = new_prob(keep);
    new_t = new_t(keep);
    f = f(:,keep);
    
    pts = [pts new_pts];
    t = [t new_t];
    features = [features f];
    probs = [probs new_prob'];
    
    continue
    
    if rand() < conf.goal_threshold
        goal_pt = conf.goal_sampler(conf.n_samples);
    else
        goal_pt = conf.valid_sampler(conf.n_samples);
    end
    pts = [pts goal_pt];
    continue
    
    % compute closest point
    pt_diff = pts - repmat(goal_pt,1,size(pts,2));
    pt_dist = sum(pt_diff .* pt_diff,1);
    [~,idx] = min(pt_dist);
    
    % move forward
    parent_pt = pts(:,idx);
    parents = [parents idx];
    
    pt = get_pt(parent_pt,goal_pt,models,conf);
    
    add_pt=true;
    for j=1:length(conf.obs)
        if inpolygon(pt(1),pt(2),conf.obs{j}(1,:),conf.obs{j}(2,:))
            add_pt=false;
            break;
        end
    end
    for j=1:length(conf.in)
        if inpolygon(pt(1),pt(2),conf.in{j}(1,:),conf.in{j}(2,:))
            add_pt=false;
            break;
        end
    end
    if add_pt
        pts = [pts pt];
    end
end

end

% return a point in a polygon with given obstacles
function sample(in,out)

end

function weights = update_weights(t,p)
    %weights = (t/1000 + p) / (sum(t/1000) + sum(p));
    weights = (t + (1000-p)) / (sum(t) + (sum((1000 - p))));
end

function idx = choose_point(weights,n_samples)
    w2 = cumsum(weights);
    idx=zeros(1,n_samples);
    for j=1:n_samples
        i = rand()/4+0.75 < w2;
        idx(j) = find(i==1,1,'first');
    end
end

function pt = get_pt(parent_pt,goal_pt,model,conf)
dist = abs((rand() * model.movement_dev * 2) - ...
    (model.movement_mean - model.movement_dev));
rot = abs((rand() * model.rotation_dev * 2) - ...
    (model.rotation_mean - model.rotation_dev));
angle = atan2(goal_pt(2) - parent_pt(2), goal_pt(1) - parent_pt(1));

pt = parent_pt + [cos(angle)*dist;sin(angle)*dist;0];
end