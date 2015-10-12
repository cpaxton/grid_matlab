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
    in = inpolygon(x,y,gates{i}.corners(1,:),gates{i}.corners(2,:));
    in_gates(i,:) = in;
end
in_gates = [in_gates;zeros(size(x))];
[in,idx] = max(in_gates);
gate=in.*idx;
end
end