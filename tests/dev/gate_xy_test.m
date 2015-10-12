traj = [trials{3}{1}.x; trials{3}{1}.y; trials{3}{1}.w];
gate = envs{3}.gates{1};
gate_x = gate.x;
gate_y = gate.y;
gate_w = gate.w;

figure(1);
draw_gates({gate});
plot(traj(1,:),traj(2,:));

traj = traj - repmat([gate.x;gate.y;0],1,size(traj,2));
traj = rotate_trajectory(traj,-gate.w);
gate = move_gate(-gate.x,-gate.y,gate);
gate = rotate_gate(0,0,-gate.w,gate);

figure(2);
draw_gates({gate});
plot(traj(1,:),traj(2,:));

figure(3);
draw_gates({gate});
for i = 1:length(trials{3})
    traj = [trials{3}{i}.x; trials{3}{i}.y; trials{3}{i}.w];
    traj = traj - repmat([gate_x;gate_y;0],1,size(traj,2));
    traj
    traj = rotate_trajectory(traj,-gate_w);
    traj
    plot(traj(1,:),traj(2,:));
end