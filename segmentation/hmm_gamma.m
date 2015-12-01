function [ gamma ] = hmm_gamma( alpha, beta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
gamma = alpha .* beta;
sum(alpha(end,:))
gamma = gamma / sum(alpha(end,:));
end

