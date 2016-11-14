function traj = pid (x, xg, params)

traj = zeros(5,1);

for i = 1:2
    [xn,A,B] = dynamics(x(1:3),x(4:5));    
    Kp = [0 0 1; 1 1 0];
    e = xg(1:3) - x(1:3);
    xp = Kp*(xg(1:3) - xn(1:3))
    ed = e - (xg(1:3) - xn(1:3))
    [e ed]
    
    traj(:,i) = [x(1:3);xp];
    x = [dynamics(x(1:3),xp); xp];
    
end