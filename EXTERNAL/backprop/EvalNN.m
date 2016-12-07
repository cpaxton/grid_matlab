function [ output ] = EvalNN( inputs,individual,ni,nh,no )

% A Matlab implementation of a MultiLayer perceptron with
% backpropagation training with momentum.
% 
% 
% by: José Antonio Martín H. <jamartinh [*AT*] fdi ucm es>
% 
% 
% Placed in the public domain. August 23, 2008

ni = ni+1; % +1 for bias node

N = numel(individual);

wi = individual(1:ni*nh);
wi = reshape(wi,ni,nh);

wo = individual(ni*nh+1:N);
wo = reshape(wo,nh,no);

%input activations
ai     = [inputs 1]; % 1 for bias node;

% hidden activations
sum    = ai * wi;
ah     = tanh(sum);

% output activations
sum    =  ah * wo;
output = tanh(sum);

