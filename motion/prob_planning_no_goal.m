function [ traj, Z ] = prob_planning_no_goal( x0, model, local_env, Z, config)
%UNTITLED Summary of this function goes here
%   model is the skill we are using
%   next_model is the following skill
%   env is a representation of the local environment
%   Z is the initial distribution we will refine

if nargin < 4
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0);
elseif nargin < 5
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0);
elseif nargin < 6
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0, Z);
else
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0, Z, config);
end