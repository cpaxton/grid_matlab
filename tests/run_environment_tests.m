
NENV = 3;
%% test learned model on environment 1

%pt = [115;980;0];
pt = [269.0530;924.3133;0];

% first step
conf = [];
conf.gate = 1;
conf.k = 4;
% show_loglikelihood(models{4},pt,envs{NENV},conf);
[path1,~] = eval_model(models{4}, pt, envs{NENV},conf);
pt = path1(1:3,end);

% third step
conf = [];
conf.prev_gate = 1;
conf.k = 1;
[path3,~] = eval_model(models{1}, pt, envs{NENV}, conf);
pt = path3(1:3,end);

%[~,p] = get_features_for_point(pt(1),pt(2),pt(3),0,0,envs{2});
%BernoulliAssign(bmm,p')

figure(1);clf;
draw_environment(envs{NENV});
draw_trajectory(path1,models{4}.color);
%draw_trajectory(path2,models{2}.color);
draw_trajectory(path3,models{1}.color);

%% test learned model on environment 2

pt = [115;980;0];
%pt = [172.8375;962.2352;-0.0496];

% first step
conf = [];
conf.gate = 1;
conf.k = 4;
%show_loglikelihood(models{4},pt,envs{NENV+1},conf);
[path1,~] = eval_model(models{4},pt,envs{NENV+1},conf);
pt = path1(1:3,end);
%path1b = eval_model(models{4},pt,envs{NENV+1},conf);
%pt = path1b(1:3,end);

% second step
conf = [];
conf.gate = 2;
conf.prev_gate = 1;
conf.k = 2;
[path2,~] = eval_model(models{2}, pt, envs{NENV+1}, conf);
pt = path2(1:3,end);

% third step
conf = [];
conf.gate = 2;
conf.prev_gate = 1;
conf.k = 3;
[path3,~] = eval_model(models{3}, pt, envs{NENV+1}, conf);
pt = path3(1:3,end);

% fourth step
conf = [];
conf.gate = 3;
conf.prev_gate = 2;
conf.k = 1;
[path4,~] = eval_model(models{1}, pt, envs{NENV+1}, conf);
pt = path4(1:3,end);


% [~,p] = get_features_for_point(pt(1),pt(2),pt(3),0,0,envs{2});
% BernoulliAssign(bmm,p')
% 
figure(2);clf;
draw_environment(envs{NENV+1});
draw_trajectory(path1,models{4}.color);
%draw_trajectory(path1b,models{4}.color);
draw_trajectory(path2,models{2}.color);
draw_trajectory(path3,models{3}.color);
draw_trajectory(path4,models{1}.color);
% 
% 


%% test learned model on environment 3

%pt = [115;980;0];
pt = [172.8375;962.2352;-0.0496];

% first step
conf = [];
conf.gate = 1;
show_loglikelihood(models{4},pt,envs{NENV+2},conf);
path1 = eval_model(models{4},pt,envs{NENV+2},conf);
pt = path1(1:3,end);
%path1b = eval_model(models{4},pt,envs{NENV+1},conf);
%pt = path1b(1:3,end);

% second step
conf = [];
conf.gate = 2;
conf.prev_gate = 1;
path2 = eval_model(models{2}, pt, envs{NENV+2}, conf);
pt = path2(1:3,end);

% third step
conf = [];
conf.gate = 2;
conf.prev_gate = 1;
path3 = eval_model(models{3}, pt, envs{NENV+2}, conf);
pt = path3(1:3,end);

% fourth step
conf = [];
conf.gate = 3;
conf.prev_gate = 2;
path4 = eval_model(models{1}, pt, envs{NENV+2}, conf);
pt = path4(1:3,end);


% [~,p] = get_features_for_point(pt(1),pt(2),pt(3),0,0,envs{2});
% BernoulliAssign(bmm,p')
% 
figure(3);clf;
draw_environment(envs{NENV+2});
draw_trajectory(path1,models{4}.color);
%draw_trajectory(path1b,models{4}.color);
draw_trajectory(path2,models{2}.color);
draw_trajectory(path3,models{3}.color);
draw_trajectory(path4,models{1}.color);