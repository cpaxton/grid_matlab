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
        world
        
    end
    
    methods
        
        function obj = MctsNode(world)
            obj.env = world;
        end
        
    end
    
end

