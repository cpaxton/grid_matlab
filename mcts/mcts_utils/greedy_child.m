function child = greedy_child(nodes, curr_node, curr_traj)
    if nodes(curr_node).is_root
        [~, idx] = max(nodes(curr_node).child_score);
        child = nodes(curr_node).children(idx);
    else
        end_of_traj = nodes(curr_node).trajs{curr_traj}(:,end-1:end);
        
        assert(length(nodes(curr_node).children) > 0);
        p = zeros(size(nodes(curr_node).children));
        for i = 1:length(nodes(curr_node).children)
            idx = nodes(curr_node).children(i);
            p(i) = traj_probability(end_of_traj, nodes(idx).models{nodes(idx).action_idx}, nodes(idx).local_env);
        end
        
        p = cumsum(p) / sum(p);
        [~, idx] = max(rand() < p);
        child = nodes(curr_node).children(idx);
    end
end