function loglik = gmmLogLikelihood( Data, model, k )
%gmmLogLikelihood -- compute log likelihood of a model
%   Detailed explanation goes here

if k==1
    F = gaussPDF(Data, model.mu, model.sigma);
else
    for i=1:k
        %Compute probability p(x|i)
        Pxi(:,i) = gaussPDF(Data, model.mu(:,i), model.sigma(:,:,i));
    end
    F = Pxi*model.priors';
end
F(F<realmin) = realmin;
loglik = mean(log(F));
end

