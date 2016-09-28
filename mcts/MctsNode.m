classdef MctsNode
    %MctsNode Represents a particular node in the tree search
    %   Also needs to evaluate the state of the game.
    
    properties (GetAccess = public, SetAccess = public)
        % associated mcts actions
        actions
        
        % actor position
        x
        
        % initial world state
        % includes environment
        % note that this is a constraint on optimization
        world
        
        % list of nodes that follow this one
        children
        
        % probability of choosing each action
        action_distribution
    end
    
    methods
        
        function obj = MctsNode(world, models)
            obj.world = world;
            obj.children = [];
            
            % take in action models
            for i = 1:length(models)
                % check action to see if its possible from this state
                obj.actions = [obj.actions; models{i}];
            end
            
            obj.action_distribution = ones(size(obj.actions)) ... 
                / length(obj.actions);
        end
        
        % choose a child
        function select()
        end
        
        % create action
        function expand()
        end
        
        % simulate the game forward
        function rollout()
        end
        
    end
    
end

