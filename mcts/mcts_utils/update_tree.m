function nodes = backup_tree_after_initialization(nodes)
% UPDATE_TREE
%   go through the whole tree and update everything
%   set the values of each branch correctly
cur_idx = [];
for i = 1:length(nodes)
   if nodes(i).is_terminal
       cur_idx = [cur_idx i];
   end
end

parent_traj = [nodes(cur_idx).traj_parent_traj];
parent_node = [nodes(cur_idx).traj_parent_node];
unique_parents = unique(parent_node);

while length(parent_node) > 0
    for i = 1:length(unique_parents)
        parent = unique_parents(i);
        for j = 1:length(cur_idx)
            idx = cur_idx(j);
            trajs = nodes(idx).traj_parent_traj(nodes(idx).traj_parent_node == parent);
        end
    end
    break
end

end