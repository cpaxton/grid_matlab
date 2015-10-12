function traj = rotate_trajectory(traj,w)
% rotates a trajectory "traj" by angle "w"
% traj(1:2,:) = x;y
% traj(3,:) = w

traj(1:2,:) = rmat(traj(1:2,:),w);
traj(3,:) = traj(3,:) + w;

end

function mat = rmat(mat, w)
    dist = sqrt(sum(mat.^2,1));
    theta = atan2(mat(2,:),mat(1,:)) + w;
    mat = [dist .* cos(theta); dist .* sin(theta)];
end