function [ proximity ] = surface_proximity( x, bounds, limit )
%SURFACE_PROXIMITY Summary of this function goes here
%   Detailed explanation goes here

%% make sure we're doing this right
assert(size(x,1)<=5);
assert(size(bounds,1)==2);
if nargin < 3
    limit = 100;
end

%% number of dimensions
num_bounds = size(bounds,2);
num_x = size(x,2);

bx = bounds(1,:);
by = bounds(2,:);
xx = x(1,:);
xy = x(2,:);

X = (repmat(xx,num_bounds,1) - repmat(bx',1,num_x)) .^ 2;
Y = (repmat(xy,num_bounds,1) - repmat(by',1,num_x)) .^ 2;

dist = sqrt(min(X+Y));
proximity = limit - min(dist,limit);

end