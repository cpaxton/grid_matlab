res_mean = zeros(2,length(trials));
res_std = zeros(2,length(trials));

for i = 1:length(trials)-2
    
    dists = zeros(length(trials{i}) * length(test_trials{i}),1);
    dist2 = zeros(length(trials{i}),1);
    idx = 0;
    
    path = evaluate([150,950,-0.060]',envs{i},bmm,models);
    
    for j = 1:length(trials{i})
        
        traj1 = [trials{i}{j}.x; trials{i}{j}.y];
        for k= 1:length(test_trials{i})
            
            traj2 = [test_trials{i}{k}.x; test_trials{i}{k}.y];
            a = dtw(traj1',traj2');
            idx = idx + 1;
            dists(idx) = a;
        end
        
        dist2(j) = dtw(traj1',path(1:2,:)');
    end
    
    res_mean(1,i) = mean(dists);
    res_std(1,i) = std(dists);
    res_mean(2,i) = mean(dist2);
    res_std(2,i) = std(dist2);
    
end

figure();
tmeans = res_mean(1,1:5);
vmeans = res_mean(2,1:5);
barwitherr([res_std(1,1:5)' res_std(2,1:5)'],[tmeans' vmeans']);
xlabel('Cluster');
ylabel('DTW Distance');
legend('Human','Model');
title('Similarity between Human and Model Trajectories');