function metric = metric_probability_max(node)
    if node.visits > 0
        %fprintf('val = %f %f %f\n', node.expected_p_max, node.expected_p_var, node.expected_p);
        metric = node.expected_p + (2*node.expected_p_var); %max(diag(node.Z.sigma));
        %metric = (node.expected_p_max + (0.5 * node.expected_p_var)) + max(diag(node.Z.sigma));
        %if node.config.n_primitives ~= node.models{node.action_idx}.num_primitives + 1
        %    metric = 0
        %end
    else
        metric = 100;
    end
end