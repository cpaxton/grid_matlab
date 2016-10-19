function [nodes] = nodes_from_plan(plan, prev_gate, next_gate, world, models, config)

nodes = MctsNode(world, models, 0);
nodes = nodes_from_plan_helper(nodes, plan, prev_gate, next_gate, 1);

end

function nodes = nodes_from_plan_helper(nodes, plan, prev_gate, next_gate, idx, config)

%nodes(idx)
%nodes(idx).selection_metric = config.compute_metric(nodes(idx));
%nodes(idx).rollout_metric = config.compute_rollout_metric(nodes(idx));
        
%% is this the end? is it a terminal node?
if nodes(idx).step > 0
    done_plan = nodes(idx).step > length(plan) || plan(nodes(idx).step) == nodes(idx).ACTION_FINISH;
else
    done_plan = false;
end

%% create local env if this is a "real" non-root action
if nodes(idx).step > 0
    nodes(idx).local_env = nodes(idx).world.make_local_env( ...
        nodes(idx).prev_gate, ...
        nodes(idx).next_gate, ...
        nodes(idx).prev_gate_option, ...
        nodes(idx).next_gate_option);
    nodes(idx).Z = model_init_z(nodes(idx).models{nodes(idx).action_idx}, ...
        nodes(idx).config);
end

%% if we can still descend farther into the tree
if nodes(idx).depth <= nodes(idx).config.max_depth && ~done_plan
    
    if nodes(idx).step > 0 && nodes(idx).config.allow_repeat
        % create new node and append it
        nodes = [nodes MctsNode(nodes(idx).world, ...
            nodes(idx).models, ...
            nodes(idx).step)];
        nodes(idx).children = [nodes(idx).children length(nodes)];
        nodes(end).action_idx = nodes(idx).action_idx;
        nodes(end).next_gate = nodes(idx).next_gate;
        nodes(end).prev_gate = nodes(idx).prev_gate;
        nodes(end).next_gate_option = nodes(idx).next_gate_option;
        nodes(end).prev_gate_option = nodes(idx).prev_gate_option;
    end
    
    next_step = nodes(idx).step + 1;
    num = length(nodes(idx).children);
    action_idx = plan(next_step);
    child_next_gate = next_gate(next_step);
    child_prev_gate = prev_gate(next_step);
    if nodes(idx).config.allow_repeat
        min_primitives = 1;
        nodes(idx).config.max_primitives = 1;
    elseif nodes(idx).config.fixed_num_primitives
        min_primitives = nodes(idx).models{action_idx}.num_primitives;
        nodes(idx).config.max_primitives = nodes(idx).models{action_idx}.num_primitives;
    else
        min_primitives = 1;
        nodes(idx).config.max_primitives = nodes(idx).models{action_idx}.num_primitives + 1;
    end
    for j = min_primitives:nodes(idx).config.max_primitives
        fprintf (' - adding children at %d: %d primitives\n', nodes(idx).depth, j);
        if child_next_gate <= length(nodes(idx).world.env.gates)
            for i = 1:length(nodes(idx).world.env.gates{child_next_gate})

        nodes = [nodes MctsNode(nodes(idx).world, ...
            nodes(idx).models, ...
            next_step)];
        nodes(idx).children = [nodes(idx).children length(nodes)];
                nodes(end).action_idx = action_idx;
                nodes(end).next_gate = child_next_gate;
                nodes(end).prev_gate = child_prev_gate;
                nodes(end).next_gate_option = i;
                nodes(end).prev_gate_option = nodes(idx).next_gate_option;
                nodes(end).config.n_primitives = j;
            end
        elseif child_prev_gate <= length(nodes(idx).world.env.gates) && child_prev_gate > 0
        	nodes = [nodes MctsNode(nodes(idx).world, ...
                    nodes(idx).models, ...
                    next_step)];
            nodes(idx).children = [nodes(idx).children length(nodes)];
            nodes(end).action_idx = action_idx;
            nodes(end).next_gate = child_next_gate;
            nodes(end).prev_gate = child_prev_gate;
            if child_next_gate <= length(nodes(idx).world.env.gates)
                nodes(end).next_gate_option = length(nodes(idx).world.env.gates{child_next_gate});
            end
            nodes(end).prev_gate_option = nodes(idx).next_gate_option;
            nodes(end).config.n_primitives = j;
        end
    end
    
    for i = 1:length(nodes(idx).children)
        fprintf(' - child of %d: idx = %d\n', idx, nodes(idx).children(i));
        nodes(nodes(idx).children(i)).depth = nodes(idx).depth + 1;
        nodes = nodes_from_plan_helper(nodes, plan, prev_gate, next_gate, nodes(idx).children(i));
    end
else
    nodes(idx).is_terminal = true;
end

nodes(idx).T = ones(size(nodes(idx).children)) ...
    / length(nodes(idx).children);
end