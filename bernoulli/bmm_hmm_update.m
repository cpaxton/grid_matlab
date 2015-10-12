function [p,prior] = bmm_hmm_update(input,prior_in,K,p,prior)

len = size(input, 1);
D = size(input,2); % number of variables

p_inv = ones(D, K) - p;

z = zeros(len,K);

%% Expectation step
% compute expected values for each one
for k=1:K
    p_tmp = repmat(p(:,k)',len, 1);
    p_inv_tmp = repmat(p_inv(:,k)',len, 1);
    
    tmp = zeros(len, D);
    prior = repmat(prior_in(:,k),1,D);
    tmp(input==1) = prior(input==1) .* p_tmp(input==1);
    tmp(input==0) = prior(input==0) .* p_inv_tmp(input==0);
    
    z(:,k) = prod(tmp')';
end

Z = sum(z,2);
z = z ./ Z(:,ones(K,1));

%% Maximization step
% compute updates to mixing parameters and priors
num = sum(z,1);

prior = num / len;

% compute the new mixing parameters p
for k=1:K
    xk_bar = sum(input .* repmat(z(:,k),1,D),1) / num(k);
    p(:,k) = xk_bar';
end

end