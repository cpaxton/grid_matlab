function x = mvnsample(mu,sigma,num)
    dims = length(mu);
    x = repmat(mu,1,num) + (chol(sigma)' * normrnd(0,1,dims,num));
end