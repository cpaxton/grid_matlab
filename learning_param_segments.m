%% settings
use_pca = false;
use_loglik = true;
use_kmeans = true;
use_coordinates = true;
use_dtw = false;
DEMO_LEN = 50;
MIN_CLUSTERS = 2;
MAX_CLUSTERS = 2;
PGMM_CLUSTERS = 5;
USE_EFFORT = false;
USE_XY = false;
USE_DIFF = false;
SHOW_SEGMENTS_EXAMPLE = true;
SHOW_SEGMENTS_GATES = true;
SHOW_GATE_POINTS = true;
SHOW_DATA_LOGLIKELIHOOD = false;
SKIP_IMG = false;
%DELETE_MOVEMENT_ROTATION = true;
NFIG = 1;
NDIM = 7;
NGATE_FEATURES = 6; %7;
NEXIT_FEATURES = 2; %3;
MARGIN = 0;
HOLD_OUT = true;

%% initialize random number generator
rng('default')

%% create individual segments
ap = create_segments(bmm, trials, envs, features, predicates, MARGIN);
if HOLD_OUT
    apt = create_segments(bmm, test_trials, envs, test_features, test_predicates, MARGIN);
end
if SHOW_SEGMENTS_EXAMPLE
    draw_registered_action_primitives(bmm,ap)
end

if use_pca
    fprintf('PCA not yet implemented!\n');
end

% create list of models
models = cell(bmm.k,1);
models = analyze_primitives(ap,models);

%% loop over the different actions
% create a model for each one
for k=1:bmm.k
    %% which environmental features are important for this action?
    use_gate = true;
    use_prev_gate = true;
    use_exit = true;
    %next_in = 7;
    in = 1;
    in_na = 1;
    next_in = 2;
    if USE_XY
        in = [in next_in:next_in+2];
        in_na = [in_na next_in:next_in+1];
        next_in = next_in+3;
    end
    if USE_EFFORT
        in = [in next_in:next_in+1];
        next_in = next_in+2;
    end
    for i = 1:length(ap{k})
        use_gate = use_gate && ap{k}(i).has_gate;
        use_prev_gate = use_prev_gate && ap{k}(i).has_prev_gate;
        use_exit = use_exit && ap{k}(i).use_exit;
    end
    
    if use_gate
        fprintf('1) Action primitive %d always relates to a gate.\n',k);
        in = [in next_in:(next_in+NGATE_FEATURES-1)];
        in_na = [in_na next_in:(next_in+NGATE_FEATURES-3)];
        next_in = max(in) + 1;
    else
        fprintf('1) Action primitive %d does not need a gate.\n',k);
    end
    
    if use_prev_gate
        fprintf('2) Action primitive %d always relates to a previous gate.\n',k);
        in = [in next_in:(next_in+NGATE_FEATURES-1)];
        in_na = [in_na next_in:(next_in+NGATE_FEATURES-3)];
        next_in = max(in) + 1;
    else
        fprintf('2) Action primitive %d does not need a previous gate.\n',k);
    end
    
    if use_exit
        fprintf('3) Action primitive %d always relates to the level exit.\n',k);
        in = [in next_in:(next_in+NEXIT_FEATURES-1)];
        in_na = [in_na next_in:(next_in+NEXIT_FEATURES-3)];
        next_in = max(in) + 1;
    else
        fprintf('3) Action primitive %d does not need the level exit.\n',k);
    end
    
    % set up for tp-gmm model
    %models{k}.nbVar = NDIM;
    %models{k}.nbFrames = 1 + use_gate + use_prev_gate;
    models{k}.nbStates = PGMM_CLUSTERS;
    models{k}.color = gmmColors(:,k)';
    models{k}.marker = markers(k);
    models{k}.use_gate = use_gate;
    models{k}.use_prev_gate = use_prev_gate;
    models{k}.use_exit = use_exit;
    models{k}.use_effort = USE_EFFORT;
    models{k}.use_xy = USE_XY;
    models{k}.use_diff = USE_DIFF;
    models{k}.in = in;
    models{k}.in_na = in_na;
    % set of indices for features that don't use effort/angles starting at
    % the first "feature", i.e. not configuration. So we need to start
    % counting at 3 when including effort features.
    
    if USE_EFFORT
        %models{k}.in_naf = in_na(4:end) - min(in_na(4:end)) + 3;
        models{k}.in_naf = in_na(2:end) - 1;
    else
        %models{k}.in_naf = in_na(4:end) - min(in_na(4:end)) + 1;
        models{k}.in_naf = in_na(2:end) - 1;
    end
    models{k}.nbVar = max(in);
    models{k}.nbOut = 2;
    
    if use_dtw
        ap{k} = do_dtw(ap{k},models{k});
    end
    
    if USE_DIFF
        models{k}.in = [models{k}.in (models{k}.in(2:end)+next_in-2)];
        %models{k}.in_na = [models{k}.in_na (models{k}.in_na(2:end)+next_in-2)];
        %models{k}.in_naf = [models{k}.in_naf (models{k}.in_naf+next_in-2)];
    end
    
    lens = zeros(length(ap{k}),1);
    for i = 1:length(ap{k})
        lens(i) = ap{k}(i).end - ap{k}(i).start; %size(ap{k}(i).data,2);
    end
    
    models{k}.steps = round(mean(lens));
    
    %% start by exploring what the gates look like
    if use_gate && SHOW_SEGMENTS_GATES && SHOW_GATE_POINTS && k==1
        figure(NFIG);clf;
        for i = 1:min(16,length(ap{k}))
            subplot(4,4,i); hold on;
            draw_gates({ap{k}(i).gate});
            plot(ap{k}(i).gate.corners(1,1),ap{k}(i).gate.corners(2,1),'+');
            plot(ap{k}(i).gate.corners(1,2),ap{k}(i).gate.corners(2,2),'*');
            plot(ap{k}(i).gate.corners(1,3),ap{k}(i).gate.corners(2,3),'o');
            draw_segments(ap{k}(i),NFIG);
        end
        NFIG = NFIG + 1;
    end
    
    %% FEATURES: GATE CORNERS
    % ---------------------------------------------------------------------
    
    %if k ~= 4
    %   continue
    %end
    
    %% learning
    trainingData = create_primitive_training_data(models{k},ap{k});
    if HOLD_OUT
        testData = create_primitive_training_data(models{k},apt{k});
    end
    
    max_clusters = min(size(trainingData,2), MAX_CLUSTERS);
    
    best_ab = Inf;
    best_num = 0;
    
    if any(isnan(trainingData(1,:)))
        isnan(trainingData(1,:))
        
        fprintf('ERROR: invalid training data!\n');
        pause;
        break;
    end
    
    for j=MIN_CLUSTERS:max_clusters
        
        fprintf('Task element %d, GMM iteration %d...\n',k,j);
        
        if ~use_pca
            
            if use_kmeans
                [Priors, Mu, Sigma] = EM_init_kmeans(trainingData, j);
            else
                [Priors, Mu, Sigma] = EM_init_time(trainingData, j);
            end
            
            [Priors, Mu, Sigma] = EM(trainingData, Priors, Mu, Sigma);
            
            tmp_model = struct('priors',Priors,'mu',Mu,'sigma',Sigma);
            
            ll = gmmLogLikelihood(trainingData,tmp_model,j);
        else
            [Priors, Mu, Sigma] = EM_init_kmeans(trainingData, j);
            [Priors, Mu, Sigma] = EM(trainingData, Priors, Mu, Sigma);
            
            tmp_model = struct('priors',Priors,'mu',Mu,'sigma',Sigma);
            
            ll = gmmLogLikelihood(trainingData,tmp_model,j);
        end
        
        fprintf(' - log likelihood = %f\n',ll);
        
        D = size(tmp_model.mu,1);
        free_params = (length(tmp_model.priors) - 1) + ...
            (j*D) + ...
            (j * (0.5*D*(D+1)));
        
        fprintf(' - num free params = %d\n',free_params);
        fprintf(' - num training examples = %d\n', size(trainingData,2));
        
        [a, b] = aicbic(ll,free_params,size(trainingData,2));
        fprintf(' - aic = %f\n', a);
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
    models{k}.nbStates = best_num;
    models{k}.Mu = best_model.mu;
    models{k}.Sigma = best_model.sigma;
    models{k}.Priors = best_model.priors;
    models{k}.out = 5:6;
    for j=1:models{k}.nbStates
        models{k}.inInvSigmaNT(:,:,j) = inv(models{k}.Sigma(models{k}.in(2:end),models{k}.in(2:end),j));
    end
    
    for j=1:best_num
        %models{k}.invSigma(:,:,j) = inv(best_model.sigma(:,:,j));
        models{k}.inInvSigma(:,:,j) = inv(best_model.sigma(models{k}.in,models{k}.in,j));
    end
    
    [img, expath] = show_pca_results(ap,models,k,SKIP_IMG);
    
    if HOLD_OUT && SHOW_DATA_LOGLIKELIHOOD
        test_ll = compute_loglik(testData(models{k}.in,:),models{k}.Mu,models{k}.Sigma,models{k},models{k}.in);
        train_ll = compute_loglik(trainingData(models{k}.in,:),models{k}.Mu,models{k}.Sigma,models{k},models{k}.in);
        figure();hold on;
        scatter(testData(1,:),test_ll);
        scatter(trainingData(1,:),train_ll);
    end
end
