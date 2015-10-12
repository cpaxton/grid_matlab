function [ A, B ] = hmm_fb( T0, T, seq, bmm )
%HMM_FB forward/backward algorithm dynamic programming
%   Computes the alpha and beta matrices for the forward/backward algorithm
%   given a set of data and the necessary transition/emission matrices for
%   the bmm/hmm model.

% number of states
K = size(T,1);
D = size(bmm.coef,1);

lens = zeros(size(seq));
A = cell(size(seq));
B = cell(size(seq));

for i = 1:length(seq)
    
    len = size(seq{i},2);
    A{i} = zeros(len,K);
    B{i} = ones(len,K);
    
    % compute emission probabilities for each state
    [~,~,e] = BernoulliAssign(bmm,seq{i}');

    A{i}(1,:) = T0 .* e(1,:)';

    for j = 2:len
        for k= 1:K
            A{i}(j,k) = sum(A{i}(j-1,:) .* T(:,k)' .* e(j,:));
        end
    end
    
    for j=(len-1):-1:1
        for k= 1:K
            B{i}(j,k) = sum(B{i}(j+1,:) .* T(k,:) .* e(j+1,:));
        end
    end
end

end

