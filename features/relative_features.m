function [features, predicates, est_state] = relative_features( data, env, fig, in_state)
%RELATIVE_FEATURES new compute features function based on relative
%positions to goals

if nargin > 2 && fig > 0
    figure(fig);
    draw_environment(env)
    draw_trial(data)
end

if nargin < 4
    gates_done = zeros(size(env.gates)); % store whether or not gates are hit
    next_gate = 1;
else
    gates_done = in_state.gates_done;
    next_gate = in_state.next_gate;
end




end

