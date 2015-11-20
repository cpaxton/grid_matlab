function p = unary( x, s, model )
%UNARY Compute unary probability given the proposed model
% This is computing p(class = y | x)
%   x are the set of observations
%   y is the class
%   model is the model for the given class
%   s is the sparsity term for the model

p = 1;
for i = 1:length(x)
    %p = p + log((s(i) * mvnpdf(x{i},model{i}.mu,model{i}.sigma)) + (1 - s(i)));
    p = p * ((s(i) * mvnpdf(x{i},model{i}.mu,model{i}.sigma)) + (1 - s(i)));
    
    %p = p * (mvnpdf(x{i},model{i}.mu,model{i}.sigma));
end

end

