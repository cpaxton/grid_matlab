function [ features, names ] = get_clustering_features( traj, env )
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

gate = in_gates(traj(1,:),traj(2,:),env.gates);
state = struct('gates_done',num2cell(gate<0),'next_gate',num2cell(ones(1,size(traj,2))));

features = [];

for i = 1:len
    % take this slice of the example
    pt = traj(:,i);
    [p,state] = compute_predicates(pt,env,state(1));
    f = p; % add in the predicates
    it = in_tissue(pt,env.surfaces)
    f = [f;it];
    
    features = [features f];
end

start = 1;
names = cell(size(features,1),1);
[names,start] = add_names(p,'predicates',start,names);
[names,start] = add_names(it,'in_tissue',start,names);

end

function [names,start] = add_names(f,fname,start,names)
flen = start+(length(f)-1);
for j=start:flen
    names{j} = fname;
end
start=start+flen;
end
