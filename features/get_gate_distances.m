function f = get_gate_distances(p, gate)
    %dists = zeros(size(gate.corners,2),size(p,2));
    %for i = 1:size(gate.corners,2)
    %    dists(i,:) = sqrt(sum((p(1:2,:) - repmat(gate.corners(:,i),1,size(p,2))) .^ 2,1));
    %end
    
    %dists
    %min(dists)
    %pause
    
    f = zeros(4,size(p,2));
    f(1:3,:) = abs(rotate_trajectory(p(1:3,:) - repmat([gate.x;gate.y;0],1,size(p,2)),-gate.w)) / gate.height;
    %f(end-2,:) = min(dists)  / gate.height;
    f(end-1,:) = sqrt(sum((p(1:2,:) - repmat([gate.x;gate.y],1,size(p,2))) .^ 2,1))  / gate.height;

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