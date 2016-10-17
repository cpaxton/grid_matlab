function [nodes] = flatten_tree(root, config)
% FLATTEN_TREE
%   Because MATLAB objects are just terrible.
%   Turn a tree into an array. Replace all children with index.

nodes = [];

nodes = [nodes root];


end

function [idx,nodes] = flatten_helper(node, config)
end