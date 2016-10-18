function traj = mcts_extract(nodes, idx)
% MCTS_EXTRACT get best MCTS path through the tree

current_idx = idx;

traj = [];

depth = 1;

while true
    fprintf(' - extraction at %d\n', idx);
   % find best trajectory from this state
   % follow it to the appropriate child option
   best_num_visits = 0;
   best_node_idx = 0;
   best_traj_idx = 0;
   for i = 1:length(nodes(idx).children)
        %[num_visits, traj_idx] = max(nodes(idx).traj_visits);
        %fprintf('At %d: choosing traj %d with %d visits\n', idx, traj_idx, 
        child_idx = nodes(idx).children(i);
        [num_visits, traj_idx] = max(nodes(child_idx).traj_visits);
        if ~isempty(num_visits) && num_visits > best_num_visits
           best_num_visits = num_visits;
           best_node_idx = child_idx;
           best_traj_idx = traj_idx;
        end
   end
   idx = best_node_idx;
   traj = [traj nodes(best_node_idx).trajs{best_traj_idx}];
   depth = depth + 1;
   
   if nodes(idx).is_terminal || depth > nodes(1).config.max_depth
       break
   end
end

end