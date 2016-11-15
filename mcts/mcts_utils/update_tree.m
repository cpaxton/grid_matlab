function nodes = update_tree(nodes)
% UPDATE_TREE
%   go through the whole tree and update everything
%   set the values of each branch correctly
terminal_idx = [];
for i = 1:length(nodes)
   if nodes(i).is_terminal
       terminal_idx = [terminal_idx i];
   end
end

end