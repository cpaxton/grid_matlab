function draw_frame(A,b,scale)

if nargin < 3
    scale = 1.0;
end

draw2DArrow(b, scale*A(:,1), [0.9 0.6 0.6]);
draw2DArrow(b, scale*A(:,2), [0.9 0.9 0.6]);

end