function [ nodes ] = initialize_tree(nodes, x0, w0, config)
% INITIALIZE_TREE
%   Descend through the tree
%   Draw samples at each "level" until we have reached the end

%% Start at the root node (idx = 1)
% sample children at random according to transition probabilities

x = x0;
p = 1;
start_t = 0;

parent_node = 0;
idx = 1;
pidx = 1;

depth = 1;

fprintf('INITIALIZING:\n');
while true
    parent = [];
    children = [];
    T = [];
    assert(sum(p) == 1);
    for i = 1:length(idx)
        children = [children nodes(idx(i)).children];
        parent = [parent ones(length(nodes(idx(i)).children),1) * idx(i)];
        T = [T pidx(i) * nodes(idx).T];
        
        n_samples = p(i) * config.initialization_samples;
        node = nodes(idx(i));
        if node.action_idx > 0 && ~isempty(node.children)
            [trajs, params, ~, ~, raw_p, ~, parent_traj] = traj_forward(x, p, ...
                node.models{node.action_idx}, ...
                0, node.local_env, 0, ...
                node.Z, node.config, n_samples, start_t);
            
            lens = zeros(length(trajs));
            for j = 1:length(trajs)
                lens(j) = start_t + length(trajs{j}) - 1;
            end
            
            parent_node = parent(i);
            node.trajs = {node.trajs{:} trajs{:}};
            node.traj_params = [node.traj_params params];
            node.traj_raw_p = [node.traj_raw_p; raw_p];
            node.traj_p = [node.traj_p; p];
            node.traj_p_max = max(node.traj_p_max, p);
            %node.traj_h = [node.traj_h; h];
            node.traj_t = [node.traj_t; lens];
            node.traj_parent_traj = [node.traj_parent_traj; ones(size(p))*parent_traj];
            node.traj_parent_node = [node.traj_parent_node; ones(size(p))*parent_node];
            node.traj_visits = [node.traj_visits; zeros(size(p))];
            node.traj_p_sum = [node.traj_p_sum; zeros(size(p))];
            node.traj_children = [node.traj_children; zeros(size(p))];
        end
        
        if config.initialization == 'pw'
            traj_score = ones(size(p)) * Inf;
        elseif config.initialization == 'h'
            traj_score = p;
        end
        node.traj_score = [node.traj_score; traj_score];
        
        node.initialized = true;
        
        nodes(idx(i)) = node;
    end
    
    fprintf(' - depth = %d\n', depth);
    
    idx = children;
    pidx = T;
    
    depth = depth + 1;
    if isempty(idx)
        break
    end
end

end