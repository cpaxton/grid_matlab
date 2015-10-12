%% set up experiments
SKIP_FORWARD_BACKWARD = true;

%% load needle data
% test_needle;

D = size(predicates{1}{1},1);
K = 6;
p = zeros(D, K);
prior = zeros(1,K);

input = [];
for i=1:6
    for j=1:length(predicates{i})
        input = [input predicates{i}{j}];
        goals = next_goal(trials{i}{j},envs{i});
        
        for ii=1:size(predicates{i}{j},2)
            if trials{i}{j}.x(ii) >= envs{i}.width
                % class 6
                p(:,6) = p(:,6) + predicates{i}{j}(:,ii);
                prior(6) = prior(6) + 1;
            elseif goals(ii) > length(envs{i}.gates) && ~in_gates(trials{i}{j}.x(ii),trials{i}{j}.y(ii),envs{i}.gates)
                % class 1
                p(:,1) = p(:,1) + predicates{i}{j}(:,ii);
                prior(1) = prior(1) + 1;
            %elseif trials{i}{j}.x(ii) > envs{i}.width
            %    p(:,6) = p(:,1) + predicates{i}{j}(:,ii);
            %    prior(6) = prior(6) + 1;
            elseif goals(ii) > length(envs{i}.gates)
                % class 5
                p(:,5) = p(:,5) + predicates{i}{j}(:,ii);
                prior(5) = prior(5) + 1;
            elseif in_gates(trials{i}{j}.x(ii),trials{i}{j}.y(ii),envs{i}.gates);
                p(:,2) = p(:,2) + predicates{i}{j}(:,ii);
                prior(2) = prior(2) + 1;
            elseif goals(ii) <= length(envs{i}.gates) && goals(ii) > 1
                p(:,3) = p(:,3) + predicates{i}{j}(:,ii);
                prior(3) = prior(3) + 1;
            else
                p(:,4) = p(:,4) + predicates{i}{j}(:,ii);
                prior(4) = prior(4) + 1;
            end
        end
    end
end

p = p ./ repmat(prior,D,1);
prior = prior / sum(prior);

bmm = BernoulliEM(input',K,p,prior);

%% draw the assignments for different trials

figure(2); clf;
for i=1:6
    subplot(2,3,i);
    draw_environment(envs{i});
    for j=1:length(predicates{i})
        labels = BernoulliAssign(bmm,predicates{i}{j}');
        for k=1:bmm.k
            % plot trials of each color
            x = trials{i}{j}.x(:,labels==k);
            y = trials{i}{j}.y(:,labels==k);
            w = trials{i}{j}.w(:,labels==k);
            u = cos(w);
            v = sin(w);
            %quiver(x, y, u, v, 'color', colors(k));
            plot(x,y,'.','color', colors(k));
        end
    end
end

if ~SKIP_FORWARD_BACKWARD
    %% estimate HMM transition and emission probabilities
    % these are maximum likelihood estimates (supposedly)
    
    seq = {};
    for i=1:6
        seq = {seq{:} predicates{i}{:}};
    end
    
    [T0,T,E] = estimate_transition_emission(bmm,seq);
    bmm.coef = E;
    
    % we then need to do HMM training
    [A, B] = hmm_fb(T0,T,seq,bmm);
    bmm.A = A;
    bmm.B = B;
    
    [T0,T,E] = estimate_transition_emission(bmm,seq,true);
    bmm.coef = E;
    bmm.T = T;
    bmm.T0 = T0;
    
    %% hold out!
    if HOLD_OUT
        bmm2 = bmm;
        seq = {};
        for i=1:6
            seq = {seq{:} test_predicates{i}{:}};
        end
        [A, B] = hmm_fb(T0,T,seq,bmm2);
        bmm2.A = A;
        bmm2.B = B;
    end
end

%% show results after running HMM
show_original_bmm;