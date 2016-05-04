function [features,all_labels]=feature_compute(trials,predicates,envs,bmm)
F_PER_GATE = 4;
F_PER_EXIT = 2;
NUM_LEVELS=12;
origin_x=0;origin_y=0;
all_labels = {};
features = {};
for i = 1:NUM_LEVELS
    features{i} = {}
    for j = 1:length(trials{i})
        %% compute the next frame for each time step
        [goals, opts] = next_goal(trials{i}{j},envs{i});
        
        next_opt = opts(1,:);
        prev_opt = opts(2,:);
        
        local_env = [];
        features{i}{j} = zeros(2*F_PER_EXIT + F_PER_GATE, length(goals));
        
        %% compute each local environment: what's the next gate, prev gate that I am computing features for
        %% TODO: check to see if they exist
        pt = [trials{i}{j}.x;trials{i}{j}.y;trials{i}{j}.w];
        for idx=1:length(goals)
            if (goals(idx) <= length(envs{i}.gates))
                local_env.next_gate = envs{i}.gates{goals(idx)};
                features{i}{j}(1:4,idx) = get_gate_distances(pt(1:3,idx),local_env.next_gate{next_opt(idx)});
            end
            if (goals(idx)-1 > 0)
                local_env.prev_gate = envs{i}.gates{goals(idx)-1};
                features{i}{j}(5:8,idx) = get_gate_distances(pt(1:3,idx),local_env.prev_gate{prev_opt(idx)});
            end
            local_env.exit = [envs{i}.width-origin_x;(envs{i}.height / 2)-origin_y;0];
            features{i}{j}(9:10,idx) = get_end_distance(pt(1:3,idx),local_env.exit);
            
            %% TODO: outside: take this set of data and use BP-AR-HMM to segment
            %% return all_labels{i}{j}
            %             end
            
            all_labels{i}{j} = BernoulliAssign(bmm,predicates{i}{j}');
        end
    end
end
end