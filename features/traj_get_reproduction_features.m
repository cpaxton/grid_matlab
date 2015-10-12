function f = traj_get_reproduction_features(pt,model,local_env)
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