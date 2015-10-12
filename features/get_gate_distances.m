function f = get_gate_distances(p, gate)
    %f = zeros(size(gate.corners,2)+3,size(p,2));
    %dists = zeros(size(gate.corners,2),size(p,2));
    %for i = 1:size(gate.corners,2)
    %    f(i,:) = sqrt(sum((p(1:2,:) - repmat(gate.corners(:,i),1,size(p,2))) .^ 2,1));
    %end
    f = zeros(4,size(p,2));
    %f((i+1):(i+3),:) = rotate_trajectory(p(1:3,:) - repmat([gate.x;gate.y;0],1,size(p,2)),-gate.w);
    f(1:3,:) = rotate_trajectory(p(1:3,:) - repmat([gate.x;gate.y;0],1,size(p,2)),-gate.w);
    %f((i+2),:) = abs(f((i+2),:));
    %f(end-1,:) = min(dists);
    f(end-1,:) = sqrt(sum((p(1:2,:) - repmat([gate.x;gate.y],1,size(p,2))) .^ 2,1));
    %f(end,:) = abs(gate.w - p(3,:));
    angles = p(3,:);
    angles(angles > pi) = angles(angles > pi) - pi;
    angles(angles < -pi) = angles(angles < -pi) + pi;
    f(end,:) = abs(gate.w - angles);
    %if abs(p(3,:)) > pi
    %    disp('---');
    %    gate.w
    %    p(3,:)
    %    angles
    %    pause
    %end
    
end