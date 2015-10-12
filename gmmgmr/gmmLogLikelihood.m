function loglik = gmmLogLikelihood( Data, model, k )
%gmmLogLikelihood -- compute log likelihood of a model
%   Detailed explanation goes here

for i=1:k
    %Compute probability p(x|i)
    Pxi(:,i) = gaussPDF(Data, model.mu(:,i), model.sigma(:,:,i));
end

F = Pxi*model.priors';
F(F<realmin) = realmin;
loglik = mean(log(F));

end

