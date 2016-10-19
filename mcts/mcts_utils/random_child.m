function child = random_child(nodes, curr_node)
% Return a random child node (index in nodes)
    assert(length(nodes(curr_node).children) > 0);
    child = nodes(curr_node).children(randi(length(nodes(curr_node).children)));
end