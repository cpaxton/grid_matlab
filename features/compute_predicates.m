function [predicates,state] = compute_predicates( x, env, in_state )
%COMPUTE_PREDICATES determines which action we should be performing
% x is the state [x;y;w]
% u is the command at the state [movement;rotation]
% env
% state

%% computation

gate = in_gates(x(1,:),x(2,:),env.gates);
if nargin < 3
    state = struct('gates_done',num2cell(gate<0),'next_gate',num2cell(ones(1,size(x,2))));
else
    state = struct('gates_done',num2cell(gate>0),'next_gate',num2cell((ones(1,size(x,2))*in_state.next_gate)+(gate==in_state.next_gate)));
end

%% combine predicates into one vector to return
predicates = [
    gate > 0; ... % needle in gates
    %facing_exit; ...
    %0; ...
    [state.next_gate] > 1; ... % from one gate to something
    [state.next_gate] <= length(env.gates); ... % to a gate
    x(1,:) >= env.width; ... % exit
    ];

end

