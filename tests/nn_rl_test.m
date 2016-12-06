% Reinforcement Learning Simple Test
% GOAL: move to goal position g

%% task setup
% goal is at this position
% if you get within 10, you get 1 reward
g = [50,50];
radius = 10;

mu = [50,50];
sigma=eye(2);

% input features
x = mvnrnd(mu,sigma*100,100);

% commands
gx = repmat(g,100,1);
best_cmd = x - gx;
y = best_cmd + (5 * rand(100, 2));

% rewards
x2 = x + y;
x2sq = x2 .* x2;
dists = 