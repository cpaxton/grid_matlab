function x = uniform_sample(mu,sigma,num)
    dims = length(mu);
    x = repmat(mu - diag(sigma),1,num) + (2 * repmat(diag(sigma),1,num) .* rand(dims,num));
end