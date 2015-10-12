function [x,A,B] = dynamics(x,u)

assert(length(x(:)) == 3)

A = eye(3);
% B = [cos(x(3)) 0 0;
%      sin(x(3)) 0 0;
%      0 0 1];
B = [cos(x(3)) 0;
     sin(x(3)) 0;
     0 1];
 
 if nargin > 1
    x = A*x + B*u;
 end 
 
end