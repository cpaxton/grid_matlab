function [ output_args ] = draw_normalized_trajectory_3d( traj )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

quiver3(traj.g(1,:),traj.g(2,:),traj.g(3,:),traj.gz(1,:),traj.gz(2,:),traj.gz(3,:));

end

