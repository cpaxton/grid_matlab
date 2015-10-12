function [ frame ] = create_gate_frame( gate, NDIM )
%CREATE_GATE_FRAME Create a reference frame for the gate
%   Detailed explanation goes here

frame = create_frame(NDIM);

%% position of gate
frame.b(2) = gate.x;
frame.b(3) = gate.y;
if NDIM > 3
    frame.b(4) = gate.w;
    if frame.b(4) < 0
        frame.b(4) = frame.b(4) + (2*pi);
    end
end

%% compute gate height and width
% assume 1 = upper left, 2 = lower left, 3 = lower right
height = sqrt(sum((gate.corners(:,1) - gate.corners(:,2)) .^2)) / 2;
width = sqrt(sum((gate.corners(:,3) - gate.corners(:,2)) .^2)) / 2;

%% orientation and scaling of gate
frame.A(2,2) = width*cos(gate.w);
frame.A(2,3) = height*cos(gate.w + pi/2);
frame.A(3,2) = width*sin(gate.w);
frame.A(3,3) = height*sin(gate.w + pi/2);

end

