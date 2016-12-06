function [r, dists] = reward_nn_test(x,y,g,radius)

gx = repmat(g,100,1);

dx2 = (x + y) - gx;
dx2sq = dx2 .* dx2;
dists = sqrt(sum(dx2sq,2));
r = dists < radius;

end