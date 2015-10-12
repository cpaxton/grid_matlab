function [ new_gate ] = move_gate( x, y, gate )
%MOVE_GATE Translates gate by (x, y)
%   Returns a new gate

new_gate.x = gate.x + x;
new_gate.y = gate.y + y;
new_gate.w = gate.w;

mv = repmat([x;y],1,4);

new_gate.corners = gate.corners + mv;
new_gate.top = gate.top + mv;
new_gate.bottom = gate.bottom + mv;

new_gate.height = gate.height;
new_gate.width = gate.width;

end

