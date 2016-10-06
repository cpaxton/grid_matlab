function [ll, prob] = compute_loglik(Data, Mu, Sigma, model, idx)
% COMPLUTE_LOGLIK
%   Data: input feature vector
%   Mu: GMM expected values
%   Sigma: GMM covariances
%   model: Action model
%   idx: 

if nargin < 4
    idx = 1:(model.nbVar);
end

if length(idx) == length(model.in) && isequal(idx,model.in)
    use_inv_sigma = true;
    use_inv_sigma_nt = false;
elseif length(idx) == length(model.in)-1 && isequal(idx,model.in(2:end))
    use_inv_sigma = false;
    use_inv_sigma_nt = true;
else
    use_inv_sigma = false;
    use_inv_sigma_nt = false;
end

if model.normalize
    Data = Data - repmat(model.norm_mean(idx),1,size(Data,2));
    Data = Data ./ repmat(model.norm_std(idx),1,size(Data,2));
end

for i=1:(model.nbStates)

    %Compute probability p(x|i)
    if use_inv_sigma
        Pxi(:,i) = gaussPDF_fast(Data, Mu(idx,i), Sigma(idx,idx,i), model.inInvSigma(:,:,i));
    elseif use_inv_sigma_nt
        Pxi(:,i) = gaussPDF_fast(Data, Mu(idx,i), Sigma(idx,idx,i), model.inInvSigmaNT(:,:,i));
    else
        Pxi(:,i) = gaussPDF(Data, Mu(idx,i), Sigma(idx,idx,i));
    end
end

F = Pxi*model.Priors';
F(find(F<realmin)) = realmin;
prob = F;
ll = log(F);


end
