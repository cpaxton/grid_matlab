function [ traj ] = project_to_frame( traj, frame )
%PROJECT_TO_FRAME Put a trajectory into a specific frame of reference with
%both scaling and rotation.
%   traj: DxN trajectory (points and features)
%   frame: reference frame
%       frame.x: x position
%       frame.y: y position
%       frame.w: planar rotation

traj(1,:) = (traj(1,:) - frame.x) / frame.width;
traj(2,:) = (traj(2,:) - frame.y) / frame.height;
traj = rotate_trajectory(traj,-frame.w);
end

