rng(100);
trajs = prob_plan_for_environment(x0,envs{4},bmm,models,true);

for i = 1:length(trajs)
    figure(i+1);
    draw_environment(envs{4});
    for j = 1:i
        j=plot(trajs{j}(1,:),trajs{j}(2,:));
    end
end