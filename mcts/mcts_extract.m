function traj = mcts_extract(nodes, idx)
% MCTS_EXTRACT get best MCTS path through the tree

current_idx = idx;

traj = [];

depth = 1;

prev_node = 0;
prev_traj = 0;

while true
    fprintf(' - extraction at %d\n', idx);
   % find best trajectory from this state
   % follow it to the appropriate child option
   best_num_visits = 0;
   best_node_idx = 0;
   best_traj_idx = 0;
   for i = 1:length(nodes(idx).children)
        child_idx = nodes(idx).children(i);
        fprintf('\t -- child = %d:\n', child_idx);
        for j = 1:length(nodes(child_idx).traj_visits)
            num_visits = nodes(child_idx).traj_visits(j);
            traj_idx = j;
            if ~isempty(num_visits) && num_visits > best_num_visits ...
                    && prev_traj == nodes(child_idx).traj_parent_traj(traj_idx)
                
                fprintf('\t\t --- traj = %d\n', traj_idx);
                
                best_num_visits = num_visits;
                best_node_idx = child_idx;
                best_traj_idx = traj_idx;
                best_prev_node = nodes(child_idx).traj_parent_node(traj_idx);
                best_prev_traj = nodes(child_idx).traj_parent_traj(traj_idx);
            end
        end
   end
   fprintf('\tbest parent node = %d, traj = %d, visited %d times\n', best_prev_node, best_prev_traj, best_num_visits);
   prev_node = best_node_idx;
   prev_traj = best_traj_idx;
   idx = best_node_idx;
   traj = [traj nodes(best_node_idx).trajs{best_traj_idx}];
   depth = depth + 1;
   
   if nodes(idx).is_terminal || depth > nodes(1).config.max_depth
       break
   end
end

end