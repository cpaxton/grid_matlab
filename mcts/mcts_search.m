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
CHILD_TERMINAL = 5;

current_idx = 1;
current_traj = 0;
root_num_children = 0;

count = 1;

xs = zeros(5, nodes(1).config.max_depth);

%% Main loop: iterate until budget is exhausted
% while not done
while count <= 20
    
    fprintf('=============\n');
    
    % reset current node
    current_idx = 1;
    current_traj = 0;
    x = x0;

    % store a trace through the tree out to max depth
    trace = zeros(nodes(1).config.max_depth, 5);
    depth = 1;
    
    % descend through the tree
    % choose child with best value, or use DPW to create a new child
    % NOTE: for now assuming all trajectories are the same length
    while true %~nodes(current_idx).is_terminal
        
        if depth == 1
            parent_node = 1;
            parent_traj = 0;
            num_children = root_num_children;
            num_visits = count;
        else
            parent_node = trace(depth - 1, CHILD_NODE);
            parent_traj = trace(depth - 1, CHILD_TRAJ);
            num_children = nodes(parent_node).traj_children(parent_traj);
            num_visits = nodes(parent_node).traj_visits(parent_traj);
        end
        
        if num_visits < 1 || config.expand(num_visits, num_children)
            % choose a child
            
            if num_visits == 0
                samples = config.init_samples;
            else
                samples = 1;
            end
            
            done = false;
            for i = 1:samples
                child = config.choose_child(nodes, parent_node);
                
                if nodes(child).is_terminal
                    done = true;
                    break
                end
                
                nodes(child) = initialize_node(...
                    nodes(child),...
                    x, ...
                    1, ...
                    config, ...
                    parent_node, ...
                    parent_traj);
                
                if parent_node > 1
                    nodes(parent_node).traj_children(parent_traj) = nodes(parent_node).traj_children(parent_traj) + 1;
                else
                    root_num_children = root_num_children + 1;
                end 
            end
            if done
                break
            end
        end
        
        %% ROLLOUT
        % greedily choose child, or add a trajectory
            
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
        
        fprintf('Selected child %d in node %d\n', best_traj, best_node);
        
        trace(depth, CHILD_NODE) = best_node;
        trace(depth, CHILD_TRAJ) = best_traj;
        trace(depth, CHILD_P) = best_p;
        trace(depth, CHILD_VISITS) = best_visits;
        trace(depth, CHILD_TERMINAL) = nodes(best_node).is_terminal;
        
        %% update current node
        current_idx = best_node;
        current_traj = best_traj;

        xs(:,depth) = x;
        x = best_x;
        
        depth = depth + 1;
        
        if nodes(current_idx).is_terminal
            trace(depth,CHILD_TERMINAL) = true
            fprintf ('---a-s-sadfasdf\n');
            break
        elseif depth > nodes(1).config.max_depth
            break
        end

    end
    
    %% draw
    if config.draw_figures && mod(count,20) == 0
        figure(round(count/20)+1); clf; hold on;
        draw_environment(w0.env);
        draw_environment(w0.env);
        draw_nodes(nodes);
        plot(xs(1,:),xs(2,:),'*','color','black');
    end
    
    nodes = config.backup(count, nodes, trace, depth);
    count = count + 1;
end

%% After the end:
% descend once through the tree along the most-visited branch
% end result will be our approximately optimal task and motion plan

end

