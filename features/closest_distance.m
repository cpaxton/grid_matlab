%% CLOSEST_DISTANCE
% compute closest distance and point from point to a polygon
function [d, cpt] = closest_distance(pt, polygon)
dist = zeros(4,1);
cpts = zeros(4,2);
len = size(polygon,2);

for a = 1:len
    if (a == len)
        b = 1;
    else
        b = a + 1;
    end
    A = polygon(:,a);
    B = polygon(:,b);
    dist(a) = abs(det([B-A A-pt]) / norm(B - A));
    cpts(a,:) = dot(B-A,pt-A)/norm(B-A)^2*(B-A) + A;
end

[d, idx] = min(dist);
cpt = cpts(idx,:) - pt';
end