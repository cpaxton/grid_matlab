function gate = relative_gate(x,y,w,gate)
    gate = rotate_gate(x,y,w,gate);
    
    gate.x = gate.x - x;
    gate.y = gate.y - y;
    
    tmp = repmat([x;y],1,4);
    gate.corners = gate.corners - tmp;
    gate.top = gate.top - tmp;
    gate.bottom = gate.bottom - tmp;
end
% 
% function ngate = relative_gate(x,y,w,gate)
% 
% ngate = cell(length(gate),1);
% 
% for i = 1:length(gate)
%     
%     ngate{i} = rotate_gate(x,y,w,gate{i});
%     
%     ngate{i}.x = gate{i}.x - x;
%     ngate{i}.y = gate{i}.y - y;
%     
%     tmp = repmat([x;y],1,4);
%     ngate{i}.corners = gate{i}.corners - tmp;
%     ngate{i}.top = gate{i}.top - tmp;
%     ngate{i}.bottom = gate{i}.bottom - tmp;
% end
% 
% %draw_gates({gate});
% 
% end