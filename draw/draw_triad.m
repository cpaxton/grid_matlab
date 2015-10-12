function draw_triad( tform, scale )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    scale = 1.0
end

t = tform(1:3,4);

end_x = t(1:3) + scale*tform(1:3,1);
end_y = t(1:3) + scale*tform(1:3,2);
end_z = t(1:3) + scale*tform(1:3,3);

plot3([t(1);end_x(1)],[t(2);end_x(2)],[t(3);end_x(3)],'r-','lineWidth',2);
plot3([t(1);end_y(1)],[t(2);end_y(2)],[t(3);end_y(3)],'g-','lineWidth',2);
plot3([t(1);end_z(1)],[t(2);end_z(2)],[t(3);end_z(3)],'b-','lineWidth',2);

end

