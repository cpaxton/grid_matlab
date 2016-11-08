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
    ends = [];
    next_p = [];
    assert(abs(sum(p) - 1) < 1e-8);
    is_root = false;
    
    %% loop over the current set of equal nodes
    for i = 1:length(idx)
        fprintf('   - %d\n',idx);
        children = [children nodes(idx(i)).children];
        parent = [parent ones(length(nodes(idx(i)).children),1) * idx(i)];
        T = [pidx(i) * nodes(idx(i)).T];
        
        %% set up goal
        % goals are chosen at random from the current node
        goal = 0;
        if ~isempty(nodes(idx(i)).goals)
            r = randi(length(nodes(idx(i)).goals));
            goal = nodes(nodes(idx(i)).goals(r));
        end
        
        %% generate trajectories if necessary
        n_samples = round(pidx(i) * config.initialization_samples);
        node = nodes(idx(i));
        if node.action_idx > 0 && ~isempty(node.children) && n_samples > 0
            node.action_idx
            [trajs, params, ~, raw_p, raw_pa, raw_pg, parent_traj] = traj_forward(x, p, ...
                node.models{node.action_idx}, ...
                goal.models{goal.action_idx}, ...
                node.local_env, goal.local_env, ...
                node.Z, node.config, n_samples, start_t);
            ends = [ends traj_ends(trajs)];
            next_p = [next_p raw_p];
            
            lens = zeros(length(trajs));
            for j = 1:length(trajs)
                lens(j) = start_t + length(trajs{j}) - 1;
            end
            
            parent_node = parent(i);
            node.trajs = {node.trajs{:} trajs{:}};
            node.traj_params = [node.traj_params params];
            node.traj_raw_p = [node.traj_raw_p; raw_p];
            node.traj_p = [node.traj_p; raw_p];
            node.traj_p_max = max(node.traj_p_max, p);
            %node.traj_h = [node.traj_h; h];
            node.traj_t = [node.traj_t; lens];
            node.traj_parent_traj = [node.traj_parent_traj; parent_traj];
            node.traj_parent_node = [node.traj_parent_node; ones(size(p))*parent_node];
            node.traj_visits = [node.traj_visits; zeros(size(p))];
            node.traj_p_sum = [node.traj_p_sum; zeros(size(p))];
            node.traj_children = [node.traj_children; zeros(size(p))];
        else
            is_root = true;
        end
        %% Initialize new trajectories
        if config.initialization == 'pw'
            traj_score = ones(size(p)) * Inf;
        elseif config.initialization == 'h'
            traj_score = p;
        end
        node.traj_score = [node.traj_score; traj_score];
        
        node.initialized = true;
        
        nodes(idx(i)) = node;
    end
    
    %% Update and move on
    % Set up lists of children as the next set of nodes we sample from
    % Set up probabilities we want to sample from
    fprintf(' - depth = %d\n', depth);
    
    idx = children;
    pidx = T;
    if ~is_root
        x = ends;
        p = next_p / sum(next_p);
    else
        fprintf('   - note: root node.\n');
    end
    
    assert(size(x,2) == length(p));
    
    %% 
    depth = depth + 1;
    if isempty(idx) || isempty(p)
        break
    end
end

end