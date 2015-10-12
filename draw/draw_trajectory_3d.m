function draw_trajectory_3d( traj )
%DRAW_TRAJECTORY_3D Summary of this function goes here
%   Detailed explanation goes here

colors = 'rgbmcy';

%clf;
hold on;
lb = [traj.label];
xyz = [traj.gripper_pt];
uvw = [traj.gripper_z];

for i=1:max(lb)
    %quiver3(xyz(1,lb==i),xyz(2,lb==i),xyz(3,lb==i),uvw(1,lb==i),uvw(2,lb==i),uvw(3,lb==i),'color',colors(i));
    plot3(xyz(1,lb==i),xyz(2,lb==i),xyz(3,lb==i),'-','color',colors(i),'linewidth',2);
end
axis equal;
%axis square;

plot3(traj(1).beam_pose(1,4),traj(1).beam_pose(2,4),traj(1).beam_pose(3,4),'o');
plot3(traj(1).node_pose(1,4),traj(1).node_pose(2,4),traj(1).node_pose(3,4),'*');

end

