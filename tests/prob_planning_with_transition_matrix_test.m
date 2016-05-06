rng(100);
x0 = [190,1000,0,0,0]'; 

T = ones(5) / 5;
T0 = ones(5,1) / 5;

[action_probabilities,trajectories] = ...
    prob_plan_for_environment_hsmm(x0,envs{2},models,T,T0);