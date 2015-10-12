function draw_frame_angle(b,w,scale)

A = [cos(w) cos(w+pi/2);sin(w) sin(w+pi/2)];
draw_frame(A,b,scale);

end