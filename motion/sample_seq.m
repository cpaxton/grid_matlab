function traj = sample_seq(x0,z)
    num = length(z);
    traj = [];
    for i = 1:3:num
        u = z(i)/20;
        v = z(i+1);
        t = z(i+2);
        seg = sample_primitive(x0,u,v,t);
        x0 = seg(1:5,end);
        traj = [traj seg(:,1:(end-1))];
    end
    %x = zeros(5,1);
    %x(1:3) = dynamics(traj(1:3,end),traj(4:5,end));
    %traj = [traj x];
end