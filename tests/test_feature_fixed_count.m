allf = []
allx = []
for i = 1:length(f)
    for j = 1:length(f{i})
        allf = [allf f{i}{j}];
        allx = [allx trials{i}{j}.x];
    end
end