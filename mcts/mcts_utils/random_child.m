function child = random_child(nodes, curr_node)
    child = nodes(curr_node).children(randi(length(nodes(curr_node).children)));
end