%% Create tree search for environment
env = envs{11};
w0 = NeedleMasterWorld(env);

x0 = [600; 800; 0; 0; 0];
actions = {models{1:5}};
root = MctsNode(w0, actions, 0);
[plan, prev_gate, next_gate] = get_symbolic_plan(w0.env);
config = make_default_mcts_config();

%% Flatten into list of nodes
nodes = flatten_tree(root, config);

%% Run search test
nodes = mcts_search(nodes, config);
mcts_extract(nodes);