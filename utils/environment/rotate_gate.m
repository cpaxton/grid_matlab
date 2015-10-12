function [ new_gate ] = rotate_gate( x, y, w, gate)
%ROTATE_GATE Rotates a gate angle w around point (x, y)
%   Will create a whole new gate

%% center the gate on zero
new_gate = move_gate(-x,-y,gate);

%% rotate each point around the origin
dist = sqrt(new_gate.x^2 + new_gate.y^2);
nw = atan2(new_gate.y, new_gate.x) + w;
new_gate.x = dist * cos(nw);
new_gate.y = dist * sin(nw);

new_gate.w = new_gate.w + w;
new_gate.corners = rmat(new_gate.corners,w);
new_gate.top = rmat(new_gate.top,w);
new_gate.bottom = rmat(new_gate.bottom,w);

%% restore the gate to its old position
new_gate = move_gate(x,y,new_gate);

end

function mat = rmat(mat, w)
    dist = sqrt(sum(mat.^2,1));
    theta = atan2(mat(2,:),mat(1,:)) + w;
    mat = [dist .* cos(theta); dist .* sin(theta)];
end

