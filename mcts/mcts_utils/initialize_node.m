function node = initialize_node(node, x, n_samples, config, parent_node, parent_traj)

if ~node.is_root
    if ~config.greedy_expansion
        [ trajs, params, ~, ~, raw_p, ~, ~ ] = traj_forward(x, 1, ...
            node.models{node.action_idx}, ...
            0, node.local_env, 0, ...
            node.Z, node.config, n_samples);
    else
        [ trajs, params, ~, ~, raw_p, ~, ~ ] = traj_forward(x, 1, ...
            node.models{node.action_idx}, ...
            0, node.local_env, 0, ...
            node.Z, node.config, config.num_greedy_samples * n_samples);
        [raw_p,sort_idx] = sort(raw_p,'descend');
        raw_p = raw_p(1:n_samples);
        trajs = {trajs{sort_idx(1:n_samples)}};
        params = params(:,sort_idx(1:n_samples));
    end
    
    %p = log(raw_p);
    p = raw_p;
    
    node.trajs = {node.trajs{:} trajs{:}};
    node.traj_params = [node.traj_params params];
    node.traj_raw_p = [node.traj_raw_p; raw_p];
    node.traj_p = [node.traj_p; p];
    node.traj_parent_traj = [node.traj_parent_traj; ones(size(p))*parent_traj];
    node.traj_parent_node = [node.traj_parent_node; ones(size(p))*parent_node];
    node.traj_visits = [node.traj_visits; zeros(size(p))];
    node.traj_p_sum = [node.traj_p_sum; zeros(size(p))];
    node.traj_children = [node.traj_children; zeros(size(p))];
    
    if config.initialization == 'pw'
        traj_score = ones(size(p)) * Inf;
    elseif config.initialization == 'h'
        traj_score = p;
    end
    node.traj_score = [node.traj_score; traj_score];
    
    node.initialized = true;
end

end