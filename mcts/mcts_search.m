function [ nodes ] = mcts_search( nodes, x0, w0, config )
%MCTS_SEARCH run MCTS search through the tree
%   Uses the MctsNode objects, despite not being member functions.
%   At each iteration, select and rollout down the tree.
%   During backup, add extra options to tree.

%% Definitions
% Define location where we store the high-level option and the specific
% trajectory associated with that option in each rollout/simulation.
CHILD_NODE = 1;
CHILD_TRAJ = 2;
CHILD_P = 3;
CHILD_VISITS = 4;

current_idx = 1;
current_traj = 0;

count = 1;

%% Main loop: iterate until budget is exhausted
% while not done
while count <= 3
    
    if config.draw_figures
        figure(count+1); clf; hold on;
        draw_environment(w0.env);
    end
    
    % reset current node
    current_idx = 1;
    current_traj = 0;
    x = x0;

    % store a trace through the tree out to max depth
    trace = zeros(nodes(1).config.max_depth, 4);
    depth = 1;
    
    % descend through the tree
    % choose child with best value, or use DPW to create a new child
    % NOTE: for now assuming all trajectories are the same length
    while true %~nodes(current_idx).is_terminal
        
        if depth == 1
            parent_node = 0;
            parent_traj = 0;
        else
            parent_node = trace(depth - 1, CHILD_NODE);
            parent_traj = trace(depth - 1, CHILD_TRAJ);
        end
        
        if ~nodes(current_idx).initialized ...
                || (~nodes(current_idx).is_root && trace(depth-1,CHILD_VISITS) == 0)
            % draw a set of samples for this node's children to choose the
            % best one
            
            fprintf('Expanding from node %d, traj %d\n', parent_node, parent_traj);
            
            n_children = length(nodes(current_idx).children);
            for i = 1:length(nodes(current_idx).children)
                nodes(nodes(current_idx).children(i)) = initialize_node(...
                    nodes(nodes(current_idx).children(i)),...
                    x, ...
                    config.init_samples / n_children, ...
                    config, ...
                    parent_node, ...
                    parent_traj);
            end
            
            nodes(current_idx).initialized = true;
        end
        
        %% PROGRESSIVE WIDENING FUNCTION
        % greedily choose child, or add a trajectory
        if true
            
            best_node = 0;
            best_score = 0;
            best_traj = 0;
            best_x = [];
            best_p = 0;
            best_visits = 0;
            
            % greedily choose best existing child according to UCT
            for i = 1:length(nodes(current_idx).children)
                % choose best child
                child_idx = nodes(current_idx).children(i);
                for j = 1:length(nodes(child_idx).trajs)
                    new_parent_traj = nodes(child_idx).traj_parent_traj(j);
                    if nodes(child_idx).traj_score(j) > best_score ...
                            && new_parent_traj == parent_traj;
                        best_score = nodes(child_idx).traj_score(j);
                        best_node = nodes(current_idx).children(i);
                        best_traj = j;
                        best_x = nodes(child_idx).trajs{j}(:,end);
                        best_p = nodes(child_idx).traj_raw_p(j);
                        best_visits = nodes(child_idx).traj_visits(j);
                    end
                end
            end
        else
            % create child by creating new random sample
        end
        
        fprintf('Selected child %d in node %d\n', best_traj, best_node);
        
        trace(depth, CHILD_NODE) = best_node;
        trace(depth, CHILD_TRAJ) = best_traj;
        trace(depth, CHILD_P) = best_p;
        trace(depth, CHILD_VISITS) = best_visits;
        
        %% update current node
        current_idx = best_node;
        current_traj = best_traj;
        x = best_x;
        
        %% draw
        if config.draw_figures
            draw_nodes(nodes);
            plot(x(1),x(2),'*','color','black');
        end
        
        depth = depth + 1;
        
        if depth > nodes(1).config.max_depth
            break
        end
        

    end
    trace
    nodes = config.backup(count, nodes, trace, depth);
    count = count + 1;
end

%% After the end:
% descend once through the tree along the most-visited branch
% end result will be our approximately optimal task and motion plan

end

