classdef MctsNode
    %MctsNode Represents a particular node in the tree search
    %   Also needs to evaluate the state of the game.
    
    properties (GetAccess = public, SetAccess = public)
        
        % constants
        config = struct('n_iter', 1, ...
            'start_iter', 1, ...
            'n_primitives',3, ...
            'n_primitive_params', 3, ...
            'n_samples', 100, ...
            'step_size', 0.75, ...
            'good', 0, ...
            'show_figures', true);
        
        % associated actions
        models = []; % defines models used for actions
        actions = []; % defines parameterized actions
        
        % actor position
        x0
        
        % visits indicates numbers of CEM iterations performed
        % upper confidence bound for distribution plus subtree
        initialized = false;
        converged = false;
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
        
        function obj = MctsNode(x0, world, models, parent)
            obj.x0 = x0;
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
        function select(obj)
            % -- if this is done, choose a child
            if obj.converged
                % select a child
            else
                obj.sample_and_rollout();
            end
            
            % -- check to see if this action has converged
        end
        
        % simulate the game forward
        % rollouts only optimize over goal positions
        % note that we still propogate info back, initialize and create
        % nodes during rollouts
        function rollout(obj)
            % draw action(s)
        end
        
        % draw n_samples trajectories
        % sample from possible successor actions
        % compute reward and propogate back
        function sample_and_rollout(obj)
            % initialize new child
            % call child.rollout()
        end
        
        % res is -log likelihood
        function res = search_iter(obj)
            if ~obj.is_terminal
                obj.select()
                res = obj.avg_reward;
            else
                res = 0;
            end
        end
        
    end
    
end

