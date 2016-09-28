

%% Create tree search for environment
env = envs{2};

w0 = NeedleMasterWorld(env);

f_select = @(node, action, p) p; 

actions = {models{1:4}};
root = MctsNode(w0, actions, 0);
root.f_select = f_select;

% loop until termination:
for i = 1:100
    res = root.search_iter();
end
