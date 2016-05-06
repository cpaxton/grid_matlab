rng(100);
x0 = [190,1000,0,0,0]'; 

T = ones(5) / 5;
T0 = ones(5,1) / 5;

[action_probabilities,trajectories,labels] = ...
    prob_plan_for_environment_hsmm(x0,envs{2},models,T,T0);


figure(); clf;
draw_environment(envs{2}); hold on;
for i = 1:length(trajectories)
   plot(trajectories{i}(1,:),trajectories{i}(2,:));
end
