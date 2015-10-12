function frame = create_frame( NDIM, v )

frame.b = zeros(NDIM,1);
frame.A = eye(NDIM);

if nargin > 1
   
    frame.b(2) = v(1);
    frame.b(3) = v(2);
    frame.b(4) = v(3);
    
    frame.A(2,2) = 100*cos(v(3));
    frame.A(2,3) = 100*cos(v(3) + pi/2);
    frame.A(3,2) = 100*sin(v(3));
    frame.A(3,3) = 100*sin(v(3) + pi/2);
    
end
