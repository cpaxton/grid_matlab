

%% Create tree search for environment
env = envs{11};

w0 = NeedleMasterWorld(env);

f_select = @(node, action, p) p; 

x0 = [600; 800; 0; 0; 0];
actions = {models{1:5}};
root = MctsNode(w0, actions, 0);
[plan, prev_gate, next_gate] = get_symbolic_plan(w0.env);
root = root.initFromPlan(plan, prev_gate, next_gate);

% loop until termination:
for i = 1:5
    fprintf('=============================\n');
    fprintf('ITER %d\n',i);
    figure(i); clf; hold on;
    draw_environment(env);
    [root, res] = root.search_iter(x0);
    root.draw_all();
    root.print();
end
