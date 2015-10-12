function pt = sample_gate(gate,num)
w = norm(gate.corners(:,3) - gate.corners(:,2));
h = norm(gate.corners(:,2) - gate.corners(:,1));
pt = rand(3,num) .* repmat([w; h; 2*pi],1,num);
pt(1:2,:) = rmat(pt(1:2,:),gate.w) + repmat([gate.x - (w/2); gate.y - (h/2)],1,num);
end

function mat = rmat(mat, w)
    dist = sqrt(sum(mat.^2,1));
    theta = atan2(mat(2,:),mat(1,:)) + w;
    mat = [dist .* cos(theta); dist .* sin(theta)];
end