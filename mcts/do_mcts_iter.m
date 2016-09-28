%% MCTS iteration
function do_mcts_iter(root)

%% call the function to go through each node and find its child
node = root.select();

%% expand the unexplored node
% this creates the node
% it also does CEM optimization on the previous action
node.expand();

%% simulate a game
% rollout models are based on a sim
% rollouts are based on two gmms learned from demonstration:
% - rollout_gate if there is an unfinished gate
% - rollout_done if there is not
node.rollout(rollout_gate, rollout_done);

end