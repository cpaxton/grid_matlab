function f = in_tissue( pt, obstacles )
%IN_TISSUE Summary of this function goes here
%   Detailed explanation goes here


f = zeros(1,size(pt,2));
if ~isempty(obstacles)
    for i = 1:length(obstacles)
       in = inpolygon(pt(1,:),pt(2,:), ...
           obstacles{i}.bounds(1,:), ...
           obstacles{i}.bounds(2,:));
       f = f | in;
    end
end

end

