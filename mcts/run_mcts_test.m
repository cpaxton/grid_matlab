function [traj, nodes] = run_mcts_test(env, models, fig)

if nargin < 3
    fig = 1;
end

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

%% Run search test
nodes = mcts_search(nodes, x0, w0, config);
traj = mcts_extract(nodes, 1);

figure(fig); clf; hold on;
draw_environment(w0.env);
draw_nodes(nodes);
if config.highlight_extracted_path
    plot(traj(1,:), traj(2,:), '*', 'color', 'r');
end
    
end