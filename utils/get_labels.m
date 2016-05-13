function labels = get_labels(bmm,predicates,NUM_LEVELS)

if nargin < 3
    NUM_LEVELS = 6; % limit ourselves to the first 6 levels
end

labels = {}
for i = 1:NUM_LEVELS
    for j = 1:length(predicates{i})
        %% compute the labels for this trial and use them to determine
        % what each motion will be
        fprintf('labelling env=%d trial=%d\n',i,j);
        
        % assign labels to each of the current positions based on
        % computed predicates
        labels{i}{j} = BernoulliAssign(bmm,predicates{i}{j}');
    end
end