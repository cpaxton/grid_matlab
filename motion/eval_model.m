function [ path, ll] = eval_model( model, pt, env, conf)
%EVAL_MODEL Evaluates an action primitive from a point in the model.
%   Provide a task model, origin point ('pt'), and an environment
%   'conf' needs to contain the settings for this primitive
%   ie, what is the gate/prev_gate/exit/etc. we are parameterizing it with?

USE_OPT = false;

if nargin<6
    USE_STATE = false;
else
    USE_STATE = true;
end
if nargin<5
    USE_BMM = false;
else
    USE_BMM = true;
end

if length(pt) ~= 3
    fprintf('WARNING: provided point should be in the form (x,y,theta)!\n');
end

% flip dimensions if necessary
if size(pt,1) < size(pt,2)
    pt = pt';
end

%% rotate the necessary gates/exits/environment features
tmp_env = [];
tmp_env.exit = [env.width;(env.height / 2);0];

if model.use_gate
    tmp_env.gate = relative_gate(pt(1),pt(2),-pt(3),env.gates{conf.gate}{conf.opt});
end
if model.use_prev_gate
    tmp_env.prev_gate = relative_gate(pt(1),pt(2),-pt(3),env.gates{conf.prev_gate}{conf.prev_opt});
end

if USE_OPT
    [path, ll] = gmm_maximization( model, tmp_env);
else
    paths = cell(25,1);
    lls = zeros(25,1);
    for i=1:25
        [path, ll] = create_path( model, tmp_env, model.steps, 0, 0, 0);
        
        paths{i} = path;
        lls(i) = sum(ll(end));
    end
    [ll,idx] = max(lls);
    path = paths{idx};
end

path(1:3,:) = rotate_trajectory(path(1:3,:),pt(3));
path(1:2,:) = path(1:2,:) + repmat(pt(1:2),1,size(path,2));

end

