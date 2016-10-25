function child = ucb1_child(nodes, curr_node)
% Return a random child node (index in nodes)
    len = length(nodes(curr_node).children);
    assert(len > 0);
    child = 1;
    score = -Inf;
    for i = 1:len
        if nodes(curr_node).child_score(i) > score
            score = nodes(curr_node).child_score(i);
            child = nodes(curr_node).children(i);
        end
    end
end