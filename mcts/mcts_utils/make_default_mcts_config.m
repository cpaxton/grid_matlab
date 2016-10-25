function config = make_default_mcts_config()
    C = 2;
    alpha = 0.5;
    %compute_score = @(sum, nb, p, t) pw_compute_score(sum, nb, p, t, C, alpha);
    compute_score = @(sum, nb, p, t) uct_compute_score(sum, nb, p, t, 0.1);
    %compute_score = @(sum, nb, p, t) prior_compute_score(sum, nb, p, t, 0.1); 
    option_compute_score = @(sum, nb, p, t) uct_compute_score(sum, nb, p, t, 1);
    config = struct('update', 0, ...
                    'dist', 0, ...
                    'select', 0, ...
                    'backup', @(iter, nodes, trace, max_depth) default_backup(iter, nodes, trace, max_depth, compute_score, option_compute_score), ...
                    'expand', @(num_visits, num_children) pw_expand(num_visits, num_children, C, alpha), ...
                    'choose_child', @(nodes, curr_node) ucb1_child(nodes, curr_node), ... % ucb1_child or random_child
                    'compute_metric', @(obj) metric_probability_max(obj), ...
                    'compute_rollout_metric', @(obj) metric_probability(obj), ...
                    'draw_figures', true, ...
                    'init_samples', 1, ... number of samples to use when creating a new node
                    'greedy_expansion', true, ... do greedy expansion to improve rollouts
                    'num_greedy_samples', 10, ... randomly sample this many and choose the best
                    'num_iter', 200, ... max number of iterations to perform
                    'draw_step', 200, ... show output image every X iterations
                    'initialization', 'pw', ... pw or h -- pw initializes to Inf, h to probability
                    'rollouts', true,  ... should we roll out trajectories to the end at all, or just stop and use goal probs as our rollouts?
                    'highlight_extracted_path', true ... highlight the chosen path
                    );
end