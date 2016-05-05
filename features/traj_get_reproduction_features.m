function f = traj_get_reproduction_features(pt,model,local_env)
%% TRAJ_GET_REPRODUCTION_FEATURES: get features for a particular 
% trajectory. Points are assumed to have been provided sequentially, so
% we compute diff features based on the previous index in [pt] rather than
% based on some other variable we provided.
%
%   pt: [x;y;w;movement;rotation] describing a trajectory or a set of 
%   possible points for which we need to compute features
%
%   model: struct containing a GMM and feature information. This tells us 
%   which features are necessary to reproduce a particular action, and
%   gives us the GMM describing the distribution of those features.
%
%   local_env: local environment struct, containing next and previous gates
%   as well as the exit.
%
%   f: [OUTPUT] the set of features associated with this trajectory in
%   environment "local_env". Columns are observations.

use_diff = model.use_diff;
model.use_diff = false;
f = get_reproduction_features(pt,model,local_env);
model.use_diff = use_diff;

%% differentials
% let's say we care about how fast we are moving relative to each of these
% features. this assumes you provided an extra
if model.use_diff
    df = [zeros(size(f,1),1) f(:,2:end)-f(:,1:(end-1))];
    if model.use_param
        f = [f;df(1:(end-2),:)];
    else
        f = [f;df];
    end
end

end