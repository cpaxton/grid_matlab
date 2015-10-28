function [ features, names ] = get_clustering_features( trial, env )
%GET_CLUSTERING_FEATURES Gets a subset of the features for automatically
%clustering examples
%   - This will compute the gate features for the closest gates, exit
%   features, and everything else
%   - Will also need to track "state" so we can tell if all gates are done or
%   if there are other gates remaining
%   - Missing data will be input as NaN and must be dealt with later in
%   some other way. The only way we actually get missing data is if we
%   don't have an open and a closed gate.

NGATE_FEATURES = 4; %6; %7;

traj = [trial.x;trial.y;trial.w;trial.movement;trial.rotation];
len = size(traj,2);

gate = in_gates(traj(1,:),traj(2,:),env.gates);
state = struct('gates_done',num2cell(gate<0),'next_gate',num2cell(ones(1,size(traj,2))));
[goals, opts] = next_goal(trial,env);
exit = [env.width;(env.height / 2);0];

features = [];

for i = 1:len
    % take this slice of the example
    pt = traj(:,i);
    [p,state] = compute_predicates(pt,env,state(1));
    it = in_tissue(pt,env.surfaces);
    ef = get_end_distance(pt,exit);
    
    goal = goals(i);
    opt = opts(1,i);
    prev_opt = opts(2,i);
    
    if goal > 1
        pgd = get_gate_distances(pt,env.gates{goal-1}{prev_opt});
    else
        pgd = ones(NGATE_FEATURES,1) * nan;
    end
    if goal <= length(env.gates)
        ngd = get_gate_distances(pt,env.gates{goal}{opt});
    else
        ngd = ones(NGATE_FEATURES,1) * nan;
    end
    
    f = [p;it;ef;pgd;ngd];
    
    features = [features f];
end

start = 1;
names = cell(size(features,1),1);
[names,start] = add_names(p,'predicates',start,names);
[names,start] = add_names(it,'in_tissue',start,names);
[names,start] = add_names(ef,'exit',start,names);
[names,start] = add_names(pgd,'prev_gate',start,names);
[names,start] = add_names(ngd,'next_gate',start,names);

end

function [names,start] = add_names(f,fname,start,names)
flen = start+(length(f)-1);
for j=start:flen
    names{j} = fname;
end
start=start+flen;
end
