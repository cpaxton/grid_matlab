function [gate, in_gates] = in_gates(x,y,gates)
%% IN_GATES
% determine which if any gate the needle is in
%gate = 0;

if isempty(gates)
    gate = zeros(size(x));
    in_gates = zeros(size(x));
    return
else

in_gates = zeros(length(gates),length(x));
for i=1:length(gates)
    for j = 1:length(gates{i})
        in = inpolygon(x,y,gates{i}{j}.corners(1,:),gates{i}{j}.corners(2,:));
        in_gates(i,:) = in;
        if in > 0
            break
        end
    end
end
in_gates = [in_gates;zeros(size(x))];
[in,idx] = max(in_gates);
gate=in.*idx;
end
end