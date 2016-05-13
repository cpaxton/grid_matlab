function flat = flatten_trials(trials,NUM_TRIALS)

if nargin < 2
    NUM_TRIALS = 12
end

flat = [];

for i = 1:NUM_TRIALS
    for j = 1:length(trials{i})
        flat = [flat [trials{i}{j}.x;trials{i}{j}.y;trials{i}{j}.w;...
            trials{i}{j}.movement;trials{i}{j}.rotation]];
    end
end

end