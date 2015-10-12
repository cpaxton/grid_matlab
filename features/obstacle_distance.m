function [all, tb, dt] = obstacle_distance(pt, env)
% OBSTACLE_DISTANCE returns distance to closest obstacle from a point

tb = pt(1);
for i = 1:length(env.gates)
    gdist = min(closest_distance(pt, env.gates{i}.top), ...
        closest_distance(pt, env.gates{i}.bottom));
    if gdist < tb
        tb = gdist;
    end
end

dt = pt(1);
for i = 1:length(env.surfaces)
    if env.surfaces{i}.isDeepTissue
        dt = min(dt, closest_distance(pt, env.surfaces{i}.bounds));
    end
end

all = min(tb, dt);

end