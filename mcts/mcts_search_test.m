%% Create environment and set up
env = envs{11};
w0 = NeedleMasterWorld(env);

x0 = [600; 800; 0; 0; 0];
actions = {models{1:5}};
config = make_default_mcts_config();

%% get a  list of nodes
[plan, prev_gate, next_gate] = get_symbolic_plan(w0.env);
nodes = nodes_from_plan(plan, prev_gate, next_gate, w0, models, config);

%% Run search test
nodes = mcts_search(nodes, x0, w0, config);
mcts_extract(nodes, 1);