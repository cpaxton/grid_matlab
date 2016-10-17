function [ nodes ] = mcts_search( nodes, x0, w0, config )
%MCTS_SEARCH run MCTS search through the tree
%   Uses the MctsNode objects, despite not being member functions.
%   At each iteration, select and rollout down the tree.
%   During backup, add extra options to tree.

%% Definitions
% Define location where we store the high-level option and the specific
% trajectory associated with that option in each rollout/simulation.
CHILD_OP = 1;
CHILD_ACTION = 2;

current_idx = 1;

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

    % store a trace through the tree out to max depth
    trace = zeros(nodes(1).config.max_depth, 2);
    
    % descend through the tree
    % choose child with best value, or use DPW to create a new child
    while false && ~nodes(current_idx).is_terminal
        
        if ~nodes(current_idx).initialized
            % draw a set of samples for this node
            nodes(current_idx) = initialize_node(nodes(current_idx), nodes, config);
        end
        
        %% DOUBLE PROGRESSIVE WIDENING FUNCTION
        % greedily choose child, or add a trajectory
        if true
            % greedily choose best existing child according to UCT
            next_idx = 1;
        else
            % create child by creating new random sample
        end
        
        %% update current node
        current_idx = next_idx;
    end
    
    count = count + 1;
end

%% After the end:
% descend once through the tree along the most-visited branch
% end result will be our approximately optimal task and motion plan

end

