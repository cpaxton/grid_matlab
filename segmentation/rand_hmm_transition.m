function [ y_ ] = rand_hmm_transition( y, T )
%RAND_HHM_TRANSITION Choose a random HMM state transition from y given T
%   y = current state
%   T = transition matrix

% make sure these are valid probabilities
assert(abs(sum(T(y,:)) - 1) < 0.00001);

%cumsum(T(y,:))
r = rand();
%r < cumsum(T(y,:))
%T(y,:)
y_ = min(find(r < cumsum(T(y,:))));
%pause
end

