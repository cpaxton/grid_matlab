function dist = get_end_distance(pt,exit)
    pt = rotate_trajectory(pt,-exit(3));
    tmp = rotate_trajectory(exit,-exit(3));
    dist = [abs(tmp(1,1)-pt(1,:)); ...
        abs(tmp(3,1) - pt(3,:))];
end