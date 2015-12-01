function [ beta ] = hmm_backward( x, hmm )
%UNTITLED5 Summary of this function goes here
%   x = data
%   s = sparsity terms
%   models = feature emission models
%   I = initial state probabilities
%   T = transition probabilities

% make sure models are set up correctly
assert(size(x,2) == size(hmm.models,2));

% make sure these are valid probabilities
for y = 1:hmm.nclasses
    assert(abs(sum(hmm.T(y,:)) - 1) < 0.00001);
end
assert(abs(sum(hmm.T0) - 1) < 0.00001);

%% initialize variables
len = size(x,1);
beta = zeros(len,hmm.nclasses);

%% first step
for i = 1:hmm.nclasses
    %alpha(1,i) = log(hmm.T0(i)) + unary({x{1,:}},hmm.s(i,:),{hmm.models{i,:}});
    beta(len,i) = 1;%(hmm.T0(i)) * unary({x{1,:}},hmm.s(i,:),{hmm.models{i,:}});
end

%% loop over the rest of the variables
for t = (len-1):-1:1
    for i = 1:hmm.nclasses
        for ii = 1:hmm.nclasses
            ptrans_yii_yi = hmm.T(ii,i);
            pyii = unary({x{t,:}},hmm.s(ii,:),{hmm.models{ii,:}});
            pyi = beta(t+1,i);
            beta(t,ii) = beta(t,ii) + (ptrans_yii_yi *  pyii * pyi);
        end
    end
end

