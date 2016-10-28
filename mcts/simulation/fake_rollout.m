function [trace, depth] = fake_rollout(nodes, idx, trace, depth, parent_node, parent_traj)

%% Trace indices
CHILD_NODE = 1;
CHILD_TRAJ = 2;
CHILD_P = 3;
CHILD_VISITS = 4;
CHILD_TERMINAL = 5;
CHILD_IDX = 6;

%% Next Goal
% first step: if this is not terminal, get goal probability at the end of
% the trajectory
idx = nodes(idx).goals(1);

% Assess the likelihood of the trajectory we just followed
end_of_traj = nodes(parent_node).trajs{parent_traj}(:,end-1:end);
p = traj_probability(end_of_traj, nodes(idx).models{nodes(idx).action_idx}, nodes(idx).local_env);

trace(depth,CHILD_P) = p;
trace(depth,CHILD_NODE) = idx;
%depth = depth + 1;

%% Predict the Future
% To make sure we have a fair comparison against longer/shorter
% trajectories, take the average reward of all known trajectories to the end of
% time
if ~isempty(nodes(idx).goals)
    idx = nodes(idx).goals(1);
    while ~nodes(idx).is_terminal
        
        if nodes(idx).visits > 0
            
            depth = depth + 1;
            
            p = nodes(idx).p / nodes(idx).visits;
            fprintf('---- %d %f\n', idx, p);
            trace(depth,CHILD_NODE) = idx;
            trace(depth,CHILD_P) = p;
            
        else
            break
        end
        
        idx = nodes(idx).goals(1);
    end
end

end