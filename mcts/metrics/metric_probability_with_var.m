function metric = metric_probability(node)
    if node.visits > 0
        metric = node.expected_p + node.expected_p_var;
    else
        metric = 100;
    end
end