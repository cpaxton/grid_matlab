%% create
ex = [];
idx = [];
for i = 1:1%length(trials{2})
    ex = [ex [ap{4}(i).originalData; ones(1,length(ap{4}(i).t))*length(ap{4}(i).t)/5]];
    idx = [idx ap{4}(i).t / 1000];
end

mu = zeros(3,5);
sigma = zeros(3,3,5);
for j=1:5
    first = ex(4:6,and(idx <= 0.2*j, idx > 0.2*(j-1)))';
    mu(:,j) = mean(first)';
    sigma(:,:,j) = (cov((first))) + 0.0001*eye(3);
end

%% set up gate for features
gate = envs{2}.gates{1};
corners = rotate_trajectory([gate.corners;zeros(1,4)],-gate.w);
gate.width=1;%(max(corners(1,:)) - min(corners(1,:)))*0.5;
gate.height=1;%(max(corners(2,:)) - min(corners(2,:)))*0.5;
%% sample and show learning
NUM_SAMPLES = 500;
NUM_ELITE = 3;

Zs = zeros(3,NUM_SAMPLES,5);
ends = zeros(3, NUM_SAMPLES);

figure(1); clf;
local_env = [];
local_env.gate = envs{2}.gates{1};
for iter=1:4
    
    fprintf('Iteration %d\n',iter);
    
    subplot(2,2,iter); hold on;
    draw_environment(envs{2});
    
    gen_x = [];
    
    for i=1:NUM_SAMPLES
        origin = ex(1:3,1) + [normrnd(0,10);normrnd(0,10);0];
        path = [];
        for j = 1:5
            Z = mu(:,j) + chol(sigma(:,:,j))'*[normrnd(0,1);normrnd(0,1);0];%normrnd(0,1)];
            x = sample_primitive(origin,Z(2),Z(1),Z(3));
            path = [path x];
            origin = x(:,end);
            Zs(:,i,j) = Z;
        end
        ends(:,i) = path(:,end);
        gen_x = [gen_x; path'];
        plot(path(1,:),path(2,:),'r');
    end
    exp_x = [];
    exp_y = [];
    for i=1:length(trials{2})
        plot(ap{4}(i).originalData(1,:),ap{4}(i).originalData(2,:),'b');
        exp_x = [exp_x; project_to_frame(ap{4}(i).originalData(1:3,:),gate)'];
        exp_y = [exp_y; ones(size(ap{4}(i).t))'];
    end
    
    %gen_x = [ones(size(ends,2),1) project_to_frame(ends,gate)'];
    %gen_y = -1 * ones(size(ends,2),1);
    gen_y = -1 * ones(size(gen_x,1),1);
    
    %sidx = randperm(size(gen_y,1));
    %gen_x = gen_x(sidx(1:100),:);
    %gen_y = gen_y(sidx(1:100),:);
    
    X = [gen_x; exp_x];
    Y = [gen_y; exp_y];
    
    tmp = ends - repmat(ap{4}(1).originalData(1:3,end),1,NUM_SAMPLES);
    dists = sum(tmp.*tmp);
    %svm = fitcsvm(X,Y,'KernelFunction','linear');
    %[~,s] = predict(svm,X);
    %dists = s(1:length(gen_y),1);
    
    [~,sorted_idx] = sort(dists);
    plot(ends(1,sorted_idx(1:10)),ends(2,sorted_idx(1:10)),'g*');
    
    % fit gaussians again
    for j=1:5
        mu(:,j) = mean(Zs(:,sorted_idx(1:NUM_ELITE),j),2);
        %sigma(:,:,j) = (cov(Zs(:,sorted_idx(1:NUM_ELITE),j)')) + 0.000001*eye(3);
        sigma(:,:,j) = (cov(Zs(:,sorted_idx(1:NUM_ELITE),j)')) + 0.00001*eye(3);
    end
end

%% optimization to fit trajectories
x0 = rand(6,1);
x0 = x0 / norm(x0);
A = diag(x0(1:3)); B = x0(4:6);
num_gen = size(gen_x,1);
num_exp = size(exp_x,1);

cost_for_gen = sum(gen_x * A .* gen_x,2) + (gen_x * B);

gradient_for_gen = sum((gen_x * A)  + repmat(B',num_gen,1),2);
gradient_for_exp = sum((exp_x * A)  + repmat(B',num_exp,1),2);

score_gen = mean(sum((gen_x * A)  + repmat(B',num_gen,1),2));
score_exp = mean(sum((exp_x * A)  + repmat(B',num_exp,1),2));

search_score = score_gen - score_exp;

obj = @(x) mean(sum((gen_x * diag(x(1:3)))  + repmat(x(4:6)',num_gen,1),2)) ...
    - mean(sum((exp_x * diag(x(1:3)))  + repmat(x(4:6)',num_exp,1),2));

x = fmincon(obj,x0,[],[],[],[],-1*ones(6,1),ones(6,1));
%fminsearch(obj,x0);

A = diag(x(1:3)); B = x(4:6);
num_gen = size(gen_x,1);
num_exp = size(exp_x,1);

cost_for_gen = sum(gen_x * A .* gen_x,2) + (gen_x * B);
cost_for_exp = sum(exp_x * A .* exp_x,2) + (exp_x * B);

gradient_for_gen = sum((gen_x * A)  + repmat(B',num_gen,1),2);
gradient_for_exp = sum((exp_x * A)  + repmat(B',num_exp,1),2);

% print output of found cost function
score_gen = mean(sum((gen_x * A)  + repmat(B',num_gen,1),2))
score_exp = mean(sum((exp_x * A)  + repmat(B',num_exp,1),2))

search_score = score_gen - score_exp
mean(cost_for_gen)
mean(cost_for_exp)

%% sample and show learning
NUM_SAMPLES = 250;
NUM_ELITE = 3;

Zs = zeros(3,NUM_SAMPLES,5);
ends = zeros(3, NUM_SAMPLES);

figure(2); clf;
local_env = [];
local_env.gate = envs{2}.gates{1};


mu = zeros(3,5);
sigma = zeros(3,3,5);
for j=1:5
    first = ex(4:6,and(idx <= 0.2*j, idx > 0.2*(j-1)))';
    mu(:,j) = mean(first)';
    sigma(:,:,j) = (cov((first))) + 0.0001*eye(3);
end


for iter=1:16
    
    fprintf('Iteration %d\n',iter);
    
    subplot(4,4,iter); hold on;
    draw_environment(envs{2});
    
    gen_x = [];
    
    for i=1:NUM_SAMPLES
        origin = ex(1:3,1) + [normrnd(0,10);normrnd(0,10);0];
        path = [];
        for j = 1:5
            Z = mu(:,j) + chol(sigma(:,:,j))'*[normrnd(0,1);normrnd(0,1);0];%normrnd(0,1)];
            x = sample_primitive(origin,Z(2),Z(1),Z(3));
            path = [path x];
            origin = x(:,end);
            Zs(:,i,j) = Z;
        end
        ends(:,i) = path(:,end);
        plot(path(1,:),path(2,:),'r');
    end
    exp_x = [];
    exp_y = [];
    for i=1:length(trials{2})
        plot(ap{4}(i).originalData(1,:),ap{4}(i).originalData(2,:),'b');
    end
    
    X = project_to_frame(path,gate)';
    dists = sum(X * A .* X,2) + (X * B);
    %tmp = ends - repmat(ap{4}(1).originalData(1:3,end),1,NUM_SAMPLES);
    %dists = sum(tmp.*tmp);
    
    [~,sorted_idx] = sort(dists);
    plot(ends(1,sorted_idx(1:10)),ends(2,sorted_idx(1:10)),'g*');
    
    % fit gaussians again
    for j=1:5
        mu(:,j) = mean(Zs(:,sorted_idx(1:NUM_ELITE),j),2);
        sigma(:,:,j) = (cov(Zs(:,sorted_idx(1:NUM_ELITE),j)')) + 0.0000001*eye(3);
    end
end

%% sample and show learning 2
NUM_SAMPLES = 250;
NUM_ELITE = 3;

Zs = zeros(3,NUM_SAMPLES,5);
ends = zeros(3, NUM_SAMPLES);

figure(3); clf;
local_env = [];
local_env.gate = envs{2}.gates{1};
gate = envs{3}.gates{1};
corners = rotate_trajectory([gate.corners;zeros(1,4)],-gate.w);
gate.width=1;%(max(corners(1,:)) - min(corners(1,:)))*0.5;
gate.height=1;%(max(corners(2,:)) - min(corners(2,:)))*0.5;


mu = zeros(3,5);
sigma = zeros(3,3,5);
for j=1:5
    first = ex(4:6,and(idx <= 0.2*j, idx > 0.2*(j-1)))';
    mu(:,j) = mean(first)';
    sigma(:,:,j) = (cov((first))) + 0.0001*eye(3);
end


for iter=1:16
    
    fprintf('Iteration %d\n',iter);
    
    subplot(4,4,iter); hold on;
    draw_environment(envs{3});
    
    gen_x = [];
    
    for i=1:NUM_SAMPLES
        origin = ex(1:3,1) + [normrnd(0,10);normrnd(0,10);0];
        path = [];
        for j = 1:5
            Z = mu(:,j) + chol(sigma(:,:,j))'*[normrnd(0,1);normrnd(0,1);0];%normrnd(0,1)];
            x = sample_primitive(origin,Z(2),Z(1),Z(3));
            path = [path x];
            origin = x(:,end);
            Zs(:,i,j) = Z;
        end
        ends(:,i) = path(:,end);
        plot(path(1,:),path(2,:),'r');
    end
    exp_x = [];
    exp_y = [];
    
    X = project_to_frame(path,gate)';
    dists = sum(X * A .* X,2) + (X * B);
    
    [~,sorted_idx] = sort(dists);
    plot(ends(1,sorted_idx(1:10)),ends(2,sorted_idx(1:10)),'g*');
    
    % fit gaussians again
    for j=1:5
        mu(:,j) = mean(Zs(:,sorted_idx(1:NUM_ELITE),j),2);
        sigma(:,:,j) = (cov(Zs(:,sorted_idx(1:NUM_ELITE),j)')) + 0.0000001*eye(3);
    end
end
