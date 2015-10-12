function [ bmm ] = autoBernoulliEM( inputs, max_num )
%autoBernoulliEM Chooses an optimal cluster size and returns a BMM
%   Computes the log likelihood of each BMM (as the product of the max
%   probablities for each example)

bmms =  cell(1,max_num);

idx = 0;
best_score = -Inf;

for i = 2:max_num
    bmms{i} = BernoulliEM(inputs,i);
    [~,probs] = BernoulliAssign(bmms{i},inputs);
    %free_vars = numel(bmms{i}.coef) + length(bmms{i}.prior) - 1;
    loglik = mean(log(probs));
    %[~,b] = aicbic(loglik,free_vars,size(inputs,1));
    %if ~isnan(b) && b < min_score
    %    min_score = b;
    %    idx = i;
    %end
    loglik
    if loglik > best_score
        best_score = loglik;
        idx = i;
    end
end

bmm = bmms{idx};

end

