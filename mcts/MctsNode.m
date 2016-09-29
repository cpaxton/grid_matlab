classdef MctsNode
    %MctsNode Represents a particular node in the tree search
    %   Also needs to evaluate the state of the game.
    
    properties (GetAccess = public, SetAccess = public)
        
        % constants
        MAX_SAMPLES = 100;
        NUM_PRIMITIVE_PARAMS = 3;
        NUM_STEPS = 10;
        NUM_PRIMITIVES = 1;
        
        % associated actions
        models = []; % defines models used for actions
        actions = []; % defines parameterized actions
        
        % actor position
        x
        
        % visits indicates numbers of CEM iterations performed
        % upper confidence bound for distribution plus subtree
        initialized = false
        avg_reward = 0;
        num_samples = 0;
        visits = [];
        
        % initial world state
        % includes environment
        % note that this is a constraint on optimization
        world
        
        % list of nodes that follow this one
        children
        
        is_terminal = false
        is_root = false
        parent
        
        % probability of choosing each action
        prior_a
        
        % selection function
        f_select
        
        % trajectory distributions
        mus
        sigmas
        
        % node-action transition matrix (what do we do from here?)
        T
    end
    
    methods
        
        function obj = MctsNode(world, models, parent)
            obj.world = world;
            obj.children = [];
            if isa(parent, 'MctsNode')
                obj.f_select = parent.f_select;
                obj.parent = parent;
                obj.is_root = false;
            else
                obj.is_root = true;
            end
            
            % take in action models
            for i = 1:length(models)
                % check action to see if its possible from this state
                obj.models = [obj.models; models{i}];
            end
            
            obj.prior_a = ones(size(obj.actions)) ... 
                / length(obj.actions);
            obj.T = ones(size(obj.actions)) ... 
                / length(obj.actions);
        end
        
        % compute the expansion probabilities -- 
        % - p(a)
        % - p(mean | a)
        % --> UCB on the above
        function update(obj)
            
        end
        
        % choose a child
        % select() also prunes the tree by doing full trajectory
        % optimization and collision checks.
        % -- 
        % Approach:
        % - compute upper confidence bound on action distribution
        % - plus UCB on discrete choice
        % - if unvisited: prior and p(mean | a)
        function select_and_rollout(obj)
            % -- if # samples is high enough: update distribution
            if obj.num_samples > obj.MAX_SAMPLES
                obj.update()
            end
            
            % -- draw and continue
            
            
            % -- check to see if this action has converged
        end
        
        % simulate the game forward
        % rollouts only optimize over goal positions
        % note that we still propogate info back, initialize and create
        % nodes during rollouts
        function rollout(obj)
            % draw action(s)
        end
        
        % create child
        function expand_and_rollout(obj)
            % initialize new child
            % call child.rollout()
        end
        
        % res is -log likelihood
        function res = search_iter(obj)
            if ~obj.is_terminal
                obj.select_and_rollout()
                res = obj.avg_reward;
            else
                res = 0;
            end
        end
        
    end
    
end

