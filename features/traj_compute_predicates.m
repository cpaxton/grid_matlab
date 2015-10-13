function [predicates,state] = traj_compute_predicates(traj,env,initial_state)
% TRAJ_COMPUTE_PREDICATES computes predicates over a whole trajectory
% each state is given as the result of the 


len = size(traj,2);
predicates = zeros(4,len);
states = [];

if nargin < 3
    initial_state = struct('gates_done',0,'next_gate',0);
end

for i = 1:len
    [p,state] = compute_predicates(traj(:,i),env,initial_state);
    predicates(:,i) = p;
    states = [states state];
    initial_state = state;
end

end