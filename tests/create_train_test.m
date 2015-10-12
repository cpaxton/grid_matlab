NUM_LEVELS = 6;

% test
test_trials = cell(NUM_LEVELS,1);
test_predicates = cell(NUM_LEVELS,1);
test_features = cell(NUM_LEVELS,1);

% train
train_trials = cell(NUM_LEVELS,1);
train_predicates = cell(NUM_LEVELS,1);
train_features = cell(NUM_LEVELS,1);

for i = 1:NUM_LEVELS
    
    % initialize
    train_trials{i} = {};
    train_predicates{i} = {};
    train_features{i} = {};
    test_trials{i} = {};
    test_predicates{i} = {};
    test_features{i} = {};
    
    idx = randperm(length(trials{i}));
    for j = 1:length(trials{i})
        if j <= length(trials{i})-2
            train_trials{i}{j} = trials{i}{idx(j)};
            train_predicates{i}{j} = predicates{i}{idx(j)};
            train_features{i}{j} = features{i}{idx(j)};
        else
            test_idx = length(trials{i}) - j + 1;
            test_trials{i}{test_idx} = trials{i}{idx(j)};
            test_predicates{i}{test_idx} = predicates{i}{idx(j)};
            test_features{i}{test_idx} = features{i}{idx(j)};
        end
    end
end