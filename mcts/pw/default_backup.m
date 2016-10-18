function nodes = default_backup(iter, nodes, trace, max_depth, compute_score)

CHILD_NODE = 1;
CHILD_TRAJ = 2;
CHILD_P = 3;

% compute score as the geometric mean of all observed actions
% this is so we can reasonably compare long and short trajectories
score = exp(mean(log(trace(:,CHILD_P))));

for i = (max_depth-1):-1:1
    node_idx = trace(i, CHILD_NODE);
    traj_idx = trace(i, CHILD_TRAJ);
    
    nodes(node_idx).traj_p_sum(traj_idx) = nodes(node_idx).traj_p_sum(traj_idx) + score;
    nodes(node_idx).traj_visits(traj_idx) = nodes(node_idx).traj_visits(traj_idx) + 1;
    nodes(node_idx).traj_score(traj_idx) = compute_score(nodes(node_idx).traj_p_sum(traj_idx), nodes(node_idx).traj_visits(traj_idx), iter);
end

end