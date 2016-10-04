classdef MctsNode
    %MctsNode Represents a particular node in the tree search
    %   Also needs to evaluate the state of the game.
    
    properties (GetAccess = public, SetAccess = public)
        
        % constants
        config = struct('n_iter', 1, ...
            'start_iter', 1, ...
            'n_primitives', 1, ...
            'max_primitives', 5, ...
            'allow_repeat', false, ...
            'n_primitive_params', 3, ...
            'n_samples', 100, ...
            'step_size', 0.75, ...
            'good', 12, ...
            'show_figures', true, ...
            'max_depth', 5, ...
            'rollout_depth', 3, ...
            'weighted_sample_starts', false);
        
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
        rollout_metric = 1;
        
        ACTION_EXIT = 1;
        ACTION_APPROACH = 4;
        
        compute_metric;
        compute_rollout_metric;
        
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
        idx = [];
        expected_p = 1;
        expected_p_var = 0;
        expected_p_max = 1;
        
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
                done_plan = obj.step > length(plan) || plan(obj.step) == obj.ACTION_EXIT;
            else
                done_plan = false;
            end
            
            if obj.step > 0
                obj.local_env = obj.world.make_local_env( ...
                    obj.prev_gate, ...
                    obj.next_gate, ...
                    obj.prev_gate_option, ...
                    obj.next_gate_option);
                obj.Z = model_init_z(obj.models{obj.action_idx}, ...
                    obj.config);
            end
            
            if obj.depth <= obj.config.max_depth && ~done_plan
                
                if obj.step > 0&& obj.config.allow_repeat
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
                obj.config.max_primitives = obj.models{action_idx}.num_primitives + 3;
                for j = 1:obj.config.max_primitives
                    if child_next_gate <= length(obj.world.env.gates)
                        for i = 1:length(obj.world.env.gates{child_next_gate})
                            idx = (i - 1) * obj.config.max_primitives + j;
                            obj.children = [obj.children MctsNode(obj.world, ...
                                obj.models, ...
                                next_step)];
                            obj.children(num+idx).action_idx = action_idx;
                            obj.children(num+idx).next_gate = child_next_gate;
                            obj.children(num+idx).prev_gate = child_prev_gate;
                            obj.children(num+idx).next_gate_option = i;
                            obj.children(num+idx).prev_gate_option = obj.next_gate_option;
                            obj.children(num+idx).config.n_primitives = j;
                        end
                    elseif child_prev_gate <= length(obj.world.env.gates) && child_prev_gate > 0
                        for i = 1:length(obj.world.env.gates{child_prev_gate})
                            idx = (i - 1) * obj.config.max_primitives + j;
                            obj.children = [obj.children MctsNode(obj.world, ...
                                obj.models, ...
                                next_step)];
                            obj.children(num+idx).action_idx = action_idx;
                            obj.children(num+idx).next_gate = child_next_gate;
                            obj.children(num+idx).prev_gate = child_prev_gate;
                            obj.children(num+idx).next_gate_option = i;
                            obj.children(num+idx).prev_gate_option = obj.next_gate_option;
                            obj.children(num+idx).config.n_primitives = j;
                        end
                    end
                end
                
                for i = 1:length(obj.children)
                    obj.children(i).depth = obj.depth + 1;
                    obj.children(i).selection_metric = obj.children(i).compute_metric(obj.children(i));
                    obj.children(i).rollout_metric = obj.children(i).compute_rollout_metric(obj.children(i));
                    obj.children(i) = obj.children(i).initFromPlan(plan, prev_gate, next_gate);
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
            
            obj.compute_metric = @(obj) metric_probability_max(obj);
            obj.compute_rollout_metric = @(obj) metric_probability(obj);
            
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
                fprintf('[%d at %d w %d] passing\n',obj.action_idx,obj.depth,obj.config.n_primitives);
                
                % select a child
                '--- METRICS ---'
                metrics = [obj.children.selection_metric]
                [~,i] = max(metrics);
                obj.children(i) = obj.children(i).select(x);
            else
                obj = obj.sample_forward(x, ones(size(x,2),1), obj.config.n_samples, obj.config.rollout_depth);
            end
            obj.selection_metric = obj.compute_metric(obj);
            obj.rollout_metric = obj.compute_rollout_metric(obj);
            
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
        function [obj, p, idx] = sample_forward(obj, x, px, nsamples, depth)
            % -- generate with traj_forward
            [ trajs, params, ~, ~, p, ~, idx ] = traj_forward(x, px, ...
                obj.models{obj.action_idx}, ...
                0, obj.local_env, 0, ...
                obj.Z, obj.config, nsamples);
            
            xsample = zeros(5,length(trajs));
            psample = px(idx) .* p;
            psample = psample / sum(psample);
            for j = 1:length(trajs)
                xsample(:,j) = trajs{j}(:,end);
            end
            
            if ~obj.is_terminal && depth > 0
                child_metrics = [obj.children.rollout_metric];
                child_metrics = cumsum(child_metrics / sum(child_metrics));
                prev = 0;
                pc = zeros(nsamples,1);
                idxc = zeros(nsamples,1);
                for i = 1:length(obj.children)
                    c_nsamples = min(nsamples, ceil(nsamples * child_metrics(i))) - prev;
                    if c_nsamples > 0
                        [obj.children(i), pi, idxi] = obj.children(i).sample_forward(xsample,psample, c_nsamples, depth - 1);
                        pc(prev+1:prev+c_nsamples) = pi;
                        idxc(prev+1:prev+c_nsamples) = idxi;
                    end
                    
                    prev = c_nsamples + prev;
                end
                
                assert(length(idxc) == nsamples)
                
                obj.idx = [obj.idx; idx(idxc)];
                obj.p = [obj.p; p(idxc) .* pc];
                obj.params = [obj.params params(:,idxc)];
            else
                obj.idx = [obj.idx; idx];
                obj.p = [obj.p; p];
                obj.params = [obj.params params];
            end
            
            obj.expected_p = mean(obj.p);
            obj.expected_p_max = max(obj.p);
            obj.expected_p_var = std(obj.p);
            if length(obj.params) >= obj.config.n_samples
                mean(obj.p)
                mean(obj.params')
                obj.Z = traj_update(obj.params, obj.p, obj.Z, obj.config);
                %obj.Z = traj_update(params, p, obj.Z, obj.config);

                fprintf('[%d at %d w %d] %f\n',obj.action_idx,obj.depth,obj.config.n_primitives,-log(mean(obj.p)));
                obj.visits = obj.visits + 1;
                
                obj.p = [];
                obj.params = [];
            end
            
            obj.selection_metric = obj.compute_metric(obj);
            obj.rollout_metric = obj.compute_rollout_metric(obj);
        end
        
        % descend through the tree from this node
        % display generated trajectories
        function draw_all(obj)
            for i = 1:length(obj.samples)
                plot(obj.samples{i}(1,:), ...
                    obj.samples{i}(2,:), ...
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
        function [obj, res] = search_iter(obj, x)
            if ~obj.is_terminal
                obj = obj.select(x);
                res = obj.avg_reward;
            else
                res = 0;
            end
        end
        
    end
    
end

