function [ f ] = get_clustering_features( traj, env )
%GET_CLUSTERING_FEATURES Gets a subset of the features for automatically
%clustering examples
%   - This will compute the gate features for the closest gates, exit
%   features, and everything else
%   - Will also need to track "state" so we can tell if all gates are done or
%   if there are other gates remaining
%   - Missing data will be input as NaN and must be dealt with later in
%   some other way. The only way we actually get missing data is if we
%   don't have an open and a closed gate.

len = size(traj,2);
state = struct('gates_done',num2cell(gate<0),'next_gate',num2cell(ones(1,size(x,2))));

for i = 1:len
    % take this slice of the example
    pt = traj(:,i);
    [p,state] = compute_predicates(pt,state);
end

end

