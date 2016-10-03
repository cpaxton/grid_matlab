function metric = metric_probability(node)
    if node.visits > 0
        metric = node.expected_p;
    else
        metric = 1;
    end
end