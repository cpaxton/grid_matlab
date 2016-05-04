function [x, y, w] = needle_update(x, y, w, movement, rotation, ~)
% NEEDLE_UPDATE apply dynamics for the needle master game!
% x, y: x and y position of the needle
% w: rotation of the needle
% movement, rotation: forward motion and chance in rotation

w = w + rotation;
x = x + (movement.*cos(w));
y = y + (movement.*sin(w));

end