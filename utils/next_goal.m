function [goals, state] = next_goal (data, env, next_gate)
% NEXT_GOAL returns the next goal for each frame in a sequence

gates_done = zeros(size(env.gates)); % store whether or not gates are hit

if nargin < 3
    next_gate = 1;
end

goals = zeros(size(data.x));

for i = 1:data.length
    gate = in_gates(data.x(i),data.y(i),env.gates);
    if gate > 0
        gates_done(gate) = true;
        if gate == next_gate
            next_gate = next_gate + 1;
        end
    end
    goals(i) = next_gate;
end

if nargout > 1
    state = [];
    state.gates_done = gates_done;
    state.next_gate = next_gate; 
end