% Reinforcement Learning Simple Test
% GOAL: move to goal position g

%% task setup
% goal is at this position
% if you get within 10, you get 1 reward
g = [50,50];
radius = 10;
ntrain = 100;

mu = [50,50];
sigma=eye(2);

% input features
x = mvnrnd(mu,sigma*100,ntrain);
vx = mvnrnd(mu,sigma*100,ntrain);

% commands
gx = repmat(g,ntrain,1);
best_cmd = gx - x;
y = best_cmd + (20 * (rand(ntrain, 2) - 0.5));

% rewards
[r, dists] = reward_nn_test(x,y,g,radius);

% show setup
draw_nn_test(x,y,g,1);

%% learn neural net: fit to data
tx = x(r == 1, :);
ty = y(r == 1, :);

net = fitnet([10 10]);
[net, tr] = train(net,x',y');

y1 = net(x');
vy1 = net(vx');
xy1 = x + y1';
plot(xy1(:,1),xy1(:,2), 'r.');

pretrain_acc = sum(r) / ntrain;
posttrain_acc = sum(reward_nn_test(x,y1',g,radius)) / ntrain;
posttrain_v_acc = sum(reward_nn_test(vx,vy1',g,radius)) / ntrain;

fprintf('TRAINED NEURAL NET.\n');
fprintf(' - train accuracy of raw data: %f\n', pretrain_acc);
fprintf(' - train accuracy of neuralnet: %f\n', posttrain_acc);
fprintf(' - validation accuracy of neuralnet: %f\n', posttrain_v_acc);
