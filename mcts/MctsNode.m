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
            'show_figures', true, ...
            'max_depth', 10);
        
        % associated action
        models % defines the model used for actions
        step % index in plan
        action_idx % index of action in models()
        prev_gate
        next_gate
        prev_gate_option = 1
        next_gate_option = 1
        depth = 0;
        
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
        
        % probability of choosing each action
        prior_a
        
        % trajectory distributions
        mus
        sigmas
        
        % node-action transition matrix (what do we do from here?)
        T
    end
    
    methods
        
        function obj = initFromPlan(obj, plan, prev_gate, next_gate)
            % create children:
            % - same step
            % - next step, all possible options for next_gate
           
            if obj.step > 0
                done_plan = obj.step > length(plan) || plan(obj.step) > 4;
            else
                done_plan = false;
            end
            if obj.depth <= obj.config.max_depth && ~done_plan
               
                if obj.step > 0
                    obj.children = MctsNode(obj.world, ...
                        obj.models, ...
                        obj.step);
                    obj.children(1).action_idx = obj.action_idx;
                    obj.children(1).next_gate = obj.next_gate;
                    obj.children(1).prev_gate = obj.prev_gate;
                    obj.children(1).next_gate_option = obj.next_gate_option;
                    obj.children(1).prev_gate_option = obj.prev_gate_option;
                end
                
                next_step = obj.step + 1;
                num = length(obj.children);
                action_idx = plan(next_step);
                child_next_gate = next_gate(next_step);
                child_prev_gate = prev_gate(next_step);
                if child_next_gate <= length(obj.world.env.gates)
                    for i = 1:length(obj.world.env.gates{child_next_gate})
                        obj.children = [obj.children MctsNode(obj.world, ...
                            obj.models, ...
                            next_step)];
                        obj.children(num+i).action_idx = action_idx;
                        obj.children(num+i).next_gate = child_next_gate;
                        obj.children(num+i).prev_gate = child_prev_gate;
                        obj.children(num+i).next_gate_option = i;
                        obj.children(num+i).prev_gate_option = obj.next_gate_option;
                    end
                end
                
                for i = 1:length(obj.children)
                    obj.children(i).depth = obj.depth + 1;
                    obj.children(i) = obj.children(i).initFromPlan(plan, next_gate, prev_gate);
                end
            else
                obj.is_terminal = true;
            end
            
            obj.T = ones(size(obj.children)) ... 
                / length(obj.children);
        end
        
        function obj = MctsNode(world, models, step)
            obj.world = world;
            obj.children = [];
            obj.step = step;
            if step ~= 0
                obj.is_root = false;
            else
                obj.is_root = true;
                
                [plan, prev_gate, next_gate] = get_symbolic_plan(world.env);
                obj = obj.initFromPlan(plan, prev_gate, next_gate);
            end
            
            % take in action models
            for i = 1:length(models)
                % check action to see if its possible from this state
                obj.models = [obj.models; models{i}];
            end
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
        function select(obj, x)
            % -- if this is done, choose a child
            if obj.converged
                % select a child
            else
                obj.sample_forward(x, ones(size(x)));
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
        function sample_forward(obj, x, px)
            % -- generate with traj_forwardp
        end
        
        % res is -log likelihood
        function res = search_iter(obj, x)
            if ~obj.is_terminal
                obj.select(x)
                res = obj.avg_reward;
            else
                res = 0;
            end
        end
        
    end
    
end

