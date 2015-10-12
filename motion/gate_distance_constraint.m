function [ceq] = gate_distance_constraint(pt,gate)
f = get_gate_distances(pt(1:3),gate);

ceq = f - pt(6:end);


end