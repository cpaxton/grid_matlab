function [ Z ] = traj_update_prev( params, p, idx, prev_p, Z, config )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% adjust variables appropriately
params = params(:,idx);
p = p(idx) .* prev_p;

Z = traj_update(params,p,Z,config);