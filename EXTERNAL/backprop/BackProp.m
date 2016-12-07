ytfunction [ individual,co,ci,error ] = BackProp(individual,inputs,targets,ni,nh,no,co,ci )

% A Matlab implementation of a MultiLayer perceptron with
% backpropagation training with momentum.
% 
% 
% by: Jos� Antonio Mart�n H. <jamartinh [*AT*] fdi ucm es>
% 
% 
% Placed in the public domain. August 23, 2008

ni = ni+1; % +1 for bias node

N  = numel(individual);
wi = individual(1:ni*nh);
wi = reshape(wi,ni,nh);

wo = individual(ni*nh+1:N);
wo = reshape(wo,nh,no);

%input activations
ai     = [inputs 1]; % 1 for bias node;

% hidden activations
netW   = ai * wi;
ah     = tanh(netW);

% output activations
netW   =  ah * wo;
ao     = tanh(netW);

% calculate error terms for output
output_deltas = (1.0-ao.^2) .* (targets - ao);

% calculate error terms for hidden
error         = output_deltas * wo';
hidden_deltas = (1.0-ah.^2) .* error;

% update output weights
change  = reshape(ah,nh,1) * output_deltas;
wo      = wo + 0.5 * change + 0.1 * co;
co      = change;


% update input weights
change  = reshape(ai,ni,1) * hidden_deltas; 
wi      = wi + 0.5 * change + 0.1 * ci;
ci      = change;

% calculate error
error      = sum(0.5*(targets-ao).^2);       
individual = [wi(:)' wo(:)'];

