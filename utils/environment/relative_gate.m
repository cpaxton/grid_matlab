function gate = relative_gate(x,y,w,gate)

gate = rotate_gate(x,y,w,gate);

gate.x = gate.x - x;
gate.y = gate.y - y;

tmp = repmat([x;y],1,4);
gate.corners = gate.corners - tmp;
gate.top = gate.top - tmp;
gate.bottom = gate.bottom - tmp;

%draw_gates({gate});

end