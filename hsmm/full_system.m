%clear all; clc; fclose all;

%init; % loads trials and environments
max_actions=3;
x0 = [190,1000,0,0,0]'; % initial position
% nstates=5;

for i=1:1
    
    fprintf(1,'Iteration %d\n',i);
    fprintf(1,'Imputation \n');
    tic;
    if(i==1) %% Human Training Data
        load('chris workspace 1 iter.mat')
        f=feature_compute_imp(trials,envs); % ppca
        % handle missing data
        f=proc_cell_feat(f);
        raw=flatten_trials(trials);
        % f=cell2mat(f); f=f';
        f(f==0)=nan;
        fprintf ('ppca... ')
        %[coef,score,latent,mu,v,S] = ppca(f,4);
        fprintf ('done.\n')
        w=S.W;
        %f=S.Recon;
        f = score;
        f=f';%f=cellwrap(f);
    else
        f=feature_compute_imp(traj,envs);
        f=proc_cell_feat(f);
        mu=mean(f);
        f1=f-repmat(mu,size(f,1),1);
        f1=f1*w*(w'*w+v*eye(size(w'*w)));
        f1=w*f1+mu;
        ind=find(f==0);
        f(ind)=f1(ind); f=f'; clear f1;
    end
    toc;
    fprintf(1,'Segmentation\n');
    tic;
    %% Segmentation using HSMM
    if(i==1)
        %load('labels');
        labels = get_labels(bmm,predicates,4);
        %for j = 1:4
        %    tmp = labels{j}{1};
        %    labels{j} = cell(1);
        %    labels{j}{1} = tmp;
        %end
        [actions,model,new_labels]=segment_hsmm(f,labels,max_actions);
    else
        labels=cellwrap(labels);
        [actions,model,new_labels]=segment_hsmm(f,labels,max_actions);
    end
    toc;
    fprintf(1,'Press any key to continue \n');
    pause;
    models=cell(1,max_actions);
    
    fprintf(1,'Learning actions (GMMs)\n');
    tic;
    %% Learn model for each GMM
    for j=1:length(models)
        models{j}=gmmemtrain(actions{j},2,60);
    end
    
    for j = 1:max_actions
       idx = find(new_labels==j);
       models{j}.movement_mean = mean(raw(4,idx));
       models{j}.rotation_mean = mean(raw(5,idx));
       models{j}.movement_dev = std(raw(4,idx));
       models{j}.rotation_dev = std(raw(5,idx));
       models{j}.nbStates = size(model.Sigma,3);
    end
    
    toc;
    fprintf(1,'Press any key to continue \n');
    pause;
    fprintf(1,'Planning\n');
    tic;
    %%   PLANNING part
    T=model.Trans; T0=model.StatesPriors;
    [~,traj,labels]=prob_plan_for_environment_hsmm(x0,envs{1},models,T,T0,max_actions);
    toc;
end