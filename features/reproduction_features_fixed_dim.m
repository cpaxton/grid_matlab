function [features,all_labels]=reproduction_features_fixed_dim(pt,local_env)
% REPRODUCTION_FEATURES_FIXED_DIM

F_PER_GATE = 4;
F_PER_EXIT = 2;
NUM_LEVELS=12;
origin_x=0;origin_y=0;
all_labels = {};
features = {};

len = size(pt,2)
features = zeros(2*F_PER_EXIT + F_PER_GATE, len);

%% compute each local environment: what's the next gate, prev gate that I am computing features for
%% TODO: check to see if they exist
for idx=1:len
    if isfield(local_env,'gate')
        features(1:4,idx) = get_gate_distances(pt(1:3,idx),local_env.gate);
    end
    if isfield(local_env,'prev_gate')
        features(5:8,idx) = get_gate_distances(pt(1:3,idx),local_env.prev_gate);
    end
    features(9:10,idx) = get_end_distance(pt(1:3,idx),local_env.exit);
    
end

features

end