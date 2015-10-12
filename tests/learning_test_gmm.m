
%% load data
% test_needle;
use_pca = 1;
use_dxdy = 0;
use_loglik = 1;

%% do bmm clustering
% learning_test_bmm;
% load('clusters_01_04.mat')

%% Put features and outputs from each of the different

if use_pca
    [pca_features, preprocessor] = apply_pca_to_data(features);
    [trainingData, points] = create_training_data(predicates,pca_features,trials,bmm,use_dxdy);
else
    [trainingData, points] = create_training_data(predicates,features,trials,bmm,use_dxdy);
end

models = cell(4,1);

%% Learn Gaussian Mixture Models
for i=1:bmm.k
    
    max_clusters = min(size(trainingData{i},2), 10);
    
    tmp_models = cell(max_clusters,1);

    best_ab = Inf;
    best_num = 0;
    
    for j=2:max_clusters
        
        fprintf('Task element %d, GMM iteration %d...\n',i,j);
        
        if ~use_pca
            [zdata, zmu, zsigma] = zscore(trainingData{i}');
            [Priors, Mu, Sigma] = EM_init_kmeans(zdata', j);
            [Priors, Mu, Sigma] = EM(zdata', Priors, Mu, Sigma);
            
            tmp_model = struct('priors',Priors,'mu',Mu,'sigma',Sigma,...
                'mean',zmu,'stdev',zsigma);
            
            ll = gmmLogLikelihood(zdata',tmp_model,j);
        else
            [Priors, Mu, Sigma] = EM_init_kmeans(trainingData{i}, j);
            [Priors, Mu, Sigma] = EM(trainingData{i}, Priors, Mu, Sigma);
            
            tmp_model = struct('priors',Priors,'mu',Mu,'sigma',Sigma);
            
            ll = gmmLogLikelihood(trainingData{i},tmp_model,j);
        end
        
        fprintf(' - log likelihod = %f\n',ll);
        
        D = size(tmp_model.mu,1);
        free_params = (length(tmp_model.priors) - 1) + ...
            (j*D) + ...
            (j * (0.5*D*(D+1)));
        
        fprintf(' - num free params = %d\n',free_params);
        fprintf(' - num training examples = %d\n', size(trainingData{i},2));
        
        [a, b] = aicbic(ll,free_params,size(trainingData{i},2));
        if use_loglik && -1*ll < best_ab
            best_ab = -1*ll;
            best_model = tmp_model;
            best_num = j;
        elseif a < best_ab
            best_ab = a;
            best_model = tmp_model;
            best_num = j;
        end
        
    end
    fprintf('Best model used %d clusters\n',best_num);
    models{i} = best_model;
    
end

%% show the results

tenvs = envs;
%tenvs{2}.gates{1} = move_gate(40,50,tenvs{2}.gates{1});
figure(4); clf;
%NUM=2;
for NUM=1:6
    
    x = 115;
    y = 980;
    t = 200;
    w = 0;
    
    action = zeros(2,1);
    ArtTraj = [];
    labels = [];
    for i=1:500
        if i == 1
            [F,P, state] = get_features_for_point(x,y,w,t,0,tenvs{NUM});
        else
            [F,P, state] = get_features_for_point(x,y,w,t,movement,tenvs{NUM},state);
        end
        len = size(F) + 2; % compute the total number of features we care about
        label = BernoulliAssign(bmm,P');
        if use_pca
            newF = apply_preprocessor(F,preprocessor);
        else
            newF = model_normalize(F',3:len,models{label})';
        end
        step = GMR(models{label}.priors,models{label}.mu,models{label}.sigma,newF,3:len,1:2);
        if ~use_pca
            movement = (step(1) * models{label}.stdev(1)) + models{label}.mean(1);
            rotation = (step(2) * models{label}.stdev(2)) + models{label}.mean(2);
        else
            movement = step(1);
            rotation = step(2);
        end
        
        ArtTraj = [ArtTraj [x y w movement rotation]'];
        if ~use_dxdy
            [x, y, w] = needle_update(x,y,w,movement,rotation,tenvs{NUM});
        else
            x = x + movement;
            y = y + rotation;
        end
        
        labels = [labels label];
        
        if(x > envs{NUM}.width + 100)
            break
        end
    end
    
    if use_dxdy
        colors = {'r.', 'g.', 'b.', 'y.', 'm.', 'c.'};
    else
        colors = ['r' 'g' 'b' 'y' 'm' 'c'];
    end
    subplot(2,3,NUM); hold on;
    draw_environment(tenvs{NUM});
    for k = 1:bmm.k
        traj = ArtTraj(:,labels==k);
        Au = cos(traj(3,:));
        Av = sin(traj(3,:));
        if use_dxdy
            plot(traj(1,:), traj(2,:), colors{k});
        else
            quiver(traj(1,:), traj(2,:), Au, Av, 'color', colors(k));
        end
    end
end