

seq = {};
for i=1:4
   seq = {seq{:} predicates{i}{:}};
end

[T0, T,E] = estimate_transition_emission(bmm,seq);

%bmm.coef = E;

% we then need to do HMM training
[A, B] = hmm_fb(T0,T,seq,bmm);

model = [];
samples = [];

%% Parameters
model.nbStates = 3; %Number of components in the model
model.nbFrames = 2; %Number of candidate frames of reference
model.nbVar = 3; %Dimension of the datapoints in the dataset (here: x1,x2)

nbSamples = length(trials{2}); %Number of samples in the MAT file

if model.nbStates==3
  colGMM = eye(3)*0.5+0.5;
else
  colGMM = rand(model.nbStates,3);
end

%% compute samples for pgmm
% frame0.b = [96; 972];
% frame0.A = [1 0; 0 1];
frame1.b = [envs{2}.gates{1}.x; envs{2}.gates{1}.y; envs{2}.gates{1}.w - pi];
frame1.A = [cos(envs{2}.gates{1}.w) cos(envs{2}.gates{1}.w + pi/2) 0; ...
            sin(envs{2}.gates{1}.w) sin(envs{2}.gates{1}.w + pi/2) 0; ...
            0 0 1];
        
% frame1.b = [envs{2}.gates{1}.x; envs{2}.gates{1}.y];
% frame1.A = [cos(envs{2}.gates{1}.w) cos(envs{2}.gates{1}.w + pi/2); ...
%             sin(envs{2}.gates{1}.w) sin(envs{2}.gates{1}.w + pi/2)];
% frame2.b = [envs{2}.width; envs{2}.height/2];
% frame2.A = [1 0; 0 1];

for i=1:nbSamples
    labels = BernoulliAssign(bmm,predicates{2}{i}');
    %samples(i).p;
    samples(i).Data = [trials{2}{i}.x(labels==1); trials{2}{i}.y(labels==1); trials{2}{i}.w(labels==1)];
    samples(i).nbData = size(samples(i).Data,2);
    
    % starting frame
    %frame0.b = [trials{2}{i}.x(1); trials{2}{i}.y(1); trials{2}{i}.w(1);];
    frame0.b = [96; 972; 0];
    frame0.A = [1 0 0; 0 1 0; 0 0 1];

%    frame0.A = [cos(trials{2}{i}.w(1) + pi) cos(trials{2}{i}.w(1) + 3*pi/2) 0; ...
%                sin(trials{2}{i}.w(1) + pi) sin(trials{2}{i}.w(1) + 3*pi/2) 0; ...
%                 0 0 1];
            
%     frame0.A = [cos(trials{2}{i}.w(1) + pi) cos(trials{2}{i}.w(1) + 3*pi/2); ...
%                 sin(trials{2}{i}.w(1) + pi) sin(trials{2}{i}.w(1) + 3*pi/2)];
    
    %ending frame
    %frame2.b = [trials{2}{i}.x(end); trials{2}{i}.y(end); trials{2}{i}.w(end)];
    %frame2.A = [cos(trials{2}{i}.w(end) + pi) cos(trials{2}{i}.w(end) + 3*pi/2) 0; ...
    %            sin(trials{2}{i}.w(end) + pi) sin(trials{2}{i}.w(end) + 3*pi/2) 0; ...
    %            0 0 1];
    
    samples(i).p = [frame0; frame1]; %frame2];
%     samples(i).p(2) = frame1;
%     samples(i).p(3) = frame2;
end

figure(1); 
subplot(1,2,1);
hold on;
draw_environment(envs{2});
for i=1:nbSamples
    for j=1:model.nbFrames
        draw2DArrow(samples(i).p(j).b(1:2), 100 * samples(i).p(j).A(1:2,1), [0.6 0.6 0.6]);
        draw2DArrow(samples(i).p(j).b(1:2), 100 * samples(i).p(j).A(1:2,2), [0.6 0.6 0.6]);
    end
    labels = BernoulliAssign(bmm,predicates{2}{i}');
    for k=1:bmm.k
        % plot trials of each color
        x = trials{2}{i}.x(:,labels==k);
        y = trials{2}{i}.y(:,labels==k);
        w = trials{2}{i}.w(:,labels==k);
        u = cos(w + pi);
        v = sin(w);
        quiver(x, y, u, v, 'color', colors(k));
    end
end

%% kmeans to initialize model
fprintf('Parameters estimation of proposed PGMM:');
model = init_proposedPGMM_kmeans(samples, model); %Initialization with k-means clustering
[~, model, LL] = EM_proposedPGMM(samples, model);
%Computation of the resulting Gaussians for each sample (for display purpose)
for n=1:nbSamples
  %Computes resulting Gaussians after projections and products of Gaussians estimation
  samples(n).prodRes = computeResultingGaussians(model, samples(n).p);
end

%% show the clusters you found
for n=1:nbSamples 
  for i=1:model.nbStates
    plotGMM(samples(n).prodRes(1).Mu(1:2,i), samples(n).prodRes(1).Sigma(1:2,1:2,i), colGMM(i,:), 1);  
  end
end

%% compute samples for pgmm regression
frame0.b = [26; 572; 0];
%frame0.A = [1 0 0; 0 1 0; 0 0 1];
%frame2.b = [envs{2}.width; envs{2}.height/2; 0];
%frame2.A = [1 0 0; 0 1 0; 0 1 0];
% frame0.b = [96; 972];
% frame0.A = [1 0; 0 1];
testp = [frame0; frame1]; %frame2];
testres = computeResultingGaussians(model, testp);

subplot(1,2,2);
draw_environment(envs{2});
for j=1:model.nbFrames
    draw2DArrow(testp(j).b(1:2), 100 * testp(j).A(1:2,1), [0.6 0.6 0.6]);
    draw2DArrow(testp(j).b(1:2), 100 * testp(j).A(1:2,2), [0.6 0.6 0.6]);
end
for i=1:model.nbStates
    plotGMM(testres.Mu(1:2,i), testres.Sigma(1:2,1:2,i), colGMM(i,:), 1);
end