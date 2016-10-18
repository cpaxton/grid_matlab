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

current_idx = 1;
current_traj = 0;

count = 0;

%% Main loop: iterate until budget is exhausted
% while not done
while count < 1
    
    if config.draw_figures
        figure(count+1); clf; hold on;
        draw_environment(w0.env);
    end
    
    % reset current node
    current_idx = 1;
    current_traj = 0;
    x = x0;

    % store a trace through the tree out to max depth
    trace = zeros(nodes(1).config.max_depth, 3);
    depth = 1;
    
    % descend through the tree
    % choose child with best value, or use DPW to create a new child
    while ~nodes(current_idx).is_terminal
        
        if ~nodes(current_idx).initialized
            % draw a set of samples for this node's children to choose the
            % best one
            n_children = length(nodes(current_idx).children);
            for i = 1:length(nodes(current_idx).children)
                nodes(nodes(current_idx).children(i)) = initialize_node(...
                    nodes(nodes(current_idx).children(i)),...
                    x, ...
                    config.init_samples / n_children, ...
                    config);
            end
            
            nodes(current_idx).initialized = true;
        end
        
        %% DOUBLE PROGRESSIVE WIDENING FUNCTION
        % greedily choose child, or add a trajectory
        if true
            
            best_node = 0;
            best_score = 0;
            best_traj = 0;
            best_x = [];
            best_p = 0;
            
            % greedily choose best existing child according to UCT
            for i = 1:length(nodes(current_idx).children)
                % choose best child
                child_idx = nodes(current_idx).children(i);
                for j = 1:length(nodes(child_idx).trajs)
                    if nodes(child_idx).traj_score(j) > best_score
                        best_score = nodes(child_idx).traj_score(j);
                        best_node = nodes(current_idx).children(i);
                        best_traj = j;
                        best_x = nodes(child_idx).trajs{j}(:,end);
                        best_p = nodes(child_idx).traj_raw_p(j);
                    end
                end
            end
        else
            % create child by creating new random sample
        end
        
        trace(depth, CHILD_NODE) = best_node;
        trace(depth, CHILD_TRAJ) = best_traj;
        trace(depth, CHILD_P) = best_p;
        
        config.backup(nodes, trace)
        
        %% update current node
        current_idx = best_node;
        current_traj = best_traj;
        x = best_x;
        
        %% draw
        if config.draw_figures
            draw_nodes(nodes)
        end
        
        depth = depth + 1;
        
        trace
        
        if depth > nodes(1).config.max_depth
            break
        end
        

    end
    
    count = count + 1;
end

%% After the end:
% descend once through the tree along the most-visited branch
% end result will be our approximately optimal task and motion plan

end

