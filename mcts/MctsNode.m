classdef MctsNode
    %MctsNode Represents a particular node in the tree search
    %   Also needs to evaluate the state of the game.
    
    properties (GetAccess = public, SetAccess = public)
        % associated mcts actions
        action
        
        % actor position
        x
        
        % initial world state
        % includes environment
        world
        
    end
    
    methods
        
        function obj = MctsNode(world)
            obj.world = world;
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

