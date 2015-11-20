function [ alpha ] = hmm_forward( x, hmm )
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
alpha = zeros(len,hmm.nclasses);


%% first step
for i = 1:hmm.nclasses
    %alpha(1,i) = log(hmm.T0(i)) + unary({x{1,:}},hmm.s(i,:),{hmm.models{i,:}});
    alpha(1,i) = (hmm.T0(i)) * unary({x{1,:}},hmm.s(i,:),{hmm.models{i,:}});
end

%% loop over the rest of the variables
for t = 2:len
    for i = 1:hmm.nclasses
        for ii = 1:hmm.nclasses
            %ptrans_yi_yii = log(hmm.T(i,ii));
            ptrans_yi_yii = hmm.T(i,ii);
            pyii = unary({x{t,:}},hmm.s(ii,:),{hmm.models{ii,:}});
            pyi = alpha(t-1,i);
            alpha(t,ii) = alpha(t,ii) + (ptrans_yi_yii *  pyii * pyi);
        end
    end
end

