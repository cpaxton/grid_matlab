fprintf('Gate checks:\n')
for i = 1:length(ap{4})
    %check = min(min(get_gate_distances(ap{4}(i).originalData(1:3,:),ap{4}(i).orig_gate) == ap{4}(i).gate_features));
    tmp = get_gate_distances(ap{4}(i).originalData(1:3,:),ap{4}(i).orig_gate) - ap{4}(i).gate_features;
    check = ~det(tmp' * tmp);
    disp(check);
    if check == 0
        disp(get_gate_distances(ap{4}(i).originalData(1:3,:),ap{4}(i).orig_gate) - ap{4}(i).gate_features)
        break
    end
end
fprintf('Prev gate checks:\n')
for i = 1:length(ap{5})
    tmp = get_gate_distances(ap{5}(i).originalData(1:3,:),ap{5}(i).orig_prev_gate) - ap{5}(i).prev_gate_features;
    check = ~det(tmp' * tmp);
    disp(check);
    if check == 0
        disp(get_gate_distances(ap{5}(i).originalData(1:3,:),ap{5}(i).orig_prev_gate) - ap{5}(i).prev_gate_features)
        break
    end
end
fprintf('Exit checks:\n')
for i = 1:length(ap{4})
    tmp = get_end_distance(ap{4}(i).originalData(1:3,:),ap{4}(i).orig_exit) - ap{4}(i).exit_features;
    check = ~det(tmp'*tmp);
    disp(check);
    if check == 0
        disp(get_end_distance(ap{4}(i).originalData(1:3,:),ap{4}(i).exit) - ap{4}(i).exit_features);
    end
end