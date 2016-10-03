function metric = metric_prior_probability(node, weight)
    metric = 1 / (1 + (weight * node.visits));
    if node.visits > 0
        metric = metric + node.expected_p;
    end
end