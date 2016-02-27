
figure(2);
test1_envs = cell(16,1);
for i = 1:16
    subplot(4,4,i);
    env = generate_environment(1920,1080,2,2);
    draw_environment(env,0,1);
    test1_envs{i} = env;
end

figure(3);
test2_envs = cell(16,1);
for i = 1:16
    subplot(4,4,i);
    env = generate_environment(1920,1080,2,0);
    draw_environment(env);
    test2_envs{i} = env;
end