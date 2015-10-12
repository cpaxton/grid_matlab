function bmm = BernoulliEM(input,K,p,prior)
% function to perform EM to find latent clusters responsible for random
% variables
% tons of thanks to this: http://blog.zabarauskas.com/expectation-maximization-tutorial/

len = size(input, 1);
D = size(input,2); % number of variables

if nargin < 3
    p = rand(D, K);
    
    prior = rand(1,K);
    prior = prior / sum(prior);
    
    for i=1:D
        p(i,:) = p(i,:) / sum(p(i,:));
    end
end
    
for iter=1:100
%     p_inv = ones(D, K) - p;
%     
%     z = zeros(len,K);
%     
%     %% Expectation step
%     % compute expected values for each one
%     for k=1:K
%         p_tmp = repmat(p(:,k)',len, 1);
%         p_inv_tmp = repmat(p_inv(:,k)',len, 1);
%         
%         tmp = zeros(len, D);
%         tmp(input==1) = p_tmp(input==1);
%         tmp(input==0) = p_inv_tmp(input==0);
%         
%         z(:,k) = prior(k) * prod(tmp')';
%     end
%   
%     Z = sum(z,2);
%     z = z ./ Z(:,ones(K,1));
%     
%     %% Maximization step
%     % compute updates to mixing parameters and priors
%     num = sum(z,1);
%     
%     prior = num / len;
%     
%     % compute the new mixing parameters p
%     for k=1:K 
%         xk_bar = sum(input .* repmat(z(:,k),1,D),1) / num(k);
%         p(:,k) = xk_bar';
%     end
    [p,prior] = bmm_em_step(input,K,p,prior);
end

bmm = struct('coef',p,'prior',prior,'k',K);

end