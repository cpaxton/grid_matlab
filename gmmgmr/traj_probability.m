function p = traj_probability(traj, model, local_env)

fa = traj_get_reproduction_features(traj(:,1:end),model,local_env);
len = size(fa,2);
if model.use_time
    if model.use_avg_len
        max_t = ceil(model.len_mean);
    else
        max_t = len;
    end
    fa = [1000 * (0:(len-1)) / max_t; fa];
    %fprintf('WARNING: time wrong! Check this.');
end

p = exp(mean(compute_loglik(fa,model.Mu,model.Sigma,model,model.in)));

end