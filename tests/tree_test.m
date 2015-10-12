% test for model 4
% goal = gate{1}
% obstacles = top and bottom of gate{1}
% valid = everything
% these are defined by the regions of space that are free

for k=1:bmm.k
    for j=1:models{k}.nbStates
        models{k}.inInvSigmaNT(:,:,j) = inv(models{k}.Sigma(models{k}.in(2:end),models{k}.in(2:end),j));
    end
end

env = envs{2};
%env.gates{1} = move_gate(-350,0,env.gates{1});
%env.gates{1} = move_gate(-100,-150,env.gates{1});
pt = [trials{2}{1}.x(1); trials{2}{1}.y(1); trials{2}{1}.w(1)];

goal_conf = [];
goal_conf.valid_sampler = @(x)(sample_environment(env.width,env.height,x));
goal_conf.goal_sampler = @(x)(sample_gate(env.gates{1},x));
goal_conf.bmm = bmm;
goal_conf.label = 4;
goal_conf.valid = {[1 env.width env.width 1; 1 1 env.height env.height]};
goal_conf.obs = {env.gates{1}.top,env.gates{1}.bottom};
goal_conf.num_iter = 400;
goal_conf.ll_threshold = 300;
goal_conf.goal_threshold = 0.00;
goal_conf.n_samples = 10;
goal_conf.gate = 1;
goal_conf.prev_gate = 0;
goal_conf.goal_label = [2 5];

[pts,prob,parents,cprob,goal_met,goal_parents] = build_tree(pt,models{4},env,goal_conf);
path = tree_find_path(pts, parents, cprob, goal_met, goal_parents);
path2 = tree_find_path(pts, parents, prob, goal_met, goal_parents);

figure(1);
clf; hold on;
draw_environment(env);
plot(pts(1,:),pts(2,:),'.');
plot(path(1,:),path(2,:),'g.-');
%plot(path2(1,:),path2(2,:),'y.-');

