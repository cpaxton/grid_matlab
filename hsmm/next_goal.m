function [goals, opts, state] = next_goal (data, env, next_gate)
% NEXT_GOAL returns the next goal for each frame in a sequence

gates_done = zeros(size(env.gates)); % store whether or not gates are hit

if nargin < 3
    next_gate = 1;
end

goals = zeros(size(data.x));


[gates,gate_opts]= in_gates(data.x,data.y,env.gates);
for i = 1:data.length
    gate = gates(i);
    if gate > 0
        gates_done(gate) = true;
        if gate == next_gate
            next_gate = next_gate + 1;
        end
    end
    goals(i) = next_gate;
end

ref_opts = zeros(max(goals),1);
for i = 1:(max(goals)-1) % ASSUME FOR NOW THAT ALL GOALS ARE REACHED
    option = max(gate_opts(gates==i));
    ref_opts(i) = option;
end

next_opt = zeros(size(gate_opts));
prev_opt = zeros(size(gate_opts));
for i = 1:length(goals)
    if goals(i) > 1
        prev_opt(i) = ref_opts(goals(i)-1);
    end
    if goals(i) < next_gate
        next_opt(i) = ref_opts(goals(i));
    end
end

% pack it up
opts = [next_opt;prev_opt];

if nargout > 2
    state = [];
    state.gates_done = gates_done;
    state.next_gate = next_gate;
end