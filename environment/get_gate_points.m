function [ entrance, exit ] = get_gate_points( gate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    entrance = [-1 * cos(gate.w) * gate.width/2 + gate.x; -1 * sin(gate.w) * gate.width/2 + gate.y; gate.w];
    exit = [cos(gate.w) * gate.width/2 + gate.x; sin(gate.w) * gate.width/2 + gate.y; gate.w];

end

