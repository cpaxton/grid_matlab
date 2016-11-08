function config = make_default_mcts_config(extra)

    if nargin<1
        extra=50;
    end

    C = 1; 
    alpha = 0.5;
    %compute_score = @(sum, nb, p, t) pw_compute_score(sum, nb, p, t, C, alpha);
    compute_score = @(sum, nb, p, t) uct_compute_score(sum, nb, p, t, 0.01);
    %compute_score = @(sum, nb, p, t) prior_compute_score(sum, nb, p, t, 1); 
    option_compute_score = @(sum, nb, p, t) uct_compute_score(sum, nb, p, t, 0);
    config = struct('update', 0, ...
                    'dist', 0, ...
                    'select', 0, ...
                    'backup', @(iter, nodes, trace, max_depth) default_backup(iter, nodes, trace, max_depth, compute_score, option_compute_score), ...
                    'expand', @(num_visits, num_children) pw_expand_extra(num_visits, num_children, C, alpha, extra), ...
                    'choose_child', @(nodes, curr_node, curr_traj) greedy_child(nodes, curr_node, curr_traj), ... % ucb1_child or random_child or greedy_child
                    'compute_metric', @(obj) metric_probability_max(obj), ...
                    'compute_rollout_metric', @(obj) metric_probability(obj), ...
                    'draw_figures', true, ...
                    'init_samples', 1, ... number of samples to use when creating a new node
                    'greedy_expansion', true, ... do greedy expansion to improve rollouts
                    'num_greedy_samples', 1, ... randomly sample this many and choose the best
                    'num_iter', 10, ... max number of iterations to perform
                    'draw_step', 20000, ... show output image every X iterations
                    'initialization', 'pw', ... pw or h -- pw initializes to Inf, h to probability
                    'rollouts', false,  ... should we roll out trajectories to the end at all, or just stop and use goal probs as our rollouts?
                    'highlight_extracted_path', true, ... highlight the chosen path
                    'dist_update_step', 20, ... how many samples do we need to try to refit distribution?
                    'initialization_samples', 100, ... [SMART SEARCH] how many samples do we initialize the tree with?
                    'gp', true, ... Use Gaussian Process for smart search
                    'gp_samples', 100, ... How many samples used for CEM with GP?
                    'gp_iter', 1 ... How many CEM iterations do we use before drawing a new sample
                    );
end