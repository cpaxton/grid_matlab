function [x, y, w] = needle_update(x, y, w, movement, rotation, ~)

%% evaluate x, y if they are not in tissue!

w = w + rotation;

x = x + (movement.*cos(w));
%x = x + (width*movement*cos(w));
y = y + (movement.*sin(w));
%y = y - (height*movement*sin(w));

end