figure(10); clf; hold on;
draw_environment(envs{1});
g = fake_prev_gate(envs{1});
draw_gates({g});