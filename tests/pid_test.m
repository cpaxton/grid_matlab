% pid_test

x0 = [190; 1000; 0; 0; 0];
xg = [600; 700; -pi/4; 0; 0];

d0 = x0 - xg;

traj = simple_pid(x0,xg)

figure(1); clf; hold on;
draw_environment(envs{4});

plot(traj(1,:), traj(2,:))