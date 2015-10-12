function  [ pts ] = build_map( start_pt, models, conf)
%BUILD_TREE Create a tree of points.
%   start_pt: x,y,w of the needle at the start of the motion
%   model: model of the motion to perform
%   env: environment to work in
%   goal: function handle to sample goals for this
%   num_iter: number of iterations to perform
%   ll_threshold: when do we start treating unlikely features as obstacles?
%   (0 = never)
%
% This function builds a tree of motions, out from the start position, and
% attempts to plan a path to the goal. It continues until it reaches some
% maximum number of iterations, then stops and chooses the "best" path
% through the world.
%
% We do not place points in obstacles, and treat certain impossible feature
% results as obstacles as well. In the end, we want a map of points


end