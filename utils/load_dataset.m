function [trials, features, predicates] = load_dataset(envs,dirname,nlevels)

lengths = ones(nlevels,1);
trials = cell(nlevels,1);

info = dir([dirname '/tr*']);

for i=1:length(info)
    [idx, ~] = textscan(info(i).name,'trial_%f_%s.csv');
    idx = idx{1} + 1;
    
    trials{idx}{lengths(idx)} = load_data( ...
        [dirname info(i).name], ...
        envs{idx});
    lengths(idx) = lengths(idx) + 1;
end

%% create data to explore

features = cell(6,1);
predicates = cell(6,1);

%fprintf('Creating features and predicates...\n');

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
