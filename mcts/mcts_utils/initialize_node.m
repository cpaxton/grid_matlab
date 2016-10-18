function node = initialize_node(node, x, n_samples, config, parent_node, parent_traj)

if ~node.is_root
    [ trajs, params, ~, ~, p, ~, ~ ] = traj_forward(x, 1, ...
        node.models{node.action_idx}, ...
        0, node.local_env, 0, ...
        node.Z, node.config, n_samples);
    
    node.trajs = {node.trajs{:} trajs{:}};
    node.traj_params = [node.traj_params; params];
    node.traj_raw_p = [node.traj_raw_p; p];
    node.traj_p = [node.traj_p; p];
    node.traj_parent_traj = [node.traj_parent_traj; ones(size(p))*parent_traj];
    node.traj_parent_node = [node.traj_parent_node; ones(size(p))*parent_node];
    node.traj_visits = [node.traj_visits; zeros(size(p))];
    node.traj_p_sum = [node.traj_p_sum; zeros(size(p))];
    
    if config.initialization == 'pw'
        traj_score = ones(size(p)) * Inf;
    else
        traj_score = p;
    end
    node.traj_score = [node.traj_score; traj_score];
end

end