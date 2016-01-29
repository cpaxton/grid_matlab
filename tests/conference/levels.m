rng(100);
x0 = [190,1000,0,0,0]'; 

figure();
%% goals
subplot(3,5,1);
prob_plan_for_environment(x0,envs{4},bmm,models,true);
subplot(3,5,2);
prob_plan_for_environment(x0,envs{5},bmm,models,true);
subplot(3,5,3);
prob_plan_for_environment(x0,envs{6},bmm,models,true);
subplot(3,5,4);
prob_plan_for_environment(x0,envs{7},bmm,models,true);
subplot(3,5,5);
prob_plan_for_environment(x0,envs{8},bmm,models,true);

%% no goals
subplot(3,5,6);
prob_plan_for_environment(x0,envs{4},bmm,models,false);
subplot(3,5,7);
prob_plan_for_environment(x0,envs{5},bmm,models,false);
subplot(3,5,8);
prob_plan_for_environment(x0,envs{6},bmm,models,false);
subplot(3,5,9);
prob_plan_for_environment(x0,envs{7},bmm,models,false);
subplot(3,5,10);
prob_plan_for_environment(x0,envs{8},bmm,models,false);

%% no goals
subplot(3,5,11);
global_plan_for_environment(x0,envs{4},models);
subplot(3,5,12);
global_plan_for_environment(x0,envs{5},models);
subplot(3,5,13);
global_plan_for_environment(x0,envs{6},models);
subplot(3,5,14);
global_plan_for_environment(x0,envs{7},models);
subplot(3,5,15);
global_plan_for_environment(x0,envs{8},models);
