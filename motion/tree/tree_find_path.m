function [ path ] = tree_find_path( pts, parents, cprob, goal_met, goal_parents )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[~,idx] = min(cprob);
parent = goal_parents(idx);
path = goal_met(:,idx);
while parent ~= 0
   path = [pts(:,parent) path];
   parent = parents(parent);
end

if ~isempty(path)
    path(4:5,1:end-1) = path(4:5,2:end);
    path(4:5,end) = [0;0];
end
end

