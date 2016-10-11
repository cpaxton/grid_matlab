%% Create tree search for environment
env = envs{11};
w0 = NeedleMasterWorld(env);

x0 = [600; 800; 0; 0; 0];
actions = {models{1:5}};
root = MctsNode(w0, actions, 0);

%% Flatten into list of nodes
nodes = flatten_tree(root);

%% Run search test
nodes = mcts_search(nodes, config);
mcts_extract(nodes, 1);