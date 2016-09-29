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
        action_idx = 0% index of action in models()
        prev_gate = 0
        next_gate = 0
        prev_gate_option = 1
        next_gate_option = 1
        depth = 0;
        selection_metric = 1;
        
        compute_metric;
        
        % actor position
        x0
        Z
        
        % visits indicates numbers of CEM iterations performed
        % upper confidence bound for distribution plus subtree
        initialized = false;
        converged = false;
        avg_reward = 0;
        num_samples = 0;
        visits = 0;
        samples = {};
        p = [];
        params = [];
        
        % initial world state
        % includes environment
        % note that this is a constraint on optimization
        world
        local_env
        
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
                    
                    
                    obj.local_env = obj.world.make_local_env( ...
                        obj.prev_gate, ...
                        obj.next_gate, ...
                        obj.prev_gate_option, ...
                        obj.next_gate_option);
                    obj.Z = model_init_z(obj.models{obj.action_idx}, ...
                        obj.config);
                    
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
                    obj.children(i).selection_metric = obj.children(i).compute_metric(obj.children(i));
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
            obj.models = models;
            
            obj.compute_metric = @(obj) metric_prior_probability(obj,2);
            
            if step ~= 0
                obj.is_root = false;
            else
                obj.is_root = true;
                obj.converged = true;
                
                [plan, prev_gate, next_gate] = get_symbolic_plan(world.env);
                obj = obj.initFromPlan(plan, prev_gate, next_gate);
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
        function obj = select(obj, x)
            % -- if this is done, choose a child
            if obj.converged
                % select a child
                metrics = [obj.children.selection_metric];
                [~,i] = max(metrics);
                obj.children(i) = obj.children(i).select(x);
            else
                obj = obj.sample_forward(x, ones(size(x,2),1));
            end
            obj.selection_metric = obj.compute_metric(obj);
            
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
        function obj = sample_forward(obj, x, px)
            % -- generate with traj_forward
            [ trajs, params, Z, p, pa, pg, idx ] = traj_forward(x, px, ...
                obj.models{obj.action_idx}, ...
                0, obj.local_env, 0, ...
                obj.Z, obj.config);
            obj.samples = trajs;
            obj.p = p;
            obj.params = params;
        end
        
        % descend through the tree from this node
        % display generated trajectories
        function draw_all(obj)
            for i = 1:length(samples)
                plot(samples{i}(1,:), ...
                    samples{i}(2,:), ...
                    obj.models{obj.action_idx}.color);
            end
            for i = 1:length(obj.children)
                obj.children(i).draw_all();
            end
        end
        
        % descend through the tree
        % choose the mean of every distribution and draw that
        function draw_best(obj,x)
            traj = sample_seq(x,Z.mu);
            plot(traj(1,:),traj(2,:),obj.models{obj.action_idx}.color);
            for i = 1:length(obj.children)
                obj.children(i).draw_best(traj(:,end));
            end
        end
        
        function show_all(obj)
           draw_environment(obj.world.env,0,1);
           obj.draw_all();
        end
        
        function show_best(obj)
           draw_environment(obj.world.env,0,1);
           obj.draw_best();
        end
        
        % res is -log likelihood
        function res = search_iter(obj, x)
            if ~obj.is_terminal
                obj = obj.select(x);
                res = obj.avg_reward;
            else
                res = 0;
            end
        end
        
    end
    
end

