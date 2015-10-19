function [ trial ] = load_data( filename, env, fig )
%LOAD_DATA Summary of this function goes here
%   Detailed explanation goes here

if nargin > 2
    figure(fig);
end
raw = csvread(filename)';

trial = struct('length',size(raw,2),...
    't',raw(1,:),...
    'x',raw(2,:),...
    'y',env.height - raw(3,:),...
    'w',-1*raw(4,:)+pi,...
    'movement',-1*raw(5,:),...
    'rotation',-1*raw(6,:));

trial.w(trial.w > pi) = trial.w(trial.w > pi) - (2*pi);

end

