

%% Create tree search for environment
env = envs{2};

w0 = NeedleMasterWorld(env);

f_select = @(node, action, p) p; 

x0 = [190; 1000; 0; 0; 0];
actions = {models{1:4}};
root = MctsNode(w0, actions, 0);

% loop until termination:
for i = 1:10
    fprintf('=============================\n');
    fprintf('ITER %d\n',i);
    figure(i); clf; hold on;
    draw_environment(env);
    [root, res] = root.search_iter(x0);
    root.draw_all()
end
