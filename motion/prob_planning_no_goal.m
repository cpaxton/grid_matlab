function [ traj, Z ] = prob_planning_no_goal( x0, model, local_env, obstacles, Z, n_iter)
%UNTITLED Summary of this function goes here
%   model is the skill we are using
%   next_model is the following skill
%   env is a representation of the local environment
%   Z is the initial distribution we will refine

if nargin < 4
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0);
elseif nargin < 5
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0, obstacles);
elseif nargin < 6
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0, obstacles, Z);
else
    [traj, Z] = prob_planning(x0, model, 0, local_env, 0, obstacles, Z, n_iter);
end