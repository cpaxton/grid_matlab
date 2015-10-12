function [ T0, T, E ] = estimate_transition_emission( bmm, seq, use_ab )
%ESTIMATE_TRANSMISSION_EMISSION estimates the settings for an hmm
%   This should be based on a BMM and predicates

if nargin < 3
    use_ab = false;
end

%% number of dimensions (random variables/predicates)
D = size(bmm.coef,1);

%% create variables to track data and compute MLE estimates
transition_counts = zeros(bmm.k, bmm.k);
state_counts = zeros(bmm.k,1);
full_state_counts = zeros(1,bmm.k);
p_counts = zeros(D,bmm.k);
first = zeros(bmm.k,1);

%% iterate over data
for i=1:length(seq)
    if ~use_ab
        labels = BernoulliAssign(bmm,seq{i}');
    else
        prob = bmm.A{i} .* bmm.B{i};
        prob = (prob ./ repmat(sum(bmm.A{i} .* bmm.B{i},2),1,bmm.k))';
        [~,labels] = max(prob);
    end
    
    for k=1:bmm.k
        p_counts(:,k) = p_counts(:,k) + sum(seq{i}(:,labels==k),2);
        full_state_counts(k) = full_state_counts(k) + sum(labels==k);
    end
    
    first(labels(1)) = first(labels(1)) + 1;
    
    for idx=2:length(labels)
        s0 = labels(idx-1);
        s1 = labels(idx);
        transition_counts(s0,s1) = transition_counts(s0,s1) + 1;
        state_counts(s0) = state_counts(s0) + 1;
    end
end

T0 = first / sum(first);
T = transition_counts ./ repmat(state_counts, 1, bmm.k);
E = p_counts ./ repmat(full_state_counts,D,1);

end

