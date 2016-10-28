function nodes = default_backup(iter, nodes, trace, max_depth, compute_score, option_compute_score)

CHILD_NODE = 1;
CHILD_TRAJ = 2;
CHILD_P = 3;
CHILD_IDX = 6;

% compute score as the geometric mean of all observed actions
% this is so we can reasonably compare long and short trajectories

%score = exp(mean(log(trace(1:(max_depth-1),CHILD_P))));
score = sum(trace(1:(max_depth-1),CHILD_P));

for i = 1:max_depth
    node_idx = trace(i, CHILD_NODE);
    traj_idx = trace(i, CHILD_TRAJ);
    option_idx = trace(i, CHILD_IDX);
   
    if node_idx == 0 || traj_idx == 0
        % Skip anything that was just included from one of our fake
        % rollouts
        continue
    end
    
    if i == 1
        parent_visits = iter;
    else
        parent_node = nodes(node_idx).traj_parent_node(traj_idx);
        parent_traj = nodes(node_idx).traj_parent_traj(traj_idx);
        parent_visits = nodes(parent_node).traj_visits(parent_traj);
    end
    
    nodes(node_idx).traj_p_sum(traj_idx) = nodes(node_idx).traj_p_sum(traj_idx) + score;
    nodes(node_idx).traj_visits(traj_idx) = nodes(node_idx).traj_visits(traj_idx) + 1;
    nodes(node_idx).traj_score(traj_idx) = compute_score(nodes(node_idx).traj_p_sum(traj_idx), nodes(node_idx).traj_visits(traj_idx), nodes(node_idx).traj_p(traj_idx), parent_visits);
    
    nodes(node_idx).p = sum(nodes(node_idx).traj_p_sum);
    nodes(node_idx).visits = sum(nodes(node_idx).traj_visits);
    
    % if we took another action after this one, then we should keep track
    % of how good that OPTION is and how often we should explore it
    if option_idx > 0
        nodes(node_idx).child_visits(option_idx) = nodes(node_idx).child_visits(option_idx) + 1;
        nodes(node_idx).child_p_sum(option_idx) = nodes(node_idx).child_p_sum(option_idx) + score;

        option_visits = sum(nodes(node_idx).child_visits);
        avg_option_p = nodes(node_idx).child_p_sum(option_idx) / nodes(node_idx).child_visits(option_idx);
        nodes(node_idx).child_score(option_idx) = option_compute_score(nodes(node_idx).child_p_sum(option_idx), nodes(node_idx).child_visits(option_idx), avg_option_p, option_visits);
    end
end

end