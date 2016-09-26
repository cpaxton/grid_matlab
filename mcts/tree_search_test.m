

%% Create tree search for environment
env = envs{2};

w0 = NeedleMasterWorld(env);

root = MctsNode(w0);
