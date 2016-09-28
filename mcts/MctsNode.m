classdef MctsNode
    %MctsNode Represents a particular node in the tree search
    %   Also needs to evaluate the state of the game.
    
    properties (GetAccess = public, SetAccess = public)
        % associated actions
        actions
        
        % actor position
        x
        
        % visits
        num_visits = 0;
        avg_reward = 0;
        sim_rewards = [];
        sim_children = [];
        
        % initial world state
        % includes environment
        % note that this is a constraint on optimization
        world
        
        % list of nodes that follow this one
        children
        
        is_terminal
        is_root
        parent
        
        % probability of choosing each action
        action_distribution
        
        % selection function
        f_select
    end
    
    methods
        
        function obj = MctsNode(world, models, parent)
            obj.world = world;
            obj.children = [];
            if isa(parent, 'MctsNode')
                obj.f_select = parent.f_select;
                obj.parent = parent;
                is_root = false;
            else
                is_root = true;
            end
            
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
        
        % create child
        function expand()
        end
        
        % simulate the game forward
        function rollout()
        end
        
    end
    
end

