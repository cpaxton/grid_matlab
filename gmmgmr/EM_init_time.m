function [Priors, Mu, Sigma] = EM_init_time(Data, ns)

minT = min(Data(1,:));
maxT = max(Data(1,:));

[nbVar, ~] = size(Data);

step = (maxT - minT) / ns;
for k=1:ns
   idx = find(Data(1,:) > (minT + ((k - 1) * step)));
   idx = find(Data(1,idx) < (minT + (k * step)));
   
   Priors(k) = length(idx);
   Mu(:,k) = mean(Data,2);
   Sigma(:,:,k) = cov([Data(:,idx) Data(:,idx)]');
   
   Sigma(:,:,k) = Sigma(:,:,k) + 1E-5.*diag(ones(nbVar,1));
end

Priors = Priors / sum(Priors);

end