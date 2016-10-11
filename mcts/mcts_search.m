function [ root ] = mcts_search( root, config )
%MCTS_SEARCH run MCTS search through the tree
%   Uses the MctsNode objects, despite not being member functions.
%   At each iteration, select and rollout down the tree.
%   During backup, add extra options to tree.

%% Definitions
% Define location where we store the high-level option and the specific
% trajectory associated with that option in each rollout/simulation.
CHILD_OP = 1;
CHILD_ACTION = 2;

current_node = root;
current_idx = 0;

%% Main loop: iterate until budget is exhausted
% while not done
while false

    % store a trace through the tree out to max depth
    trace = zeros(config.max_depth, 2);
    
    % descend through the tree
    % choose child with best value, or use DPW to create a new child
    while ~current_node.is_terminal
        
        if ~current_node.initialized
            % draw a set of samples for this node
            current_node = initialize_node(current_node);
        end
        
        %% DOUBLE PROGRESSIVE WIDENING FUNCTION
        % greedily choose child, or add a trajectory
        if false
            % greedily choose best existing child according to UCT
        else
            % create child by creating new random sample
        end
        
        %% update current node
        current_node = next_node;
        current_idx = next_idx;
    end
end

%% After the end:
% descend once through the tree along the most-visited branch
% end result will be our approximately optimal task and motion plan

end

