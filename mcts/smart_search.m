% Search Version 2
% - Initialize search by drawing a large number of samples recursively
% through the tree.
env = envs{4};

%% Create environment and set up
rng(101);
w0 = NeedleMasterWorld(env);

%x0 = [650; 700; 0; 0; 0];
%x0 = [600; 800; 0; 0; 0];
x0 = [190; 1000; 0; 0; 0];
config = make_default_mcts_config();
action_config = make_default_action_config();
%action_config = make_fixed_action_config();

%% get a  list of nodes
[plan, prev_gate, next_gate] = get_symbolic_plan(w0.env);
nodes = nodes_from_plan(plan, prev_gate, next_gate, w0, models, action_config);

%% start search
% initialize the tree
nodes = initialize_tree(nodes, x0, w0, config); % draw 100 samples and send them down the tree
% note: extra branches aren't "dead", they just have a heuristic associated
% with them.

count = 1;

xs = zeros(5, nodes(1).config.max_depth);

figure(1); clf; hold on;
draw_environment(w0.env);
draw_nodes(nodes);

%% Main loop: iterate until budget is exhausted
% while not done
while count <= config.num_iter
   
    
    count = count + 1;
end
    