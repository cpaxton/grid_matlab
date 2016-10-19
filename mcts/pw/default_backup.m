function nodes = default_backup(iter, nodes, trace, max_depth, compute_score)

CHILD_NODE = 1;
CHILD_TRAJ = 2;
CHILD_P = 3;

% compute score as the geometric mean of all observed actions
% this is so we can reasonably compare long and short trajectories

%score = exp(mean(log(trace(:,CHILD_P))));
score = exp(mean(log(trace(1:(max_depth-1),CHILD_P))));

for i = 1:(max_depth-1)
    node_idx = trace(i, CHILD_NODE);
    traj_idx = trace(i, CHILD_TRAJ);
    
    if i == 1
        parent_visits = iter;
    else
        parent_node = nodes(node_idx).traj_parent_node(traj_idx);
        parent_traj = nodes(node_idx).traj_parent_traj(traj_idx);
        parent_visits = nodes(parent_node).traj_visits(parent_traj);
    end
    
    nodes(node_idx).traj_p_sum(traj_idx) = nodes(node_idx).traj_p_sum(traj_idx) + score;
    nodes(node_idx).traj_visits(traj_idx) = nodes(node_idx).traj_visits(traj_idx) + 1;
    nodes(node_idx).traj_score(traj_idx) = compute_score(nodes(node_idx).traj_p_sum(traj_idx), nodes(node_idx).traj_visits(traj_idx), parent_visits);
end

end