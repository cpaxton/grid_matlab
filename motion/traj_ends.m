function [ ends ] = traj_ends( trajs )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

ends = zeros(5,length(trajs));

for i = 1:length(trajs)
    ends(:,i) = trajs{i}(:,end);
end

end

