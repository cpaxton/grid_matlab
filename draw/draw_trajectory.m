function draw_trajectory( traj, color, marker)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

marker = '.';

u = cos(traj(3,:));
v = sin(traj(3,:));

%quiver(traj(1,:),traj(2,:),u,v,'color',color);
plot(traj(1,:),traj(2,:),marker,'color',color,'markerSize',6.0);
end

