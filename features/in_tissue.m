function f = in_tissue( pt, local_env )
%IN_TISSUE Summary of this function goes here
%   Detailed explanation goes here

if isempty(local_env.obstacles)
   f = zeros(size(pt));
else
    for i = 1:length(local_env.obstacles)
       in = inpolygon(pt(1,:),pt(2,:), ...
           local_env.obstacles{i}.bounds(1,:), ...
           local_env.obstacles{i}.bounds(2,:))
       
    end
end

end

