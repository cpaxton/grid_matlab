function [trials, features, predicates] = downsample_trials(trials,envs,rate)
% downsample trials to a reasonable amount

for i = 1:length(trials)
    for j = 1:length(trials{i})
        trials{i}{j}.x = trials{i}{j}.x(1:rate:end);
        trials{i}{j}.y = trials{i}{j}.y(1:rate:end);
        trials{i}{j}.w = trials{i}{j}.w(1:rate:end);
        trials{i}{j}.t = trials{i}{j}.t(1:rate:end);
        
        trials{i}{j}.movement = rate * trials{i}{j}.movement(1:rate:end);
        trials{i}{j}.rotation = rate * trials{i}{j}.rotation(1:rate:end);
        
        trials{i}{j}.length = length(trials{i}{j}.t);
    end
end

trials = fix_downsampled_movement(trials);

for i=1:length(trials)
    features{i} = cell(size(trials{i}));
    predicates{i} = cell(size(trials{i}));
    for j=1:length(trials{i})
        [Ftmp, Ptmp] = compute_features(trials{i}{j},envs{i});
        features{i}{j} = Ftmp;
        predicates{i}{j} = Ptmp;
        fprintf('... done level %d, trial %d\n',i,j);
    end
end

end